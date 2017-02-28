ActsAsTaggableOn.delimiter = ','

module ActsAsTaggableOn
  class Tagging
    acts_as_taggable
  end
end

class SubtagParser < ActsAsTaggableOn::GenericParser

  # from 'a, a(), b(1,2,3), c(1,2)' return 'b(1,2,3)' and 'c(1,2)'
  FULL_TAGS_PATTERN = /[\w ]*\([^()]+\)/
  # from 'a, a(), b(1,2,3), c(1,2)' return 'a()', 'b(1,2,3)' and 'c(1,2)'
  BRACKETS_PATTERN = /\([^()]*\)/
  # from 'b(1,2,3)' return '1,2,3'
  INSIDE_BRACKETS_PATTERN = /\(([\w ,]+)\)/

  def parse
    ActsAsTaggableOn::TagList.new.tap do |tag_list|
      tag_list.add @tag_list.gsub(BRACKETS_PATTERN,'').split(',').collect(&:strip)
    end
  end
end
