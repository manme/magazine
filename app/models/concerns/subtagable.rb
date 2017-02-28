module Subtagable
  extend ActiveSupport::Concern

  def save_subtags(tags)
    # preload tags and taggings for article
    obj_tags = self.tags.includes(:taggings).to_a

    # get tags with brackets (subtags)
    arr_full_tags = tags.scan(SubtagParser::FULL_TAGS_PATTERN)

    arr_full_tags.each do |full_tag|
      tag_name = full_tag.gsub(SubtagParser::BRACKETS_PATTERN, '').strip
      subtags = subtags_from(full_tag)

      obj_tag = obj_tags.find { |tag| tag.name == tag_name }
      next if obj_tag.nil?

      save_subtags_for_tag(obj_tag, subtags)
    end
  end

  def subtags_from(full_tag)
    arr_subtags = full_tag.scan(SubtagParser::INSIDE_BRACKETS_PATTERN).first
    return nil if arr_subtags.nil?
    arr_subtags.first.split(',').collect(&:strip)
  end

  def save_subtags_for_tag(obj_tag, subtags)
    obj_tag.taggings.each do |obj_tagging|
      next if obj_tagging.tag_list.any?

      obj_tagging.tag_list = subtags
      obj_tagging.save
    end
  end
end