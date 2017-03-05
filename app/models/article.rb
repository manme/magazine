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
  include PgSearch

  acts_as_taggable
  include Subtagable

  validates :title, presence: true
  validates :content, presence: true

  belongs_to :user

  pg_search_scope :search_for, against: %i(title content)

  def self.search_in_tags(tag_name)
    article_ids = []

    # finding subtags
    subtags = ActsAsTaggableOn::Tagging.tagged_with(tag_name)
    subtags.pluck(:taggable_id, :taggable_type).each do |taggable_id, taggable_type|
      article_ids << taggable_id if taggable_type == Article.name
    end

    # finding tags
    Article.tagged_with(tag_name).pluck(:id).each do |article_id|
      article_ids << article_id
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
