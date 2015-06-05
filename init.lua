function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

local function split(str, sep)
    sep = sep or ','
    fields={}
    local matchfunc = string.gmatch(str, "([^"..sep.."]+)")
    if not matchfunc then return {str} end
    for str in matchfunc do
        table.insert(fields, str)
    end
    return fields
end

---------------------------------------------------------------------
function read(path, sep, tonum)
    tonum = tonum or true
    sep = sep or ','
    local csvFile = {}
    local file = assert(io.open(path, "r"))
    for line in file:lines() do
        fields = split(line, sep)
        if tonum then -- convert numeric fields to numbers
            for i=1,#fields do
                fields[i] = tonumber(fields[i]) or fields[i]
            end
        end
        table.insert(csvFile, fields)
    end
    file:close()
    return csvFile
end
-- [1]Name, [2]Symbol, [3]Atomic_Number, [4]Atomic_Weight, [5]Density, 
-- [6]Melting_Point, [7]Boiling_Point, [8]Atomic_Radius, [9]Covalent_Radius, 
-- [10]Ionic_Radius, [11]Specific_Volume, [12]Specific_Heat, [13]Heat_Fusion, 
-- [14]Heat_Evaporation, [15]Thermal_Conductivity, [16]Pauling_Electronegativity, 
-- [17]First_Ionisation_Energy, [18]Oxidation_States, [19]Electronic_Configuration, 
-- [20]Lattice, [21]Lattice_Constant
local elements_table = read (minetest.get_modpath("elements").."/elements.csv", ",")
-- loop through elements table. Register a node for each element.
for row, cells in pairs(elements_table) do
	local fn = ""
	-- test for presence of texture. Otherwise use default.
	if file_exists(minetest.get_modpath("elements").."/textures/"..cells[2]..".png") then
		fn = cells[2]..".png"
	else
		fn = "missing.png"
	end 
	minetest.register_node("elements:"..string.lower(cells[1]), {
		description = cells[1],
		tiles = {fn},
		groups = {dig_immediate=2, },
		-- sounds = default.node_sound_wood_defaults(),
		on_construct = function(pos)
			-- @todo add metadata for elements summary.
		end, 
	})
	
end
