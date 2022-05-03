local DEBUG = require('config').DEBUG
local table = require('__stdlib__/stdlib/utils/table')

if DEBUG then
    local developer = require('__stdlib__/stdlib/data/developer/developer')
    developer.make_test_entities('pycoalprocessing')
end

--[[
--find all techs with utility science packs and log a list of names
local techs = {}
for t, tech in pairs(data.raw.technology) do
    log(tech.name)
    if tech.unit ~= nil and tech.unit.ingredients ~= nil then
        for i, ing in pairs(tech.unit.ingredients) do
            log(serpent.block(ing))
            if string.match(ing[1], "utility") then
                table.insert(techs, tech.name)
            end
        end
    end
end

log(serpent.block(techs))
]]--

for r,recipe in pairs(data.raw.recipe) do
    if recipe.category == "combustion" then
        local temp
        for _,result in pairs(recipe.results) do
            if result.name == "combustion-mixture1" then
                temp = result.temperature
            end
        end
        recipe.localised_name = {"recipe-name." .. recipe.name, temp}
    end
end


for _, module in pairs(data.raw.module) do
    local remove_recipe = {}

    for _, r in pairs(module.limitation or {}) do
        if not data.raw.recipe[r] then
            remove_recipe[r] = true
        end
    end

    if not table.is_empty(remove_recipe) then
        local limit = table.array_to_dictionary(module.limitation, true)

        for r, _ in pairs(remove_recipe) do
            limit[r] = nil
        end

        module.limitation = table.keys(limit)
    end

    remove_recipe = {}

    for _, r in pairs(module.limitation_blacklist or {}) do
        if not data.raw.recipe[r] then
            remove_recipe[r] = true
        end
    end

    if not table.is_empty(remove_recipe) then
        local limit = table.array_to_dictionary(module.limitation_blacklist, true)

        for r, _ in pairs(remove_recipe) do
            limit[r] = nil
        end

        module.limitation_blacklist = table.keys(limit)
    end
end


local function create_tmp_tech(recipe, original_tech, add_dependency)
    local new_tech = TECHNOLOGY {
        type = "technology",
        name = "tmp-" .. recipe .. "-tech",
        icon = "__pycoalprocessinggraphics__/graphics/placeholder.png",
        icon_size = 128,
        order = "c-a",
        prerequisites = {},
        effects = {
            { type = "unlock-recipe", recipe = recipe }
        },
        unit = {
            count = 30,
            ingredients = {
                {"automation-science-pack", 1}
            },
            time = 30
        }
    }

    RECIPE(recipe):set_enabled(false)

    if original_tech then
        RECIPE(recipe):remove_unlock(original_tech)

        if add_dependency then
            new_tech.dependencies = { original_tech }
        end
    end

    return new_tech
end


-- TMP TECHS HERE --
-- create_tmp_tech(<recipe-name>): Create tmp tech with only that recipe
-- create_tmp_tech(<recipe-name>, <tech-name>): Create tmp tech with only that recipe, and remove it from tech
if mods["pyalienlife"] then

end

if mods["pyalienlife"] and mods["pyhightech"] then
    -- create_tmp_tech("salt-mine", "electrolysis")
end

