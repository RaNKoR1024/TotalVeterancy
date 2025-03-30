-- ****************************************************************************
-- **
-- **  File     :  /lua/shield.lua
-- **  Author(s):  John Comes, Gordon Duclos
-- **
-- **  Summary  : Shield lua module
-- **
-- **  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
-- ****************************************************************************
local oldShield = Shield
Shield = Class(oldShield) {

    InitBuffValues = function(self, spec)
        self.spec = spec
        local UnitxpValue = spec.Owner:GetBlueprint().Economy.xpValue
        if UnitxpValue == nil then
            UnitxpValue = 1
        end
        local ShieldHealthValue = spec.ShieldMaxHealth
        if ShieldHealthValue == nil then
            ShieldHealthValue = 1
        end

        if spec.Owner then
            self.XPperDamage = UnitxpValue / ShieldHealthValue
        else
            self.XPperDamage = 0
        end
        spec.Owner.Sync.ShieldMaxHp = spec.ShieldMaxHealth -- replace this with generic
        spec.Owner.Sync.ShieldRegen = spec.ShieldRegenRate -- method to directly query
        -- LOG(spec.ShieldRegenRate)
        -- LOG(self.XPperDamage)

    end,

    OnCreate = function(self, spec)
        self:InitBuffValues(spec)
        oldShield.OnCreate(self, spec)
    end,

    ChargingUp = function(self, curProgress, time)
        oldShield.ChargingUp(self, curProgress, time)
        self:SetHealth(self, self:GetMaxHealth())
    end,

    OnDamage = function(self, instigator, amount, vector, type)
        local absorbed = self:OnGetDamageAbsorption(instigator, amount, type)
        local hp = self:GetMaxHealth()
        if (self.XPperDamage * absorbed) > 3 then
            self.Owner:AddXP(self.XPperDamage * absorbed * 0.25)
            --               LOG('___' .. self.XPperDamage*absorbed)
        end
        oldShield.OnDamage(self, instigator, amount, vector, type)
    end
}

local oldUnitShield = PersonalShield
PersonalShield = Class(oldUnitShield) {

    InitBuffValues = function(self, spec)
        self.spec = spec
        local UnitxpValue = spec.Owner:GetBlueprint().Economy.xpValue
        if UnitxpValue == nil then
            UnitxpValue = 1
        end
        local ShieldHealthValue = spec.ShieldMaxHealth
        if ShieldHealthValue == nil then
            ShieldHealthValue = 1
        end

        if spec.Owner then
            self.XPperDamage = UnitxpValue / ShieldHealthValue
        else
            self.XPperDamage = 0
        end
        spec.Owner.Sync.ShieldMaxHp = spec.ShieldMaxHealth -- replace this with generic
        spec.Owner.Sync.ShieldRegen = spec.ShieldRegenRate -- method to directly query
        -- LOG(spec.ShieldRegenRate)
        -- LOG(self.XPperDamage)

    end,

    OnCreate = function(self, spec)
        Shield.InitBuffValues(self, spec)
        oldUnitShield.OnCreate(self, spec)
    end,

    ChargingUp = function(self, curProgress, time)
        oldUnitShield.ChargingUp(self, curProgress, time)
        self:SetHealth(self, self:GetMaxHealth())
    end,

    ApplyDamage = function(self, instigator, amount, vector, dmgType, doOverspill)
        oldUnitShield.ApplyDamage(self, instigator, amount, vector, dmgType, doOverspill)
    end,

    CreateShieldMesh = function(self)
        oldUnitShield.CreateShieldMesh(self)
    end,

    RemoveShield = function(self)
        oldUnitShield.RemoveShield(self)
    end,

    OnDestroy = function(self)
        oldUnitShield.OnDestroy(self)
    end

}

local oldUnitBubbleShield = PersonalBubble
PersonalBubble = Class(oldUnitBubbleShield) {

    InitBuffValues = function(self, spec)
        self.spec = spec
        local UnitxpValue = spec.Owner:GetBlueprint().Economy.xpValue
        if UnitxpValue == nil then
            UnitxpValue = 1
        end
        local ShieldHealthValue = spec.ShieldMaxHealth
        if ShieldHealthValue == nil then
            ShieldHealthValue = 1
        end

        if spec.Owner then
            self.XPperDamage = UnitxpValue / ShieldHealthValue
        else
            self.XPperDamage = 0
        end
        spec.Owner.Sync.ShieldMaxHp = spec.ShieldMaxHealth -- replace this with generic
        spec.Owner.Sync.ShieldRegen = spec.ShieldRegenRate -- method to directly query
        -- LOG(spec.ShieldRegenRate)
        -- LOG(self.XPperDamage)

    end,

    OnCreate = function(self, spec)
        Shield.InitBuffValues(self, spec)
        oldUnitBubbleShield.OnCreate(self, spec)
    end,

    ChargingUp = function(self, curProgress, time)
        oldUnitBubbleShield.ChargingUp(self, curProgress, time)
        self:SetHealth(self, self:GetMaxHealth())
    end
}

