include "constants.lua"

--pieces
local  base, flare1, flare2, nozzle1, nozzle2, missile, rgun, lgun, rwing, lwing, rjet, ljet, body 
	= piece( "base", "flare1", "flare2", "nozzle1", "nozzle2", "missile", "rgun", "lgun", "rwing", "lwing", "rjet", "ljet", "body")

smokePiece = {base, rwing, lwing}

--variables
local shotCycle = 0
local flare = {
	[0] = flare1,
	[1] = flare2,
}

----------------------------------------------------------

local WING_DISTANCE = 8

local function activate()
	Move(rwing, x_axis, 0, 10)
	Move(lwing, x_axis, 0, 10)
end

local function deactivate()
	Move(rwing, x_axis, WING_DISTANCE, 10)
	Move(lwing, x_axis, -WING_DISTANCE, 10)
end

function script.Create()
	Move(rwing, x_axis, WING_DISTANCE)
	Move(lwing, x_axis, -WING_DISTANCE)
end

function script.StartMoving()
	activate()
end

function script.StopMoving()
	deactivate()
end

function script.QueryWeapon(num) 
	if num == 1 then
		return flare[shotCycle]
	elseif num == 2 then
		return flare2
	end
end

function script.AimFromWeapon(num) 
	return base
end

function script.AimWeapon(num, heading, pitch)
	return not (GetUnitValue(COB.CRASHING) == 1) 
end

function script.FireWeapon(num)
	if num == 1 then
		shotCycle = 1 - shotCycle
		EmitSfx( flare[shotCycle], UNIT_SFX3 )
	elseif num == 2 then
		EmitSfx( flare2, UNIT_SFX3 )
	elseif num == 3 then
		EmitSfx( missile, UNIT_SFX2 )
	end
end

function script.BlockShot(num)
	return (GetUnitValue(COB.CRASHING) == 1)
end

function script.Killed(recentDamage, maxHealth)
	local severity = (recentDamage/maxHealth) * 100
	if severity < 100 then
		Explode(base, sfxNone)
		Explode(rwing, sfxNone)
		Explode(lwing, sfxNone)
		Explode(rjet, sfxSmoke + sfxFire + sfxExplode + sfxShatter + sfxExplodeOnHit)
		Explode(ljet, sfxSmoke + sfxFire + sfxExplode + sfxShatter + sfxExplodeOnHit)
		return 1
	else
		Explode(base, sfxNone)
		Explode(rwing, sfxNone)
		Explode(lwing, sfxNone)
		Explode(rjet, sfxSmoke + sfxFire + sfxExplode + sfxShatter + sfxExplodeOnHit)
		Explode(ljet, sfxSmoke + sfxFire + sfxExplode + sfxShatter + sfxExplodeOnHit)
		return 2
	end
end
