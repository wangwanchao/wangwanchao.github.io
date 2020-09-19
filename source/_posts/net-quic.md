---
title: QUIC协议
date: 2020-09-05 15:48:30
tags:
categpries: NetWork
---
最近在阿里云看到一篇介绍QUIC协议的文章，又勾起了我对她的兴趣。无论网络的如何发展，好像仍然无法解决地铁上网速卡到打不开网页的问题。而QUIC多多少少和这个沾点边

1. QUIC是什么？what
2. QUIC用来做什么？for
3. QUIC解决了什么问题？solve
4. QUIC的设计原理是什么？design
5. 你自己如何实现QUIC？practice

1) QUIC是一种基于UDP的通信协议，现在已经被IETF采纳为标准协议HTTP/3

<!-- more -->
一次无法理解的东西，我可能会分很长时间补充(待续...)





## Cloudflare基于Rust实现的quiche



### 
Windows
Exit any running-instance of Chrome.
Right click on your "Chrome" shortcut.
Choose properties.
At the end of your "Target:" line add the command line flags. For example:
--disable-gpu-vsync
With that example flag, it should look like below (replacing "--disable-gpu-vsync" with any other command line flags you want to use):
chrome.exe --disable-gpu-vsync
Launch Chrome like normal with the shortcut.
macOS
Quit any running instance of Chrome.
Run your favorite Terminal application.
In the terminal, run commands like below (replacing "--remote-debugging-port=9222" with any other command line flags you want to use):
/Applications/Chromium.app/Contents/MacOS/Chromium --remote-debugging-port=9222

# For Google Chrome you'll need to escape spaces like so:
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222
Linux
Quit any running instance of Chrome.
Run your favorite terminal emulator.
In the terminal, run commands like below (replacing "--remote-debugging-port=9222" with any other command line flags you want to use):
chromium-browser --remote-debugging-port=9222
google-chrome --foo --bar=2
