---
layout:             post

categories:         []
tags:               [ self, jekyll ]

date:               2018-08-31 13:47:00 +0200
# last_modified_at:   <datetime>
# published:          false

author:             sfarnik
# title:              ''

# image:              https://dummyimage.com/800x480

excerpt_separator:  <!--more-->
# excerpt:
# description:

# redirect_from:
---

Additionally to [previous part](/2018-08-28-issues-using-feed-plugin/) this post should finalize my adaptions and show that I was missing the plugins ability to use the authors collection to access to the email and url properties.

Also, the plugin does list the correct language for the feed itself, utilizing the ```site.lang``` property, but it fails to do so for the posts. It would be possible to set defaults in ```_config.yml``` for the _posts collection, but it would be better if the language falls back to the site setting.

The third issue I was about to mention is the fact, that the plugin is using and exposing the full feed.

After searching the internet and reading more and more articles, I refined my feed a even more!

<!--more-->

Even, the feed is allowed to link to and icon and logo, so I added the favicon.ico and logo.png here as well.

~~~xml
    <link rel="icon" href="{{ '/assets/icons/favicon.ico' | absolute_url }}" />
    <link rel="logo" href="{{ '/assets/icons/icon.png' | absolute_url }}" />
~~~

About the author: The plugin only uses author which is declared on the site itself, not using the authors collection which many themes are using.

So I simply assign either the first author in the collection if it exists, or the site.author as usual:
Its just one line addes and afterwards the . notation replaced by an underscore (_), assesing our temporary assigned variable.

~~~xml
{% raw %}
    {% assign site_author = site.data.authors.first[1] | default: site.author %}
    {% if site_author %}
      <author>
          <name>{{ site_author.name | default: site_author | xml_escape }}</name>
        {% if site_author.social.email or site.author.email %}
          <email>{{ site_author.social.email | default: site_author.email | xml_escape }}</email>
        {% endif %}
        {% if site_author.uri %}
          <uri>{{ site_author.uri | xml_escape }}</uri>
        {% endif %}
      </author>
    {% endif %}
{% endraw %}
~~~

This completed the feed itself, now we're going to adapt the posts, represented as ```<entry>``` in Atom feeds.

The first thing is about the used language, if a post doesn't specify one, it should fall back to the lang defined in the site configuration:

~~~xml
      <entry{% if post.lang or site.lang %}{{" "}}xml:lang="{{ post.lang | default: site.lang }}"{% endif %}>
~~~

Each post/entry also has an author element; here the plugin is utilizing the authors collection, however, it doesn't use the social property.

~~~xml
{% raw %}
        {% assign post_author_email = post_author.social.email | default: post_author.email | default: nil %}
        {% assign post_author_uri = post_author.social.uri | default: post_author.uri | default: nil %}
{% endraw %}
~~~

Now, we're coming for the full-feed. At first I didn't like the idea that the full feed is being used.
However, there are different views on this and when I do read the feed I subscribed for, I prefer full-feed and complain when sites only show their parial-feed (just search for it, there are a lot of comments about it).

So, now I also use the full-feed, however I thought it would make sense to add a property which would change the behaviour. This is what feed.summary_only is for. So if you don't set it, the default is the same as with the plugin and the feed will show the full posts.

Here I also make use of the ```<![CDATA[ ]]>``` element in xml, so there is no more escaping needed and the feed also looks nice in Internet Explorer's default view.

~~~xml
{% raw %}
        {% unless site.feed.summary_only %}
        <content type="html" xml:base="{{ post.url | absolute_url | xml_escape }}">
          <div xmlns="http://www.w3.org/1999/xhtml"><![CDATA[
            {% if post.image %}
            <img re-ignore class="webfeedsFeaturedVisual" src="{{ post.image | absolute_url }}" />
            {% endif %}
            {{ post.content | normalize_whitespace | replace: post.excerpt_separator, '' }}
          ]]></div>
        </content>
        {% endunless %}
{% endraw %}
~~~

