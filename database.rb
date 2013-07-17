#This is my application
require "mysql2"
require "CSV"
require "yaml"

config = YAML::load(open("#{File.expand_path(File.dirname(__FILE__))}/configs/configs.yml"))["mysql"]
client = Mysql2::Client.new(:host => "localhost", :username => "root", :database => "patrick_class")

files = "*.csv"
files = Dir.glob files
p files


client.query "truncate table customers"
class FormatDate
    def self.format(date)
		Date.strptime(date, "%m/%d/%Y").strftime("%Y-%m-%d")
	end
end
begin
	# File.readlines(file).map {  |records|
		# records = records.gsub("\n","")
		# p records 
		# records = records.split(",")
	
	# }
	
	files.each { |file|
		p file
		CSV.foreach(file, :headers => :first_row) { |records|
			p records
			fname = records[0].gsub("'","''")
			lname = records[1].gsub("'","''")
			dob = FormatDate.format(records[2])
			dob = Date.strptime(records[2], "%m/%d/%Y").strftime("%Y-%m-%d")
			age = records[3]
			p "Insert into customers values('#{fname}', '#{lname}','#{dob}','#{age}')"
				client.query "Insert into customers values('#{fname}', '#{lname}','#{age}','#{dob}','#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}')"
		
		}
	}
	
	
rescue Exception => e
	@message = e.message
	exit
end

files.each{|file| FileUtils.mv(file, "backup/")}


