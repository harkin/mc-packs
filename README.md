Modpacks for various different Minecraft servers I run, built with [packwiz](https://packwiz.infra.link/)

`vanilla-world` is for my persistent vanilla world
 * goal is any vanilla client can connect and get full functionality
 * includes a bunch of performance and QoL mods for anyone who's into that
`skyblock-carpet` is a skyblock mod world based on carpet-skyblock-additions
 * primarily for me
 * nothing that alters the vanilla experience fundamentally (other that the skyblock mod itself)

Usage:

"$INST_JAVA" -jar ../../packwiz-installer-bootstrap.jar https://raw.githubusercontent.com/harkin/mc-packs/main/vanilla-world/pack.toml


Waiting on updates for 26.1.2:
* carpet https://modrinth.com/mod/carpet or https://www.curseforge.com/minecraft/mc-mods/carpet/files/all?page=1&pageSize=20&gameVersionTypeId=4&showAlphaFiles=hide
* better ping display https://modrinth.com/mod/better-ping-display-fabric
* EMI https://modrinth.com/mod/emi
* too-fast https://modrinth.com/mod/too-fast
* nvidium https://modrinth.com/mod/nvidium
* Observable https://modrinth.com/mod/observable (for testing, have heard mixed reports about it's affect on perf)
* Lootr https://modrinth.com/mod/lootr (instanced loot chests, might be a on-runner if it breaks catastrophically without client side mod)
* Enchantment Descriptions https://modrinth.com/mod/enchantment-descriptions

To investigate:
* Async https://modrinth.com/mod/async async entity processing, early alpha
* faster-random (https://modrinth.com/mod/faster-random) requires a non-headless jvm
* modern fix: https://www.curseforge.com/minecraft/mc-mods/modernfix. Big perf claims, didn't see them in very limited testing
* memory leak fix: https://modrinth.com/mod/memoryleakfix/
* https://modrinth.com/mod/tooltipfix
* very many players https://modrinth.com/mod/vmp-fabric
* https://modrinth.com/mod/threatengl
* https://modrinth.com/mod/rrls
* distant horizons https://modrinth.com/mod/distanthorizons
* https://modrinth.com/mod/item-descriptions
* https://modrinth.com/mod/itemstats
* https://modrinth.com/mod/3dskinlayers

From Remarkably Optimized (https://modrinth.com/modpack/remarkably, checked 1.15.65 for 26.2):
* gnetum https://modrinth.com/mod/gnetum spreads HUD rendering over multiple frames, should help with minihud/xaero's
* obe https://modrinth.com/mod/obe faster block entity rendering (chests, signs etc)
* zfastsurface https://modrinth.com/mod/zfastsurface and zmaterial-rule-compiler https://modrinth.com/mod/zmaterial-rule-compiler worldgen opts from the zfastnoise author, both need zconfig, both break moonrise
* quick-pack https://modrinth.com/mod/quick-pack faster resource/data pack zip loading
* ixeris https://modrinth.com/mod/ixeris threaded input polling, test with mouse tweaks/controlling
* asyncparticles https://modrinth.com/mod/asyncparticles async particle ticking + GPU particle rendering, beta, test with iris shaders and voxy
* sodium-extra https://modrinth.com/mod/sodium-extra mostly quality toggles (fog, animations etc), works with sodium 0.9.1
* reeses-sodium-options https://modrinth.com/mod/reeses-sodium-options options menu only, 26.2 build needs exactly sodium 0.9.2 so blocked by the sodium pin
* They use modernfix-mvus https://modrinth.com/mod/modernfix-mvus (see Investigated)

Config tweaks from Remarkably Optimized (would need a config/ folder in the pack, all experimental/non-default):
* More Culling: `leavesCullingMode = "DEPTH"` culls leaf faces deep inside canopies but keeps outer ones, biggest win in forests. Also `includeMangroveRoots = true`, `endGatewayCulling = true`, `itemFrameLODRange = 16`, `itemFrame3FaceCullingRange = 2.0` (item frame ones might just be defaults)
* FerriteCore: `useSmallThreadingDetector = true` smaller per-chunk-section threading detector, saves memory. Low risk
* ImmediatelyFast: `experimental_sign_text_buffering` cheaper sign text, `experimental_screen_batching` batches GUI draw calls (test with JEI/xaero's), `experimental_disable_error_checking` skips GL error checks (hides render errors), `experimental_disable_resource_pack_conflict_handling` skips resource pack conflict workarounds (could glitch with some packs)
* Lithium: `mixin.experimental=true` less-tested game logic opts, applies server side. They also set `mixin.world.explosions.block_raycast.skip_air.no_air_counting=false`, probably to keep explosions vanilla-exact, unconfirmed
* C2ME: `gcFreeChunkSerializer = true` less GC churn when saving chunks. Riskiest one since it writes world data, needs testing alongside fast async world save. Backups first

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
* Glimmer https://modrinth.com/shader/glimmer-shaders/
* RethinkingVoxels https://modrinth.com/shader/rethinking-voxels

TODO
* Hold sodium at 0.9.1 for voxy: `packwiz pin sodium` and `packwiz pin iris` before `packwiz update --all`. Voxy 0.2.19's fabric.mod.json claims sodium 0.9.2 support but there are github issues saying otherwise. Sodium 0.9.2 breaks iris <=1.11.2 so upgrade both together


Notes:
* Fast async world save or chunk sending seemed to have increased MSPT. Unclear if it's a real increase, but might be worth it for the benefits anyway

Investigated:
Modern fix showed decreased RAM usage in some light testing, around 20-25% less in the vanilla world. There was a very small increase in MSPT that might be due to other factors. For now I've removed it because the world is using very little RAM to begin with. Client investigations also needed here, didn't see any FPS changes but there might be a corresponding decrease in RAM usage
