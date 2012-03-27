class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :screen_name
      t.string :name
      t.float :initial_weight
      t.float :initial_body_fat_percentageinitial
      t.date :regist_date

      t.timestamps
    end
  end
end
