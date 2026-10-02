local UIAnim = require "widgets/uianim"
local Text = require "widgets/text"
local easing = require "easing"
local Widget = require "widgets/widget"

local config_list = {
    hound = {
        scale = 0.066,
        build = "hound_ocean",
        loop = false
    },

    prime_mate = {
        scale = 0.066,
        bank = "pigman",
        build = "monkeymen_build",
        animation = "idle_loop",
        loop = true,
    },

    deerclops = {
        animation = "idle_loop",
        loop = true
    },

    bearger = {
        scale = 0.02,
        animation = "idle_loop",
        loop = true
    },

    klaus_sack = {
        scale = 0.066,
        bank = "klaus_bag",
        build = "klaus_bag",
    },

    malbatross = {
        scale = 0.02,
        animation = "idle_loop",
        loop = true,
    },

    toadstool = {
        scale = 0.02,
        loop = true,
    },

    crabking = {
        scale = 0.015,
        bank = "king_crab",
        build = "crab_king_build",
    },

    antlion = {
        loop = true,
    },

    dragonfly = {
        loop = true,
    },
    -- 黑寡妇
	hoodedwidow = {
    scale = 0.04,
    bank = "widow",
    build = "widow1",
    animation = "idle",
    loop = true,
    },

    atrium_gate = {
        scale = 0.03,
        build = "atrium_gate",
    },

    beequeenhive = {
        scale = 0.05,
        bank = "bee_queen_hive",
        build = "bee_queen_hive",
        animation = "large",
    },

    lunarrift_portal = {
        scale = 0.05,
        bank = "lunar_rift_portal",
        build = "lunar_rift_portal",
        animation = "stage_1_loop",
        loop = true,
    },

	shadowrift_portal = {
        scale = 0.05,
        bank = "shadowrift_portal",
        build = "shadowrift_portal",
        animation = "stage_1_loop",
        loop = true,
    },
	mock_dragonfly = {
    scale = 0.04,
    bank = "moonmaw_dragonfly",
    build = "moonmaw_dragonfly",
    animation = "idle",
    loop = true,
    },
	mothergoose = {
    scale = 0.03,
    bank = "goosemoose",
    build = "goosemoose_yule_build",
    animation = "idle",
    loop = true,
    },
}

for k,v in pairs(config_list) do
    v.scale = v.scale or 0.033
    v.x = v.x or 0
    v.y = v.y or -50
    v.bank = v.bank or k
    v.build = v.build or (v.bank .. "_build")
    v.animation = v.animation or "idle"
end

local TipsBadge = Class(Widget, function(self, prefab)
    Widget._ctor(self, "TipsBadge")

    --self.bg = self:AddChild(Image("images/.xml", ".tex"))

    local config = config_list[prefab]

    self.head = self:AddChild(UIAnim())
    self.head:SetScale(config.scale)
    self.head:SetPosition(config.x, config.y)
    self.head:GetAnimState():SetBank(config.bank)
    self.head:GetAnimState():SetBuild(config.build)
    self.head:GetAnimState():PlayAnimation(config.animation, config.loop)

    self.num = self:AddChild(Text(NUMBERFONT, 30))
    self.num:SetHAlign(ANCHOR_MIDDLE)
    self.num:SetPosition(55, -40.5)
end)

return TipsBadge

