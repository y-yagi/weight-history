class CreateWeightData < ActiveRecord::Migration
  def change
    create_table :weight_data do |t|
      t.string :uid
      t.float :weight
      t.float :body_fat_percentage
      t.date :data_date

      t.timestamps
    end
  end
end
