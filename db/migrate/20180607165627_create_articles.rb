class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do |t|
      t.string :title, null: false, default: ""
      t.string :url, null: false, default: ""
      t.string :content, null: false, default: ""
      t.string :author, null: false, default: ""
      t.datetime :published, null: false
      t.references :feed, foreign_key: true
      t.timestamps
    end
  end
end
