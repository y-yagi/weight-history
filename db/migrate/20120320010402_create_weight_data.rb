class CreateWeightData < ActiveRecord::Migration
  def change
    create_table :weight_data do |t|
      t.string :uid
      t.string :name
      t.float :weight
      t.float :body_fat_percentageinitial
      t.date :regist_date
      t.timestamps
    end
  end
end
