class ChangeColumnArticles < ActiveRecord::Migration[5.1]
  def change
    remove_column :articles, :content, :string
    add_column :articles, :content, :text
  end
end
