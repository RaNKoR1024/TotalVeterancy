--****************************************************************************
--**  Summary  :  Seraphim Commander Script
--****************************************************************************

local oldXSL0001 = XSL0001
XSL0001 = Class( oldXSL0001 ) {

    RegenBuffThread = function(self)
        while not self:IsDead() do
            --Get friendly units in the area (including self)
            local units = AIUtils.GetOwnUnitsAroundPoint(self:GetAIBrain(), categories.ALLUNITS, self:GetPosition(), self:GetBlueprint().Enhancements.RegenAura.Radius)

            --Give them a 5 second regen buff
            for _,unit in units do
                Buff.ApplyBuff(unit, 'SeraphimACURegenAura')
            end

            --Wait 5 seconds
            WaitSeconds(5)
        end
    end,

    AdvancedRegenBuffThread = function(self)
        while not self:IsDead() do
            --Get friendly units in the area (including self)
            local units = AIUtils.GetOwnUnitsAroundPoint(self:GetAIBrain(), categories.ALLUNITS, self:GetPosition(), self:GetBlueprint().Enhancements.AdvancedRegenAura.Radius)

            --Give them a 5 second regen buff
            for _,unit in units do
                Buff.ApplyBuff(unit, 'SeraphimAdvancedACURegenAura')
            end

            --Wait 5 seconds
            WaitSeconds(5)
        end
    end,

    OnStartBuild = function(self, unitBeingBuilt, order)
           --# FA version didn't call its own base class
        --# So we'll call it for them.
        ACUUnit.OnStartBuild(self, unitBeingBuilt, order)
        oldXSL0001.OnStartBuild(self, unitBeingBuilt, order)
    end,

    CreateEnhancement = function(self, enh)
        ACUUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]

        -- Regenerative Aura
        if enh == 'RegenAura' then
            local bp = self:GetBlueprint().Enhancements[enh]
            if not Buffs['SeraphimACURegenAura'] then
                BuffBlueprint {
                    Name = 'SeraphimACURegenAura',
                    DisplayName = 'SeraphimACURegenAura',
                    BuffType = 'COMMANDERAURA',
                    Stacks = 'ALWAYS',
                    Duration = 5,
                    Affects = {
                        RegenPercent = {
                            --Add = bp.RegenPerSecond or 0.1,
                            --Mult = 0,
                            Add = 0,
                            Mult = bp.RegenPerSecond or 0.1,
                            Ceil = bp.RegenCeiling,
                            Floor = bp.RegenFloor,
                        },
                    },
                }

            end

            self.RegenThreadHandle = self:ForkThread(self.RegenBuffThread)

        elseif enh == 'RegenAuraRemove' then
            if self.ShieldEffectsBag then
                for k, v in self.ShieldEffectsBag do
                    v:Destroy()
                end
                self.ShieldEffectsBag = {}
            end
            KillThread(self.RegenThreadHandle)

        elseif enh == 'AdvancedRegenAura' then
            if self.RegenThreadHandle then
                if self.ShieldEffectsBag then
                    for k, v in self.ShieldEffectsBag do
                        v:Destroy()
                    end
                    self.ShieldEffectsBag = {}
                end
                KillThread(self.RegenThreadHandle)

            end

            local bp = self:GetBlueprint().Enhancements[enh]
            if not Buffs['SeraphimAdvancedACURegenAura'] then
                BuffBlueprint {
                    Name = 'SeraphimAdvancedACURegenAura',
                    DisplayName = 'SeraphimAdvancedACURegenAura',
                    BuffType = 'COMMANDERAURA',
                    Stacks = 'ALWAYS',
                    Duration = 5,
                    Affects = {
                        RegenPercent = {
                            --Add = bp.RegenPerSecond or 0.1,
                            --Mult = 0,
                            Add = 0,
                            Mult = bp.RegenPerSecond or 0.1,

                            Ceil = bp.RegenCeiling,
                            Floor = bp.RegenFloor,
                        },
                        MaxHealth = {
                            Add = 0,
                            Mult = bp.MaxHealthFactor or 1.0,
                        },
                    },
                }
            end

            self.AdvancedRegenThreadHandle = self:ForkThread(self.AdvancedRegenBuffThread)

        elseif enh == 'AdvancedRegenAuraRemove' then
            if self.ShieldEffectsBag then
                for k, v in self.ShieldEffectsBag do
                    v:Destroy()
                end
                self.ShieldEffectsBag = {}
            end
            KillThread(self.AdvancedRegenThreadHandle)

        else
            oldXSL0001.CreateEnhancement(self, enh)
        end
    end,

}

TypeClass = XSL0001