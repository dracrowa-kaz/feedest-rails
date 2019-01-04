class ChangeColumnArticleTitle < ActiveRecord::Migration[5.1]
  def change
    remove_column :articles, :title, :text
    add_column :articles, :title, :text, :limit => 4294967295
  end
end
