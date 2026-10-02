modimport "common"

SERVER = TheNet and TheNet:GetIsServer()
CLINET = TheNet and not TheNet:IsDedicated()

AddModRPCHandler("Tips", "T", function()
end)

if CLINET then
    modimport("client")
end

local entities = {}

AddPrefabPostInitAny(function(inst)
    entities[inst.prefab] = inst
    inst:ListenForEvent("onremove", function()
        if entities[inst.prefab] == inst then
            entities[inst.prefab] = nil
        end
    end)
end)

local function findentity(prefabname)
    return entities[prefabname]
end

local function gettimespawner(t)
    local spawner = TheWorld and t.spawner and TheWorld.components[t.spawner]
    local data = spawner and spawner.OnSave and spawner:OnSave()

    if t.conditionfn and not t.conditionfn(data) then
        return
    end

    local time = data and data[t.timetowhat]
    time = time and math.floor(time)
    if time then
        return time
    end

    local worldsettingstimer = TheWorld and TheWorld.components.worldsettingstimer
    local ent = findentity(t.spawner or t.name)
    if ent ~= nil and ent.components ~= nil and ent.components.worldsettingstimer ~= nil then
        worldsettingstimer = ent.components.worldsettingstimer
    end

    if worldsettingstimer == nil or t.timername == nil then
        return nil
    end

    time = worldsettingstimer:GetTimeLeft(t.timername)
    time = time and math.floor(time)
    return time or nil
end

local function gettimeleft(t)
    local prefab = findentity(t.prefab)
    if prefab == nil or prefab.components.timer == nil then
        return
    end

    local time
    local timer
    for _, v in ipairs(t.timer) do
        time = prefab.components.timer:TimerExists(v) and
                prefab.components.timer:GetTimeLeft(v)
        if time then
            timer = v
            break
        end
    end

    local time = t.adjusttimefn and t.adjusttimefn(time, timer) or time
    time = time and math.floor(time)
    return time or nil
end

local function getdefaultposition(t, time)
    if time and time > 0 then
        return
    end

    local ent = c_findnext(t.prefab or t.name)
    if ent ~= nil then
        return ent:GetPosition():__tostring()
    end
end

