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
local Buff = import('/lua/sim/buff.lua')
Unit = Class(oldUnit) {

    OnCreate = function(self)
        oldUnit.OnCreate(self)
        local bp = self:GetBlueprint()
        if bp.Economy.XPperLevel then -- just to make certain this is not called
            -- for units which do not need it
            self.XPnextLevel = bp.Economy.XPperLevel
            self.xp = 0
            --            self.Txp = 0
            self.XpModfierInCombat = 1
            self.XpModfierOutOfCombat = 1
            self.XpModfierCombat = 1
            self.XpModfier = 0.2
            self.XpModfierBuffed = 0.4
            self.XpModfierOld = 0.2
            if bp.Economy.xpTimeStep ~= nil then
                self.Waittime = bp.Economy.xpTimeStep * 0.002
            end

            self.VeteranLevel = 1
            self.LevelProgress = 1
            self.Sync.LevelProgress = self.LevelProgress
            self.Sync.RegenRate = bp.Defense.RegenRate
        end
        self.VeteranLevel = 1
        self.LevelProgress = 1
        self.Sync.LevelProgress = self.LevelProgress
        self.Sync.RegenRate = bp.Defense.RegenRate
        if self.XPnextLevel == nil then
            self.XPnextLevel = 100
        end
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        if self:GetBlueprint().Economy.xpTimeStep then
            self:ForkThread(self.XPOverTime)
            self.XpModfier = self.XpModfierOld
        end
        oldUnit.OnStopBeingBuilt(self, builder, layer)
    end,

    -- testcode
    -- Economy-this is for everything which requires energy to be run: intel, shields etc
    SetMaintenanceConsumptionActive = function(self)
        if self.XPOverTimeThread then
            KillThread(self.XPOverTimeThread)
        end
        self.XPOverTimeThread = ForkThread(self.XPOverTime, self)
        oldUnit.SetMaintenanceConsumptionActive(self)
    end,

    SetMaintenanceConsumptionInactive = function(self)
        KillThread(self.XPOverTimeThread)
        oldUnit.SetMaintenanceConsumptionInactive(self)
    end,
    -- testcode end

    XPOverTime = function(self)
        if not self:GetBlueprint().Economy.xpTimeStep then
            return
        end -- sanity check
        -- local waittime = (self:GetBlueprint().Economy.xpTimeStep + self.VeteranLevel)* 0.01
        -- WaitSeconds(self.Waittime + (self.VeteranLevel * 0.5 - 1) * 0.05 ) --wait longer to improve performance

        while not self:IsDead() do
            self:AddXP((self.XPnextLevel * self.XpModfier * self.XpModfierCombat) / 60) -- (def=45)Will be incrementing the divider to slow down xp-over-time till it feels right
            WaitSeconds(self.Waittime + (self.VeteranLevel * 0.5 - 1) * 0.0125) -- Could this low value be getting in the way?? Increased multi to 0.0125 to slow progression by 25%
        end
    end,

    startBuildXPThread = function(self)
        local levelPerSecond = self:GetBlueprint().Economy.BuildXPLevelpSecond
        if not levelPerSecond then
            return
        end
        WaitSeconds(1) -- when you build THAT fast you do not need any xp, another performance tweak
        while not self:IsDead() do
            self.XpModfier = self.XpModfierBuffed
            self:AddXP(self.XPnextLevel / (1 + self.VeteranLevel * 0.3) + 3) -- adjusted again, removed ceil, performance
            WaitSeconds(5) -- to reduce the performance impact
        end
    end,

    -- testcode

    -- reworked builder xp to include upgrades and allow for pausing
    -- launchers are still unaffected
    -- inconsistent gains for commanders.
    SetActiveConsumptionActive = function(self)
        self.XpModfier = self.XpModfierBuffed
        if self.BuildXPThread then
            KillThread(self.BuildXPThread)
        end
        self.BuildXPThread = ForkThread(self.startBuildXPThread, self)
        oldUnit.SetActiveConsumptionActive(self)
    end,

    SetActiveConsumptionInactive = function(self)
        self.XpModfier = self.XpModfierOld
        KillThread(self.BuildXPThread)
        if self.BuildXPThread then
            KillThread(self.BuildXPThread)
        end
        oldUnit.SetActiveConsumptionInactive(self)
    end,

    OnProductionPaused = function(self)
        KillThread(self.BuildXPThread)
        if self.BuildXPThread then
            KillThread(self.BuildXPThread)
        end
        oldUnit.OnProductionPaused(self)
    end,

    OnProductionUnpaused = function(self)
        if self.BuildXPThread then
            KillThread(self.BuildXPThread)
        end
        self.BuildXPThread = ForkThread(self.startBuildXPThread, self)
        oldUnit.OnProductionUnpaused(self)
    end,

    -- end testcode

    --    OnStartBuild = function(self, unitBeingBuilt, order)
    --        --LOG('unit:OnStartBuild')
    --        self.BuildXPThread = ForkThread(self.startBuildXPThread, self)
    --        oldUnit.OnStartBuild(self, unitBeingBuilt, order)
    --    end,
    --
    OnStopBuild = function(self, unitBeingBuilt)
        self.XpModfier = self.XpModfierOld
        -- LOG('unit:OnStopBuild')
        KillThread(self.BuildXPThread)
        oldUnit.OnStopBuild(self, unitBeingBuilt)
    end,

    OnFailedToBuild = function(self)
        self.XpModfier = self.XpModfierOld
        -- LOG('unit:OnFailedToBuild')
        KillThread(self.BuildXPThread)
        oldUnit.OnFailedToBuild(self)
    end,

    ------------------------------------------------------------------------------------- VETERANCY
    ---------------------------------------------------------------------------------

    -- use this to go through the AddKills function rather than directly setting veterancy
    SetVeterancy = function(self, veteranLevel)
        veteranLevel = veteranLevel or 0
        if veteranLevel <= 5 then

            return oldUnit.SetVeterancy(self, veteranLevel) -- I'm pretty sure this is where its resetting unit level I guess its fine, but those special buffs get delayed
        else
            local bp = self:GetBlueprint() -- change suggested by Gilbot
            if bp.Veteran['Level' .. veteranLevel] then
                self:AddKills(bp.Veteran['Level' .. veteranLevel])
            else
                WARN('SetVeterancy called on ' .. self:GetUnitId() .. ' with veteran level ' .. veteranLevel ..
                         ' which was not defined in its BP file. ' .. ' Veterancy level has not been set.')
            end
        end
    end,

    -- Check to see if we should veteran up.
    CheckVeteranLevel = function(self)
        if not self.XPnextLevel then
            return
        end
        local bp = self:GetBlueprint()
        --        LOG('xp:' .. self.xp.. ' level at:' .. self.XPperLevel)
        while self.xp >= self.XPnextLevel do
            self.xp = self.xp - self.XPnextLevel
            self.XPnextLevel = bp.Economy.XPperLevel * (1 + 0.1 * self.VeteranLevel)
            self:SetVeteranLevel(self.VeteranLevel + 1) -- fix this, it is causing  overhead
        end
        self.LevelProgress = self.xp / self.XPnextLevel + self.VeteranLevel
        self.Sync.LevelProgress = self.LevelProgress
        --        self.Sync.XPnextLevel = self.Txp - self.xp + self.XPnextLevel
        -- syncing XP need for Levelup, calculation within the UI is faulty.
    end,

    -- fix, 117 did not adjust this to reflect new balance
    AddLevels = function(self, levels) -- Not sure where this is called
        if self.VeteranLevel >= 1000 then 
            return
        end
        local bp = self:GetBlueprint()
        local curlevel = self.VeteranLevel
        local percent = self.LevelProgress - curlevel
        local xpAdd = 0
        if levels >= (1 - percent) then
            xpAdd = self.XPnextLevel * (1 - percent)
            levels = levels - (1 - percent)
        else
            xpAdd = self.XPnextLevel * levels
            levels = 0
        end
        while levels > 1 do
            levels = levels - 1
            curlevel = curlevel + 1
            xpAdd = xpAdd + bp.Economy.XPperLevel * (1 + 0.1 * curlevel) -- fixed
        end -- to account for the 10% increase per gained level
        xpAdd = xpAdd + bp.Economy.XPperLevel * (1 + 0.1 * (curlevel + 1)) * levels
        self:AddXP(xpAdd) -- same
    end,

    SetVeteranLevel = function(self, level)
        -- LOG(' ')
        -- LOG('*DEBUG: '.. self:GetBlueprint().Description .. ' VETERAN UP! LEVEL ', repr(level))
        local old = self.VeteranLevel
        self.VeteranLevel = level
        local bpA = self:GetBlueprint()
        -- Apply default veterancy buffs
        local buffTypes = {'Damage', 'DamageArea', 'Range', 'Speed', 'BuildRate'}
        local buffTypesNonCombat = {'Regen', 'Health', 'Vision', 'OmniRadius', 'Radar', 'Shield', 'RateOfFire'}
        local buffACUTypes = {'ACUResourceProduction', 'CEC'}
        local buffSCUTypes = {'CEC'}
        local buffSTRUCTURETypes = {'ResourceProduction'}
        local buffSHIELDTypes = {'EnergyCon'}

        if bpA.Categories and not (table.find(bpA.Categories, 'STRUCTURE') and table.find(bpA.Categories, 'DEFENSE') and
            table.find(bpA.Categories, 'ANTIMISSILE') and table.find(bpA.Categories, 'ARTILLERY')) then
            for k, bType in buffTypes do
                Buff.ApplyBuff(self, 'Veterancy' .. bType)
            end
        end

        if bpA.Categories then
            for k, bType in buffTypesNonCombat do -- Moved health (and ROF) buffs to here only, all units get this...sorry the naming is back to front with bufftypes
                Buff.ApplyBuff(self, 'Veterancy' .. bType)
            end
        end

        if bpA.Categories and table.find(bpA.Categories, 'COMMAND') then
            for k, bType in buffACUTypes do
                Buff.ApplyBuff(self, 'Veterancy' .. bType)
            end
        end

        if bpA.Categories and table.find(bpA.Categories, 'SUBCOMMAND') then
            for k, bType in buffSCUTypes do
                Buff.ApplyBuff(self, 'Veterancy' .. bType)
            end
        end

        if bpA.Categories and table.find(bpA.Categories, 'STRUCTURE') then
            for k, bType in buffSTRUCTURETypes do
                Buff.ApplyBuff(self, 'Veterancy' .. bType)
            end
        end

        if bpA.Categories and table.find(bpA.Categories, 'SHIELD') then
            for k, bType in buffSHIELDTypes do
                Buff.ApplyBuff(self, 'Veterancy' .. bType)
            end
        end

        -- if old >= 25 then
        --	local shield = self:GetShield()
        -- 	    if not shield then 
        -- 	        self:CreateShield(bpA)
        -- 	end
        -- end

        -- Get any overriding buffs if they exist
        local bp = self:GetBlueprint().Buffs
        -- Check for unit buffs

        if bp then
            for bLevel, bData in bp do
                if (bLevel == 'Any' or bLevel == 'Level' .. level) then
                    for bType, bValues in bData do
                        local buffName = self:CreateUnitBuff(bLevel, bType, bValues)
                        if buffName then
                            Buff.ApplyBuff(self, buffName)
                        end
                    end
                end
            end
        end

        self:GetAIBrain():OnBrainUnitVeterancyLevel(self, level)
        self:DoUnitCallbacks('OnVeteran')
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
            -- LOG(buffName .. ': '..buffMinLevel.. ' - '..buffMaxLevel)
            BuffBlueprint {
                MinLevel = buffMinLevel,
                MaxLevel = buffMaxLevel,
                Name = buffName,
                DisplayName = buffName,
                BuffType = buffType,
                Stacks = buffValues.Stacks,
                -- self.BuffTypes[buffType].BuffStacks,
                Duration = buffValues.Duration,
                Affects = buffValues.Affects
            }
        end

        -- Return the buffname so the buff can be applied to the unit
        return buffName
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

    AddXP = function(self, amount)
        if self.VeteranLevel >= 1000 then 
            return
        end
        if not self.XPnextLevel then
            return
        end
        --        self.Txp = self.Txp + (math.ceil(amount))
        --        self.Sync.Txp = self.Txp-- Total EXP collected
        self.xp = self.xp + (amount) -- removed ceil, hope this speeds things up
        --        LOG('___' .. amount .. repr(self:GetBlueprint().Description))
        self:CheckVeteranLevel()
    end,

    IsInCombat = function(self, instigator)
        if self.BuildXPThread then
            KillThread(self.BuildXPThread)
        end
        if instigator.BuildXPThread then
            KillThread(instigator.BuildXPThread)
        end
        -- self:ForkThread(self.DoTakeDamage)
        -- self:ForkThread(instigator.DoTakeDamage)
        self.BuildXPThread = ForkThread(self.startBuildXPThread, self)
        instigator.BuildXPThread = ForkThread(instigator.startBuildXPThread, self)

        self.XpModfierCombat = self.XpModfierInCombat;
        instigator.XpModfierCombat = instigator.XpModfierInCombat;

        WaitSeconds(2)
        if self.BuildXPThread then
            KillThread(self.BuildXPThread)
        end
        if instigator.BuildXPThread then
            KillThread(instigator.BuildXPThread)
        end

        self.XpModfierCombat = self.XpModfierOutOfCombat;
        instigator.XpModfierCombat = instigator.XpModfierOutOfCombat;
        oldUnit.IsInCombat(self, instigator)
    end,

    DoTakeDamage = function(self, instigator, amount, vector, damageType)
        if instigator and IsUnit(instigator) and not instigator:IsDead() then
            local preAdjHealth = self:GetHealth()
            local bp = self:GetBlueprint()

            if bp.Categories and
                (table.find(bp.Categories, 'TECH1') or table.find(bp.Categories, 'TECH2') or
                    table.find(bp.Categories, 'TECH3')) and not table.find(bp.Categories, 'STRUCTURE') and
                not table.find(bp.Categories, 'LAND') and not table.find(bp.Categories, 'NAVAL') and
                not table.find(bp.Categories, 'ENGINEER') then
                bp.FlyerMulti = 1
            else
                bp.FlyerMulti = 12 -- Our air gets picked off quickly, so we're giving them much love
            end

            if bp.Economy.xpPerHp then -- Its okay to leave this clause in. Since all the calculations are based around the bp.economy.xpperhp anyway
                if amount >= preAdjHealth then
                    instigator:AddXP(preAdjHealth * bp.Economy.xpPerHp * bp.FlyerMulti * 1.40) -- Going to increment the 1.xx multi till it feels right
                else
                    instigator:AddXP(amount * bp.Economy.xpPerHp * bp.FlyerMulti * 1.40)
                    self:AddXP(amount * bp.Economy.xpPerHp * 1.40)
                end
            end

        end
        oldUnit.DoTakeDamage(self, instigator, amount, vector, damageType)

    end,

    GetShield = function(self)
        return self.MyShield or nil
    end
}

