require 'sqlite3'
require 'httparty'
require 'zip'
require 'JSON'

database = 'Mtg.db'


# Get the most recent version of AllSets-x.json.zip
inputStream = HTTParty.get('https://mtgjson.com/json/AllSets-x.json.zip')

zipName = "jsonzip.zip"

# Write the file to the disk
localFile = open(zipName,"w")
localFile.write(inputStream)
localFile.close

# Unzip the file to get the json object
Zip::File.open(zipName) do |zipFile|
	file = File.read(io)

#	allSets = JSON.parse(file)
#	
#	allSets.each do |set|
#	
#	end	
end


# Download the most up to date MTGJson AllSets-x file


SQLite3::Database.new(database) do |db|
end

