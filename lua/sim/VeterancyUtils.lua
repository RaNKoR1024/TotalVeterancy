LevelCap = 100
LevelSoftCap = 10

TicksInTimeStep = 20

TakenDamegeToXpModifier = 1.0
DealingDamageToXpModifier = 1.0
local killXpModifier = 10.0

BuildUnitXpModifier = 3.0

CommonLevelMult = 0.2

AddBuffTypes = function(buffTypes, additionalBuffTypes)
    for k, buffType in additionalBuffTypes do
        table.insert(buffTypes, buffType)
    end
end

GetUnitLevelByHealth = function(maxHealth, currentMaxHealth)
    return (currentMaxHealth / maxHealth) - 1 / CommonLevelMult
end

GetKillXpByLevel = function(baseXpValue, level)
    return GetXpToLevel(baseXpValue, level) * killXpModifier
end

GetXpToLevel = function(baseXpValue, level)
    return math.ceil(baseXpValue * (1 + level))
end

FormatXpAmount = function(xp)
    if xp > 10000000 then
        return math.floor(xp / 1000000) .. 'M'
    else
        if xp > 10000 then
            return math.floor(xp / 1000) .. 'K'
        else
            return tostring(math.floor(xp))
        end
    end
end
