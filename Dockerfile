FROM node:12-alpine3.12
LABEL creater="blog" description="这是一个静态网站" version="1.0"

RUN npm install npm -g \
    npm install -g hexo \
    npm install -g hexo-cli 

WORKDIR /blog
COPY ./* /blog/
RUN npm install --force \
    npm uninstall hexo-math --save \ 
    npm install hexo-renderer-mathjax --save 
RUN hexo g

CMD ["hexo", "s", "-p 8080"]
EXPOSE 8080