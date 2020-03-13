statapi = {
    -- version = "",
    -- intllib = S,
}

statapi.names = {
    "n_dug",
    "u_dug",
    "n_placed",
    "u_placed"
}

-- References:
-- * Bucket_Game/mods/coderfood/unified_foods/hunger.lua

local of_player = {}
for i, what in ipairs(statapi.names) do
    of_player[i] = {}
end

local function index_of(what)
    for i, n in ipairs(statapi.names) do
        if n == what then
            return i
        end
    end
    return nil
end

statapi.get = function(player, what)
    local inv = player:get_inventory()
    if not inv then return nil end
    local i = index_of(what)
    if not i then return nil end
    local has = inv:get_stack("stats", i):get_count()
    if has == 0 then
        return nil
    end
    return has - 1
end

statapi.get_int = function(player, what)
    return statapi.get(player, what) or 0
end

local function push_meta_at(player, i, what)
    local inv = player:get_inventory()
    local plname = player:get_player_name()
    if not inv then return nil end
    local value = of_player[i][plname]
    if not value then
        minetest.log("error", "Error: push_meta_at got a bad index.")
        return nil
    end
    local iname = "stat:"..what
    inv:set_stack("stats", i, ItemStack({name=iname, count=value+1}))
    return true
end

local function push_meta(player, what)
    local i = index_of(what)
    if not i then return nil end
    return push_meta_at(player, i, what)
end

local function pull_meta_at(player, i)
    local inv = player:get_inventory()
    if not inv then return nil end
    local has = inv:get_stack("hunger", 1):get_count()
    local plname = player:get_player_name()
    if has < 1 then
        -- nil or 0 means bad or Empty slot
        of_player[i][plname] = 0
    else
        of_player[i][plname] = has - 1
    end
    return true
end

statapi.set = function(player, what, value)
    local i = index_of(what)
    if not i then return nil end
    local plname = player:get_player_name()
    if value > 65535 then value = 65535 end
    -- 65536 yields empty item error: See "Re: 99 items"
    -- by GreenDimond (Wed Mar 01, 2017 21:58)
    -- <https://forum.minetest.org/viewtopic.php?p=254386
    --  &sid=b3c0e94cd51c6883c2552858563fd8da#p254386>
    if value < 0 then value = 0 end
    of_player[i][plname] = value
    return push_meta_at(player, i, what)
end

minetest.register_on_joinplayer(function(player)
    local plname = player:get_player_name()
    local inv = player:get_inventory()
    for i, what in ipairs(statapi.names) do
        inv:set_size("stats", 32)
        pull_meta_at(player, i)  -- Load it (forcibly non-nil).
        push_meta_at(player, i, what)  -- Save it (in case it's nil).
    end
end)

minetest.register_on_respawnplayer(function(player)
    -- reset stats (and save)
    local plname = player:get_player_name()
    for i, what in ipairs(statapi.names) do
        of_player[i][plname] = 0
        push_meta_at(player, i, what)
    end
end)
