if shuaguai == nil then
  shuaguai = {}
  shuaguai.base=nil

end
function shuaguai:Shuaguaiinit()
  print("shuaguaiinit")

  ShuaGuai_unit={
      "npc_myunit_1",--第1波
      "npc_myunit_2",--第2波
      "npc_myunit_3",--第3波
      "npc_myunit_4",--第4波
      "npc_myunit_5",--第5波
      "npc_myunit_6",
      "npc_myunit_7",
      "npc_myunit_8",
      "npc_myunit_9",
      "npc_myunit_10",
      "npc_myunit_11",
      "npc_myunit_12",
      "npc_myunit_13",
      "npc_myunit_14",
      "npc_myunit_15",
      "npc_myunit_16",
      "npc_myunit_17",
      "npc_myunit_18",
      "npc_myunit_19",
      "npc_myunit_20",
      "npc_myunit_21",
      "npc_myunit_22",
      "npc_myunit_23",
      "npc_myunit_24",
    }
  ShuaGuai_entity = {}
  --获取波数
  ShuaGuai_max=#ShuaGuai_unit
  --用于记录波数
  GameRules.ShuaGuai_bo=0
  --设置刷怪数量
  ShuaGuai_count=60
  GameRules.ShuaGuai_num=0
  ShuaGuai_entity[1]=Entities:FindByName(nil,"spawn_enemy_attack_top")
  shuaguai.base=Entities:FindByName(nil,"zhuxian3_base")
   Timers:CreateTimer(0, function()
    print("start shuaguai bo ="..GameRules.ShuaGuai_bo+1)
     shuaguai:ShuaGuai()
     return 120
  end)   
end

function shuaguai:ShuaGuai()
  GameRules.ShuaGuai_bo = GameRules.ShuaGuai_bo + 1
  shuaguai:ShuaGuaifun(ShuaGuai_entity[1],GameRules.ShuaGuai_bo)

end

function shuaguai:ShuaGuaifun( entityname , num)
  print("Run ShuaGuai")
  
  --波数+1
--  GameRules.ShuaGuai_bo = GameRules.ShuaGuai_bo + 1
    --设置刷怪数量
  local ent_spawn =entityname
  local i=1
  Timers:CreateTimer(0, function()
     if GameRules:State_Get() >= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        for spanwnum=1,1 do
          --创建单位
          i=i+1
          local unit = CreateUnitByName(ShuaGuai_unit[GameRules.ShuaGuai_bo], ent_spawn:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_BADGUYS)

          --添加相位移动的modifier，持续时间0.2秒
          --当相位移动的modifier消失，系统会自动计算碰撞，这样就避免了卡位
          unit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
          unit:SetContextThink(DoUniqueString("AttackingBase"), 
        function ()
          if IsValidEntity(shuaguai.base) == false then return nil end
          local newOrder = {
          UnitIndex = unit:entindex(), 
          OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
           TargetIndex = nil, --Optional.  Only used when targeting units
          AbilityIndex = 0, --Optional.  Only used when casting abilities
          Position = shuaguai.base:GetOrigin() , --Optional.  Only used when targeting the ground
          Queue = 0 --Optional.  Used for queueing up abilities
          }
          ExecuteOrderFromTable(newOrder)
          return 6
        end, 0) 
        end
        -- 循环刷近战和远程兵
        if i<30 then
            return 1
        else
            return nil
        end
    end
  end)   

end