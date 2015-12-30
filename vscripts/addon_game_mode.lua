-- Generated from template

if GameMode_Zhuxian3 == nil then
	_G.GameMode_Zhuxian3 = class({})
end
-- settings.lua is where you can specify many different properties for your game mode and is one of the core barebones files.
require('internal/util')
require('settings')
-- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
require('libraries/notifications')
-- This library allow for easily delayed/timed actions
require('libraries/timers')

-- These internal libraries set up barebones's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/gamemode')
require('internal/events')

-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core barebones files.
require('events')

require('mysystem/shuaguai')


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
	GameRules.AddonTemplate = GameMode_Zhuxian3()
	GameRules.AddonTemplate:InitGameMode()
end

function GameMode_Zhuxian3:InitGameMode()
	GameMode_Zhuxian3 = self
	  GameMode_Zhuxian3:_InitGameMode()
	print( "Template addon is loaded." )
	 Convars:RegisterCommand( "command_example", Dynamic_Wrap(GameMode_Zhuxian3, 'ExampleConsoleCommand'), "A console command example", FCVAR_CHEAT )

 	 DebugPrint('[BAREBONES] Done loading Barebones gamemode!\n\n')
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
end


function GameMode_Zhuxian3:PostLoadPrecache()
  DebugPrint("[BAREBONES] Performing Post-Load precache")    
  --PrecacheItemByNameAsync("item_example_item", function(...) end)
  --PrecacheItemByNameAsync("example_ability", function(...) end)

  --PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
  --PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode_Zhuxian3:OnFirstPlayerLoaded()
  DebugPrint("[BAREBONES] First Player has loaded")
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function GameMode_Zhuxian3:OnAllPlayersLoaded()
  DebugPrint("[BAREBONES] All Players have loaded into the game")
end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in
]]
function GameMode_Zhuxian3:OnHeroInGame(hero)
  DebugPrint("[BAREBONES] Hero spawned in game for first time -- " .. hero:GetUnitName())

  -- This line for example will set the starting gold of every hero to 500 unreliable gold
  hero:SetGold(500, false)

  -- These lines will create an item and add it to the player, effectively ensuring they start with the item
  -- local item = CreateItem("item_example_item", hero, hero)
  -- hero:AddItem(item)

  --[[ --These lines if uncommented will replace the W ability of any hero that loads into the game
    --with the "example_ability" ability

  local abil = hero:GetAbilityByIndex(1)
  hero:RemoveAbility(abil:GetAbilityName())
  hero:AddAbility("example_ability")]]
end

--[[
  This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
  gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
  is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function GameMode_Zhuxian3:OnGameInProgress()
  DebugPrint("[BAREBONES] The game has officially begun")

  Timers:CreateTimer(30, -- Start this timer 30 game-time seconds later
    function()
      DebugPrint("This function is called 30 seconds after the game begins, and every 30 seconds thereafter")
      return 30.0 -- Rerun this timer every 30 game-time seconds 
    end)
end

-- Evaluate the state of the game
function GameMode_Zhuxian3:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end
function GameMode_Zhuxian3:ExampleConsoleCommand()
  print( '******* Example Console Command ***************' )
  local cmdPlayer = Convars:GetCommandClient()
  if cmdPlayer then
    local playerID = cmdPlayer:GetPlayerID()
    if playerID ~= nil and playerID ~= -1 then
      -- Do something here for the player who called this command
      PlayerResource:ReplaceHeroWith(playerID, "npc_dota_hero_viper", 1000, 1000)
    end
  end

  print( '*********************************************' )
end

-- --监听执行内容
-- function GameMode_Zhuxian3:OnGameRulesStateChange(keys)
--     print("OnGameRulesStateChange")
--     --获取游戏进度
--     local newState = GameRules:State_Get()
--     --游戏开始
--     if newState==DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
--         print("initNewVliageUnit")
--     	--加载新手村的怪物和NPC
--     end
-- end


