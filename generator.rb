#!/usr/bin/env ruby

FABRIC_PERFORMANCE_MODS = [
  { name: "chunk-sending-forge-fabric", host: :cf },
  { name: "clumps", host: :mr },
  { name: "cupboard --file-id 5477517", host: :cf }, # there's a NeoForge version that erroneously gets picked up without the file-id
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
  { name: "smooth-chunk-save", host: :cf },
  { name: "sodium", host: :mr },
  { name: "spark", host: :mr },
]

FABRIC_MODS_I_LIKE = [
  { name: "accelerated-decay", host: :mr },
  { name: "appleskin", host: :mr },
  { name: "better-mount-hud", host: :mr },
  { name: "better-ping-display-fabric", host: :mr },
  { name: "carpet", host: :cf },
  { name: "continuity", host: :mr },
  { name: "cubes-without-borders", host: :mr },
  { name: "ftb-backups-2", host: :cf },
  { name: "horsebuff", host: :mr },
  { name: "iris", host: :mr },
  { name: "minihud", host: :mr },
  { name: "modmenu", host: :mr },
  { name: "mouse-tweaks", host: :mr },
  { name: "ok-zoomers", host: :mr },
  { name: "roughly-enough-items", host: :mr },
  { name: "servux", host: :mr },
  { name: "too-fast", host: :cf },
  { name: "tweakeroo", host: :mr },
  { name: "wthit", host: :mr },
  { name: "xaeros-minimap", host: :mr },
  { name: "xaeros-world-map", host: :mr },
]

FABRIC_MULTIPLAYER_MODS = [
  { name: "simple-voice-chat", host: :mr },
  { name: "when-dungeons-arise", host: :mr },
  { name: "when-dungeons-arise-seven-seas", host: :mr },
]

def generate_modpack(folder_name, mods)
  return if Dir.exist?(folder_name)

  Dir.mkdir(folder_name)
  Dir.chdir(folder_name) do
    system("packwiz init --name #{folder_name} --author harkin --modloader fabric --fabric-latest --mc-version 1.21 --version 0.0.1")
    mods.each do |mod|
      success = system("packwiz #{mod[:host]} add #{mod[:name]} -y >> /dev/null")
      unless success
        puts "Something went wrong installing #{mod[:name]}"
      end
    end
  end
end

generate_modpack("vanilla-world", FABRIC_PERFORMANCE_MODS + FABRIC_MODS_I_LIKE + FABRIC_MULTIPLAYER_MODS)

