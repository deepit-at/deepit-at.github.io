---
layout:         about

title:          About
description:    ''

menu:           true
order:          8
---

{{ page.content | reading_time }}

<!--author-->

## Credits

{% unless jekyll.environment == 'development' %}
    {% capture github_raw_link %}{% github_edit_link %}{% endcapture %}{% assign github_raw_link = github_raw_link | replace: "/edit/", "/raw/" %}
{% endunless %}

This site/blog is published using [Jekyll] which is hosted on [GitHub pages].
The clou here it has no dynamic elements, no database in the backend. So this site is completely static and regenerated every time when content is added. Which is really simple due to markdown

{% unless jekyll.environment == 'development' %}
 - go ahead and look for the source code for this very page [here]({{ github_raw_link }})
{% endunless %}

For those interested, [smashing magazine] has articles with a good starting point ([Build A Blog With Jekyll And GitHub Pages](https://www.smashingmagazine.com/2014/08/build-blog-jekyll-github-pages/)) and also a review of some alternatives ([Static Site Generators Reviewed: Jekyll, Middleman, Roots, Hugo](https://www.smashingmagazine.com/2015/11/static-website-generators-jekyll-middleman-roots-hugo-review/)).

As theme I chose [Hydejack], which felt nice, has quite some features which challenged me to get into the whole matter and quite conincidentially the author, Florian Klampfer is also from Austria.

Another nice coincidence was, that while finally deciding to starting a blog with some internal deadline, last month Florian announced a new version of his theme:
<blockquote class="twitter-tweet" data-lang="en">
<a href="https://twitter.com/qwtel/status/1018746048892682240"></a>
</blockquote>

The photo for the sidebar is grabbed from [unsplash], photographed by [Ronald Smeets (@ronaldsmeets)](https://unsplash.com/@ronaldsmeets?utm_medium=referral&amp;utm_campaign=photographer-credit) and titled "A Dreary Morning In The Mountains"

[Jekyll]: https://jekyllrb.com/
[GitHub pages]: https://pages.github.com/
[smashing magazine]: https://www.smashingmagazine.com
[Hydejack]: https://hydejack.com/
[unsplash]: https://unsplash.com/?utm_medium=referral


{% capture github_raw_link %}{% github_edit_link %}{% endcapture %}{% assign github_raw_link = github_raw_link | replace:
"/edit/", "/raw/" %}

This site/blog is published using [Jekyll] which is hosted on [GitHub pages].
The clou here it has no dynamic elements, no database in the backend. So this site is completely static and regenerated every time when content is added. Which is really simple due to markdown

{% unless github_raw_link contains "blob//" %}
 - go ahead and look for the source code for this very page [here]({{ github_raw_link }})
{% endunless %}

For those interested, [smashing magazine] has articles with a good starting point ([Build A Blog With Jekyll And GitHub Pages](https://www.smashingmagazine.com/2014/08/build-blog-jekyll-github-pages/)) and also a review of some alternatives ([Static Site Generators Reviewed: Jekyll, Middleman, Roots, Hugo](https://www.smashingmagazine.com/2015/11/static-website-generators-jekyll-middleman-roots-hugo-review/)).

As theme I chose [Hydejack], which felt nice, has quite some features which challenged me to get into the whole matter and quite conincidentially the author, Florian Klampfer is also from Austria.

Another nice coincidence was, that while finally deciding to starting a blog with some internal deadline, last month Florian announced a new version of his theme:
<blockquote class="twitter-tweet" data-lang="en">
<a href="https://twitter.com/qwtel/status/1018746048892682240"></a>
</blockquote>

The photo for the sidebar is grabbed from [unsplash], photographed by [Ronald Smeets (@ronaldsmeets)](https://unsplash.com/@ronaldsmeets?utm_medium=referral&amp;utm_campaign=photographer-credit) and titled "A Dreary Morning In The Mountains"

[Jekyll]: https://jekyllrb.com/
[GitHub pages]: https://pages.github.com/
[smashing magazine]: https://www.smashingmagazine.com
[Hydejack]: https://hydejack.com/
[unsplash]: https://unsplash.com/?utm_medium=referral
