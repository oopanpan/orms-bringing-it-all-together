class Dog

    def self.create_table
        sql = "CREATE TABLE IF NOT EXISTS dogs(id INTEGER PRIMARY KEY, name TEXT, breed TEXT);"
        DB[:conn].execute(sql)
    end

    def self.drop_table
        sql = "DROP TABLE dogs"
        DB[:conn].execute(sql)
    end

    def self.create(name:, breed:)
        dog = self.new(name: name, breed: breed)
        dog.save
    end

    def self.new_from_db(row)
        self.new(id:row[0],name:row[1],breed:row[2])
    end

    def self.find_by_id(id)
        sql = "SELECT * FROM dogs WHERE id = ?"
        row = DB[:conn].execute(sql, id).first
        self.new_from_db(row)
    end

    def self.find_or_create_by(name:,breed:)
        dog = self.find_by_name(name)
        if dog && dog.breed == breed
            dog
        else
            self.create(name:name, breed:breed)
        end

    end

    def self.find_by_name(name)
        sql = "SELECT * FROM dogs WHERE name = ?"
        row = DB[:conn].execute(sql, name).first
        self.new_from_db(row)
    end

    attr_accessor :id, :name, :breed

    def initialize(id: nil, name:, breed:)
        @id = id
        @name = name
        @breed = breed
    end

    def insert
        sql = "INSERT INTO dogs (name, breed) VALUES (?,?)"
        DB[:conn].execute(sql, self.name, self.breed)
    end
    
    def update
        sql = "UPDATE dogs SET name = ? WHERE id = ?"
        DB[:conn].execute(sql,self.name, self.id)
    end

    def save
        if self.id == nil
            self.insert
            self.id = DB[:conn].execute("SELECT * FROM dogs ORDER BY id DESC LIMIT 1")[0][0]
            self
        else
            self.update
            self
        end
    end


end