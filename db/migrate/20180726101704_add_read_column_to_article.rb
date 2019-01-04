class AddReadColumnToArticle < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :read, :boolean, default: false
  end
end
