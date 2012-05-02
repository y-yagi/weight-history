# -*- encoding: UTF-8 -*-


weight = 59.8
body_fat_percentage = 18.0 
data_date = Date.new(2012,1,1)

(1..30).each do |i| 
  WeightData.create(
    :uid => '79129290',
    :weight => weight,
    :body_fat_percentage =>body_fat_percentage,
    :data_date => data_date
  )

 weight = weight - 0.1
 body_fat_percentage = body_fat_percentage - 0.1 
 data_date = data_date.next
end

