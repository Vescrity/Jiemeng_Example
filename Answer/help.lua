local t = {
    Answers = {
        {
            regex = "^\\.help$",
            ["pri"] = 100.0,
            ["anss"] = {
                {
                    ["lua_exec"] = [=====[
                return [==[
桔梦帮助文档，更新于2024-11-27

娱乐功能:
今日人品: .jrrp/.jrrp3/.jrrpn/.jrrpsp
随机语录
牌堆抽取: .draw#(牌堆名)[#(次数)]
牌堆列表: 桔梦牌堆列表
常用推荐: ask 超能力 我是谁 吃什么 塔罗牌
一言
百科: 百科#(查询内容)
随机图
弱智AI: 桔梦#(消息内容)
清理上下文: 桔梦#/clear
杀死: 桔梦#/kill
实用功能:
汉英词典(?): 查词#(词语)
随机三音 | 来点灵感
今日新闻
文转图：.t2img# 或 回复要转换的消息 .t2img
获取图片链接: 回复图片消息 .img
获取消息信息: 回复消息 .get
撤回消息: 回复需要撤回的消息 .del
引用(qoute): 回复需要引用的消息 .qt
lua编程: .lua#
cpp编程: .cpp#
python: .py#
Markdown: .md#
状态相关:
项目信息: .info
Bot状态: .status
测试功能:
一个弱智游戏: .game#...
]==]
]=====]
                },
            }
        }
    }
}
return t
