# == Schema Information
#
# Table name: articles
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  content    :string           not null
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Article < ApplicationRecord
  acts_as_taggable
  include Subtagable

  validates :title, presence: true
  validates :content, presence: true

  scope :search_title, ->(search) { where("title LIKE ?", "%#{search}%")}
  scope :search_content, ->(search) { where("content LIKE ?", "%#{search}%")}
  scope :search, ->(search) { search_title(search).or(search_content(search)) }

  def self.search_in_tags(tag_name)
    article_ids = []

    # finding subtags
    ActsAsTaggableOn::Tagging.tagged_with(tag_name).each do |tagging|
      article_ids << tagging.taggable_id if tagging.taggable_type == Article.name
    end

    # finding tags
    Article.tagged_with(tag_name).each do |article|
      article_ids << article.id
    end

    article_ids
  end

  def all_tags
    taggings.map do |tagging|
      str = tagging.tag.name
      subtags = tagging.taggings.map { |sub_tagging| sub_tagging.tag.name }
      str << ' (' << subtags.join(', ') << ' )' if subtags.any?
      str
    end.join(', ')
  end
end
