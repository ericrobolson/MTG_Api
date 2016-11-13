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
	id = database.execute("
			SELECT Id FROM " + table + "
			WHERE " + column + " = ? ", value)[0]
	
	if (id.nil?)
		if (value.nil?)
			return nil
		end
	
		database.execute("
		INSERT INTO " + table + "
			("+ column +")
		VALUES
			(?)
		", value)
	end 
	id = database.execute("
			SELECT Id FROM " + table + "
			WHERE " + column + " = ? ", value)[0]
		
	return id;	
end


########################################################################
# Insert the set with the specified values into the database
#	database: the database connection to use
# RETURNS: the id of the set created or found
########################################################################
def insert_set(db, set_name, set_code, set_release_date, set_online_only, set_border_id, set_type_id, set_block_id)
	# Grab the set_id that fits the data
	set_id = db.execute("SELECT Id FROM MtgSet WHERE
		Name = ? AND 
		Code = ? AND 
		ReleaseDate = ?",
		[
			set_name, 
			set_code, 
			set_release_date, 
		])[0]
	
	if (set_id.nil?)
		# Insert the data into the database
		db.execute("INSERT OR IGNORE INTO MtgSet 
		(
			Name, 
			Code, 
			ReleaseDate, 
			OnlineOnly, 
			BorderId, 
			SetTypeId,
			BlockId) 
		VALUES (?,?,?,?,?,?,?)", 
		[
			set_name, 
			set_code, 
			set_release_date, 
			set_online_only, 
			set_border_id, 
			set_type_id, 
			set_block_id
		])
	end
	
	# Grab the set_id that fits the data
	set_id = db.execute("SELECT Id FROM MtgSet WHERE
		Name = ? AND 
		Code = ? AND 
		ReleaseDate = ?",
		[
			set_name, 
			set_code, 
			set_release_date
		]
	)[0]
	
	puts set_name + ': ' + set_id.to_s
	puts '-- ' + set_code.to_s
	puts '-- ' + set_release_date.to_s
	puts '-- ' + set_online_only.to_s
	puts '-- ' + set_border_id.to_s
	puts '-- ' + set_type_id.to_s
	puts '-- ' + set_block_id.to_s
end


########################################################################
# Insert the card with the specified values into the database
#	database: the database connection to use
# RETURNS: the id of the created or found
########################################################################
def insert_card(db, card, set_id)
	card_name = card['name']
	card_power = card['power']
	card_toughness = card['toughness']
	card_loyalty = card['loyalty']
	card_cmc = card['cmc']
	
	# Grab the card_id that fits the data
	card_id = db.execute("SELECT Id FROM Card WHERE
		Name = ?",
		[card_name])[0]
	
	if (card_id.nil?)
		# Insert the data into the database
		db.execute("INSERT OR IGNORE INTO Card 
		(
			Name, 
			Power,
			Toughness,
			Loyalty,
			Cmc
		) 
		VALUES (?,?,?,?,?)", 
		[
			card_name,
			card_power,
			card_toughness,
			card_loyalty,
			card_cmc
		])
	end
	
	# Grab the card_id that fits the data
	card_id = db.execute("SELECT Id FROM Card WHERE
		Name = ?",
		[card_name])[0]
	
	
	puts card_name + ': ' + card_id.to_s
	
	# 
	card.each do |item|
		puts item
		
		## XXXXXXXXXXXXXXXXXXXXXXXXXX
		## Todo list 
		##
		## Create the RarityInfo
		##		Create/update the Rarity table
		## Create the ArtistInfo
		##		Create/update the artist table
		## Create the LegalityInfo
		##		Create/update the Legality table
		## Create the TypeInfo
		##		Create/update the Type table
		##		Create all linking tables
		## Create the SetInfo
		## Create the LayoutInfo 
		##		Create/update the Layout table
		## Create the ManaInfo
		##		Create/update the Color table
		##		Create all linking tables
		
		
	end
	
	return card_id
end


########################################################################
# Parse the json object and build the database
########################################################################
def Main(database, zip_name, json_filename)
	

	SQLite3::Database.new(database) do |db|
		json = get_json_object zip_name, json_filename
		
		# Iterate through each set
		json.each do |set|
			# Get the set info
			set_info_index = 1
			set_info = set[set_info_index]
		
			# Set the data 
			set_name = set_info['name'].to_s
			set_code = set_info['code'].to_s
			set_release_date = set_info['releaseDate'].to_s
			set_online_only = set_info['onlineOnly'].to_s
					
			# Set the ids or create them if they do not exist
			set_border_id = insert_value_into_database(db, 'Border', 'BorderType', set_info['border'])
			set_type_id = insert_value_into_database(db, 'SetType', 'SetType', set_info['type'])
			set_block_id = insert_value_into_database(db, 'Block', 'BlockName', set_info['block'])
			
			# Get the set id or insert it if it doesn't exist
			set_id = insert_set(db, set_name, set_code, set_release_date, set_online_only, set_border_id, set_type_id, set_block_id)
			
			# Go through and create each card		
			set_info['cards'].each do |card|
				# Get the card id
				card_id = insert_card(db, card, set_id)
				
				# XXXX 
				# Go through and create the NamesInfo
				
			end
		end
	end
end	
	
# Main program
#get_zipfile(all_sets_url, zip_name) # Don't need to run this every time
Main(database, zip_name, json_filename)