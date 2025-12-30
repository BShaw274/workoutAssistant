require_relative '../db'
require 'sequel'

class InjuryReport < Sequel::Model(:injury_reports)
  many_to_one :user

  # severity is an integer; user can interpret scale
end
