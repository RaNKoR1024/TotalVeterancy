-- ****************************************************************************
-- **
-- **  File     :  /lua/shield.lua
-- **  Author(s):  John Comes, Gordon Duclos
-- **
-- **  Summary  : Shield lua module
-- **
-- **  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
-- ****************************************************************************
local Utils = import('/mods/TotalVeterancyRebalanced/lua/sim/VeterancyUtils.lua')
local oldShield = Shield
Shield = Class(oldShield) {

    OnCreate = function(self, spec)
        self.spec = spec
        spec.Owner.Sync.ShieldMaxHp = spec.ShieldMaxHealth
        spec.Owner.Sync.ShieldRegen = spec.ShieldRegenRate
        oldShield.OnCreate(self, spec)
    end,

    ChargingUp = function(self, curProgress, time)
        oldShield.ChargingUp(self, curProgress, time)
        self:SetHealth(self, self:GetMaxHealth())
    end,

    OnDamage = function(self, instigator, amount, vector, type)
        local absorbed = self:OnGetDamageAbsorption(instigator, amount, type)
        local xpPerHp = self.Owner.xpPerHp
        if xpPerHp then
            local sumXp = xpPerHp * absorbed
            self.Owner:AddXp(sumXp * Utils.TakenDamegeToXpModifier)
            instigator:AddXp(sumXp * Utils.DealingDamageToXpModifier)
        end
        oldShield.OnDamage(self, instigator, amount, vector, type)
    end
}

local oldUnitShield = PersonalShield
PersonalShield = Class(oldUnitShield) {

    OnCreate = function(self, spec)
        self.spec = spec
        spec.Owner.Sync.ShieldMaxHp = spec.ShieldMaxHealth
        spec.Owner.Sync.ShieldRegen = spec.ShieldRegenRate
        oldUnitShield.OnCreate(self, spec)
    end,

    ChargingUp = function(self, curProgress, time)
        oldUnitShield.ChargingUp(self, curProgress, time)
        self:SetHealth(self, self:GetMaxHealth())
    end,
}

local oldUnitBubbleShield = PersonalBubble
PersonalBubble = Class(oldUnitBubbleShield) {

    OnCreate = function(self, spec)
        self.spec = spec
        spec.Owner.Sync.ShieldMaxHp = spec.ShieldMaxHealth
        spec.Owner.Sync.ShieldRegen = spec.ShieldRegenRate
        oldUnitBubbleShield.OnCreate(self, spec)
    end,

    ChargingUp = function(self, curProgress, time)
        oldUnitBubbleShield.ChargingUp(self, curProgress, time)
        self:SetHealth(self, self:GetMaxHealth())
    end
}

local oldUnitCzarShield = CzarShield
CzarShield = Class(oldUnitCzarShield) {

    OnCreate = function(self, spec)
        self.spec = spec
        spec.Owner.Sync.ShieldMaxHp = spec.ShieldMaxHealth
        spec.Owner.Sync.ShieldRegen = spec.ShieldRegenRate
        oldUnitCzarShield.OnCreate(self, spec)
    end,

    ChargingUp = function(self, curProgress, time)
        oldUnitCzarShield.ChargingUp(self, curProgress, time)
        self:SetHealth(self, self:GetMaxHealth())
    end
}

local oldUnitTransportShield = TransportShield
TransportShield = Class(oldUnitTransportShield) {

    OnCreate = function(self, spec)
        self.spec = spec
        spec.Owner.Sync.ShieldMaxHp = spec.ShieldMaxHealth
        spec.Owner.Sync.ShieldRegen = spec.ShieldRegenRate
        oldUnitTransportShield.OnCreate(self, spec)
    end,

    ChargingUp = function(self, curProgress, time)
        oldUnitTransportShield.ChargingUp(self, curProgress, time)
        self:SetHealth(self, self:GetMaxHealth())
    end
}

local oldAntiArtilleryShield = AntiArtilleryShield
AntiArtilleryShield = Class(oldAntiArtilleryShield) {

    OnCreate = function(self, spec)
        self.spec = spec
        spec.Owner.Sync.ShieldMaxHp = spec.ShieldMaxHealth
        spec.Owner.Sync.ShieldRegen = spec.ShieldRegenRate
        oldAntiArtilleryShield.OnCreate(self, spec)
    end,

    ChargingUp = function(self, curProgress, time)
        oldAntiArtilleryShield.ChargingUp(self, curProgress, time)
        self:SetHealth(self, self:GetMaxHealth())
    end,

    OnDamage = function(self, instigator, amount, vector, type)
        local absorbed = self:OnGetDamageAbsorption(instigator, amount, type)
        local xpPerHp = self.Owner.xpPerHp
        if xpPerHp then
            local sumXp = xpPerHp * absorbed
            self.Owner:AddXp(sumXp * Utils.TakenDamegeToXpModifier)
            instigator:AddXp(sumXp * Utils.DealingDamageToXpModifier)
        end
        oldAntiArtilleryShield.OnDamage(self, instigator, amount, vector, type)
    end
}
