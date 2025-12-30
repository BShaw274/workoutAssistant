require 'sinatra'
require 'json'
require_relative 'db'
require_relative 'models'

# Serve static frontend files from ./public
set :public_folder, File.expand_path('public', __dir__)

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

before do
  content_type :json
end

get '/health' do
  {status: 'ok'}.to_json
end

# Users
post '/users' do
  payload = JSON.parse(request.body.read)
  user = User.create(name: payload['name'], email: payload['email'], created_at: Time.now)
  status 201
  user.values.to_json
end

get '/users/:id' do
  user = User[params[:id]]
  halt 404,({error: 'user not found'}.to_json) unless user
  user.values.merge({workouts: user.workouts.map(&:id)}).to_json
end

# Workouts
post '/workouts' do
  payload = JSON.parse(request.body.read)
  workout = Workout.create(
    user_id: payload['user_id'],
    date: payload['date'],
    notes: payload['notes'],
    quality_id: payload['quality_id'],
    injury_id: payload['injury_id'],
    created_at: Time.now
  )

  if payload['exercises'] && payload['exercises'].is_a?(Array)
    payload['exercises'].each do |ex|
      workout.add_exercise(name: ex['name'], sets: ex['sets'], reps: ex['reps'], weight: ex['weight'], notes: ex['notes'])
    end
  end

  status 201
  workout.summary.to_json
end

get '/workouts' do
  Workout.all.map(&:summary).to_json
end

get '/workouts/:id' do
  w = Workout[params[:id]]
  halt 404,({error: 'workout not found'}.to_json) unless w
  w.summary.to_json
end

# Exercises (standalone create if needed)
post '/exercises' do
  payload = JSON.parse(request.body.read)
  ex = Exercise.create(
    workout_id: payload['workout_id'],
    name: payload['name'],
    sets: payload['sets'],
    reps: payload['reps'],
    weight: payload['weight'],
    notes: payload['notes']
  )
  status 201
  ex.values.to_json
end

# Injury reports
post '/injuries' do
  payload = JSON.parse(request.body.read)
  ir = InjuryReport.create(
    user_id: payload['user_id'],
    area: payload['area'],
    severity: payload['severity'],
    notes: payload['notes'],
    reported_at: Time.now
  )
  status 201
  ir.values.to_json
end

# Workout quality options
post '/qualities' do
  payload = JSON.parse(request.body.read)
  q = WorkoutQuality.create(label: payload['label'], score: payload['score'])
  status 201
  q.values.to_json
end
