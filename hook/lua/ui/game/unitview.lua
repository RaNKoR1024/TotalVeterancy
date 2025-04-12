do
    local Utils = import('/mods/TotalVeterancyRebalanced/lua/sim/VeterancyUtils.lua')
    local OldUpdateWindow = UpdateWindow

    function UpdateWindow(info)
        OldUpdateWindow(info)

        if info.blueprintId ~= 'unknown' then
            for index = 1, 5 do
                local i = index
                controls.vetIcons[i]:Hide()
            end

            controls.XPText:Hide()
            controls.vetXPBar:Hide()
            controls.vetXPText:Hide()
            controls.Buildrate:Hide()
            controls.shieldText:Hide()

            local bp = __blueprints[info.blueprintId]
            --enemy level display
            if info.entityId == nil and info.maxHealth and bp.Defense.MaxHealth then
                if table.find(bp.Categories, 'COMMAND') or table.find(bp.Categories, 'SUBCOMMANDER') then
                    controls.vetXPText:SetText('Level ☠☠☠')
                    controls.vetXPText:Show()
                else
                    local level = Utils.GetUnitLevelByHealth(bp.Defense.MaxHealth, info.maxHealth)
                    local killxp = Utils.GetKillXpByLevel(bp.Economy.BaseXpValue, level)
                    local killxpString = Utils.FormatXpAmount(killxp)
                    controls.vetXPText:SetText(
                        string.format(
                            'Level~%d  worth ~%s XP',
                            level,
                            killxpString
                        )
                    )
                    controls.vetXPText:Show()
                end
            end

            if bp.Economy.BaseXpValue then
                --enemy xp display
                if info.entityId == nil then
                    controls.shieldText:SetText(string.format('BaseXP %d', bp.Economy.BaseXpValue))
                    controls.shieldText:Show()
                end

                --level progress and new numerical xp display
                local unitData = UnitData[info.entityId]
                if unitData.LevelProgress then
                    local level = math.floor(unitData.LevelProgress)
                    local percent = unitData.LevelProgress - level
                    local xpNextLevel = 0
                    local xp = 0
                    if level < Utils.LevelCap then
                        xpNextLevel = Utils.GetXpToLevel(bp.Economy.BaseXpValue, level + 1)
                        xp = xpNextLevel * percent
                    end
                    local worth = Utils.GetKillXpByLevel(bp.Economy.BaseXpValue, level)
                    local xpString = Utils.FormatXpAmount(xp)
                    local xpNextLevelString = Utils.FormatXpAmount(xpNextLevel)
                    local worthString = Utils.FormatXpAmount(worth)
                    controls.XPText:SetText(
                        string.format(
                            'current XP %s / next Level %s / worth %s',
                            xpString,
                            xpNextLevelString,
                            worthString
                        )
                    )
                    controls.XPText:Show()
                    controls.vetXPBar:SetValue(percent)
                    controls.vetXPText:SetText(string.format('Level %d', level))
                    controls.vetXPText:Show()
                    controls.vetXPBar:Show()
                end
            end

            -- regen rate
            if info.health and UnitData[info.entityId].RegenRate then
                controls.health:SetText(string.format("%d / %d +%d/s", info.health, info.maxHealth,
                    math.floor(UnitData[info.entityId].RegenRate)))
            end
            -- shield hp, regen
            if info.shieldRatio > 0 and UnitData[info.entityId].ShieldMaxHp then
                controls.shieldText:Show()
                if UnitData[info.entityId].ShieldRegen then
                    controls.shieldText:SetText(string.format("%d / %d +%d/s",
                        math.floor(UnitData[info.entityId].ShieldMaxHp * info.shieldRatio),
                        UnitData[info.entityId].ShieldMaxHp, UnitData[info.entityId].ShieldRegen))
                else
                    controls.shieldText:SetText(string.format("%d / %d",
                        math.floor(UnitData[info.entityId].ShieldMaxHp * info.shieldRatio),
                        UnitData[info.entityId].ShieldMaxHp))
                end
            end
            -- changed. build rate sync replaced by method
            if info.userUnit ~= nil and info.userUnit:GetBuildRate() >= 2 then
                controls.Buildrate:SetText(string.format("%d", math.floor(info.userUnit:GetBuildRate())))
                controls.Buildrate:Show()
            end
        else
            controls.XPText:Hide()
            controls.vetXPBar:Hide()
            controls.vetXPText:Hide()
            controls.Buildrate:Hide()
        end
    end

    local OldCreateUI = CreateUI

    function CreateUI()
        OldCreateUI()
        controls.vetXPBar = StatusBar(controls.bg, 0, 1, false, false, nil, nil, true)
        controls.vetXPText = UIUtil.CreateText(controls.bg, '', 12, UIUtil.bodyFont)
        controls.shieldText = UIUtil.CreateText(controls.bg, '', 13, UIUtil.bodyFont)
        controls.Buildrate = UIUtil.CreateText(controls.bg, '', 12, UIUtil.bodyFont)
        controls.XPText = UIUtil.CreateText(controls.bg, '', 12, UIUtil.bodyFont)
    end
end
