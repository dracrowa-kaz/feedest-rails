class ChangeClumnArticlesText < ActiveRecord::Migration[5.1]
  def change
    remove_column :articles, :content, :text
    add_column :articles, :content, :text, :limit => 4294967295
  end
end
