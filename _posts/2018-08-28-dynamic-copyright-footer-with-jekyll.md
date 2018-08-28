---
layout:             post

categories:         []
tags:               [ self, jekyll ]

date:               2018-08-28 12:41:07 +0200
# last_modified_at: <datetime>
# published:        false

author:             sfarnik
# title:              ''

# image:              https://dummyimage.com/wvga

excerpt_separator:  <!--more-->
# excerpt:
# description:

# redirect_from:
---

As you might have noticed, I am using Jekyll for this blog.
I keep tinkering with it, instead of writing some blog posts. So I decided maybe I should write some post about ... my tinkering with Jekyll.

Sounds good ? Here we go!

<!--more-->

The footer originally in the theme, uses a static year for the text.
I adapted it in a way, which adopts dynamically.

I didn't like the idea to have to edit the string each year, so it would reflect the blogs lifetime.<br />Instead I did a small change, once.

Though, I have to trigger a build by Jekyll, which happens automatically when I put new articles online.

First, we adapt the ```_config.yaml```:

~~~yaml
# This text will appear in a `<small>` tag in the footer of every page.
copyright:             >
  © 2018. All rights reserved.
  Open `_config.yml` to edit this text.
~~~

to

~~~yaml
# This text will appear in a `<small>` tag in the footer of every page.
copyright:             © <!--copyyears--> deepit.at; All rights reserved.
~~~

You guessed correctly that we're going to replace the ```<!--copyyears-->``` to the dynamic string.
So let's go to ```_includes\body\footer.html```:

The original line is just a static string:
~~~html
    <p><small class="copyright">{{ site.copyright | markdownify | replace:'<p>','' | replace:'</p>','' }}</small></p>
~~~

Here is the updated part:
~~~html
{% raw %}
    {% assign year_from = site.posts[-1].date | date: '%Y' %}
    {% assign year_to   = site.time | date: '%Y' %}
    {% if year_from == nil or year_from == year_to %}
      {% assign year_string = year_from %}
    {% else %}
      {% assign from_to_seperator = site.data.strings.from_to_seperator | default: '-' %}
      {% assign year_string = year_from | append: '&nbsp;' | append: from_to_seperator | append: '&nbsp;' | append: year_to %}
    {% endif %}
    <p><small class="copyright">{{ site.copyright | markdownify | replace:'<!--copyyears-->',year_string | replace:'<p>','' | replace:'</p>','' }}</small></p>
{% endraw %}
~~~

What is happening here ?

- For the starting year, we're using the date from the first ever post
- The current year is covered by ```site.time```, which represents the time when Jekyll build the site
- Next, we're covering two things:
  - When we don't have a first post, the ```year_from``` string will be empty, so we will be just using the ```year_to``` - Jekyll should have build a site, right, so this one won't be empty at all
  - If both years are the same, we also will be using just one
  - On the other hand, if we have different years, then we will build a string like `2018 - 2019'
- Finally, we can replace the ```<!--copyyears-->``` from ```site.copyright``` with our dynamically generated string

Now I don't need to take care anymore about this litte detail.

All the best,<br />Stefan
