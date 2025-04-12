-- ****************************************************************************
-- **
-- **  File     :  /lua/unit.lua
-- **  Author(s):  John Comes, David Tomandl, Gordon Duclos
-- **
-- **  Summary  : The Unit lua module
-- **
-- **  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
-- ****************************************************************************




local oldUnit = Unit
local Buff = import('/lua/sim/Buff.lua')
local Utils = import('/mods/TotalVeterancyRebalanced/lua/sim/VeterancyUtils.lua')
Unit = Class(oldUnit) {

    OnCreate = function(self)
        oldUnit.OnCreate(self)
        local bp = self:GetBlueprint()
        self.Sync.RegenRate = bp.Defense.RegenRate
        if self:HasLevel() then
            self.VeteranLevel = 0
            self.LevelProgress = 0
            self.Sync.LevelProgress = self.LevelProgress
            self.xp = 0
            self.currentXpPerTimeStep = math.ceil(
                Utils.TicksInTimeStep *
                bp.Economy.XpPerTick
            )
            self:CalculateXpValues(bp.Economy)
        end
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        if self:HasLevel() then
            local bp = self:GetBlueprint()
            if table.find(bp.Categories, "STRUCTURE") and self.IsUpgrade then
                WARN('Upgraded - ' .. builder.LevelProgress)
                self:SyncLevel(builder.LevelProgress)
            end
            self:ForkThread(self.XPOverTime)
        end
        oldUnit.OnStopBeingBuilt(self, builder, layer)
    end,

    -- testcode
    -- Economy-this is for everything which requires energy to be run: intel, shields etc
    SetMaintenanceConsumptionActive = function(self)
        -- WARN('SetMaintenanceConsumptionActive')
        -- if self.XPOverTimeThread then
        --     KillThread(self.XPOverTimeThread)
        -- end
        -- if self.VeteranLevel < LevelCap then
        --     self.XPOverTimeThread = ForkThread(self.XPOverTime, self)
        -- end
        oldUnit.SetMaintenanceConsumptionActive(self)
    end,

    SetMaintenanceConsumptionInactive = function(self)
        -- WARN('SetMaintenanceConsumptionInactive')
        -- KillThread(self.XPOverTimeThread)
        oldUnit.SetMaintenanceConsumptionInactive(self)
    end,
    -- testcode end

    XPOverTime = function(self)
        while not self:IsDead() and self:CanLevelUp() do
            self:AddXp(self.currentXpPerTimeStep)
            if self.buildStartTick then
                local currentTicks = GetGameTick()
                self:AddBuildXp(currentTicks - self.buildStartTick)
                self.buildStartTick = currentTicks
            end
            WaitTicks(Utils.TicksInTimeStep + 1)
        end
    end,

    SetActiveConsumptionActive = function(self)
        if self:HasLevel() and self:CanLevelUp() then
            self.buildStartTick = GetGameTick()
        end
        oldUnit.SetActiveConsumptionActive(self)
    end,

    SetActiveConsumptionInactive = function(self)
        if self.buildStartTick then
            self:AddBuildXp(GetGameTick() - self.buildStartTick)
            self.buildStartTick = nil
        end
        oldUnit.SetActiveConsumptionInactive(self)
    end,

    AddBuildXp = function(self, ticks)
        if ticks <= 0 then
            return
        end
        local bp = self:GetBlueprint()
        self:AddXp(ticks * bp.Economy.XpPerTick * Utils.BuildUnitXpModifier)
    end,

    -- use this to go through the AddKills function rather than directly setting veterancy
    SetVeterancy = function(self, veteranLevel)
        veteranLevel = veteranLevel or 0
        if veteranLevel <= 5 then
            return oldUnit.SetVeterancy(self, veteranLevel) -- I'm pretty sure this is where its resetting unit level I guess its fine, but those special buffs get delayed
        else
            local bp = self:GetBlueprint()                  -- change suggested by Gilbot
            if bp.Veteran['Level' .. veteranLevel] then
                self:AddKills(bp.Veteran['Level' .. veteranLevel])
            else
                WARN('SetVeterancy called on ' .. self:GetUnitId() .. ' with veteran level ' .. veteranLevel ..
                    ' which was not defined in its BP file. ' .. ' Veterancy level has not been set.')
            end
        end
    end,

    -- Allowing buff bonus and adj bonus at same time!!
    UpdateProductionValues = function(self)
        local bpEcon = self:GetBlueprint().Economy
        if not bpEcon then
            return
        end
        self:SetProductionPerSecondEnergy((self.EnergyProdMod or bpEcon.ProductionPerSecondEnergy or 0) *
            (self.EnergyProdAdjMod or 1))
        self:SetProductionPerSecondMass((self.MassProdMod or bpEcon.ProductionPerSecondMass or 0) *
            (self.MassProdAdjMod or 1))
    end,

    DoTakeDamage = function(self, instigator, amount, vector, damageType)
        if instigator and IsUnit(instigator) and not instigator:IsDead() then
            local preAdjHealth = self:GetHealth()
            local bp = self:GetBlueprint()

            if self:HasLevel() and self.xpPerHp and preAdjHealth > 0 then
                if amount >= preAdjHealth then
                    instigator:AddXp(
                        preAdjHealth * self.xpPerHp * Utils.DealingDamageToXpModifier
                    )
                    if not self:IsDead() then
                        instigator:AddXp(Utils.GetKillXpByLevel(bp.Economy.BaseXpValue, self.VeteranLevel))
                    end
                else
                    local sumXp = amount * self.xpPerHp
                    instigator:AddXp(sumXp * Utils.DealingDamageToXpModifier)
                    self:AddXp(sumXp * Utils.TakenDamegeToXpModifier)
                end
            end
        end
        oldUnit.DoTakeDamage(self, instigator, amount, vector, damageType)
    end,

    SyncLevel = function(self, level)
        local roundLevel = math.floor(level)
        while roundLevel > self.VeteranLevel do
            self:OnVeteranLevelUp()
        end
        local remain = level - roundLevel
        if remain > 0 and self:CanLevelUp() then
            self.xp = remain * self.xpToNextLevel
        end
    end,

    AddXp = function(self, amount)
        if not self:GetBlueprint().Economy.BaseXpValue then
            return
        end
        if self:CanLevelUp() then
            self.xp = self.xp + amount
            self:CheckVeteranLevel()
        end
    end,

    -- Check to see if we should veteran up.
    CheckVeteranLevel = function(self)
        if not self.xpToNextLevel then
            return
        end
        local bp = self:GetBlueprint()
        while self.xp >= self.xpToNextLevel do
            if self:CanLevelUp() then
                self:OnVeteranLevelUp()
            else
                self.xp = 0
            end
        end
        self.LevelProgress = self.xp / self.xpToNextLevel + self.VeteranLevel
        self.Sync.LevelProgress = self.LevelProgress
    end,

    OnVeteranLevelUp = function(self)
        local bpA = self:GetBlueprint()
        self.xp = self.xp - self.xpToNextLevel
        local old = self.VeteranLevel
        self.VeteranLevel = self.VeteranLevel + 1
        self:CalculateXpValues(bpA.Economy)


        if bpA.VeterancyBuffTypes then
            self:ApplyVeterancyBuffs(bpA.VeterancyBuffTypes)
        end

        -- Get any overriding buffs if they exist
        local bp = bpA.Buffs
        -- Check for unit buffs

        if bp then
            for bLevel, bData in bp do
                if (bLevel == 'Any' or bLevel == 'Level' .. self.VeteranLevel) then
                    for bType, bValues in bData do
                        local buffName = self:CreateUnitBuff(bLevel, bType, bValues)
                        if buffName then
                            Buff.ApplyBuff(self, buffName)
                        end
                    end
                end
            end
        end

        self:GetAIBrain():OnBrainUnitVeterancyLevel(self, self.VeteranLevel)
        self:DoUnitCallbacks('OnVeteran')
    end,

    ApplyVeterancyBuffs = function(self, bTypeTable)
        for k, bType in bTypeTable do
            Buff.ApplyBuff(self, 'Veterancy' .. bType)
        end
    end,

    -- function to generate the new veterancy buffs
    CreateUnitBuff = function(self, levelName, buffType, buffValues)
        -- Generate a buff based on the unitId
        local buffName = self:GetUnitId() .. levelName .. buffType
        local buffMinLevel = nil
        local buffMaxLevel = nil
        if buffValues.MinLevel then
            buffMinLevel = buffValues.MinLevel
        end
        if buffValues.MaxLevel then
            buffMaxLevel = buffValues.MaxLevel
        end

        -- Create the buff if needed
        if not Buffs[buffName] then
            BuffBlueprint {
                MinLevel = buffMinLevel,
                MaxLevel = buffMaxLevel,
                Name = buffName,
                DisplayName = buffName,
                BuffType = buffType,
                Stacks = buffValues.Stacks,
                Duration = buffValues.Duration,
                Affects = buffValues.Affects
            }
        end

        -- Return the buffname so the buff can be applied to the unit
        return buffName
    end,

    HasLevel = function(self)
        return self:GetBlueprint().Economy.BaseXpValue ~= nil
    end,

    CanLevelUp = function(self)
        return self.VeteranLevel < Utils.LevelCap
    end,

    CalculateXpValues = function(self, economy)
        self.xpToNextLevel = Utils.GetXpToLevel(economy.BaseXpValue, self.VeteranLevel + 1)
        local maxHealth = self:GetMaxHealth()
        local shield = self:GetShield()
        if shield then
            maxHealth = maxHealth + shield:GetMaxHealth()
        end
        self.xpPerHp = Utils.GetXpToLevel(economy.BaseXpValue, self.VeteranLevel) / maxHealth
    end,

    GetShield = function(self)
        return self.MyShield or nil
    end,
}
