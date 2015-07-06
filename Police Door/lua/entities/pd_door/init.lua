AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local P_Groups = {}
P_Groups["Civil Protection"] = true
P_Groups["Civil Protection Chief"] = true

function ENT:Initialize()
	self:SetModel("models/hunter/plates/plate1x3.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetAngles(Angle(0,90,90))
	self:SetTrigger(true)
	self:SetCustomCollisionCheck(true)
	self.MakeSolid = CurTime()
	self.Dmg = 15
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	
	self:SetMaterial("models/props_combine/stasisshield_sheet")
end

function ENT:SpawnFunction(ply,tr,class)
	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 48
	
	local ent = ents.Create(class)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	
	return ent
end

function ENT:Touch(ent)
	if IsValid(ent) then
		if ent:IsPlayer() then
			local Closed = true
			for k,v in pairs(P_Groups) do
				if team.GetName(ent:Team())==k then
					Closed = false
				end
			end
			
			if !Closed then
				self.MakeSolid = CurTime()+0.5
			end
		end
	end
end

function ENT:Think()
	if self.MakeSolid >= CurTime() then
		self:SetSolid(SOLID_NONE)
		local Rand = math.Round(math.Rand(1,5),0)
		if Rand==3 then
			local LBounds = self:OBBMins()
			local MBounds = self:OBBMaxs()
			local Pos = self:LocalToWorld(Vector(math.Rand(LBounds[1],MBounds[1]),math.Rand(LBounds[2],MBounds[2]),math.Rand(LBounds[3],MBounds[3])))
			local Effect = EffectData()
			Effect:SetOrigin( Pos )
			util.Effect( "StunstickImpact", Effect )
		end
	end
	
	if self.MakeSolid < CurTime() then
		self:SetSolid(SOLID_VPHYSICS)
		if self.Dmg<=0 then
			self.Dmg = 15
		end
	end
end

function ENT:OnTakeDamage(dmg)
	if IsValid(dmg:GetAttacker()) then
		if dmg:GetAttacker():IsPlayer() then
			if dmg:IsBulletDamage() then
				if self.Dmg>0 then
					self.Dmg = math.Clamp(self.Dmg-dmg:GetDamage(),0,15)
				else
					if self.MakeSolid <= CurTime() then
						self.MakeSolid = CurTime()+15
					end
				end
			end
		end
	end
	
	self:RemoveAllDecals()
end