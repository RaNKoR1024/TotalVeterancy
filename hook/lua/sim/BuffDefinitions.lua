-- ****************************************************************************
-- **
-- **  File     :  /lua/sim/buffdefinition.lua
-- **
-- **  Copyright � 2008 Gas Powered Games, Inc.  All rights reserved.
-- ****************************************************************************
import('/lua/sim/AdjacencyBuffs.lua')
import('/lua/sim/CheatBuffs.lua') -- Buffs for AI Cheating

local Utils = import('/mods/TotalVeterancyRebalanced/lua/sim/VeterancyUtils.lua')
------------------------------------------------------------------------------------------------------------------------------------
---- VETERANCY BUFFS - COMMON LONG
------------------------------------------------------------------------------------------------------------------------------------

-- This gets applied to everything and is combined with culmulative with other MaxHealth bonuses. So gotta be careful what we add here
BuffBlueprint {
    Name = 'VeterancyCommonLong',
    DisplayName = 'VeterancyCommonLong',
    BuffType = 'VETERANCYCOMMONLONG',
    Stacks = 'ALWAYS',
    Duration = -1,
    Affects = {
        MaxHealth = {
            AddMult = Utils.CommonLevelMult
        },
        Regen = {
            AddMult = 0.1
        },
        ShieldMaxHealth = {
            AddMult = Utils.CommonLevelMult
        },
        ShieldRegen = {
            AddMult = 0.1
        },
        RateOfFire = {
            AddMult = 0.1
        }
    }
}

------------------------------------------------------------------------------------------------------------------------------------
---- VETERANCY BUFFS - COMMON
------------------------------------------------------------------------------------------------------------------------------------

-- every level
BuffBlueprint {
    MaxLevel = Utils.LevelSoftCap,
    Name = 'VeterancyCommon',
    DisplayName = 'VeterancyCommon',
    BuffType = 'VETERANCYCOMMON',
    Stacks = 'ALWAYS',
    Duration = -1,
    Affects = {
        Regen = {
            Add = 10.0,
            AddMult = 0.5
        },
        ShieldRegen = {
            Add = 10.0,
            AddMult = 0.5
        },
        RateOfFire = {
            AddMult = 0.2
        },
        OmniRadius = {
            AddMult = 0.1
        },
        RadarRadius = {
            AddMult = 0.1
        },
        VisionRadius = {
            AddMult = 0.1
        },
        EnergyMaintenance = {
            AddMult = -0.05
        },
        EnergyProduction = {
            AddMult = 0.4
        },
        MassProduction = {
            AddMult = 0.4
        },
        BuildRate = {
            AddMult = 0.4
        }
    }
}

------------------------------------------------------------------------------------------------------------------------------------
---- VETERANCY BUFFS - NON ANTI-MISSILE LONG
------------------------------------------------------------------------------------------------------------------------------------

-- every level
BuffBlueprint {
    Name = 'VeterancyNonAntiMissileLong',
    DisplayName = 'VeterancyNonAntiMissileLong',
    BuffType = 'VETERANCYNONANTIMISSILELONG',
    Stacks = 'ALWAYS',
    Duration = -1,
    Affects = {
        Damage = {
            AddMult = Utils.CommonLevelMult
        }
    }
}

------------------------------------------------------------------------------------------------------------------------------------
---- VETERANCY BUFFS - NON ANTI-MISSILE
------------------------------------------------------------------------------------------------------------------------------------

-- every level
BuffBlueprint {
    MaxLevel = Utils.LevelSoftCap,
    Name = 'VeterancyNonAntiMissile',
    DisplayName = 'VeterancyNonAntiMissile',
    BuffType = 'VETERANCYNONANTIMISSILE',
    Stacks = 'ALWAYS',
    Duration = -1,
    Affects = {
        DamageRadius = {
            Add = 0.1,
            AddMult = 0.1
        },
    }
}

------------------------------------------------------------------------------------------------------------------------------------
---- VETERANCY BUFFS - NON AIR
------------------------------------------------------------------------------------------------------------------------------------

-- Because of all bombers dont drop bombs after more then 60% boost move speed
BuffBlueprint {
    MaxLevel = Utils.LevelSoftCap,
    Name = 'VeterancyNonAir',
    DisplayName = 'VeterancyNonAir',
    BuffType = 'VETERANCYNONAIR',
    Stacks = 'ALWAYS',
    Duration = -1,
    Affects = {
        MoveMult = {
            AddMult = 0.2
        },
    }
}

__moduleinfo.auto_reload = true
