SWEP.Author			    = "Private Ryan"
SWEP.Contact			= ""
SWEP.Purpose			= ""
SWEP.Instructions		= "Left Click: Set Doorgroup. Right Click: Disallow Ownership. Reload: Change doorgroup"
SWEP.Category           = "Easy Doorgroup"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		    = "models/weapons/w_pistol.mdl"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		= "none"

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

local ShootSound = Sound( "Metal.SawbladeStick" )

/*---------------------------------------------------------
	Reload does nothing
---------------------------------------------------------*/

local db = false

function SWEP:Reload()
    if !db && IsValid(self:GetOwner()) then
        db = true

        net.Start("DOORGROUP_GUN")
            net.WriteInt(2, 8)
        net.Send(self:GetOwner())

        timer.Simple(1, function() db = false end)
    end
end

/*---------------------------------------------------------
  Think does nothing
---------------------------------------------------------*/
function SWEP:Think()
end

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/

local doors = {
    ["prop_door_rotating"] = true,
    ["func_door"] = true,
    ["func_door_rotating"] = true
}

function SWEP:PrimaryAttack()

    local tr = self:GetOwner():GetEyeTrace()
    local entity
    if IsValid(tr.Entity) then entity = tr.Entity end
    if ( tr.HitWorld ) then return end
    if ( IsValid(entity) && !doors[entity:GetClass()] ) then return end

    local effectdata = EffectData()
    effectdata:SetOrigin( tr.HitPos )
    effectdata:SetNormal( tr.HitNormal )
    effectdata:SetMagnitude( 8 )
    effectdata:SetScale( 1 )
    effectdata:SetRadius( 16 )
    util.Effect( "Sparks", effectdata )

    self:EmitSound( ShootSound )
    self.BaseClass.ShootEffects( self )

    // The rest is only done on the server
    if ( !SERVER ) then return end

    entity:setDoorGroup(self:GetOwner():GetNWString("DOORGROUP_GUN", "Cops and Mayor only"))
    self:GetOwner():ChatPrint("Door set to: " .. self:GetOwner():GetNWString("DOORGROUP_GUN", "Cops and Mayor only"))

end

/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
    local tr = self:GetOwner():GetEyeTrace()
    local entity
    if IsValid(tr.Entity) then entity = tr.Entity end
    if ( tr.HitWorld ) then return end
    if ( IsValid(entity) && !doors[entity:GetClass()] ) then return end

    local effectdata = EffectData()
    effectdata:SetOrigin( tr.HitPos )
    effectdata:SetNormal( tr.HitNormal )
    effectdata:SetMagnitude( 8 )
    effectdata:SetScale( 1 )
    effectdata:SetRadius( 16 )
    util.Effect( "Sparks", effectdata )

    self:EmitSound( ShootSound )
    self.BaseClass.ShootEffects( self )

    if !SERVER then return end

    entity:setKeysNonOwnable(true)
    entity:setDoorGroup(nil)

    self:GetOwner():ChatPrint("Door is now unownable.")
end