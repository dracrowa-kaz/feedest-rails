FactoryBot.define do
  factory :article do
    title 'title'
    url 'https://qiita.com/hatnychan/items/b39f8b166b5c5ec86c0e'
    content 'content'
    author 'author'
    published Date.today
    feed_id 1
  end
end