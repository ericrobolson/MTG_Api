require 'sqlite3'
require 'httparty'
require 'zip'
require 'JSON'

database = 'Mtg.db'
all_sets_url = 'https://mtgjson.com/json/AllSets-x.json.zip'
zip_name = 'jsonzip.zip'
json_filename = 'AllSets-x.json'

######################################################################
# Get the most recent version of the zipped json object containing  
# the mtg cards .
######################################################################
def get_zipfile(all_sets_url, zip_name)
	# Get the most recent version of AllSets-x.json.zip
	input_stream = HTTParty.get(all_sets_url)	
	
	# Write the file to the disk
	File.open(zip_name, "wb") do |f|
		f.binmode
		f.write input_stream.parsed_response
	end
end

########################################################################
# Get the json object from the given file name
########################################################################
def get_json_object(zip_name, json_filename)
	# Unzip the file to get the json object
	Zip::File.open(zip_name, Zip::File::CREATE) do |zip_file|
		json =  zip_file.read(zip_file.get_entry(json_filename))
		
		return JSON.parse(json)
	end
end

########################################################################
# Insert the specified value into the database
#	database: the database connection to use
#	table: the table to insert into
#	column: the column to insert to
#	value:	the value to use
# RETURNS: the id of the value inserted
########################################################################
def insert_value_into_database(database, table, column, value)
	

	database.execute("
		INSERT OR IGNORE INTO " + table + "
			("+ column +")
		VALUES
			(?)
	", value)
	
	id = database.execute("
			SELECT Id FROM " + table + "
			WHERE " + column + " = ? ", value)[0]
		
	return id;	
end


########################################################################
# Parse the json object and build the database
########################################################################
def Main(database, zip_name, json_filename)
	SQLite3::Database.new(database) do |db|
		json = get_json_object zip_name, json_filename
		json.each do |set|
			# Get the set info
			set_info_index = 1
			set_info = set[set_info_index]
		
			######### Pseudocode
			# 1: Set the set data
			# 2: Check to see if it exists in the database
			# 	2a: If not, create it and all associated info
			#	2b: If so, then load the ids from the db
			
			# Set the data 
			set_name = set_info['name'].to_s
			set_code = set_info['code'].to_s
			set_release_date = set_info['releaseDate'].to_s
			set_online_only = set_info['onlineOnly'].to_s
					
			# Set the ids or create them if they do not exist
			set_border_id = insert_value_into_database(db, 'Border', 'BorderType', set_info['border'])
			set_type_id = insert_value_into_database(db, 'SetType', 'SetType', set_info['type'])
			set_block_id = insert_value_into_database(db, 'Block', 'BlockName', set_info['block'])
			
			# set_id
			
		end
	end
end	
	
# Main program
Main(database, zip_name, json_filename)