---
title: MD文件规范
date: 2017-01-01 9:29:54
tags: [markdown]
categories: 技术
---
# 文件头格式规范
``` stylus
    ---
    title: Markdown效果预览
    date: 2017-01-01 16:29:54
    tags: [java,nginx]
    categories: Markdown
    description:
    ---
```
## title
 - 文章标题

## date
 - 文件编写日期

## tags
 - tomcat
 - nginx
 - java
 - 青春
 - markdown
 - 读书
 - js<!--more-->
 - ajax
 - 前端
 - html5
 - ...

## categories
 - 文言
 - 美文
 - 诗歌
 - 文档
 - 技术
 - 摄影

## description
 - 文章概述，如果不为空，则预览的时候显示后标签后面的内容（作用和正文中的分隔符作用差不多）

# 正文格式规范
## 分隔符
差不多200字的时候添加摘要分隔符，使摘要和正文隔开

摘要分割符使用方法如下：
``` stylus
XXXX<!-- more -->
XXXX
```
