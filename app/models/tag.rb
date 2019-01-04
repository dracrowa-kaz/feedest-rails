class Tag < ApplicationRecord
  belongs_to :user
  scope :same_day_tags, -> (name){ where(:name => name).where(created_at: Time.zone.today.beginning_of_day..Time.zone.today.end_of_day) }

  def self.register_original_tag(original_tag: original_tag, current_user: current_user)
    Tag.create(name: original_tag, user: current_user) if Tag.should_register_tag(tag_name: original_tag, current_user: current_user)
  end

  def self.register_qiita_tags(item_id: item_id, current_user: current_user)
    url = 'https://qiita.com/api/v2/items/' + item_id
    uri = URI.parse(url)
    json = Net::HTTP.get(uri)
    rss = JSON.parse(json)
    rss['tags'].each do |entry|
      tag_name = entry['name']
      if Tag.should_register_tag(tag_name: tag_name, current_user: current_user)
        Tag.create(name: tag_name, user: current_user)
      end
    end
  end

  def self.should_register_tag(tag_name: tag_name, current_user: current_user)
    Rails.logger.info tag_name.present? && current_user.tags.same_day_tags(tag_name).count.zero?
    tag_name.present? && current_user.tags.same_day_tags(tag_name).count.zero?
  end
end
