class CreateFeeds < ActiveRecord::Migration[5.1]
  def change
    create_table :feeds do |t|
      t.string :title, null: false, default: ""
      t.string :url, null: false, default: ""
      t.references :user, foreign_key: true
      t.timestamps null: false
    end
  end
end
