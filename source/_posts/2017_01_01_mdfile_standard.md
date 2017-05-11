---
title: Markdown文件规范
date: 2017-01-01 9:29:54
comments: false
tags: [markdown]
categories: 技术
permalink: file_standard
---
> &emsp;&emsp;Markdown是一种可以使用普通文本编辑器编辑的标记语言，通过简单的标记语法，可以自动生成具有一定样式的文本。markdown语法简单明了，学习容易，而且功能比纯文本要强，因此很多人用他来写博客，比如WordPress和大型的CMS如Joomla、Drupal等都支持markdown。除此之外markdown还用于github中README.md用于编写说明文档。

# 文件头格式规范
``` stylus
    ---
    title: 诫子书
    date: 2017-04-15 16:20:00
    updated: 2017-04-15 16:20:00
    comments: false
    tags: [励志]
    categories: 文言
    permalink: to_son
    description: xx
    ---
```
## title
 - 文章标题

## date
 - 文件编写日期
 
## updated
 - 更新时间

## comments
 - 是否开启评论true or false 

## tags
 - tomcat
 - nginx
 - java
 - markdown
 - js
 - ajax
 - html5
 - 前端
 - 青春
 - 励志
 - 读书
 - 激情
 - ...

## categories
 - 文言
 - 美文
 - 诗歌
 - 文档
 - 技术
 - 摄影
 - ...
## description
 - 文章概述，如果不为空，则预览的时候显示后标签后面的内容（作用和正文中的分隔符作用差不多）

# 正文格式规范
```
    > &emsp;&emsp;其实非常喜欢这...
    
    # 标题一
    ## 标题二
    ### 标题三    
    XXXXXXXX
    ## 标题二.1
```

## 说明
 - 我们用引用符号`>` 来规范文本格式，作为摘要部分，一般情况下，摘要要大于150个字，因为摘要的前150个字用于作为首页摘要简讯
 - 斜体`*摘要：*`注明摘要部分开始，这不是必需，而是规范。