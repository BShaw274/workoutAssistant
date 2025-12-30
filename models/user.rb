require_relative '../db'
require 'sequel'

class User < Sequel::Model
  one_to_many :workouts
  one_to_many :injury_reports
end
