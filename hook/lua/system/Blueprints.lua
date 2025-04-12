do
    local oldModBP = ModBlueprints

    function ModBlueprints(all_bps)
        oldModBP(all_bps)

        local ACUbaseValue = 6400 --
        local SCUbaseValue = 6400 -- 30k if calculated by cost
        local defaultXpPerTickModifier = 0.01
        local nonCombatXpPerTickModifier = defaultXpPerTickModifier * 10
        local commonBuffTypes = { 'Common', 'CommonLong' }
        local nonAntimissleBuffTypes = { 'NonAntiMissile', 'NonAntiMissileLong' }
        local nonAirBuffTypes = { 'NonAir' }

        local once = true
        for id, bp in all_bps.Unit do
            if bp.Economy
                and bp.Categories
                and bp.Economy.BuildCostMass
                and bp.Economy.BuildCostEnergy
                and bp.Economy.BuildTime
                and bp.Defense.MaxHealth
                and (not table.find(bp.Categories, 'UNTARGETABLE') or table.find(bp.Categories, 'SATELLITE'))
            then
                if table.find(bp.Categories, 'COMMAND') then
                    bp.Economy.BaseXpValue = ACUbaseValue
                elseif table.find(bp.Categories, 'SUBCOMMANDER') then
                    bp.Economy.BaseXpValue = SCUbaseValue
                else
                    bp.Economy.BaseXpValue = math.max(
                        10,
                        math.ceil(
                            (bp.Economy.BuildCostMass + bp.Economy.BuildCostEnergy * 0.01 + bp.Economy.BuildTime * 0.01) *
                            0.1
                        )
                    )
                end

                local veterancyBuffTypes = {}
                local xpPerTickModifier = defaultXpPerTickModifier
                AddBuffTypes(veterancyBuffTypes, commonBuffTypes)
                if table.find(bp.Categories, 'STRUCTURE') then
                    if table.find(bp.Categories, 'ECONOMY') then
                        xpPerTickModifier = nonCombatXpPerTickModifier
                    end
                end
                if not (table.find(bp.Categories, 'STRUCTURE') and table.find(bp.Categories, 'DEFENSE') and table.find(bp.Categories, 'ANTIMISSILE')) then
                    AddBuffTypes(veterancyBuffTypes, nonAntimissleBuffTypes)
                end
                if not table.find(bp.Categories, 'AIR') then
                    AddBuffTypes(veterancyBuffTypes, nonAirBuffTypes)
                end
                if table.find(bp.Categories, 'INTELLIGENCE') then
                    xpPerTickModifier = nonCombatXpPerTickModifier
                end

                if table.find(bp.Categories, 'STRUCTURE')
                    and (table.find(bp.Categories, 'ECONOMY') or table.find(bp.Categories, 'INTELLIGENCE'))
                then
                    xpPerTickModifier = nonCombatXpPerTickModifier
                end

                bp.Economy.XpPerTick = bp.Economy.BaseXpValue * xpPerTickModifier
                bp.VeterancyBuffTypes = veterancyBuffTypes
            end
        end
    end

    AddBuffTypes = function(buffTypes, additionalBuffTypes)
        for k, buffType in additionalBuffTypes do
            table.insert(buffTypes, buffType)
        end
    end
end
