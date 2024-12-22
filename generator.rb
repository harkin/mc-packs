#!/usr/bin/env ruby

FABRIC_PERFORMANCE_MODS = [
  { name: "chunk-sending-forge-fabric", host: :cf },
  { name: "clumps", host: :mr },
  # { name: "cupboard", host: :cf }, # there's a NeoForge version that erroneously gets picked up without the file-id
  { name: "dynamic-fps", host: :mr },
  { name: "ebe", host: :mr },
  { name: "entityculling", host: :mr },
  { name: "fast-async-world-save-forge-fabric", host: :cf },
  { name: "fast-ip-ping", host: :mr },
  { name: "ferrite-core", host: :mr },
  { name: "immediatelyfast", host: :mr },
  { name: "indium", host: :mr },
  { name: "krypton", host: :mr },
  { name: "lithium", host: :mr },
  { name: "moreculling", host: :mr },
  { name: "no-chat-reports", host: :mr },
  { name: "noisium", host: :mr },
  # { name: "nvidium", host: :mr }, not compatible with Sodium 0.6.0 yet
  { name: "particle-core", host: :mr },
  { name: "recipe-essentials-forge-fabric", host: :cf },
  { name: "scalablelux", host: :cf },
  { name: "smooth-chunk-save", host: :cf },
  { name: "sodium", host: :mr },
  { name: "spark", host: :mr },
]

FABRIC_MODS_I_LIKE = [
  { name: "accelerated-decay", host: :mr },
  { name: "appleskin", host: :mr },
  { name: "better-mount-hud", host: :mr },
  { name: "better-ping-display-fabric", host: :mr },
  { name: "carpet", host: :mr },
  { name: "complementary-reimagined", host: :mr }, # technically shaders not a mod
  { name: "continuity", host: :mr },
  { name: "controlling", host: :mr },
  { name: "cubes-without-borders", host: :mr },
  { name: "ftb-backups-2", host: :cf },
  { name: "horsebuff", host: :mr },
  { name: "iris", host: :mr },
  { name: "minihud", host: :mr },
  { name: "modmenu", host: :mr },
  { name: "mouse-tweaks", host: :mr },
  { name: "roughly-enough-items", host: :mr },
  { name: "servux", host: :mr },
  { name: "too-fast", host: :cf },
  { name: "tweakeroo", host: :mr },
  { name: "wthit", host: :mr },
  { name: "xaeros-minimap", host: :mr },
  { name: "xaeros-world-map", host: :mr },
  { name: "zoomify", host: :mr },
]

FABRIC_MULTIPLAYER_MODS = [
  { name: "simple-voice-chat", host: :mr },
  { name: "when-dungeons-arise", host: :mr },
  { name: "when-dungeons-arise-seven-seas", host: :mr },
]

FABRIC_SKYBLOCK_MODS = [
  { name: "carpet-sky-additions", host: :mr },
  { name: "inventory-sorting", host: :mr },
  { name: "litematica", host: :mr },
]

def generate_modpack(folder_name, mc_version, mod_loader, mods)
  return if Dir.exist?(folder_name)

  Dir.mkdir(folder_name)
  Dir.chdir(folder_name) do
    system("packwiz init --name #{folder_name} --author harkin --modloader #{mod_loader} --#{mod_loader}-latest --mc-version #{mc_version} --version 0.0.1")
    mods.each do |mod|
      success = system("packwiz #{mod[:host]} add #{mod[:name]} -y >> /dev/null")
      unless success
        puts "Something went wrong installing #{mod[:name]}"
      end
    end
  end
end

generate_modpack("vanilla-world", "1.21", "fabric", FABRIC_PERFORMANCE_MODS + FABRIC_MODS_I_LIKE + FABRIC_MULTIPLAYER_MODS)
generate_modpack("skyblock-carpet", "1.20.4", "fabric", FABRIC_SKYBLOCK_MODS + FABRIC_PERFORMANCE_MODS + FABRIC_MODS_I_LIKE)
