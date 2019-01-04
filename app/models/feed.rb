class Feed < ApplicationRecord
  belongs_to :user
  has_many :articles, :dependent => :delete_all

  def fetchArticle
    articles = []

    # 当日の記事が既に取得済みの場合、DBから取得する
    if self.updated_today?()
      articles += self.articles.where(read: false)
    else
      # 未取得の場合、APIで取得する
      self.articles.where(read: false).destroy_all
      if Feed.is_url_json?(url: self.url)
        articles << self.fetchAndCreateArticlesFromJson()
      else
        articles << self.fetchAndCreateArticleFromXml()
      end
    end

    articles
  end

  def self.is_valid_url(url: url)
    rss = []
    if Feed.is_url_json?(url: url)
      rss = Feed.fetchArticleFromJson(url: url)
    else
      rss = Feed.fetchArticleFromXml(url: url)
    end
    rss.entries.count.zero?
  end

  def self.fetchArticleFromXml(url: url)
    Feedjira::Feed.fetch_and_parse(url)
  end

  def fetchAndCreateArticleFromXml
    rss = Feed.fetchArticleFromXml(url: self.url)
    articles = []
    rss.entries.each do |entry|
      begin
        # 重複チェック
        return unless Article.find_by(title: entry.title).nil?
        articles << Article.create({
                                       title: entry.title,
                                       url: entry.url,
                                       content: entry.content,
                                       author: entry.author,
                                       published: entry.published,
                                       feed_id: self.id
                                   })
      rescue => exception
        return articles
      end
    end
    self.updated_at = Date.today
    self.save!
    articles
  end

  def self.fetchArticleFromJson(url: url)
    uri = URI.parse(url)
    json = Net::HTTP.get(uri)
    JSON.parse(json)
  end

  def fetchAndCreateArticlesFromJson
    rss = Feed.fetchArticleFromJson(url: self.url)
    articles = []
    rss.each do |entry|
      if article = Article.create(title: entry["title"], url: entry["url"], content: entry["content"], author: entry["user"]["id"], published: entry["created_at"], feed_id: self.id)
        articles << article
      end
    end
    self.updated_at = Date.today
    self.save!
    articles
  end

  def updated_today?
    updated_today =  self.updated_at >= Date.today
    article_exists = self.articles.count > 0
    updated_today && article_exists
  end

  private

  def self.is_url_json?(url: url)
    extname = File.extname(URI.parse(url).path)
    extname == ".json"
  end
end
