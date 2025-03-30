-- ****************************************************************************
-- **
-- **  File     :  /lua/sim/buffdefinition.lua
-- **
-- **  Copyright � 2008 Gas Powered Games, Inc.  All rights reserved.
-- ****************************************************************************
import('/lua/sim/AdjacencyBuffs.lua')
import('/lua/sim/CheatBuffs.lua') -- Buffs for AI Cheating

------------------------------------------------------------------------------------------------------------------------------------
---- VETERANCY BUFFS - UNIT HEALTH
------------------------------------------------------------------------------------------------------------------------------------

-- This gets applied to everything and is combined with culmulative with other MaxHealth bonuses. So gotta be careful what we add here
BuffBlueprint {
    MaxLevel = 1000,
    Name = 'VeterancyHealth',
    DisplayName = 'VeterancyHealth',
    BuffType = 'VETERANCYHEALTH',
    Stacks = 'ALWAYS',
    Duration = -1,
    Affects = {
        MaxHealth = {
            Mult = 1.002
        },
        Regen = {
            Mult = 1.002
        },
        RateOfFireBuf = {
            Mult = 1.002
        }
    }
}

------------------------------------------------------------------------------------------------------------------------------------
---- VETERANCY BUFFS - UNIT REGEN
------------------------------------------------------------------------------------------------------------------------------------

-- every level
BuffBlueprint {
    MaxLevel = 100,
    Name = 'VeterancyRegen',
    DisplayName = 'VeterancyRegen',
    BuffType = 'VETERANCYREGEN',
    Stacks = 'ALWAYS',
    Duration = -1,
    Affects = {
        MaxHealth = {
            Add = 10,
            Mult = 1.015
        },
        Regen = {
            Add = 1.0,
            Mult = 1.015
        },
        ShieldHP = {
            Add = 10,
            Mult = 1.015
        },
        ShieldRegen = {
            Add = 1.0,
            Mult = 1.015
        }
    }
}

------------------------------------------------------------------------------------------------------------------------------------
---- VETERANCY BUFFS - UNIT DAMAGE
------------------------------------------------------------------------------------------------------------------------------------

-- every level
BuffBlueprint {
    MaxLevel = 1000,
    Name = 'VeterancyDamage',
    DisplayName = 'VeterancyDamage',
    BuffType = 'VETERANCYDAMAGE',
    Stacks = 'ALWAYS',
    Duration = -1,
    Affects = {
        Damage = {
            Mult = 1.002
        }
    }
}

------------------------------------------------------------------------------------------------------------------------------------
---- VETERANCY BUFFS - UNIT DAMAGE AOE
------------------------------------------------------------------------------------------------------------------------------------

-- every level
BuffBlueprint {
    MaxLevel = 100,
    Name = 'VeterancyDamageArea',
    DisplayName = 'VeterancyDamageArea',
    BuffType = 'VETERANCYDAMAGEAREA',
    Stacks = 'ALWAYS',
    Duration = -1,
    Affects = {
        Damage = {
            Add = 1.0,
            Mult = 1.015
        },
        DamageRadius = {
            Add = 0.02,
            Mult = 1.002 -- No more multi for you. Flat rate and you dont get a full 1 either. You gotta vet up for that
        }
    }
}

------------------------------------------------------------------------------------------------------------------------------------
---- VETERANCY BUFFS - UNIT Weapon Range
------------------------------------------------------------------------------------------------------------------------------------

BuffBlueprint {
    MaxLevel = 100,
    Name = 'VeterancyRange',
    DisplayName = 'VeterancyRange',
    BuffType = 'VETERANCYRANGE',
    Stacks = 'ALWAYS',
    Duration = -1,
    Affects = {
        MaxRadius = {
            Add = 0

        }
    }
}

------------------------------------------------------------------------------------------------------------------------------------
---- VETERANCY BUFFS - UNIT SPEED
------------------------------------------------------------------------------------------------------------------------------------

BuffBlueprint {
    MaxLevel = 100,
    Name = 'VeterancySpeed',
    DisplayName = 'VeterancySpeed',
    BuffType = 'VETERANCYSPEED',
    Stacks = 'ALWAYS',
    Duration = -1,
    Affects = {
        MoveMult = {
            Add = 0,
            Mult = 1.015
        }
    }
}

------------------------------------------------------------------------------------------------------------------------------------
---- VETERANCY BUFFS - UNIT FUEL
------------------------------------------------------------------------------------------------------------------------------------

BuffBlueprint {
    MaxLevel = 100,
    Name = 'VeterancyFuel',
    DisplayName = 'VeterancyFuel',
    BuffType = 'VETERANCYFUEL',
    Stacks = 'ALWAYS',
    Duration = -1,
    Affects = {
        Fuel = {
            Add = 0,
            Mult = 1.02
        }
    }
}

------------------------------------------------------------------------------------------------------------------------------------
---- VETERANCY BUFFS - UNIT SHIELD
------------------------------------------------------------------------------------------------------------------------------------

BuffBlueprint {
    MaxLevel = 1000,
    Name = 'VeterancyShield',
    DisplayName = 'VeterancyShield',
    BuffType = 'VETERANCYSHIELD',
    Stacks = 'ALWAYS',
    Duration = -1,
    Affects = {
        ShieldHP = {
            Mult = 1.002 -- triple
        },
        ShieldRegen = {
            Mult = 1.002 -- double
        }
    }
}

