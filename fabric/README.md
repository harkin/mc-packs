Optimise Fabric client and server performance

Goal is to keep these independent so a vanilla client can join the server and similarly the fabric client can join a vanilla server

Server mods are all about performance optimisation

Client mods include optimisations and a few QOL mods I enjoy

Waiting on updates for 1.21:
 * Observable (for testing, have heard mixed reports about it's affect on perf)
 * Borderless mining
 * Cull less leaves
 * Lootr (instanced loot chests, might be a on-runner if it breaks catastrophically without client side mod)
 * Iris Flywheel Compact (unsure what difference it makes in vanilla, want to test) iris-flw-compat

TODO
 * server backup (Fastback is working and interesting but not sure on git based backups in general)


Configs:
 * Lithium and carpet mod currently don't play nicely together and requires `mixin.world.explosions.cache_exposure=false` to be set in lithium.properties
 * Xaeros has a custom config that disables registration of status effects so that clients without it can join the server
