AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.Spawnable = false

function ENT:Draw()
	if SERVER then return end
	self:DrawModel()
end

function ENT:Initialize()
	if CLIENT then return end

	self:SetModel("models/Items/item_item_crate.mdl")
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetHealth(2000)
	self:SetNWBool("is_pointshop", true)
	self:SetNWBool("made_by_people_muth", true)
	
	local phys = self:GetPhysicsObject()
end

function ENT:OnTakeDamage(dmg)
	if dmg:GetAttacker():IsPlayer() and dmg:GetAttacker():Team() == TEAM_HUMANS then return end

	self:TakePhysicsDamage(dmg)
	self:SetHealth(self:Health() - dmg:GetDamage())
	if self:Health() <= 0 then 
		local ef = EffectData()
		ef:SetOrigin(self:GetPos())
		util.Effect("explosion", ef)
	
		self:Remove() 
	end
end

function ENT:Use(ply)
	if ply:Team() == TEAM_MUTANTS or not ply:Alive() then return end

	if ply:KeyPressed(IN_USE) then
		umsg.Start("open_shop_muth2", ply)
		umsg.End()
	end
end







