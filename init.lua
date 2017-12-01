dofile(minetest.get_modpath("sfinv_tabs") .. "/config.lua")

--Functions

function filter(tb, fields)
    local ret = {}
    for i, field in ipairs(fields) do
        ret[field] = tb[field]
    end
    return ret
end

-- Taken from luno library: https://github.com/echiesse/luno/blob/master/src/util.lua
function copy(val, lookup)
    local ret
    lookup = lookup or {}
    if type(val) == "table" then
        if lookup[val] ~= nil then
            ret = lookup[val]
        else
            ret = {}
            lookup[val] = ret
            for i, v in pairs(val) do
                local index = lookup[i] or copy(i, lookup)
                local value = lookup[v] or copy(v, lookup)
                ret[index] = value
            end
        end
    else
        ret = val
    end
    return ret
end


function filterAndCopy(tb, fields, lookup)
    local temp = filter(tb, fields)
    return copy(temp)
end




function removeKey(t, k)
	local i = 0
	local keys, values = {},{}
	for k,v in pairs(t) do
		i = i + 1
		keys[i] = k
		values[i] = v
	end
 
	while i>0 do
		if keys[i] == k then
			table.remove(keys, i)
			table.remove(values, i)
			break
		end
		i = i - 1
	end
 
	local a = {}
	for i = 1,#keys do
		a[keys[i]] = values[i]
	end
 
	return a
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function remove_items(orig, pars)
	local tcopy = deepcopy(orig)
	for i, v in pairs(pars) do
		tcopy[v]=nil
	end
	return tcopy
end



minetest.after(0, function()
local vnodes = remove_items(minetest.registered_nodes, plants)
creative.register_tab("vnodes", "Nodes", vnodes)

creative.register_tab("tools", "Tools", minetest.registered_tools)
creative.register_tab("craftitems", "Items", minetest.registered_craftitems)



local vplants = filterAndCopy(minetest.registered_nodes, plants)
creative.register_tab("mplants", "Plants", vplants)

--local vnodes = remove_items(minetest.registered_nodes, plants)
--creative.register_tab("mnodes", "vNodes", vnodes)

--check
for k, v in pairs(vplants) do
print(k, v)
end

end)
