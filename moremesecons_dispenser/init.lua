minetest.register_node("moremesecons_dispenser:placer", {
	description = "Placer",
	tiles = {"moremesecons_dispenser_placer_top.png", "moremesecons_dispenser_placer.png", "moremesecons_dispenser_placer.png",
				"moremesecons_dispenser_placer.png", "moremesecons_dispenser_placer_front.png", "moremesecons_dispenser_placer.png"},
	groups = {snappy = 2, oddly_breakable_by_hand = 3},
	paramtype2 = "facedir",
	mesecons = {effector = {
		action_on = function (pos, node)
			local dir = minetest.facedir_to_dir(node.param2)
			local pos_under, pos_above = {x=pos.x + dir.x, y=pos.y + dir.y, z=pos.z + dir.z},
								{x=pos.x + 2*dir.x, y=pos.y + 2*dir.y, z=pos.z + 2*dir.z}
			nodeupdate(pos)
			
			local inv = minetest.get_meta(pos):get_inventory()
			local invlist = inv:get_list("main")
			for i, stack in ipairs(invlist) do
				if stack:get_name() ~= nil and stack:get_name() ~= "" and minetest.get_node(pos_under).name == "air" then --obtain the first non-empty item slot
					local placer = {
						get_player_name = function() return "deployer" end,
						getpos = function() return pos end,
						get_player_control = function() return {jump=false,right=false,left=false,LMB=false,RMB=false,sneak=false,aux1=false,down=false,up=false} end,
					}
					local stack2 = minetest.item_place(stack, placer, {type="node", under=pos_under, above=pos_above})
					invlist[i] = stack2
					inv:set_list("main", invlist)
					return
				end
			end
		end
	}},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",	"invsize[8,9;]"..
									"list[context;main;0,0;8,4;]"..
									"list[current_player;main;0,4;8,4;]")
		local inv = meta:get_inventory()
		inv:set_size("main", 4*8)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
})



minetest.register_node("moremesecons_dispenser:dispenser", {
	description = "dispenser",
	tiles = {"moremesecons_dispenser_dispenser_top.png", "moremesecons_dispenser_dispenser.png", "moremesecons_dispenser_dispenser.png",
				"moremesecons_dispenser_dispenser.png", "moremesecons_dispenser_dispenser_front.png", "moremesecons_dispenser_dispenser.png"},
	groups = {snappy = 2, oddly_breakable_by_hand = 3},
	paramtype2 = "facedir",
	mesecons = {effector = {
		action_on = function (pos, node)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			for i=1, inv:get_size("main") do
				if not inv:get_stack("main", i):is_empty() then
					local stack = inv:get_stack("main", i)
					local dir = minetest.facedir_to_dir(node.param2)
					local def = minetest.registered_items[stack:get_name()]
					-----------------------------------------
					local pos_under, pos_above = vector.add(pos, dir),
							vector.add(pos, vector.add(dir, dir))
					
					local placer = {
						get_player_name = function() return "deployer" end,
						getpos = function() return pos end,
						get_player_control = function() return {jump=false,right=false,left=false,
									LMB=false,RMB=false,sneak=false,aux1=false,down=false,up=false} end,
						get_wield_index = function()
							return i % 8
						end,
						get_inventory = function()
							return inv
						end,
						get_look_dir = function()
							return dir
						end,
						get_look_yaw = function()
							return math.pi/2
						end
					}
					-----------------------------------------
					local orgstack = stack:to_string()
					if def.on_place~=nil then
						stack = def.on_place(stack, placer, {type="node", under=pos_under, above=pos_above})
					end
					if def.on_use~=nil and orgstack == stack:to_string() then
						stack = def.on_use(stack, placer, {type="node", under=pos_under, above=pos_above})
						print("on_use")
					end
					if orgstack == stack:to_string() then
						local newpos = vector.add(dir, pos)
						local newstack = stack:to_table()
						newstack.count = 1
						minetest.add_item(newpos, newstack)
						stack:take_item()
					end
					inv:set_stack("main", i, stack)
					return
				end
			end
		end
	}},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",	"invsize[8,9;]"..
									"list[context;main;0,0;8,4;]"..
									"list[current_player;main;0,4;8,4;]")
		local inv = meta:get_inventory()
		inv:set_size("main", 4*8)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
})
