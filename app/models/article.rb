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

  validates :title, presence: true
  validates :content, presence: true

  scope :search_title, ->(search) { where("title LIKE ?", "%#{search}%")}
  scope :search_content, ->(search) { where("content LIKE ?", "%#{search}%")}
  scope :search, ->(search) { search_title(search).or(search_content(search)) }

  acts_as_taggable
end
