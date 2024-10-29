Optimise Fabric client and server performance

Goal is to keep these independent so a vanilla client can join the server and similarly the fabric client can join a vanilla server

Server mods are all about performance optimisation

Client mods include optimisations and a few QOL mods I enjoy

Waiting on updates for 1.21:
 * Observable (for testing, have heard mixed reports about it's affect on perf)
 * Lootr (instanced loot chests, might be a on-runner if it breaks catastrophically without client side mod)
 * Iris Flywheel Compact (unsure what difference it makes in vanilla, want to test) iris-flw-compat

To investigate:
 * faster-random (https://modrinth.com/mod/faster-random) requires a non-headless jvm 
 * https://www.curseforge.com/minecraft/mc-mods/leaves-be-gone vs accelerated decay
 * modern fix: https://www.curseforge.com/minecraft/mc-mods/modernfix. Big perf claims, didn't see them in very limited testing
 * memory leak fix: https://modrinth.com/mod/memoryleakfix/
 * scalablelux, Starlight fork
 * cull less leaves vs accelerated decay



TODO

Configs:
 * Xaeros has a custom config that disables registration of status effects so that clients without it can join the server

Notes:
 * Fast async world save or chunk sending seemed to have increased MSPT. Unclear if it's a real increase, but might be worth it for the benefits anyway

Investigated:
Modern fix showed decreased RAM usage in some light testing, around 20-25% less in the vanilla world. There was a very small increase in MSPT that might be due to other factors. For now I've removed it because the world is using very little RAM to begin with. Client investigations also needed here, didn't see any FPS changes but there might be a corresponding decrase in RAM usage