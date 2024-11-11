require "__pypostprocessing__.lib"

require "scripts.wiki.wiki"
require "scripts.wiki.text-pages"
require "scripts.wiki.spreadsheet-pages"
require "scripts.wiki.statistics-page"

require "scripts.tailings-pond"
require "scripts.beacons"
require "scripts.milestones"

py.on_event(py.events.on_init(), function()
	for _, interface in pairs {"silo_script", "better-victory-screen"} do
		if remote.interfaces[interface] and remote.interfaces[interface]["set_no_victory"] then
			remote.call(interface, "set_no_victory", true)
		end
	end

	if remote.interfaces["freeplay"] then
		local created_items = remote.call("freeplay", "get_created_items")
		created_items["burner-mining-drill"] = 10
		remote.call("freeplay", "set_created_items", created_items)

		local debris_items = remote.call("freeplay", "get_debris_items")
		debris_items["iron-plate"] = 100
		debris_items["copper-plate"] = 50
		remote.call("freeplay", "set_debris_items", debris_items)
	end
end)

py.on_event(defines.events.on_research_finished, function(event)
	if storage.finished then return end
	local tech = event.research
	if tech.name == "pyrrhic" and game.tick ~= 0 then
		local force = tech.force
		for _, player in pairs(game.connected_players) do
			if player.force == force then player.opened = nil end
		end

		storage.finished = true
		if remote.interfaces["better-victory-screen"] and remote.interfaces["better-victory-screen"]["trigger_victory"] then
			remote.call("better-victory-screen", "trigger_victory", force)
		else
			game.set_game_state {
				game_finished = true,
				player_won = true,
				can_continue = true,
				victorious_force = force
			}
		end
	end
end)

py.on_event(py.events.on_built(), function(event)
	Beacons.events.on_built(event)
	Pond.events.on_built(event)
end)

py.on_event(py.events.on_destroyed(), Beacons.events.on_destroyed)

py.on_event(defines.events.on_entity_died, function(event)
	Pond.events.on_entity_died(event)
	Beacons.events.on_destroyed(event)
end)

py.on_event(defines.events.on_gui_opened, function(event)
	Beacons.events.on_gui_opened(event)
end)

py.on_event({defines.events.on_gui_closed, defines.events.on_player_changed_surface}, function(event)
	Wiki.events.on_gui_closed(event)
end)

py.on_event(defines.events.on_player_created, function(event)
	local player = game.players[event.player_index]
	player.print {"messages.welcome"}
	local autoplace_controls = game.surfaces["nauvis"].map_gen_settings.autoplace_controls
  game.print(autoplace_controls["raw-coal"].size)
	if script.active_mods["PyBlock"] ~= nil and (game.surfaces["nauvis"].map_gen_settings.property_expression_names.elevation ~= "elevation_island" or autoplace_controls["raw-coal"].size ~= 0) then
		player.print {"messages.pyblock-warning-no-preset"}
  elseif script.active_mods["PyBlock"] == nil and autoplace_controls["stone"] and autoplace_controls["stone"].richness <= 1 then
		player.print {"messages.warning-no-preset", {"map-gen-preset-name.py-recommended"}}
  end
	if autoplace_controls["enemy-base"] and autoplace_controls["enemy-base"].size > 0 then
		player.print {"messages.warning-biters"}
	end

	if script.active_mods.quality then
		player.print {"messages.warning-quality"}
	end

	Wiki.events.on_player_created(event)
end)

py.register_on_nth_tick(153, "pond153", "pycp", Pond.events[153])
py.register_on_nth_tick(154, "pond154", "pycp", Pond.events[154])

-- grumble grumble filters apply for the whole mod
for _, event in pairs {defines.events.on_built_entity, defines.events.on_robot_built_entity, defines.events.script_raised_built, defines.events.script_raised_revive} do
	script.set_event_filter(event, {
		{
			filter = "type",
			type = "inserter",
		},
		{
			filter = "type",
			type = "storage-tank",
			mode = "or"
		},
		{
			filter = "name",
			name = "tailings-pond",
			mode = "or"
		},
		{
			filter = "type",
			type = "beacon",
			mode = "or"
		},
	})
end

remote.add_interface("pycp", {
	---@param func string
	execute_on_nth_tick = function(func)
		py.mod_nth_tick_funcs[func]()
	end
})

-- this is also on_configuration_changed, for reasons
py.on_event(py.events.on_init(), function(changedata)
	if not changedata then return end -- on_init, don't care
	log(serpent.block(changedata))
	local quality = (changedata.mod_changes or {}).quality
	if quality and not quality.old_version then
		game.print({"messages.warning-quality"})

	end
end)

py.finalize_events()