![The feed also looks nice in Internet Explorer's default view](/assets/img/posts/feed-ie.png)
Chrome and Edge don't seem to like it, though. Both don't have an build-in Feed reader.

These changes allow me to have a nice feed with full posts.
I should also mentioned that I made changes according to what satisfies feedly: [10 ways to optimize your feed for feedly](https://blog.feedly.com/10-ways-to-optimize-your-feed-for-feedly/).

So, my ```feed.xml``` now looks like this:

~~~xml
---
---
{% raw %}
<?xml version="1.0" encoding="utf-8"?>{% capture xml_content %}
{% if page.xsl %}
<?xml-stylesheet type="text/xml" href="{{ '/feed.xslt.xml' | absolute_url }}"?>
{% endif %}
  <feed xmlns="http://www.w3.org/2005/Atom" xmlns:webfeeds="http://webfeeds.org/rss/1.0" {% if site.lang %}xml:lang="{{ site.lang }}"{% endif %}>
    <generator uri="https://jekyllrb.com/" version="{{ jekyll.version }}">Jekyll</generator>
    <link href="{{ page.url | absolute_url }}" rel="self" type="application/atom+xml" />
    <link href="{{ '/' | absolute_url }}" rel="alternate" type="text/html" {% if site.lang %}hreflang="{{ site.lang }}" {% endif %}/>

    {% unless site.hydejack.no_theme_color %}
    <webfeeds:accentColor>{{ site.theme_color | default:site.accent_color | default:'#4fb1ba' | remove_first: '#' }}</webfeeds:accentColor>
    {% endunless %}
    <webfeeds:logo>{{ '/assets/icons/icon.png' | absolute_url }}</webfeeds:logo>
    <webfeeds:cover image="{{ '/assets/icons/icon_576x576.png' | absolute_url }}" />
    <link rel="icon" href="{{ '/assets/icons/favicon.ico' | absolute_url }}" />
    <link rel="logo" href="{{ '/assets/icons/icon.png' | absolute_url }}" />
    <updated>{{ site.time | date_to_xmlschema }}</updated>
    <id>{{ '/' | absolute_url | xml_escape }}</id>

    {% if site.title or site.name %}
    <title type="text">{{ site.title | default: site.name | smartify | strip | xml_escape }}</title>
    {% endif %}

    {% if site.description %}
    <subtitle>{{ site.description | strip | xml_escape }}</subtitle>
    {% endif %}

    {% assign site_author = site.data.authors.first[1] | default: site.author %}
    {% if site_author %}
      <author>
          <name>{{ site_author.name | default: site_author | xml_escape }}</name>
        {% if site_author.social.email or site.author.email %}
          <email>{{ site_author.social.email | default: site_author.email | xml_escape }}</email>
        {% endif %}
        {% if site_author.uri %}
          <uri>{{ site_author.uri | xml_escape }}</uri>
        {% endif %}
      </author>
    {% endif %}

    {% comment %}<contributor></contributor>{% endcomment %}

    {% assign posts = site.posts | where_exp: "post", "post.draft != true", "post.published != false" %}
    {% for post in posts limit: 10 %}
      <entry{% if post.lang or site.lang %}{{" "}}xml:lang="{{ post.lang | default: site.lang }}"{% endif %}>
        <id>{{ post.id | absolute_url | xml_escape }}</id>
        <title type="html">{{ post.title | smartify | strip | normalize_whitespace | xml_escape }}</title>
        <link href="{{ post.url | absolute_url }}" rel="alternate" type="text/html" title="{{ post.title | xml_escape }}" />
        <published>{{ post.date | date_to_xmlschema }}</published>
        <updated>{{ post.last_modified_at | default: post.date | date_to_xmlschema }}</updated>

        {% assign post_author = post.author | default: post.authors[0] | default: site.author %}
        {% assign post_author = site.data.authors[post_author] | default: post_author %}
        {% assign post_author_email = post_author.social.email | default: post_author.email | default: nil %}
        {% assign post_author_uri = post_author.social.uri | default: post_author.uri | default: nil %}
        {% assign post_author_name = post_author.name | default: post_author %}

        <author>
          <name>{{ post_author_name | default: "" | xml_escape }}</name>
                {% if post_author_email %}
          <email>{{ post_author_email | xml_escape }}</email>
                {% endif %}
                {% if post_author_uri %}
          <uri>{{ post_author_uri | xml_escape }}</uri>
                {% endif %}
        </author>

        {% comment %}<contributor></contributor>{% endcomment %}

        {% if post.excerpt and post.excerpt != empty %}
        <summary type="text">{{ post.excerpt | strip_html | normalize_whitespace | strip | xml_escape }}</summary>
        {% endif %}

        {% unless site.feed.summary_only %}
        <content type="html" xml:base="{{ post.url | absolute_url | xml_escape }}">
          <div xmlns="http://www.w3.org/1999/xhtml"><![CDATA[
            {% if post.image %}
            <img re-ignore class="webfeedsFeaturedVisual" src="{{ post.image | absolute_url }}" />
            {% endif %}
            {{ post.content | normalize_whitespace | replace: post.excerpt_separator, '' }}
          ]]></div>
        </content>
        {% endunless %}

        {% if post.category %}
        <category term="{{ post.category | xml_escape }}" />
        {% endif %}

        {% for tag in post.tags %}
        <category term="{{ tag | xml_escape }}" />
        {% endfor %}

        {% assign post_image = post.image.path | default: post.image %}
        {% if post_image %}
          {% assign post_image = post_image | absolute_url %}
        <media:thumbnail xmlns:media="http://search.yahoo.com/mrss/" url="{{ post_image | xml_escape }}" />
        {% endif %}
      </entry>
    {% endfor %}
  </feed>{% endcapture %}{{ xml_content | normalize_whitespace }}
{% endraw %}
~~~

All the best,<br/>Stefan
