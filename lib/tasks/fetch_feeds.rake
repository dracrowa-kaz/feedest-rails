namespace :feeds do
  desc "フィードをフェッチしてくる"
  task :fetch => :environment do
    Rails.logger.info  "Feeds:fetch executed"
    User.all.each do |user|
      user.feeds.each do |feed|
        feed.articles.destroy_all
        rss = Feedjira::Feed.fetch_and_parse(feed.url)
        rss.entries.each do |entry|
          puts entry.url
          begin
            if Article.create(title: entry.title, url: entry.url, content: entry.content, author: entry.author, published: entry.published, feed_id: feed.id )
              puts "レコードの記録に成功"
              Rails.logger.info  "Feeds:fetch success"
            else
              puts "レコードの記録に失敗"
              Rails.logger.info  "Feeds:fetch error"
            end
          rescue => exception
            puts "レコードの記録に失敗"
            Rails.logger.info  "Feeds:fetch error"
            next
          end
        end
      end
    end
  end
end
