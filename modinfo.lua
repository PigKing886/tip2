name = "[Tips]提示系统"
description = [[
为猎犬来袭和Boss刷新提供提示
命令:
● /tips what [显示指定生物的刷新时间]
● /help tips [查看'what'的可用值]
● /不妥协选项默认关闭，需手动打开
]]

author = "suqf、風再起時"
version = "25/5/21"

--[[ icon_atlas = "icon.xml"
icon = "icon.tex" ]]

forumthread = ""

-- 让它知道你的mod是否过时，更新它以匹配游戏中的当前版本
api_version = 10

-- 指定与游戏的兼容性！
dont_starve_compatible = true
reign_of_giants_compatible = true
dst_compatible = true
all_clients_require_mod = true
server_filter_tags = {"NewTips"}

configuration_options =
{
    {
        name = "update_frequency",
        label = "更新频率",
        hover = "设置数据更新的频率。更长的时间可以减轻服务器负担，但可能导致提示信息更新不那么及时。",
        options = {
            {description = "1秒", data = 1, hover = "默认频率：适合服务器性能好或者喜欢即时更新数据的"},
            {description = "3秒", data = 3, hover = "每3秒更新一次。轻微减轻服务器负担。"},
            {description = "5秒", data = 5, hover = "每5秒更新一次。平衡性能和及时性。"},
            {description = "10秒", data = 10, hover = "每10秒更新一次。显著减轻服务器负担。"},
            {description = "30秒", data = 30, hover = "每30秒更新一次。大幅减轻服务器负担。"},
            {description = "60秒", data = 60, hover = "每分钟更新一次。最大限度减轻服务器负担，但提示不够及时。"},
        },
        default = 1,
    },

    {
        name = "tips_method",
        label = "提示方式",
        options = {
            {description = "界面显示", data = 1},
            {description = "对话气泡", data = 2},
            {description = "系统消息", data = 3},
        },
        default = 1,
    },

    {
        name = "hound",
        label = "猎犬",
        options = {
            {description = "开启", data = true},
            {description = "关闭", data = false},
        },
        default = true,
    },

    {
        name = "prime_mate",
        label = "猴船长",
        options = {
            {description = "开启", data = true},
            {description = "关闭", data = false},
        },
        default = true,
    },

    {
        name = "deerclops",
        label = "巨鹿",
        options = {
            {description = "开启", data = true},
            {description = "关闭", data = false},
        },
        default = true,
    },

    {
        name = "antlion",
        label = "蚁狮",
        options = {
            {description = "开启", data = true},
            {description = "关闭", data = false},
        },
        default = true,
    },

    {
        name = "bearger",
        label = "熊獾",
        options = {
            {description = "开启", data = true},
            {description = "关闭", data = false},
        },
        default = true,
    },

    {
        name = "klaus_sack",
        label = "克劳斯袋子",
        options = {
            {description = "开启", data = true},
            {description = "关闭", data = false},
        },
        default = true,
    },

    {
        name = "malbatross",
        label = "邪天翁",
        options = {
            {description = "开启", data = true},
            {description = "关闭", data = false},
        },
        default = true,
    },

    {
        name = "toadstool",
        label = "毒菌蟾蜍",
        options = {
            {description = "开启", data = true},
            {description = "关闭", data = false},
        },
        default = true,
    },

    {
        name = "crabking",
        label = "帝王蟹",
        options = {
            {description = "开启", data = true},
            {description = "关闭", data = false},
        },
        default = true,
    },

    {
        name = "dragonfly",
        label = "龙蝇",
        options = {
            {description = "开启", data = true},
            {description = "关闭", data = false},
        },
        default = true,
    },

    {
        name = "mock_dragonfly",
        label = " 季节龙蝇/月光龙蝇（永不妥协）",
        options = {
            {description = "开启", data = true},
            {description = "关闭", data = false},
        },
        default = false,
    },
    
	{
        name = "mothergoose",
        label = "鹅妈妈（永不妥协）",
        options = {
            {description = "开启", data = true},
            {description = "关闭", data = false},
        },
        default = false,
    },
    
	{
        name = "hoodedwidow",
        label = "蒙面寡妇（不妥协）",
        options = {
            {description = "开启", data = true},
            {description = "关闭", data = false},
        },
        default = false,
    },
	
    {
        name = "atrium_gate",
        label = "远古大门",
        options = {
            {description = "开启", data = true},
            {description = "关闭", data = false},
        },
        default = true,
    },

    {
        name = "beequeenhive",
        label = "蜂后",
        options = {
            {description = "开启", data = true},
            {description = "关闭", data = false},
        },
        default = true,
    },
    
    {
        name = "lunarrift_portal",
        label = "天体裂隙（地上可见）",
        options = {
            {description = "开启", data = true},
            {description = "关闭", data = false},
        },
        default = true,
    },
	
	{
        name = "shadowrift_portal",
        label = "暗影裂隙（洞穴可见）",
        options = {
            {description = "开启", data = true},
            {description = "关闭", data = false},
        },
        default = true,
    },

}