AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

SWEP.Weight		    = 5
SWEP.AutoSwitchTo	= false
SWEP.AutoSwitchFrom	= false

util.AddNetworkString("DOORGROUP_GUN")

net.Receive("DOORGROUP_GUN", function(len, ply)
    if net.ReadInt(8) != 1 then return end
    ply:SetNWString("DOORGROUP_GUN", net.ReadString())
end)