require 'sqlite3'

database = 'Mtg.db'

SQLite3::Database.new(database) do |db|
##########################
##### Primary Tables #####
##########################
	# Create the Card table
	db.execute("CREATE TABLE IF NOT EXISTS Card(
		Id INTEGER PRIMARY KEY ASC,
		Name TEXT NOT NULL,
		Power INTEGER,
		Toughness INTEGER,
		Loyalty INTEGER,
		Cmc INTEGER,
		
		CONSTRAINT Unique_Card
		UNIQUE (Name, Power, Toughness, Loyalty, Cmc)
	);
	")
	
	# Create the Layout table
	db.execute("CREATE TABLE IF NOT EXISTS Layout(
		Id INTEGER PRIMARY KEY ASC,
		LayoutType TEXT NOT NULL,
		CONSTRAINT Unique_Layout
		UNIQUE (LayoutType)
	);	
	")
	
	# Create the Color table
	db.execute("CREATE TABLE IF NOT EXISTS Color(
		Id INTEGER PRIMARY KEY ASC,
		ColorName TEXT NOT NULL,
		ColorSymbol TEXT NOT NULL,
		
		CONSTRAINT Unique_Color
		UNIQUE (ColorName, ColorSymbol)
	);	
	")
		
	# Create the SuperType table
	db.execute("CREATE TABLE IF NOT EXISTS SuperType(
		Id INTEGER PRIMARY KEY ASC,
		SuperType TEXT NOT NULL,
		
		CONSTRAINT Unique_SuperType
		UNIQUE (SuperType)
	);	
	")
		
	# Create the SubType table
	db.execute("CREATE TABLE IF NOT EXISTS SubType(
		Id INTEGER PRIMARY KEY ASC,
		SubType TEXT NOT NULL,
		
		CONSTRAINT Unique_SubType
		UNIQUE (SubType)
	);	
	")
	
	# Create the Type table
	db.execute("CREATE TABLE IF NOT EXISTS Type(
		Id INTEGER PRIMARY KEY ASC,
		Type TEXT NOT NULL,
		
		CONSTRAINT Unique_Type
		UNIQUE (Type)
	);	
	")
	
	# Create the Rarity table
	db.execute("CREATE TABLE IF NOT EXISTS Rarity(
		Id INTEGER PRIMARY KEY ASC,
		Rarity TEXT NOT NULL,
		
		CONSTRAINT Unique_Rarity
		UNIQUE (Rarity)
	);	
	")
	
	# Create the Artist table
	db.execute("CREATE TABLE IF NOT EXISTS Artist(
		Id INTEGER PRIMARY KEY ASC,
		ArtistName TEXT NOT NULL,
		
		CONSTRAINT Unique_Artist
		UNIQUE (ArtistName)
	);	
	")
		
	# Create the Format table
	db.execute("CREATE TABLE IF NOT EXISTS Format(
		Id INTEGER PRIMARY KEY ASC,
		FormatName TEXT NOT NULL,
		
		CONSTRAINT Unique_FormatName
		UNIQUE (FormatName)
	);	
	")
	
	# Create the Legality table
	db.execute("CREATE TABLE IF NOT EXISTS Legality(
		Id INTEGER PRIMARY KEY ASC,
		LegalityType TEXT NOT NULL,
		
		CONSTRAINT Unique_FormatName
		UNIQUE (LegalityType)
	);	
	")
		
	# Create the Border table
	db.execute("CREATE TABLE IF NOT EXISTS Border(
		Id INTEGER PRIMARY KEY ASC,
		BorderType TEXT NOT NULL,
		
		CONSTRAINT Unique_BorderType
		UNIQUE (BorderType)
	);	
	")
		
	# Create the SetType table
	db.execute("CREATE TABLE IF NOT EXISTS SetType(
		Id INTEGER PRIMARY KEY ASC,
		SetType TEXT NOT NULL,
		
		CONSTRAINT Unique_SetType
		UNIQUE (SetTYpe)
	);	
	")
	
	# Create the Block table
	db.execute("CREATE TABLE IF NOT EXISTS Block(
		Id INTEGER PRIMARY KEY ASC,
		BlockName TEXT NOT NULL,
		
		CONSTRAINT Unique_Block
		UNIQUE (BlockName)
	);	
	")
	
	# Create the Set table
	db.execute("CREATE TABLE IF NOT EXISTS MtgSet(
		Id INTEGER PRIMARY KEY ASC,
		Name TEXT NOT NULL,
		Code TEXT NOT NULL,
		ReleaseDate DATE NOT NULL,
		BorderId INTEGER,
		SetTypeId INTEGER,
		BlockId INTEGER NOT NULL,
		OnlineOnly BIT,
		
		FOREIGN KEY(BlockId) REFERENCES Block(Id),		
		
		CONSTRAINT Unique_MtgSetName UNIQUE (Name),
		CONSTRAINT Unique_MtgSetCode UNIQUE (Code)
	);	
	")
	
	
