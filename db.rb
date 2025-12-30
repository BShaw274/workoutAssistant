require 'sequel'

DB = Sequel.sqlite(File.expand_path('../db/development.sqlite3', __FILE__))

# Create tables if they don't exist. Keep schemas minimal so you can extend.
unless DB.table_exists?(:users)
  DB.create_table :users do
    primary_key :id
    String :name
    String :email, unique: true
    DateTime :created_at
  end
end

unless DB.table_exists?(:workouts)
  DB.create_table :workouts do
    primary_key :id
    foreign_key :user_id, :users
    Date :date
    String :notes, text: true
    foreign_key :quality_id, :workout_qualities
    foreign_key :injury_id, :injury_reports
    DateTime :created_at
  end
end

unless DB.table_exists?(:exercises)
  DB.create_table :exercises do
    primary_key :id
    foreign_key :workout_id, :workouts
    String :name
    Integer :sets
    Integer :reps
    Float :weight
    String :notes, text: true
  end
end

unless DB.table_exists?(:injury_reports)
  DB.create_table :injury_reports do
    primary_key :id
    foreign_key :user_id, :users
    String :area
    Integer :severity # 0-10 scale, extendable
    String :notes, text: true
    DateTime :reported_at
  end
end

unless DB.table_exists?(:workout_qualities)
  DB.create_table :workout_qualities do
    primary_key :id
    String :label # e.g., "Great", "Okay", "Poor"
    Integer :score # e.g., 0-10
  end
end
