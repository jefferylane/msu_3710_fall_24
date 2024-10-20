require 'faker' # Make sure the Faker gem is installed
require 'open-uri' # To open the image URL

# Purge existing profile photos and remove associated blobs and attachments
Student.find_each do |student|
 student.profile_photo.purge if student.profile_photo.attached?
end

# Ensure there are no orphaned attachments or blobs
ActiveStorage::Blob.where.missing(:attachments).find_each(&:purge)

#The above doesn’t delete the empty folders
# run the following to remove empty folders
# find storage/ -type d -empty -delete

Student.destroy_all # Clear existing records if any

50.times do |i|
 student =Student.create!(
   first_name: "First #{i + 1}",
   last_name: "Last #{i + 1}",
   school_email: "student#{i + 1}@msudenver.edu",
   major: Student::VALID_MAJORS.sample, # Assuming you have a VALID_MAJORS constant
   graduation_date: Faker::Date.between(from: 2.years.ago, to: 2.years.from_now),
  
 )
  # Generate a unique profile pic based on the student's name
   #profile_picture_url = "https://robohash.org/#{student.first_name.gsub(' ', '')}"
   #profile_picture = URI.open(profile_picture_url)
   #student.profile_picture.attach(io: profile_picture, filename: "#{student.first_name}.jpg")
end

puts "50 students created."