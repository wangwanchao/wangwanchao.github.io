# hexo-blog

#### 项目介绍

wangsir's blog

#### 软件架构

hexo框架 + Next主题

# 构建镜像
docker build -t wangsir/blog .


docker run --name wangsir-blog -p 8180:8080 -d wangsir/blog:0.3


