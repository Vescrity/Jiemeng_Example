local t = {
    Answers = {
        {
            pri = 100,
            anss = { lua_call1 = "Plug.webapi.daily_news" },
            regex = "^今日新闻$"
        },
        {
            pri = 88.0,
            anss = {
                lua_call = "mapi._163music"
            },
            regex = "^163#"
        },
        {
            pri = 88.0,
            anss = {
                lua_exec = "return Plug.format.fadian(_TMP.msg:param())"
            },
            regex = "^发电#"
        },
        {
            pri = 88.0,
            anss = {
                lua_exec = [[return Plug.chess.main(
                    _TMP.msg.user_id, _TMP.msg:true_param())]]
            },
            regex = "^\\.chess#"
        },
        {
            pri = 188.0,
            anss = {
                lua_call = "Plug.like.mapi.like"
            },
            regex = "^\\.like$"
        },
        {
            pri = 188.0,
            anss = {
                lua_call = "Plug.like.mapi.like5"
            },
            regex = "^\\.like5$"
        },
        {
            pri = 88.0,
            anss = {
                lua_exec = [[
                return bot.onebot.set_group_name(
                    _TMP.msg.group_id,'♪'.._TMP.msg:true_param())
                ]]
            },
            regex = "^\\.rename#"
        },
        {
            pri = 88.0,
            anss = {
                lua_call = "Plug.msginfo.mapi.get_json"
            },
            regex = "\\[CQ:reply.*\\.json$"
        },
        {
            pri = 88.0,
            anss = {
                data = { call = "mapi.Gschat" },
                state_call = "chat"
            },
            regex = "^桔梦#"
        },
        {
            pri = 88.0,
            anss = {
                state_exec = "chat",
                data = {
                    exec = "CHAT_MODEL='gemini-2.5-pro';return '已切换'"
                }
            },
            regex = "^\\.chatpro$"
        },
        {
            pri = 88.0,
            anss = {
                state_exec = "chat",
                data = {
                    exec = "CHAT_MODEL='gemini-2.5-flash';return '已切换'"
                }
            },
            regex = "^\\.chat$"
        },
        {
            pri = 88.0,
            anss = {
                state_exec = "chat",
                data = {
                    exec = [==[
                        CHAT_MODEL='gemini-2.5-flash-lite';
                        return '已切换'
                    ]==]
                }
            },
            regex = "^\\.chatlite$"
        },
        {
            pri = 88.0,
            anss = {
                data = { call = "mapi.Gchat" },
                state_call = "chat"
            },
            regex = "^桔梦-#"
        },
        {
            pri = 88.0,
            anss = {
                data = { call = "mapi.sdai" },
                state_call = "chat"
            },
            regex = "^召唤术#"
        },
        {
            pri = 88.0,
            anss = {
                data = { call = "mapi.chat.cat" },
                state_call = "chat"
            },
            regex = "^猫娘#"
        },
        {
            pri = 105.0,
            anss = {
                {
                    lua_call1 = "hitokoto",
                    weight = 13.0
                },
                "歇歇罢，没有一言了。\n    ——桔梦",
                {
                    weight = 2.0,
                    ["and"] = {
                        { draw_deck = "ask" },
                        "\n   ——桔梦"
                    }
                },
                {
                    weight = 1.0,
                    ["and"] = {
                        { order = "reRecv#桔梦语录" },
                        "\n   ——桔梦"
                    }
                }
            },
            regex = "^一言$"
        },
        {
            pri = 105.0,
            anss = { lua_call1 = "Plug.webapi.mapi.wiki" },
            regex = "^百科#"
        },
        {
            pri = 105.0,
            anss = { lua_call1 = "webapi.random_picture" },
            regex = "^随机图$"
        },
        {
            pri = 105.0,
            anss = { lua_call1 = "Plug.webapi.mapi.music_sch" },
            regex = "^点歌#"
        },
        {
            pri = 105.0,
            anss = { lua_call = "Plug.kfc.display" },
            regex = "^kfcs"
        },
        {
            pri = 105.0,
            anss = { lua_call = "Plug.kfc.mapi.modify" },
            regex = "^kfc#"
        },
        {
            pri = 105.0,
            anss = {
                lua_call = "Plug.webapi.mapi.sdcv"
            },
            regex = "^sdcv#"
        },
        {
            pri = 105.0,
            anss = {
                lua_call1 = "Plug.webapi.mapi.youdao_dict"
            },
            regex = "^查词#"
        }
    }
}
return t