if mods["pyalternativeenergy"] then
    create_tmp_tech("pbsb-alloy", "lead-mk01")

    create_tmp_tech("pbsb-alloy-2", "lead-mk02")

    create_tmp_tech("upgrader-mk01", "oil-machines-mk01", true)
    create_tmp_tech("lor-mk01", "oil-machines-mk01", true)
    create_tmp_tech("gas-refinery-mk01", "oil-machines-mk01", true)
    create_tmp_tech("oil-boiler-mk01", "oil-machines-mk01", true)

    create_tmp_tech("carbon-black-2", "rubber", true)
    create_tmp_tech("engine-unit-2", "rubber", true)

    create_tmp_tech("lithium-peroxide", "filtration")

    create_tmp_tech("p2s5", "additives")

    create_tmp_tech("ethylene", "ethylene")

    create_tmp_tech("ree-mining-drill-mk02", "machines-mk02")
    create_tmp_tech("antimonium-drill-mk02", "machines-mk02")
    create_tmp_tech("centrifuge-mk02", "machines-mk02")
    create_tmp_tech("grease-table-mk01", "machines-mk02")

    create_tmp_tech("silicon-wafer-2", "basic-electronics")
    create_tmp_tech("silicon-wafer-3", "basic-electronics")
    create_tmp_tech("pumpjack-hightech", "basic-electronics")

    create_tmp_tech("nuclear-sample", "nucleo")
    create_tmp_tech("plutonium-seperation", "nucleo")
    create_tmp_tech("particle-accelerator-mk01", "nucleo")

    create_tmp_tech("lead-container", "coated-container")

    create_tmp_tech("propeptides", "immunosupressants")

    create_tmp_tech("lithium-chloride", "lithium-processing")
    create_tmp_tech("lithium-niobate", "lithium-processing")
    create_tmp_tech("acetaldehyde-2", "lithium-processing")
    create_tmp_tech("p-dope2", "lithium-processing")

    create_tmp_tech("fuelrod-mk01-1", "nuclear-power")
    create_tmp_tech("antimony-phosphate-2", "nuclear-power")
    create_tmp_tech("plutonium-oxidation-2", "nuclear-power")
    create_tmp_tech("thermal-neutron", "nuclear-power")
    create_tmp_tech("u234-po210", "nuclear-power")
    create_tmp_tech("rtg", "nuclear-power")
    create_tmp_tech("fuelrod-mk05", "nuclear-power")
    create_tmp_tech("propene-to-butanol", "nuclear-power")
    create_tmp_tech("uranium-seperation", "nuclear-power")
    create_tmp_tech("ac-oxygenated", "nuclear-power")
    create_tmp_tech("americium-reduction", "nuclear-power")
    create_tmp_tech("curium-reduction", "nuclear-power")
    create_tmp_tech("sb-chloride-to-ore", "nuclear-power")
    create_tmp_tech("u236-u237", "nuclear-power")
    create_tmp_tech("fuelrod-mk04", "nuclear-power")

    create_tmp_tech("americium-seperation", "nuclear-power-mk02")

    create_tmp_tech("denatured-seismite-2", "pharmagenomics")

    create_tmp_tech("acrylic", "thermal-mk03")

    create_tmp_tech("nexelit-battery-recharge", "battery-mk02")

    create_tmp_tech("cyanoacetate", "renewable-mk03")
    create_tmp_tech("aerial-blimp-mk03", "renewable-mk03")
    create_tmp_tech("multiblade-turbine-mk03", "renewable-mk03")

    create_tmp_tech("czts-plate", "solar-mk03")
    create_tmp_tech("czts-slab", "solar-mk03")

    create_tmp_tech("sc-engine", "erbium")
    create_tmp_tech("rotor-m", "erbium")
    create_tmp_tech("magnetic-ring", "erbium")

    create_tmp_tech("arsenic", "nano-tech")
    create_tmp_tech("gaas", "nano-tech")
    create_tmp_tech("nanocrystaline-core", "nano-tech")

    create_tmp_tech("heavy-fermion", "integrated-circuits-3")

    create_tmp_tech("ammonium-sulfate", "nanozymes")

    create_tmp_tech("utility-box-mk04", "intermetallics-mk04")
    create_tmp_tech("electronics-mk04", "intermetallics-mk04")
    create_tmp_tech("controler-mk04", "intermetallics-mk04")
    create_tmp_tech("heating-system", "intermetallics-mk04")

    create_tmp_tech("tio2", "solar-mk03")
    create_tmp_tech("crude-top-layer", "solar-mk03")
    create_tmp_tech("transparent-anode", "solar-mk03")

    create_tmp_tech("brake-mk03", "energy-3")
    create_tmp_tech("hydraulic-system-mk01", "energy-3")

    create_tmp_tech("neutron-moderator-mk01")
    create_tmp_tech("control-rod")
end


----------------------------------------------------
-- AUTO TECH script. Make sure it's the very last
----------------------------------------------------
require('prototypes/functions/auto_tech')
----------------------------------------------------
----------------------------------------------------