------------------------------------------------------------------------------------------------------------------------------------
---- VETERANCY BUFFS - VISION
------------------------------------------------------------------------------------------------------------------------------------

BuffBlueprint {
    MaxLevel = 100,
    Name = 'VeterancyVision',
    DisplayName = 'VeterancyVision',
    BuffType = 'VETERANCYVISION',
    Stacks = 'ALWAYS',
    Duration = -1,
    Affects = {
        VisionRadius = {
            Mult = 1.01
        }
    }
}

------------------------------------------------------------------------------------------------------------------------------------
---- VETERANCY BUFFS - OMNIVISION
------------------------------------------------------------------------------------------------------------------------------------

BuffBlueprint {
    MaxLevel = 100,
    Name = 'VeterancyOmniRadius',
    DisplayName = 'VeterancyOmniRadius',
    BuffType = 'VETERANCYOMNIRADIUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    Affects = {
        OmniRadius = {
            Mult = 1.01
        }
    }
}

------------------------------------------------------------------------------------------------------------------------------------
---- VETERANCY BUFFS - RADAR RANGE
------------------------------------------------------------------------------------------------------------------------------------

BuffBlueprint {
    MaxLevel = 100,
    Name = 'VeterancyRadar',
    DisplayName = 'VeterancyRadar',
    BuffType = 'VETERANCYRADAR',
    Stacks = 'ALWAYS',
    Duration = -1,
    Affects = {
        RadarRadius = {
            Mult = 1.01
        }
    }
}

------------------------------------------------------------------------------------------------------------------------------------
---- VETERANCY BUFFS - BUILD SPEED
------------------------------------------------------------------------------------------------------------------------------------

BuffBlueprint {
    MaxLevel = 100,
    Name = 'VeterancyBuildRate',
    DisplayName = 'VeterancyBuildRate',
    BuffType = 'VETERANCYBUILDRATE',
    Stacks = 'ALWAYS',
    Duration = -1,
    Affects = {
        BuildRate = {
            Add = 1.0,
            Mult = 1.015 -- buffed up from 1.0043
        }
    }
}

------------------------------------------------------------------------------------------------------------------------------------
---- VETERANCY BUFFS - ENERGY CONSUMPTION
------------------------------------------------------------------------------------------------------------------------------------

-- These are only applied to shields. We want them to use less energy as they level up
BuffBlueprint {
    MaxLevel = 100,
    Name = 'VeterancyEnergyCon',
    DisplayName = 'VeterancyEnergyCon',
    BuffType = 'VeterancyEnergyCon',
    Stacks = 'ALWAYS',
    Duration = -1,
    Affects = {
        EnergyMaintenance = {
            Mult = 0.997
        }
    }
}

------------------------------------------------------------------------------------------------------------------------------------
---- VETERANCY BUFFS - COMMANDER ENERGY GENERATION
------------------------------------------------------------------------------------------------------------------------------------

BuffBlueprint {
    MaxLevel = 100,
    Name = 'VeterancyCEC',
    DisplayName = 'VeterancyCEC',
    BuffType = 'VeterancyCEC',
    Stacks = 'ALWAYS',
    Duration = -1,
    Affects = {
        EnergyProductionBuf = {
            Add = 2,
            Mult = 1.02
        },
        MassProductionBuf = {
            Add = 0.05,
            Mult = 1.02
        }
    }
}

------------------------------------------------------------------------------------------------------------------------------------
---- VETERANCY BUFFS - ENERGY AND MASS PRODUCTION
------------------------------------------------------------------------------------------------------------------------------------

BuffBlueprint {
    MaxLevel = 100,
    Name = 'VeterancyResourceProduction',
    DisplayName = 'VeterancyResourceProduction',
    BuffType = 'VeterancyResourceProduction',
    Stacks = 'ALWAYS',
    Duration = -1,
    Affects = {
        EnergyProductionBuf = {
            Add = 0,
            Mult = 1.02
        },
        MassProductionBuf = {
            Add = 0,
            Mult = 1.02
        }
    }
}

------------------------------------------------------------------------------------------------------------------------------------
---- VETERANCY BUFFS - ACU ENERGY AND MASS PRODUCTION
------------------------------------------------------------------------------------------------------------------------------------

BuffBlueprint {
    MaxLevel = 100,
    Name = 'VeterancyACUResourceProduction',
    DisplayName = 'VeterancyACUResourceProduction',
    BuffType = 'VeterancyACUResourceProduction',
    Stacks = 'ALWAYS',
    Duration = -1,
    Affects = {
        EnergyProductionBuf = {
            Add = 2,
            Mult = 1.02
        },
        MassProductionBuf = {
            Add = 0.05,
            Mult = 1.02
        }
    }
}

------------------------------------------------------------------------------------------------------------------------------------
---- VETERANCY BUFFS - RATE OF FIRE
------------------------------------------------------------------------------------------------------------------------------------

BuffBlueprint {
    MaxLevel = 100,
    Name = 'VeterancyRateOfFire',
    DisplayName = 'VeterancyRateOfFire',
    BuffType = 'VETERANCYRATEOFFIRE',
    Stacks = 'ALWAYS',
    Duration = -1,
    Affects = {
        RateOfFireBuf = {
            Add = 0,
            Mult = 1.015
        }
    }
}

__moduleinfo.auto_reload = true
