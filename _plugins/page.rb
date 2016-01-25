odule Jekyll
  class Page
    def tags
      (self.data['tags'] || '').split(',').map {|t| Tag.new(t)}
    end
  end
end