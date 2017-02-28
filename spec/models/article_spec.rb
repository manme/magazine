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

require 'rails_helper'

RSpec.describe Article, type: :model do
  describe '#fill_subtags' do
    let(:article) { create(:article) }
    let(:tag_list) { 'aaa, bbb , ccc () , n(kk, rr), l (oo , ff), t (yy, oo, ff)' }
    let(:subtags_h) { { n: %w(kk rr), l: %w(oo ff), t: %w(yy oo ff) } }
    before do
      article.tag_list.add(tag_list,  parser: SubtagParser)
      article.save
    end

    it 'create tags' do
      tag_list = %w(aaa bbb ccc n l t)
      expect(article.tag_list).to eq(tag_list)
    end

    it 'create subtags tags' do
      article.save_subtags(tag_list)

      tag_list = %w(aaa bbb ccc n l t)
      article.taggings.each do |tagging|

        tagging.reload
        next if subtags_h[tagging.tag.name].nil?

        subtags = tagging.taggings.map { |sub_tagging| sub_tagging.tag.name }
        expect(subtags_h[tagging.tag.name]).to eq(subtags)
      end
    end
  end
end
