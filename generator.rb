#!/usr/bin/env ruby

FABRIC_PERFORMANCE_MODS = [
  { name: "sodium", host: :mr },
]

FABRIC_CLIENT_MODS_I_LIKE =[
  { name: "minihud", host: :mr },
  { name: "tweakeroo", host: :mr },
]

FOLDERS_TO_CREATE = [
  { name: "test", version: "1.21.1" },
]

def generate_modpack(folder_name, mods)
  Dir.mkdir(folder_name)
  Dir.chdir(folder_name) do
    system("packwiz init --name #{folder_name} --author harkin --modloader fabric --fabric-latest --mc-version 1.21.1 --version 1.0.0")
    mods.each do |mod|
      system("packwiz #{mod[:host]} add #{mod[:name]} -y")
    end
  end
end

generate_modpack("test", FABRIC_PERFORMANCE_MODS + FABRIC_CLIENT_MODS_I_LIKE)