local oldUnitCzarShield = CzarShield
CzarShield = Class(oldUnitCzarShield) {

    InitBuffValues = function(self, spec)
        self.spec = spec
        local UnitxpValue = spec.Owner:GetBlueprint().Economy.xpValue
        if UnitxpValue == nil then
            UnitxpValue = 1
        end
        local ShieldHealthValue = spec.ShieldMaxHealth
        if ShieldHealthValue == nil then
            ShieldHealthValue = 1
        end

        if spec.Owner then
            self.XPperDamage = UnitxpValue / ShieldHealthValue
        else
            self.XPperDamage = 0
        end
        spec.Owner.Sync.ShieldMaxHp = spec.ShieldMaxHealth -- replace this with generic
        spec.Owner.Sync.ShieldRegen = spec.ShieldRegenRate -- method to directly query
        -- LOG(spec.ShieldRegenRate)
        -- LOG(self.XPperDamage)

    end,

    OnCreate = function(self, spec)
        Shield.InitBuffValues(self, spec)
        oldUnitCzarShield.OnCreate(self, spec)
    end,

    ChargingUp = function(self, curProgress, time)
        oldUnitCzarShield.ChargingUp(self, curProgress, time)
        self:SetHealth(self, self:GetMaxHealth())
    end
}

local oldUnitTransportShield = TransportShield
TransportShield = Class(oldUnitTransportShield) {

    InitBuffValues = function(self, spec)
        self.spec = spec
        local UnitxpValue = spec.Owner:GetBlueprint().Economy.xpValue
        if UnitxpValue == nil then
            UnitxpValue = 1
        end
        local ShieldHealthValue = spec.ShieldMaxHealth
        if ShieldHealthValue == nil then
            ShieldHealthValue = 1
        end

        if spec.Owner then
            self.XPperDamage = UnitxpValue / ShieldHealthValue
        else
            self.XPperDamage = 0
        end
        spec.Owner.Sync.ShieldMaxHp = spec.ShieldMaxHealth -- replace this with generic
        spec.Owner.Sync.ShieldRegen = spec.ShieldRegenRate -- method to directly query
        -- LOG(spec.ShieldRegenRate)
        -- LOG(self.XPperDamage)

    end,

    OnCreate = function(self, spec)
        Shield.InitBuffValues(self, spec)
        oldUnitTransportShield.OnCreate(self, spec)
    end,

    ChargingUp = function(self, curProgress, time)
        oldUnitTransportShield.ChargingUp(self, curProgress, time)
        self:SetHealth(self, self:GetMaxHealth())
    end
}

local oldAntiArtilleryShield = AntiArtilleryShield
AntiArtilleryShield = Class(oldAntiArtilleryShield) {

    InitBuffValues = function(self, spec)
        self.spec = spec
        local UnitxpValue = spec.Owner:GetBlueprint().Economy.xpValue
        if UnitxpValue == nil then
            UnitxpValue = 1
        end
        local ShieldHealthValue = spec.ShieldMaxHealth
        if ShieldHealthValue == nil then
            ShieldHealthValue = 1
        end

        if spec.Owner then
            self.XPperDamage = UnitxpValue / ShieldHealthValue
        else
            self.XPperDamage = 0
        end
        spec.Owner.Sync.ShieldMaxHp = spec.ShieldMaxHealth -- replace this with generic
        spec.Owner.Sync.ShieldRegen = spec.ShieldRegenRate -- method to directly query
        -- LOG(spec.ShieldRegenRate)
        -- LOG(self.XPperDamage)

    end,

    OnCreate = function(self, spec)
        self:InitBuffValues(spec)
        oldAntiArtilleryShield.OnCreate(self, spec)
    end,

    ChargingUp = function(self, curProgress, time)
        oldAntiArtilleryShield.ChargingUp(self, curProgress, time)
        self:SetHealth(self, self:GetMaxHealth())
    end,

    OnDamage = function(self, instigator, amount, vector, type)
        local absorbed = self:OnGetDamageAbsorption(instigator, amount, type)
        local hp = self:GetMaxHealth()
        if (self.XPperDamage * absorbed) > 3 then
            self.Owner:AddXP(self.XPperDamage * absorbed * 0.25)
            --               LOG('___' .. self.XPperDamage*absorbed)
        end
        oldAntiArtilleryShield.OnDamage(self, instigator, amount, vector, type)
    end
}
