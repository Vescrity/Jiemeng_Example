return {
    Answers = {
        {
            pri = 88.0,
            anss = {
                lua_exec = [[
                    local msg=_TMP.msg;
                    Plug.bottle.append(msg.user_nk..'扔的\n【'..msg:param()..'】');
                    return '扔！'
                ]]
            },
            regex = "^扔#"
        },
        {
            pri = 88.0,
            anss = {
                lua_exec = [===[
                local msg=bot.get_reply_message(_TMP.msg);
                Plug.bottle.append(string.format( "%s扔的\n%s说的\n【%s】",
                    _TMP.msg.user_nk,
                    msg.user_nk,
                    msg:get_string())
                );
                return '扔！']===]
            },
            regex = "\\[CQ:reply.*扔"
        },
        {
            pri = 88.0,
            anss = {
                lua_exec = "return '捡到了...'..Plug.bottle.get()"
            },
            regex = "^捡$"
        },
        {
            pri = 88.0,
            anss = {
                lua_exec = "return '捡走了...'..Plug.bottle.get_and_remove()"
            },
            regex = "^捡走$"
        },
        {
            pri = 88.0,
            anss = {
                lua_exec = "return '还有'..Plug.bottle.count()..'瓶'"
            },
            regex = "^数瓶子$"
        },

    }
}