##########################
##### Linking Tables #####
##########################
	
		# Create the LayoutInfo table
	db.execute("CREATE TABLE IF NOT EXISTS LayoutInfo(
		Id INTEGER PRIMARY KEY ASC,
		CardId INTEGER NOT NULL,
		LayoutId INTEGER NOT NULL,
		SetId INTEGER NOT NULL,
				
		FOREIGN KEY(CardId) REFERENCES Card(Id),
		FOREIGN KEY(LayoutId) REFERENCES Layout(Id),
		FOREIGN KEY(SetId) REFERENCES MtgSet(Id),		
		
		CONSTRAINT Unique_LayoutInfo
		UNIQUE (CardId, LayoutId, SetId)
	);	
	")
			
	# Create the NamesInfo table
	db.execute("CREATE TABLE IF NOT EXISTS LayoutInfo(
		Id INTEGER PRIMARY KEY ASC,
		CardId INTEGER NOT NULL,
		SecondCardId INTEGER NOT NULL,
				
		FOREIGN KEY(CardId) REFERENCES Card(Id),
		FOREIGN KEY(SecondCardId) REFERENCES Card(Id),
				
		CONSTRAINT Unique_NamesInfo
		UNIQUE (CardId, SecondCardId)
	);	
	")
		
	# Create the SetInfo table
	db.execute("CREATE TABLE IF NOT EXISTS SetInfo(
		Id INTEGER PRIMARY KEY ASC,
		CardId INTEGER NOT NULL,
		SetId INTEGER NOT NULL,
		
		FOREIGN KEY(CardId) REFERENCES Card(Id),
		FOREIGN KEY(SetId) REFERENCES MtgSet(Id),		
		
		CONSTRAINT Unique_SetInfo
		UNIQUE (CardId, SetId)
	);	
	")
	
	# Create the LegalityInfo table
	db.execute("CREATE TABLE IF NOT EXISTS LegalityInfo(
		Id INTEGER PRIMARY KEY ASC,
		CardId INTEGER NOT NULL,
		FormatId INTEGER NOT NULL,
		LegalityId INTEGER NOT NULL,
		
		FOREIGN KEY(CardId) REFERENCES Card(Id),
		FOREIGN KEY(FormatId) REFERENCES Format(Id),		
		FOREIGN KEY(LegalityId) REFERENCES Legality(Id),		
		
		CONSTRAINT Unique_LegalityInfo
		UNIQUE (CardId, FormatId, LegalityId)
	);	
	")

	# Create the ArtistInfo table
	db.execute("CREATE TABLE IF NOT EXISTS ArtistInfo(
		Id INTEGER PRIMARY KEY ASC,
		CardId INTEGER NOT NULL,
		ArtistId INTEGER NOT NULL,
		SetId INTEGER NOT NULL,
		
		FOREIGN KEY(CardId) REFERENCES Card(Id),
		FOREIGN KEY(ArtistId) REFERENCES Artist(Id),		
		FOREIGN KEY(SetId) REFERENCES MtgSet(Id),		
		
		CONSTRAINT Unique_ArtistInfo
		UNIQUE (CardId, ArtistId, SetId)
	);	
	")

	# Create the RarityInfo table
	db.execute("CREATE TABLE IF NOT EXISTS RarityInfo(
		Id INTEGER PRIMARY KEY ASC,
		CardId INTEGER NOT NULL,
		RarityId INTEGER NOT NULL,
		SetId INTEGER NOT NULL,
		
		FOREIGN KEY(CardId) REFERENCES Card(Id),
		FOREIGN KEY(RarityId) REFERENCES Rarity(Id),		
		FOREIGN KEY(SetId) REFERENCES MtgSet(Id),		
		
		CONSTRAINT Unique_RarityInfo
		UNIQUE (CardId, RarityId, SetId)
	);	
	")
		
	# Create the ManaInfoCost table
	db.execute("CREATE TABLE IF NOT EXISTS ManaInfoCost(
		Id INTEGER PRIMARY KEY ASC,
		CardId INTEGER NOT NULL,
		ColorId INTEGER NOT NULL,
		
		FOREIGN KEY(CardId) REFERENCES Card(Id),
		FOREIGN KEY(ColorId) REFERENCES Color(Id)
	);	
	")
	
	# Create the ManaInfoColorIdentity table
	db.execute("CREATE TABLE IF NOT EXISTS ManaInfoColorIdentity(
		Id INTEGER PRIMARY KEY ASC,
		CardId INTEGER NOT NULL,
		ColorId INTEGER NOT NULL,
		
		FOREIGN KEY(CardId) REFERENCES Card(Id),
		FOREIGN KEY(ColorId) REFERENCES Color(Id)
		
		CONSTRAINT Unique_ManaInfoColorIdentity UNIQUE (CardId, ColorId)
	);	
	")
		
	# Create the TypeInfo table
	db.execute("CREATE TABLE IF NOT EXISTS TypeInfo(
		Id INTEGER PRIMARY KEY ASC,
		CardId INTEGER NOT NULL,
		SetId INTEGER NOT NULL,
		
		FOREIGN KEY(CardId) REFERENCES Card(Id),
		FOREIGN KEY(SetId) REFERENCES MtgSet(Id),
		
		CONSTRAINT Unique_TypeInfo UNIQUE (CardId, SetId)
	);	
	")

	# Create the TypeInfoSuperType table
	db.execute("CREATE TABLE IF NOT EXISTS TypeInfoSuperType(
		Id INTEGER PRIMARY KEY ASC,
		CardId INTEGER NOT NULL,
		TypeInfoId INTEGER NOT NULL,
		SuperTypeId INTEGER NOT NULL,
		
		FOREIGN KEY(CardId) REFERENCES Card(Id),
		FOREIGN KEY(TypeInfoId) REFERENCES TypeInfo(Id),
		FOREIGN KEY(SuperTypeId) REFERENCES SuperType(Id),
		
		CONSTRAINT Unique_TypeInfoSuperType UNIQUE (CardId, TypeInfoId, SuperTypeId)
	);	
	")
	
	# Create the TypeInfoSubType table
	db.execute("CREATE TABLE IF NOT EXISTS TypeInfoSubType(
		Id INTEGER PRIMARY KEY ASC,
		CardId INTEGER NOT NULL,
		TypeInfoId INTEGER NOT NULL,
		SubTypeId INTEGER NOT NULL,
		
		FOREIGN KEY(CardId) REFERENCES Card(Id),
		FOREIGN KEY(TypeInfoId) REFERENCES TypeInfo(Id),
		FOREIGN KEY(SubTypeId) REFERENCES SubType(Id),
		
		CONSTRAINT Unique_TypeInfoSubType UNIQUE (CardId, TypeInfoId, SubTypeId)
	);	
	")

	
	# Create the TypeInfoType table
	db.execute("CREATE TABLE IF NOT EXISTS TypeInfoType(
		Id INTEGER PRIMARY KEY ASC,
		CardId INTEGER NOT NULL,
		TypeInfoId INTEGER NOT NULL,
		TypeId INTEGER NOT NULL,
		
		FOREIGN KEY(CardId) REFERENCES Card(Id),
		FOREIGN KEY(TypeInfoId) REFERENCES TypeInfo(Id),
		FOREIGN KEY(TypeId) REFERENCES Type(Id),
		
		CONSTRAINT Unique_TypeInfoType UNIQUE (CardId, TypeInfoId, TypeId)
	);	
	")
end

