local t = {
    Answers = {
        {
            ["pri"] = 88.0,
            ["anss"] = {
                ["data"] = {
                    ["call"] = "mapi.game.game"
                },
                ["state_call"] = "game"
            },
            ["regex"] = "^\\.game"
        },
        {
            ["pri"] = 95.0,
            ["anss"] = {
                "嗯……那就用这个开头罢！\n[1d7][1d7][1d7]"
            },
            ["regex"] = {
                "^随机三音$",
                "来点灵感"
            }
        },
        {
            ["pri"] = 105.0,
            ["anss"] = {
                ["lua_call"] = "Plug.easymapi.change_Rcode"
            },
            ["regex"] = "^\\.r#"
        },
        {
            ["pri"] = 105.0,
            ["anss"] = {
                ["lua_call"] = "mapi.ai_say"
            },
            ["regex"] = "^\\.say#"
        },
        {
            ["pri"] = 100.0,
            ["anss"] = {
                ["lua_call"] = "mapi.ai_say_reply"
            },
            ["regex"] = {
                ["and"] = {
                    "CQ:reply",
                    "\\.say"
                }
            }
        },
        {
            ["pri"] = 105.0,
            ["anss"] = {
                ["lua_call"] = "mapi.bot.draw_deck"
            },
            ["regex"] = "^\\.draw#"
        },
        {
            ["pri"] = 105.0,
            ["anss"] = {
                ["lua_call"] = "mapi.bot.set_title"
            },
            ["regex"] = "^\\.title#"
        },
        {
            ["pri"] = 105.0,
            ["anss"] = {
                ["lua_exec"] = "return bot.deck_list()"
            },
            ["regex"] = "^桔梦牌堆列表$"
        },
        {
            ["pri"] = 105.0,
            ["anss"] = {
                ["draw_deck"] = "维斯特拉贴贴"
            },
            ["regex"] = "^维斯特拉贴贴$"
        },
        {
            ["pri"] = 100.0,
            ["anss"] = {
                ["lua_call"] = "mapi.bot.txt2img"
            },
            ["regex"] = "^\\.txt2img#"
        },
        {
            ["pri"] = 100.0,
            ["anss"] = {
                ["lua_call"] = "mapi.md2png"
            },
            ["regex"] = "^\\.md#"
        },
        {
            ["pri"] = 100.0,
            ["anss"] = {
                ["lua_call"] = "mapi.md2png_reply"
            },
            ["regex"] = {
                ["and"] = { "CQ:reply", "\\.md" }
            }
        },
        {
            ["pri"] = 100.0,
            ["anss"] = {
                ["lua_call"] = "mapi.t2img"
            },
            ["regex"] = "^\\.t2img#"
        },
        {
            ["pri"] = 100.0,
            ["anss"] = {
                ["lua_call"] = "mapi.message_shuffle_reply"
            },
            ["regex"] = {
                ["and"] = {
                    "CQ:reply",
                    "\\.sf"
                }
            }
        },
        {
            ["pri"] = 100.0,
            ["anss"] = {
                ["lua_call"] = "mapi.t2img_reply"
            },
            ["regex"] = {
                ["and"] = {
                    "CQ:reply",
                    "\\.t2img"
                }
            }
        },
        {
            ["pri"] = 100.0,
            ["anss"] = {
                lua_call = "Plug.qoute.mapi.qoute"
            },
            ["regex"] = {
                ["and"] = {
                    "CQ:reply",
                    "\\.qt"
                }
            }
        },
        {
            ["pri"] = 100.0,
            ["level"] = 100.0,
            ["anss"] = {
                lua_exec = [[
                    return bot.string_only(
                        bot.os_sh(msg:true_param()))
                ]]
            },
            regex = "^\\!sh#"
        },
        {
            pri = 88,
            ["anss"] = {
                ["lua_call"] = "mapi.bot.del_msg"
            },
            ["regex"] = {
                ["and"] = {
                    "CQ:reply",
                    "\\.del"
                }
            }
        },
        {
            ["pri"] = 88.0,
            ["anss"] = {
                ["and"] = {
                    "该消息中的图片链接：\n",
                    { lua_call = "Plug.msginfo.mapi.get_imgurl" }
                }
            },
            ["regex"] = {
                ["and"] = { "\\[CQ:reply", "\\.img" }
            }
        },
        {
            ["pri"] = 88.0,
            ["anss"] = {
                ["lua_call"] = "Plug.qoute.mapi.qoute_cut"
            },
            ["regex"] = {
                ["and"] = {
                    "\\[CQ:reply",
                    "\\.qut"
                }
            }
        },
        {
            ["pri"] = 88.0,
            ["anss"] = {
                ["lua_call"] = "Plug.huma.mapi.charcut_reply"
            },
            ["regex"] = {
                ["and"] = {
                    "\\[CQ:reply",
                    "\\.cut"
                }
            }
        },
        {
            ["pri"] = 88.0,
            ["anss"] = {
                ["lua_call"] = "Plug.huma.mapi.show_utf8_reply"
            },
            ["regex"] = {
                ["and"] = {
                    "\\[CQ:reply",
                    "\\.utf"
                }
            }
        },
        {
            ["pri"] = 88.0,
            ["anss"] = {
                ["lua_call"] = "Plug.huma.mapi.show_utf8_get"
            },
            ["regex"] = {
                ["and"] = {
                    "\\.utf#"
                }
            }
        },
        {
            ["pri"] = 88.0,
            ["anss"] = {
                ["lua_call"] = "Plug.huma.mapi.charcut_get"
            },
            ["regex"] = {
                ["and"] = {
                    "\\.cut#"
                }
            }
        },
        {
            ["pri"] = 88.0,
            anss = { lua_call1 = "Plug.msginfo.mapi.echo_reply" },
            ["regex"] = {
                ["and"] = {
                    "\\[CQ:reply",
                    "\\.echo"
                }
            }
        },
        {
            pri = 88,
            ["anss"] = {
                ["and"] = {
                    "消息内容：\n",
                    { lua_call1 = "Plug.msginfo.mapi.get_info" }
                }
            },
            regex = {
                ["and"] = { "\\[CQ:reply", "\\.get$" }
            }
        },
        {
            ["pri"] = 100.0,
            ["anss"] = {
                {
                    ["draw_deck"] = "超能力"
                }
            },
            ["regex"] = "^超能力$"
        },
        {
            ["pri"] = 100.0,
            ["anss"] = {
                {
                    ["draw_deck"] = "塔罗牌"
                }
            },
            ["regex"] = "^塔罗牌$"
        },
        {
            ["pri"] = 100.0,
            ["anss"] = {
                "[CQ:music,type=163,id=1433188977]",
                "[CQ:music,type=163,id=1438092622]",
                "[CQ:music,type=163,id=1450628953]",
                "[CQ:music,type=163,id=1853917192]",
                "[CQ:music,type=163,id=1878572567]",
                "[CQ:music,type=163,id=1893149779]"
            },
            ["regex"] = "^随机冬末$"
        },
    },
}

return t
