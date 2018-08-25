module Jekyll

  class VideoEmbed < Liquid::Tag

    Syntax = /^\s*([^\s]+)(\s+(\d+)\s+(\d+)\s*)?/

    Hosts = {
      "ted"     => ->(id) { "https://embed-ssl.ted.com/talks/#{id}.html" },
      "vimeo"   => ->(id) { "https://player.vimeo.com/video/#{id}" },
      "youtube" => ->(id) { "https://www.youtube.com/embed/#{id}?color=white&theme=light&border=0&wmode=opaque&enablejsapi=1" }
    }

    def initialize(tag_name, markup, tokens)
      super

      if markup =~ Syntax then
        @host = Hosts[tag_name]
        @id = $1

        if $2.nil? then
            @width = 560
            @height = 380
        else
            @width = $2.to_i
            @height = $3.to_i
        end
      else
        raise "No video ID provided in the \"#{tag_name}\" tag"
      end
    end

    def render(context)
      "<iframe width=\"#{@width}\" height=\"#{@height}\" src=\"#{@host.call(@id)}\" frameborder=\"0\" scrolling=\"no\" allow=\"encrypted-media\"         allowfullscreen=\"allowfullscreen\" mozallowfullscreen=\"mozallowfullscreen\" msallowfullscreen=\"msallowfullscreen\" oallowfullscreen=\"oallowfullscreen\" webkitallowfullscreen=\"webkitallowfullscreen\">&nbsp;</iframe>"
    end

    Hosts.each_key { |key| Liquid::Template.register_tag key, self }

  end

end