local tips_list = {
    {
        name = "hound",
        aliases = { "hd", "wm", "worm" },
        getptfn = function()
        end,
        spawner = "hounded",
        timetowhat = "timetoattack",
    },

    {
        name = "deer",
        aliases = { "dr" },
        spawner = "deerherdspawner",
        timetowhat = "_timetospawn",
        getptfn = function()
            local herdlocation = TheWorld.components.deerherding.herdlocation
            if herdlocation ~= nil and herdlocation:Length() ~= 0 then
                return herdlocation:__tostring()
            end
        end,
    },

    {
        name = "prime_mate",
        aliases = { "pm" },
        getptfn = function()
        end,
        spawner = "piratespawner",
        timetowhat = "nextpiratechance",
    },

    {
        name = "deerclops",
        aliases = { "dc" },
        timername = "deerclops_timetoattack",
        conditionfn = function(data)
            return TheWorld.state.cycles > TUNING.NO_BOSS_TIME and
                    (TUNING.DEERCLOPS_ATTACKS_OFF_SEASON or TheWorld.state.season == "winter")
        end,
    },

    {
        name = "bearger",
        aliases = { "bg" },
        spawner = "beargerspawner",
        timername = "bearger_timetospawn",
        conditionfn = function(data)
            return data and TheWorld.state.isautumn and
                    TheWorld.state.cycles > TUNING.NO_BOSS_TIME and
                    data.numSpawned < data.numToSpawn and
                    (data.lastKillDay == nil or TheWorld.state.cycles - data.lastKillDay > TUNING.NO_BOSS_TIME)
        end
    },

    {
        name = "klaus_sack",
        aliases = { "ks" },
        timername = "klaussack_spawntimer",
    },

    {
        name = "malbatross",
        aliases = { "mt" },
        timername = "malbatross_timetospawn",
        getptfn = function(t, time)
            if time and time > 0 then
                return
            end

            if TheWorld == nil or TheWorld.components.malbatrossspawner == nil then
                return
            end

            local fn = TheWorld.components.malbatrossspawner.OnUpdate

            local _activemalbatross = GetUpValue(fn, "_activemalbatross")
            if _activemalbatross ~= nil then
                return _activemalbatross:GetPosition():__tostring()
            end

            local _shuffled_shoals_for_spawning = GetUpValue(fn, "_shuffled_shoals_for_spawning")
            if _shuffled_shoals_for_spawning ~= nil then
                local max_shoals_to_test = math.ceil(#_shuffled_shoals_for_spawning * 0.25)
                local pt = {}
                for i, v in ipairs(_shuffled_shoals_for_spawning) do
                    table.insert(pt, v:GetPosition():__tostring())
                    if i == max_shoals_to_test then
                        break
                    end
                end
                return pt
            end
        end
    },

    {
        name = "toadstool",
        aliases = { "tt" },
        timername = "toadstool_respawntask",
        getptfn = function(t, time)
            if time and time > 0 then
                return
            end
            for i = 1, c_countprefabs("toadstool_cap", true) do
                local toadstool_cap = c_findnext("toadstool_cap")
                if toadstool_cap and toadstool_cap:HasToadstool() then
                    return toadstool_cap:GetPosition():__tostring()
                end
            end
        end
    },

    {
        name = "crabking",
        aliases = { "ck" },
        prefab = "crabking",
        spawner = "crabking_spawner",
        timername = "regen_crabking",
    },

    {
        name = "antlion",
        aliases = { "al" },
        prefab = "antlion",
        spawner = "antlion",
        timername = "rage",
    },

    {
        name = "dragonfly",
        aliases = { "df" },
        prefab = "dragonfly_spawner",
        spawner = "dragonfly_spawner",
        timername = "regen_dragonfly",
    },

	{
        name = "hoodedwidow",
        aliases = { "hw" },
        prefab = "hoodedwidow",
        getptfn = function(t, time)
            if time and time > 0 then
                return
            end

            -- 尝试找到当前世界中的蒙面寡妇
            local widow = findentity("hoodedwidow")
            if widow ~= nil then
                return widow:GetPosition():__tostring()
            end
        end,
        gettimefn = function(t)
            -- 如果寡妇已经存在，返回0（表示已生成）
            local widow = findentity("hoodedwidow")
            if widow ~= nil then
                return 0
            end

            -- 查找寡妇网
            local web = findentity("widowweb")
            if web ~= nil and web.components.timer ~= nil then
                -- 获取重生计时器的剩余时间
                local time = web.components.timer:GetTimeLeft("regen_widow")
                if time ~= nil then
                    return math.floor(time)
                end
            end

            return nil
        end,
    },

    {
        name = "atrium_gate",
        aliases = { "ag" },
        prefab = "atrium_gate",
        gettimefn = function()
            local atrium_gate = findentity("atrium_gate")
            if atrium_gate == nil then
                return nil
            end

            local worldsettingstimer = atrium_gate.components.worldsettingstimer
            if worldsettingstimer == nil then
                return nil
            end

            local time = 0
            if worldsettingstimer:ActiveTimerExists("destabilizedelay") then
                time = worldsettingstimer:GetTimeLeft("destabilizedelay") + TUNING.ATRIUM_GATE_COOLDOWN + TUNING.ATRIUM_GATE_DESTABILIZE_DELAY
            elseif worldsettingstimer:ActiveTimerExists("destabilizing") then
                time = worldsettingstimer:GetTimeLeft("destabilizing") + TUNING.ATRIUM_GATE_COOLDOWN
            elseif worldsettingstimer:ActiveTimerExists("cooldown") then
                time = worldsettingstimer:GetTimeLeft("cooldown")
            end

            return math.floor(time)
        end,
    },

    {
        name = "beequeenhive",
        aliases = { "bh" },
        gettimefn = gettimeleft,
        prefab = "beequeenhive",
        timer = { "hivegrowth1", "hivegrowth2", "hivegrowth" },
        adjusttimefn = function(time, timer)
            if timer == "hivegrowth1" then
                return time + TUNING.BEEQUEEN_RESPAWN_TIME * 2 / 3
            elseif timer == "hivegrowth2" then
                return time + TUNING.BEEQUEEN_RESPAWN_TIME / 3
            end
            return time
        end
    },

    {
		name = "lunarrift_portal",
		aliases = {"lp"},
		prefab = "lunarrift_portal",
		gettimefn = function()
			if TheWorld.components.riftspawner and TheWorld.components.riftspawner:IsLunarPortalActive() then
                -- 检查当前存在的裂隙是否有阶段计时
                --[[local rift = findentity("lunarrift_portal")
                if rift and rift.components.timer then
                    local stage_time_left = rift.components.timer:GetTimeLeft("trynextstage") or TheWorld.components.lunarthrall_plantspawner.inst.components.timer:GetTimeLeft("endrift")
                    if stage_time_left then
                        return stage_time_left
				    else
					    print("不存在该计时器")
                    end
                end ]]
				return 0 -- 已存在月亮裂隙但没有阶段计时
			end

			if TheWorld.components.riftspawner and TheWorld.components.riftspawner:GetLunarRiftsEnabled() then
				local worldsettingstimer = TheWorld.components.worldsettingstimer
				if worldsettingstimer and worldsettingstimer:ActiveTimerExists("rift_spawn_timer") then
					return worldsettingstimer:GetTimeLeft("rift_spawn_timer")
				end
			end

			return nil
		end
    },

	{
        name = "shadowrift_portal",
        aliases = {"sp"},
        prefab = "shadowrift_portal",
        gettimefn = function()
            if TheWorld.components.riftspawner and TheWorld.components.riftspawner:IsShadowPortalActive() then
                return 0 -- 已存在暗影裂隙但没有阶段计时
            end

            if TheWorld.components.riftspawner and TheWorld.components.riftspawner:GetShadowRiftsEnabled() then
                local worldsettingstimer = TheWorld.components.worldsettingstimer
                if worldsettingstimer and worldsettingstimer:ActiveTimerExists("rift_spawn_timer") then
                    return worldsettingstimer:GetTimeLeft("rift_spawn_timer")
                end
            end

            return nil
        end
    },

    {
        name = "mock_dragonfly",
        aliases = {"mdf"},
        timername = "mockfly_timetoattack",
        conditionfn = function(data)
            -- 添加检查TUNING.DSTU是否存在
            if TUNING.DSTU == nil then
                return false -- 如果DSTU不存在，返回false
            end
            
            return TheWorld.state.cycles > TUNING.DSTU.NO_MOCK_DRAGONFLY_BOSS_TIME and
                   (TheWorld.state.issummer or _attackduringoffseason)
        end,
		
		getptfn = function(t, time) 
			if time and time > 0 then 
				return 
			end 
			
			-- 检查是否是满月和天数超过50天 
			if TheWorld.state.cycles > 50 and (TheWorld.state.isfullmoon or TheWorld.state.isalterawake) then 
				local moonmaw = c_findnext("moonmaw_dragonfly") 
				if moonmaw ~= nil then 
					return moonmaw:GetPosition() 
				end 
			end 
			
			local mock_dragonfly = c_findnext("mock_dragonfly") 
			if mock_dragonfly ~= nil then 
				return mock_dragonfly:GetPosition():__tostring() 
			end 
		end
        
        --[[ gettimefn = function(t)
            local time = TheWorld.components.worldsettingstimer:GetTimeLeft("mockfly_timetoattack")
            if time and time > 0 then
                -- 检查是否是满月和天数超过50天
                return time
            end
            return 0
        end ]]
    },

    {
        name = "mothergoose",
        aliases = {"mg"},
        timername = "mothergoose_timetoattack",
        conditionfn = function(data)
            -- 添加检查TUNING.DSTU是否存在
            if TUNING.DSTU == nil then
                return false -- 如果DSTU不存在，返回false
            end
            
            return TheWorld.state.cycles > TUNING.DSTU.NO_MOTHER_GOOSE_BOSS_TIME and
                   (TheWorld.state.isspring or _attackduringoffseason)
        end,

        getptfn = function(t, time)
            if time and time > 0 then
                return
            end
            
            local mothergoose = c_findnext("mothergoose")
            if mothergoose ~= nil then
                return mothergoose:GetPosition():__tostring()
            end
        end
    },
}

for i, v in ipairs(tips_list) do
    if v.gettimefn == nil then
        v.gettimefn = gettimespawner
    end
    if v.getptfn == nil then
        v.getptfn = getdefaultposition
    end
end

tips_index = {}
for i, v in ipairs(tips_list) do
    tips_index[v.name] = i
    for _, alias in ipairs(v.aliases) do
        tips_index[alias] = i
    end
end

AddPlayerPostInit(function(player)
    player:AddComponent("tips")
end)

-- auto
autotipslist = {}
for _, v in ipairs(tips_list) do
    if GetModConfigData(v.name) then
        table.insert(autotipslist, v.name)
    end
end

function AutoTips()
    local times = {}
    for _, v in ipairs(autotipslist) do
        local t = tips_list[tips_index[v]]
        local time = t:gettimefn()
        if time ~= nil and time > 0 then
            times[v] = time
            -- 实现当时间小于等于60秒时，每隔10秒发送一次公告
            if time <= 61 then
                -- 获取实体的名称（用于显示）
                print("已满足60秒以下")
				local name = ""
				if v == "mock_dragonfly" then
					name = "时令龙蝇（月光龙蝇）"
				elseif v == "mothergoose" then
					name = "鹅妈妈"
				elseif v == "antlion" then
					name = "地震"
				else
					name = STRINGS.NAMES[string.upper(v)] or v
				end
                local time_rounded = math.floor(time)
                local message = string.format("%s将在%d秒后刷新！", name, time_rounded)
                local newmessage = string.format("%s已刷新!", name)
                local TheNet = GLOBAL.TheNet
                -- 发送公告
                if SERVER then
                    if time_rounded == 60 then
                        TheNet:Announce(message)
                    elseif time_rounded == 30 then
                        TheNet:Announce(message)
                    elseif time_rounded == 10 then
                        TheNet:Announce(message)
                    elseif time <= 1 then
                        TheNet:Announce(newmessage)
                    end
                end
            end
        end
    end

    for _, player in pairs(AllPlayers) do
        if player.components.tips then
            for k, v in pairs(times) do
                player.components.tips:SetAutoValue(k, { time = v })
            end
            player.components.tips:Send()
        end
    end
end

AddPrefabPostInit("world", function(inst)
    if SERVER then
        local update_freq = GetModConfigData("update_frequency")
        AutoTips()
        inst:DoPeriodicTask(update_freq, AutoTips)
    end
end)

-- manual
AddModRPCHandler("Tips", "Time", function(inst, index)
    local t = tips_list[index]
    if t == nil then
        return
    end

    local time = t:gettimefn()
    local pt = t:getptfn(time)
    if inst.components.tips then
        inst.components.tips:SetManualValue(t.name, { time = time, pt = pt })
    end
end)

function SendRPC(what)
    local index = tips_index[what]
    if index then
        print(index)
        SendModRPCToServer(MOD_RPC.Tips.Time, index)
    end
end