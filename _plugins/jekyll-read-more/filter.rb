# jekyll-read-more
#
# A Liquid Filter for Jekyll to check and retrieve
# an excerpt from a post.
#
# https://github.com/borwahs/jekyll-read-more
#
# Copyright (c) Rob Shaw, 2015
# See readme.md for LICENSE information.

module Jekyll
  module ReadMore
    module Filter
      extend self

      # uses the markdown format <!--- (three dashes)
      EXCERPT_BREAK_TAG = "<!---excerpt-break-->"

      def post_contains_excerpt_tag(post)
        if (!post)
          return false
        end

        if (post.strip.empty?)
          return false
        end
        
        post.include?(EXCERPT_BREAK_TAG)
      end

      def get_post_excerpt(post)
        if !post_contains_excerpt_tag(post)
          return post
        end

        post_split = post.split(EXCERPT_BREAK_TAG)

        strip_footnotes(post_split[0])
      end

      def strip_footnotes(content)
        # Example: <sup>...</sup>
        # Regex: <sup>.*?<\/sup>/mi

        content.gsub(/<sup>.*?<\/sup>/mi, '')
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::ReadMore::Filter) if defined?(Liquid)
