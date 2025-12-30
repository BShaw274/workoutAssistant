require_relative '../db'
require 'sequel'

class Exercise < Sequel::Model
  many_to_one :workout

  # Expand with helpers for volume, intensity, etc.
  def volume
    (sets || 0) * (reps || 0) * (weight || 0.0)
  end
end
