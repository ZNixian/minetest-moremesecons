-- made from mesecons_pressureplates

local rules =
{
	{x = 1, y = 0, z = 0},
	{x =-1, y = 0, z = 0},
	{x = 0, y = 1, z = 0},
	{x = 0, y =-1, z = 0},
	{x = 0, y = 0, z = 1},
	{x = 0, y = 0, z =-1},
}

local bpp_on_timer = function (pos, elapsed)
	local node   = minetest.env:get_node(pos)
	local ppspec = minetest.registered_nodes[node.name].pressureplate

	-- This is a workaround for a strange bug that occurs when the server is started
	-- For some reason the first time on_timer is called, the pos is wrong
	if not ppspec then return end

	local objs   = minetest.env:get_objects_inside_radius(vector.add(pos, {x=0,y=1,z=0}), 1)
	local two_below = mesecon:addPosRule(pos, {x = 0, y = -2, z = 0})

	if objs[1] == nil and node.name == ppspec.onstate then
		minetest.env:add_node(pos, {name = ppspec.offstate})
		mesecon:receptor_off(pos)
		-- force deactivation of mesecon two blocks below (hacky)
		if not mesecon:connected_to_receptor(two_below) then
			mesecon:turnoff(two_below)
		end
	else
		for k, obj in pairs(objs) do
			local objpos = obj:getpos()
			if objpos.y > pos.y and objpos.y < pos.y+1 then
				minetest.env:add_node(pos, {name=ppspec.onstate})
				mesecon:receptor_on(pos)
				-- force activation of mesecon two blocks below (hacky)
				mesecon:turnon(two_below)
			end
		end
	end
	return true
end


function mesecon:register_pressure_plate_full_block(type, stype)
	
	
	local offstate = "moremesecons_pressureplates:pressure_plate_"..stype.."_off"
	local onstate  = "moremesecons_pressureplates:pressure_plate_"..stype.."_on"
	local description = minetest.registered_nodes[type].description .. " Block Pressure Plate"
	local textures = minetest.registered_nodes[type].tiles
	
	
	
	local ppspec = {
		offstate = offstate,
		onstate  = onstate
	}

	minetest.register_node(offstate, {
		tiles = textures,
		groups = {snappy = 2, oddly_breakable_by_hand = 3},
	    	description = description,
		pressureplate = ppspec,
		on_timer = bpp_on_timer,
		mesecons = {receptor = {
			state = mesecon.state.off,
			rules = rules,
		}},
		on_construct = function(pos)
			minetest.env:get_node_timer(pos):start(PRESSURE_PLATE_INTERVAL)
		end,
	})
	
	local textures_on = {}
	
	for i=1,#textures do
		if textures[i]~=nil then
			textures_on[i] = textures[i] .. "^[brighten"
		end
	end

	minetest.register_node(onstate, {
		tiles = textures_on,
		groups = {snappy = 2, oddly_breakable_by_hand = 3, not_in_creative_inventory = 1},
		drop = offstate,
		pressureplate = ppspec,
		on_timer = bpp_on_timer,
		mesecons = {receptor = {
			state = mesecon.state.on,
			rules = rules,
		}},
		on_construct = function(pos)
			minetest.env:get_node_timer(pos):start(PRESSURE_PLATE_INTERVAL)
		end,
		after_dig_node = function(pos)
			local two_below = mesecon:addPosRule(pos, {x = 0, y = -2, z = 0})
			if not mesecon:connected_to_receptor(two_below) then
				mesecon:turnoff(two_below)
			end
		end,
	})

	minetest.register_craft({
		output = offstate,
		recipe = {{type}, {"mesecons_pressureplates:pressure_plate_wood_off"}},
	})
	
	minetest.register_craft({
		output = offstate,
		recipe = {{type}, {"mesecons_pressureplates:pressure_plate_stone_off"}},
	})
end

mesecon:register_pressure_plate_full_block(
	"default:wood",
	"wood")

mesecon:register_pressure_plate_full_block(
	"default:tree",
	"tree")

mesecon:register_pressure_plate_full_block(
	"default:dirt",
	"dirt")

mesecon:register_pressure_plate_full_block(
	"default:dirt_with_grass",
	"grass")
	
mesecon:register_pressure_plate_full_block(
	"default:stone",
	"stone")
	
mesecon:register_pressure_plate_full_block(
	"default:cobble",
	"cobble")



minetest.register_craft({
	output = "moremesecons_pressureplates:pressure_plate_grass_off",
	recipe = {{"default:grass_1"}, {"moremesecons_pressureplates:pressure_plate_dirt_off"}},
})
