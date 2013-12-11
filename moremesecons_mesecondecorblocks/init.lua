-- made from mesecons_pressureplates


function mesecon:register_wire_block(type, stype)
	
	
	local offstate = "moremesecons_mesecondecorblocks:block_"..stype.."_off"
	local onstate  = "moremesecons_mesecondecorblocks:block_"..stype.."_on"
	local description = minetest.registered_nodes[type].description .. " Block Pressure Plate"
	local textures = minetest.registered_nodes[type].tiles
	local recipe = {{"default:mese", type}}
	
	
	
	local ppspec = {
		offstate = offstate,
		onstate  = onstate
	}
	
	local mesewire_rules =
	{
        {x = 1, y = 0, z = 0},
        {x =-1, y = 0, z = 0},
        {x = 0, y = 1, z = 0},
        {x = 0, y =-1, z = 0},
        {x = 0, y = 0, z = 1},
        {x = 0, y = 0, z =-1},
	}

	minetest.register_node(offstate, {
		tiles = textures,
		groups = {snappy = 2, oddly_breakable_by_hand = 3},
	   	description = description,
		mesecons = {conductor = {
                state = mesecon.state.off,
                onstate = onstate,
                rules = mesewire_rules
        }}
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
		mesecons = {conductor = {
                state = mesecon.state.on,
                offstate = offstate,
                rules = mesewire_rules
        }},
	})

	minetest.register_craft({
		output = offstate,
		recipe = recipe,
	})
end

mesecon:register_wire_block(
	"default:wood",
	"wood")

mesecon:register_wire_block(
	"default:tree",
	"tree")

mesecon:register_wire_block(
	"default:dirt",
	"dirt")

mesecon:register_wire_block(
	"default:dirt_with_grass",
	"grass")
	
mesecon:register_wire_block(
	"default:stone",
	"stone")
	
mesecon:register_wire_block(
	"default:cobble",
	"cobble")