include( "shared.lua" )

SWEP.PrintName      = "Easy Doorgroups"
SWEP.Slot		    = 3
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true

local col_white = Color(255,255,255)
local col_outline = Color(0,0,0)
surface.CreateFont("Roboto", {font = "Roboto", size = 30})

hook.Add("HUDPaint", "gun hud stuff", function()

    if !IsValid(LocalPlayer():GetActiveWeapon()) then return end

    if LocalPlayer():GetActiveWeapon():GetClass() == "easy_doorgroup" then

        draw.SimpleTextOutlined(LocalPlayer():GetNWString("DOORGROUP_GUN", "Cops and Mayor only"), "Roboto", 20, 600, col_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, col_outline)

    end

end)

net.Receive("DOORGROUP_GUN", function(len, ply)

    if net.ReadInt(8) != 2 then return end

    local frame = vgui.Create("DFrame")
    frame:SetSize(400, 200)
    frame:SetTitle("Set Doorgroup")
    frame:MakePopup()
    frame:SetPos(ScrW() / 2 - frame:GetWide() / 2, ScrH() / 2 - frame:GetTall() / 2)

    local entry = vgui.Create("DTextEntry", frame)
    entry:SetSize(225, 40)
    entry:SetPos(frame:GetWide() / 2 - entry:GetWide() / 2, frame:GetTall() / 2 - entry:GetTall() / 2)
    entry:SetPlaceholderText("Cops and Mayor only")
    local db = false
    entry.OnEnter = function(self)
        if !db then
            db = true
            local value = self:GetValue()
            if #value < 1 then value = "Cops and Mayor only" end
            net.Start("DOORGROUP_GUN")
                net.WriteInt(1, 8)
                net.WriteString(value)
            net.SendToServer()
            timer.Simple(1, function() db = false end)
        end
    end

end)