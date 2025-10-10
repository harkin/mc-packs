Modpacks for various different Minecraft servers I run, built with [packwiz](https://packwiz.infra.link/)

`vanilla-world` is for my persistent vanilla world
 * goal is any vanilla client can connect and get full functionality
 * includes a bunch of performance and QoL mods for anyone who's into that
`skyblock-carpet` is a skyblock mod world based on carpet-skyblock-additions
 * primarily for me
 * nothing that alters the vanilla experience fundamentally (other that the skyblock mod itself)

Usage:

"$INST_JAVA" -jar ../../packwiz-installer-bootstrap.jar https://raw.githubusercontent.com/harkin/mc-packs/main/vanilla-world/pack.toml


Waiting on updates for 1.21.7:
* Better Ping Display https://modrinth.com/mod/better-ping-display-fabric
* JEI https://modrinth.com/mod/jei
* EMI https://modrinth.com/mod/emi
* too-fast https://modrinth.com/mod/too-fast
* nvidium https://modrinth.com/mod/nvidium
* Observable (for testing, have heard mixed reports about it's affect on perf)
* Lootr (instanced loot chests, might be a on-runner if it breaks catastrophically without client side mod)
* Enchantment Descriptions https://modrinth.com/mod/enchantment-descriptions

To investigate:
* faster-random (https://modrinth.com/mod/faster-random) requires a non-headless jvm
* https://www.curseforge.com/minecraft/mc-mods/leaves-be-gone vs accelerated decay
* modern fix: https://www.curseforge.com/minecraft/mc-mods/modernfix. Big perf claims, didn't see them in very limited testing
* memory leak fix: https://modrinth.com/mod/memoryleakfix/
* https://modrinth.com/mod/tooltipfix
* very many players https://modrinth.com/mod/vmp-fabric
* https://modrinth.com/mod/threatengl
* https://modrinth.com/mod/rrls
* bobby https://modrinth.com/mod/bobby
* voxy https://modrinth.com/mod/voxy
* distant horizons https://modrinth.com/mod/distanthorizons
* https://modrinth.com/mod/item-descriptions

Aesthetics:
* https://modrinth.com/mod/lovely_snails cute snails
* https://modrinth.com/mod/adorabuild-structures interesting structures
* https://modrinth.com/mod/moogs-voyager-structures more structures
* https://modrinth.com/mod/formations-overworld more structures
* https://modrinth.com/mod/mo-structures more structures
* https://modrinth.com/mod/polydecorations/gallery server side decoractions
Functionality:
* https://modrinth.com/mod/audioplayer

Shaders to check out
* AstraLex https://modrinth.com/shader/astralex/versions
* Bliss https://modrinth.com/shader/bliss-shader/
* 
TODO


Notes:
* Fast async world save or chunk sending seemed to have increased MSPT. Unclear if it's a real increase, but might be worth it for the benefits anyway

Investigated:
Modern fix showed decreased RAM usage in some light testing, around 20-25% less in the vanilla world. There was a very small increase in MSPT that might be due to other factors. For now I've removed it because the world is using very little RAM to begin with. Client investigations also needed here, didn't see any FPS changes but there might be a corresponding decrease in RAM usage
