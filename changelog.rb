#!/usr/bin/env ruby
# frozen_string_literal: true

# Prints changelogs for every mod bumped by an uncommitted `packwiz update`.
#
# Usage:
#   cd vanilla-world
#   packwiz update --all          # leave the changes uncommitted
#   ../changelog.rb               # reads the git working-tree diff of mods/
#
# For Modrinth mods it fetches the changelog text of every version you're
# stepping through (old -> latest). For CurseForge mods it prints a link,
# since the CurseForge API requires a key.

require "net/http"
require "json"
require "uri"

MODS_GLOB = "mods/*.pw.toml"

def sh(*args)
  out = IO.popen(args, &:read)
  raise "command failed: #{args.join(' ')}" unless $?.success?
  out
end

def repo_root
  @repo_root ||= sh("git", "rev-parse", "--show-toplevel").strip
end

# Pull a `key = "value"` string out of a .pw.toml blob.
def toml_str(blob, key)
  blob[/^\s*#{Regexp.escape(key)}\s*=\s*"([^"]*)"/, 1]
end

# Pull a `key = 1234` integer out of a .pw.toml blob.
def toml_int(blob, key)
  blob[/^\s*#{Regexp.escape(key)}\s*=\s*(\d+)/, 1]
end

def parse_meta(blob)
  return nil if blob.nil? || blob.empty?

  if blob.include?("[update.modrinth]")
    { host: :modrinth, project: toml_str(blob, "mod-id"), version: toml_str(blob, "version") }
  elsif blob.include?("[update.curseforge]")
    { host: :curseforge, project: toml_int(blob, "project-id"), version: toml_int(blob, "file-id") }
  end
end

# Content of a tracked file at HEAD, or nil if it didn't exist there.
def head_blob(repo_rel_path)
  out = IO.popen(["git", "show", "HEAD:#{repo_rel_path}"], err: File::NULL, &:read)
  $?.success? ? out : nil
end

def modrinth_versions(project)
  uri = URI("https://api.modrinth.com/v2/project/#{project}/version")
  req = Net::HTTP::Get.new(uri)
  req["User-Agent"] = "mc-packs-changelog/1.0 (github.com/harkin)"
  res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |http| http.request(req) }
  return [] unless res.is_a?(Net::HTTPSuccess)

  JSON.parse(res.body)
rescue StandardError => e
  warn "  ! failed to fetch Modrinth versions for #{project}: #{e.message}"
  []
end

def modrinth_changelog(name, meta_old, meta_new)
  versions = modrinth_versions(meta_new[:project])
  if versions.empty?
    puts "  (could not fetch versions)"
    return
  end

  by_id = versions.each_with_object({}) { |v, h| h[v["id"]] = v }
  old = by_id[meta_old[:version]]
  new = by_id[meta_new[:version]]

  unless new
    puts "  (new version #{meta_new[:version]} not found in version list)"
    return
  end

  if old
    # Everything published after the old release, up to and including the new
    # one, restricted to versions that share a loader AND a game version with
    # the new release. Without the game-version filter, mods that publish
    # same-day builds for many Minecraft versions (C2ME, YACL, ...) flood the
    # output with changelogs that don't apply to the version you're on.
    loaders = new["loaders"] || []
    games = new["game_versions"] || []
    steps = versions.select do |v|
      v["date_published"] > old["date_published"] &&
        v["date_published"] <= new["date_published"] &&
        (loaders.empty? || (v["loaders"] & loaders).any?) &&
        (games.empty? || (v["game_versions"] & games).any?)
    end
    steps.sort_by! { |v| v["date_published"] }
  else
    puts "  (old version #{meta_old[:version]} no longer listed; showing latest only)"
    steps = [new]
  end

  steps.each do |v|
    date = v["date_published"][0, 10]
    puts "  ### #{v['version_number']}  (#{date})"
    log = (v["changelog"] || "").strip
    if log.empty?
      puts "  _no changelog provided_"
    else
      log.each_line { |line| puts "  #{line.chomp}" }
    end
    puts
  end
end

def curseforge_changelog(meta_new)
  puts "  CurseForge — changelog: https://www.curseforge.com/projects/#{meta_new[:project]}"
  puts "  (file id #{meta_new[:version]})"
  puts
end

# --- main ---------------------------------------------------------------

changed = sh("git", "diff", "--name-only", "--", MODS_GLOB).split("\n").map(&:strip).reject(&:empty?)

if changed.empty?
  puts "No uncommitted changes under #{MODS_GLOB}. Run `packwiz update --all` first (and don't commit yet)."
  exit 0
end

puts "# Changelog for #{changed.size} updated mod(s)\n\n"

changed.sort.each do |repo_rel|
  abs = File.join(repo_root, repo_rel)
  meta_new = parse_meta(File.exist?(abs) ? File.read(abs) : nil)
  meta_old = parse_meta(head_blob(repo_rel))

  name = File.basename(repo_rel, ".pw.toml")

  if meta_new.nil?
    puts "## #{name} — removed\n\n"
    next
  end
  if meta_old.nil?
    puts "## #{name} — newly added\n\n"
    next
  end
  if meta_old[:version] == meta_new[:version]
    next # hash-only change, not a version bump
  end

  puts "## #{name}\n\n"

  case meta_new[:host]
  when :modrinth   then modrinth_changelog(name, meta_old, meta_new)
  when :curseforge then curseforge_changelog(meta_new)
  end
end
