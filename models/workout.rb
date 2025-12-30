require_relative '../db'
require 'sequel'

class Workout < Sequel::Model
  many_to_one :user
  many_to_one :workout_quality, key: :quality_id
  many_to_one :injury_report, key: :injury_id
  one_to_many :exercises

  # Basic placeholder methods to extend
  def summary
    {
      id: id,
      user_id: user_id,
      date: date,
      notes: notes,
      quality: workout_quality ? workout_quality.values : nil,
      injury: injury_report ? injury_report.values : nil,
      exercises: exercises.map(&:values)
    }
  end
end
