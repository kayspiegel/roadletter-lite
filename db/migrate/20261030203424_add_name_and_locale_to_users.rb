class AddNameAndLocaleToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :name, :string, null: false, default: ""
    add_column :users, :locale, :string, null: false, default: "en"
  end
end
