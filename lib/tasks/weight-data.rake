#require File.expand_path('lib/tasks/direct_message')

desc "get direct message and update data"
task :update_data => :environment do
    puts "Updating data..." 
    DirectMessage.exec 
    puts "done."
end
