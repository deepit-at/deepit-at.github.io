---
layout:         about

title:          About
description:    ''

comments:       true

menu:           true
order:          8
---

Thank you for visiting my blog.

If you're curious enough to peek who authors it, I hope you did find something useful, something which helps you in your own work.
Or, when you landed first on this page, I hope you can find something - or get in contact with me when you miss a specific topic.

<!--author-->

When I started my job and began to administrate our clients, I relied heavily on the knowledge of others which I found in the community around Microsoft & Windows - in various Forums (eg. TechNet), scripts, snippets and blog articles from MVPs and/or other tech savvy folk.

Soon enough, I've gone my own ways and strived ro realize and implement my own ideas to help my employer to have productive workplaces.

Now, 10+ years later, I decided it's time to give something back. Back to the giants on whose shoulders I stood at my own beginning. Sure, they (you?) may not quite need it, but then - hopefully - people new to this job can learn from me.

## Credits

### Jekyll

This site/blog is published using [Jekyll] which is hosted on [GitHub pages].
Please follow their link to find information about both open source project and their license.

{% unless jekyll.environment == 'development' %}
    {% capture github_raw_link %}{% github_edit_link %}{% endcapture %}{% assign github_raw_link = github_raw_link | replace: "/edit/", "/raw/" %}
### GitHub
As this blog itself is hosted on GitHub, you may go ahead and look for the source code for this very page [here]({{ github_raw_link }})
{% endunless %}

### Jekyll theme

As theme I chose [Hydejack] by Florian Klampfer.
For all credits/attributions from the theme itself, have a look over here: [Hydejack NOTICE](https://hydejack.com/NOTICE/)

{% unless jekyll.environment == 'development' %}
I already did quite a few modifications, which you can also have a look at the site's GitHub [repository]({{ site.github.repository_url }}))
{% endunless %}

### TLS Certificate

This site is using a TLS certificate from [Let's Encrypt], a free, automated and open Certificate Authority.

### Assets

The photo for the sidebar is grabbed from [unsplash], photographed by [Sebastian Hans (@@sebhans)](https://unsplash.com/@sebhans?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)

### Misc

{% if site.clicky %}- [http://clicky.com/](http://clicky.com/{{ site.clicky }}) - sadly, GitHub is lacking some site analytics, this is where clicky comes to play{% endif %}
- [https://www.deepl.com/translator](https://www.deepl.com/translator) - I may author the articles directly in english, but I check and `okay' them if their translation into german is understandable by me
- [http://www.network-science.de/ascii/](http://www.network-science.de/ascii/) for the ASCII art (font is 'larry3d') used in [humans.txt](/humans.txt)
- [https://cookiepolicygenerator.com](https://cookiepolicygenerator.com) - GDPR Cookies Policy Generator
- [https://gdprprivacypolicy.net](https://gdprprivacypolicy.net) - GDPR Privacy Policy Generator
- [https://termsandconditionstemplate.net](https://termsandconditionstemplate.net) - Template for Terms & Conditions


[Jekyll]: https://jekyllrb.com/
[GitHub pages]: https://pages.github.com/
[Hydejack]: https://hydejack.com/
[Let's Encrypt]: https://letsencrypt.org/
[unsplash]: https://unsplash.com/
