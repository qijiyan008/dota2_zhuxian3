-- Generated from template

if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
end

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
	--狼
	PrecacheResource( "model", "models/heroes/lycan/lycan_wolf.vmdl", context )
	PrecacheResource( "model", "models/items/lycan/ultimate/ambry_true_form/ambry_true_form.vmdl", context )
	--熊
	PrecacheResource( "model", "models/items/lone_druid/bear/spirit_of_the_atniw/spirit_of_the_atniw.vmdl", context )
	PrecacheResource( "model", "models/items/lone_druid/bear/spirit_of_anger/spirit_of_anger.vmdl", context )
	--猪
	PrecacheResource( "model", "models/props_structures/midas_throne/kobold_overboss.vmdl", context )
	PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_kobold/kobold_a/n_creep_kobold_a.vmdl", context )
	--豺狼
	PrecacheResource( "model", "models/heroes/lone_druid/spirit_bear.vmdl", context )
	PrecacheResource( "model", "models/items/lone_druid/bear/iron_claw_spirit_bear/iron_claw_spirit_bear.vmdl", context )
	--食人魔
	PrecacheResource( "model", "models/heroes/ogre_magi/ogre_magi.vmdl", context )
	--枭兽
	PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_vulture_a/n_creep_vulture_a.vmdl", context )
	PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_vulture_b/n_creep_vulture_b.vmdl", context )
    --树人
	PrecacheResource( "model", "models/items/furion/treant/shroomling_treant/shroomling_treant.vmdl", context )



end
-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CAddonTemplateGameMode()
	GameRules.AddonTemplate:InitGameMode()
end


function CAddonTemplateGameMode:InitGameMode()
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	--关闭战争迷雾
	GameRules:GetGameModeEntity():SetFogOfWarDisabled(true)
	--设置游戏准备时间
	GameRules:GetGameModeEntity():SetCameraDistanceOverride(1280)
	--设置游戏视角
  	GameRules:SetPreGameTime(0)
  	--定义新手村怪物列表和数量(狼，熊，猪，豺狼，食人魔，枭兽，虾)
  	newVliageUnit = {"big_wolf","small_wolf","big_bear","small_bear","big_pig","small_pig","big_jackal","small_jackal","big_ogreMagi","small_ogreMagi","big_monkin","small_monkin","big_treant","small_treant"}
  	newVliageUnitCount = {1,8,1,7,1,7,1,5,1,7,1,4,4,12}
	--监听游戏进度
  	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(CAddonTemplateGameMode,"OnGameRulesStateChange"), self)
  	--监听新手村单位死亡
  	ListenToGameEvent("entity_killed", Dynamic_Wrap(CAddonTemplateGameMode,"OnEntityKilledNewVliage"), self)
end

-- Evaluate the state of the game
function CAddonTemplateGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

--监听执行内容
function CAddonTemplateGameMode:OnGameRulesStateChange(keys)
    print("OnGameRulesStateChange")
    --获取游戏进度
    local newState = GameRules:State_Get()
    --游戏开始
    if newState==DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        print("initNewVliageUnit")
    	--加载新手村的怪物和NPC
    	initNewVliageAllUnit()
    end
end


-----------------------------------------------------新手村-----------------------------------------------------
--加载新手村所有怪物
function initNewVliageAllUnit()
	print("initNewVliageAllUnit")
	local uintLength = table.getn(newVliageUnit)
	--local unitCount = table.getn(self.newVliageUnitCount)
	for i=1,uintLength do 
		local unitEntityName = newVliageUnit[i]
		local unitCountInfo = newVliageUnitCount[i]
		for j=1,unitCountInfo do
			local new_vliage_entity = Entities:FindByName(nil,unitEntityName.."_"..j)
			local new_vliage_unit = CreateUnitByName("new_village_"..unitEntityName,new_vliage_entity:GetAbsOrigin(),false,nil,nil,DOTA_TEAM_BADGUYS)
			new_vliage_unit.entityOrigin = new_vliage_entity:GetAbsOrigin()
			new_vliage_unit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
			local chaoxiang= RandomVector(RandomFloat(0, 1))--是否需要随机面向
            new_vliage_unit:SetForwardVector(chaoxiang)
		end
	end
end


--监听新手村单位死亡
function CAddonTemplateGameMode:OnEntityKilledNewVliage(keys)
	print("OnEntityKilledNewVliage")
    --获取游戏进度
    local newState = GameRules:State_Get()
    local attacker = EntIndexToHScript(keys.entindex_attacker):GetUnitName()
    local killed = EntIndexToHScript(keys.entindex_killed):GetUnitName()
    local killOrigin = EntIndexToHScript(keys.entindex_killed):GetAbsOrigin()
    local killEntityOrigin = EntIndexToHScript(keys.entindex_killed).entityOrigin
    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("refresh"..killed),
    function()
        if GameRules:State_Get() >= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        	local uintLength = table.getn(newVliageUnit)
        	for i=1,uintLength do 
        		local unitName = "new_village_"..newVliageUnit[i]
        		if killed == unitName then
					local refresh_unit = CreateUnitByName(unitName,killEntityOrigin,false,nil,nil,DOTA_TEAM_BADGUYS)
					refresh_unit.entityOrigin = killEntityOrigin
					refresh_unit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
        		end 
        	end 
            return nil
        end
    end ,10)
end

----------------------------------------------------------------------------------------------------------------