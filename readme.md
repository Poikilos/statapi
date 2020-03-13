# statapi
Get and set arbitrary stats for a Minetest player.

## Known issues
- Save statapi.names in mod_storage.
- Create a mapping between statapi.names and names of stacks.
- Account for changes to the count and order of statapi.names
- *Do some testing*
- Remove the hard-coded limit to the number of stats (you can change
  that by changing the `inv:set_size` param in api.lua).
  - Requires: "Save statapi.names in mod_storage"
- Allow changing the order of statapi.names
  - Save statapi.names in mod_storage, or add named items to inventory
    (using non-existent node names such as `stat:n_dug`).
    - Translate from the old to the new format upon load.
- Allow values > 65535
  - Requires: "Save statapi.names in mod_storage"
- Ensure mobs have same stats as players
  - Mobs having inventories is possible. See
    "Re: [Mod] Creatures [git] [minetest_mods_creatures]"
    by MirceaKitsune (Mon Jun 22, 2015 21:55)
    <https://forum.minetest.org/viewtopic.php?p=182526#p182526>
