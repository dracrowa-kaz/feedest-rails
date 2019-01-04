class Article < ApplicationRecord
  validates :title, uniqueness: true
  validates :url, uniqueness: true

  def self.mark_as_read(item_id: item_id)
    read_articles = Article.where('url LIKE ?', '%' + item_id)
    read_articles.each do |article|
      article.read = true
      article.save
    end
  end
end
