---
layout:             post

categories:         []
tags:               [ self, jekyll ]

date:               2018-08-28 18:14:30 +0200
# last_modified_at:   <datetime>
# published:          false

author:             sfarnik
# title:              ''

image:              /assets/img/posts/feed-xml.png

excerpt_separator:  <!--more-->
# excerpt:
# description:

# redirect_from:
---

> The image is showing my feed.xml template on the left, and the one from the plugin on the right

I have some issues with the [jekyll-feed](https://github.com/jekyll/jekyll-feed)  plugin available on GitHub Pages which I will explain here.

First, if you happen to use ```site.description``` then it could have trailing whitespace when you define this tag using yaml's block scalar types.
See answer [21699210](https://stackoverflow.com/a/21699210) on stackoverflow.com

The theme I use, has a default description set in ```_config.yml``` like this:

~~~yaml
description:           >
  "Best Jekyll Theme by a Mile".
  **Hydejack** is your presence on the web, featuring a blog, portfolio, and resume.

~~~

Which leads to a this part in the ```feed.xml```

~~~xml
    <subtitle>"Best Jekyll Theme by a Mile". **Hydejack** is your presence on the web, featuring a blog, portfolio, and resume. </subtitle>
~~~

See the trailing whitespace ?
What are we going to do about it ?

<!--more-->

Grab the template for the [```feed.xml```](https://raw.githubusercontent.com/jekyll/jekyll-feed/master/lib/jekyll-feed/feed.xml) from the plugins GitHub repository.
Put it in the main directory of your web site.

You will have to do two more changes, so Jekyll will consider your ```feed.xml``` when building the web site:

```_config.yml```:
~~~yaml
include:
  - feed.xml

plugins:
  # - jekyll-feed # this will remove the current plugin if you're using it
~~~

```feed.xml```:
~~~yaml
---
---
~~~

Now, to tackle the trailing whitespace, we have to add a liquid string filter to a line in our ```feed.xml```

~~~xml
{% raw %}
    <subtitle>{{ site.description | xml_escape }}</subtitle>
{% endraw %}
~~~

~~~xml
{% raw %}
    <subtitle>{{ site.description | strip | xml_escape }}</subtitle>
{% endraw %}
~~~

It's all about the ``` | strip ``` part. This remove leading and trailing whitespace from the variable.

With this, the above ```description``` would look like this:

~~~xml
    <subtitle>"Best Jekyll Theme by a Mile". **Hydejack** is your presence on the web, featuring a blog, portfolio, and resume.</subtitle>
~~~

Finally of course, I had to add the link manually to the html head:

~~~html
{% raw %}
    ...
    <link type="application/atom+xml" rel="alternate" href="{{ '/feed.xml' | absolute_url }}" title="{{ site.title }}" />
</head>
{% endraw %}
~~~

If you look at the cover image, you may see that I have two more issues with the plugin, I will cover them with a follow-up post.

All the best,<br/>Stefan
