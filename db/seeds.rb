# -*- encoding: UTF-8 -*-

User.create(
  :name => 'y_yagi', 
  :initial_weight => 60.2, 
  :initial_body_fat_percentageinitial => 18.0,
  :regist_date => Date.today
)  

WeightData.create(
  :name => 'y_yagi',
  :weight => 60.2,
  :body_fat_percentage => 18.0,
  :created_at => '2012/01/01'
)


WeightData.create(
  :name => 'y_yagi',
  :weight => 60.3,
  :body_fat_percentage => 18.0,
  :created_at => '2012/01/02'
)


WeightData.create(
  :name => 'y_yagi',
  :weight => 59.8,
  :body_fat_percentage => 18.0,
  :created_at => '2012/01/03'
)


weight = 59.8
body_fat_percentage = 18.0 
created_at = Date.new(2012,1,1)

(1..30).each do |i| 
  WeightData.create(
    :name => 'y_yagi',
    :weight => weight,
    :body_fat_percentage =>body_fat_percentage,
    :created_at => created_at
  )

 weight = weight - 0.1
 body_fat_percentage = body_fat_percentage - 0.1 
 created_at = created_at.next
end

