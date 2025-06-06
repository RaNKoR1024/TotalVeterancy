-- ****************************************************************************
-- **
-- **  File     :  /lua/sim/Weapon.lua
-- **  Author(s):  John Comes
-- **
-- **  Summary  : The base weapon class for all weapons in the game.
-- **
-- **  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
-- ****************************************************************************
local oldWeapon = Weapon
Weapon = Class(oldWeapon) {

    OnCreate = function(self)
        oldWeapon.OnCreate(self)
        local bp = self:GetBlueprint()
        self.DamageRadius = bp.DamageRadius
        self.Damage = bp.Damage
        self.range = bp.MaxRadius
        self.muzzlevelocity = bp.MuzzleVelocity
        self.rangeMod = 1
        self.adjRoF = 1
        self.bufRoF = bp.RateOfFire

        if bp.NukeOuterRingDamage and bp.NukeOuterRingRadius and bp.NukeInnerRingDamage and bp.NukeInnerRingRadius then
            self.NukeOuterRingDamage = bp.NukeOuterRingDamage or 10
            self.NukeOuterRingRadius = bp.NukeOuterRingRadius or 40

            self.NukeInnerRingDamage = bp.NukeInnerRingDamage or 2000
            self.NukeInnerRingRadius = bp.NukeInnerRingRadius or 30
        end
    end,

    CreateProjectileForWeapon = function(self, bone)
        local proj = oldWeapon.CreateProjectileForWeapon(self, bone)
        if proj and not proj:BeenDestroyed() then
            local bp = self:GetBlueprint()
            -- Mega IF statement for the BlackOps Aeon Tactical Missile - which has no damage or radius
            if bp.Categories and table.find(bp.Categories, 'AEON') and table.find(bp.Categories, 'PROJECTILE') and
                table.find(bp.Categories, 'INDIRECTFIRE') and table.find(bp.Categories, 'MISSILE') and
                table.find(bp.Categories, 'NOSPLASHDAMAGE') and bp.Physics.InitialSpeed == 40 and bp.Physics.MaxSpeed ==
                40 then
                self.DamageAmount = 6000
                self.DamageRadius = 6
            end

            local Lifetime = bp.ProjectileLifetime
            if Lifetime == 0 then
                Lifetime = proj:GetBlueprint().Physics.Lifetime * (self.rangeMod * 2)
            end -- Lets add the *2 to the lifetime, see if that makes tactical missiles fire properly
            proj.initLifetime = Lifetime
            proj:SetLifetime(Lifetime)

            if bp.NukeOuterRingDamage and bp.NukeOuterRingRadius and bp.NukeOuterRingTicks and bp.NukeOuterRingTotalTime and
                bp.NukeInnerRingDamage and bp.NukeInnerRingRadius and bp.NukeInnerRingTicks and
                bp.NukeInnerRingTotalTime then
                local data = {
                    NukeOuterRingDamage = self.NukeOuterRingDamage,
                    NukeOuterRingRadius = self.NukeOuterRingRadius,
                    NukeOuterRingTicks = bp.NukeOuterRingTicks or 20,
                    NukeOuterRingTotalTime = bp.NukeOuterRingTotalTime or 10,

                    NukeInnerRingDamage = self.NukeInnerRingDamage,
                    NukeInnerRingRadius = self.NukeInnerRingRadius,
                    NukeInnerRingTicks = bp.NukeInnerRingTicks or 24,
                    NukeInnerRingTotalTime = bp.NukeInnerRingTotalTime or 24
                }
                proj:PassData(data)
            end
        end
        return proj
    end,

    GetDamageTable = function(self)
        local damageTable = oldWeapon.GetDamageTable(self)
        damageTable.DamageRadius = (self.DamageRadius or 0)
        damageTable.DamageAmount = (self.Damage or 0)

        return damageTable
    end

}
