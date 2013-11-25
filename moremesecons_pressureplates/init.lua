-- made from mesecons_pressureplates


function mesecon:register_pressure_plate_full_block(type, stype)
	
	
	local offstate = "moremesecons_pressureplates:pressure_plate_"..stype.."_off"
	local onstate  = "moremesecons_pressureplates:pressure_plate_"..stype.."_on"
	local description = minetest.registered_nodes[type].description .. " Block Pressure Plate"
	local textures = minetest.registered_nodes[type].tiles
	local recipe = {{type},{type}}
	
	
	
	local ppspec = {
		offstate = offstate,
		onstate  = onstate
	}

	minetest.register_node(offstate, {
		tiles = textures,
		groups = {snappy = 2, oddly_breakable_by_hand = 3},
	    	description = description,
		pressureplate = ppspec,
		on_timer = pp_on_timer,
		mesecons = {receptor = {
			state = mesecon.state.off
		}},
		on_construct = function(pos)
			minetest.env:get_node_timer(pos):start(PRESSURE_PLATE_INTERVAL)
		end,
		walkable = false,
	})

	minetest.register_node(onstate, {
		tiles = textures,
		groups = {snappy = 2, oddly_breakable_by_hand = 3, not_in_creative_inventory = 1},
		drop = offstate,
		pressureplate = ppspec,
		on_timer = pp_on_timer,
		mesecons = {receptor = {
			state = mesecon.state.on
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
		walkable = false,
	})

	minetest.register_craft({
		output = offstate,
		recipe = recipe,
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