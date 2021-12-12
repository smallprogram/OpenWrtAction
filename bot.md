- # 电报机器人推送，TOKEN跟ID获取方式


为了保护自己tg安全请到你自己的仓库，点Settings，再点左边的Secrets，然后点右上角的New repositonry secret，然后在Name下面的方框写上名字，两个一个名为TGID 一个名为TGTOKEN，Value下面大方框放进密匙，点下面的绿色按钮Add secret保存即完成

- 1、 首先你得有个[telegram](https://telegram.org/)，推送消息需要 TELEGRAM_BOT_TOKEN 跟 TELEGRAM_CHAT_ID (TGID)

- 2、 整一个电报机器人, 在你的 telegram 搜索BotFather, 然后在与它的对话框中输入 /start 然后出来一堆命令符的，按 /newbot 指令,会出来一堆英文，意思是建立了一个新的机器人，问你机器人叫什么名字，你按你意思随便打一个就好了，比如叫danshui,在聊天框输入danshui发送，如果名字没给占用就可以继续下一步了，如果名字给占用了就继续设计名字，你们自己看看英文提示吧，比如danshui没给占用，下一步就继续要给机器人一个称呼，这个称呼得加 _bot 结尾，随便都可以，我就按习惯的继续用 danshui_bot 如果名字没给占用，他就出来一堆英文还有带上你刚刚建立的 danshui_bot 的名字在里面，[这个 danshui_bot 是一个链接来的，就是你的机器人了，点一下这个链接进入你的机器人，随便给他发一个信息，什么内容都可以，这个随便给它发信息是很重要的，关系到你能不能获得ID的问题](#)，然后回来看那堆英文里面有大写 HTTP API: 后面跟着一串东西的，比如 
-     9876543201:FEDCBA_dfoiuweSWEczgxT7-l4r9Y 这个就是你的TELEGRAM_BOT_TOKEN

- 这串东西不应泄露给他人,否则被人滥用的话会导致该bot被禁止.

- 3、 找到你的 TELEGRAM_CHAT_ID(TGID) ，找TELEGRAM_CHAT_ID (TGID)有两种方法

- 第一种方法
- 第一种就是在你的Telegram搜索 @Get My ID ，就跟加好友一样，搜索出来有好几个机器人的，随便点一个，然后聊天窗口那里点开始聊天，就能显示出你的TELEGRAM_CHAT_ID

#
- 第二种方法
-  如果前面你已经点了你自己创建的机器人的名字 danshui_bot 链接来发送过一次信息了就继续下面步骤，如果没有请去点击发送一次，或者发送多次信息，这个关系到获取ID的问题。

-  将前面获得的TELEGRAM_BOT_TOKEN(TGTOKEN)替换掉下面这个url中的XXYY部分,
-     https://api.telegram.org/botXXYY/getUpdates

- 把TELEGRAM_BOT_TOKEN替换掉XXYY应该是这样的:   
-     https://api.telegram.org/bot9876543201:FEDCBA_dfoiuweSWEczgxT7-l4r9Y/getUpdates   
- 然后在浏览器访问这个链接, 然后出来一串字符的，在字符里面找到message_id，需要注意的是这一串字符里面有3组阿拉伯数字的，你找"message_id":1,"from":{"id":1239000174,"is_bot" 1239000174这个就是你的TELEGRAM_CHAT_ID

-     总结你获得的TELEGRAM_BOT_TOKEN (TGTOKEN)为：9876543201:FEDCBA_dfoiuweSWEczgxT7-l4r9Y

-     你获得的TELEGRAM_CHAT_ID (TGID)为：1239000174

4、TELEGRAM_BOT_TOKEN(TGTOKEN)跟 TELEGRAM_CHAT_ID (TGID)生成好了，接下来到你自己的仓库，点Settings，再点左边的Secrets，然后点右上角的`New repositonry secret`，然后在Name下面的方框写上名字，名字为（TGTOKEN）不包括括号，Value下面大方框放进9876543201:FEDCBA_dfoiuweSWEczgxT7-l4r9Y，点下面的绿色按钮Add secret保存即完成

5、接下来再按`New repositonry secret`，然后在Name下面的方框写上名字，名字为（TGID）不包括括号，Value下面大方框放进1239000174，点下面的绿色按钮Add secret保存即完成

6、要记住，4跟5步的TELEGRAM_BOT_TOKEN (TGTOKEN)跟 TELEGRAM_CHAT_ID (TGID)都要是你自己获得的

7、设置完毕后如果打开了SSH连接的话，到了SSH这个步骤会自动把代码发送给你，也可以用于编译前后的信息提示。


#
---
#

- # pushplus推送，TOKEN的获取方式


- 1、pushplus推送，[点击这里](http://www.pushplus.plus/push1.html)，微信扫码登录，就可以看到你的token了
#
- 2、复制好pushplus你的token后，接下来到你自己的仓库，点Settings，再点左边的Secrets，然后点右上角的New repositonry secret，然后在Name下面的方框写上名字，名字为（PUSH_PLUS_TOKEN）不包括括号，Value下面大方框放进密匙，点下面的绿色按钮Add secret保存即完成
