require 'sinatra'
require 'sinatra/reloader'
require 'better_errors'
require 'pry' # allows binding.pry  to give you breakpoints in code
require 'pg'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
end

set :conn, PG.connect(dbname: 'squads')
before do
  @conn = settings.conn
end

# root route
get '/' do
  redirect to '/squads'
end

# this route should take the user to a page that shows all of the squads
get '/squads' do
  squads = []
  @conn.exec("SELECT * FROM squads") do |result|
      result.each do |author|
        squads << author
      end
  end
  p "___________________________________________________________"
  p "                     SQUADS                                "
  p squads
  p "                                                           "
  p "___________________________________________________________"
  @squads = squads
  erb :index
end

# this route should take the user to a page with a form that allows them to create a new squad
get '/squads/new' do
  erb :new
end

# this route should take the user to a page that shows information about a single squad
get '/squads/:squad_id' do
  erb :show
end

# this route should take the user to a page with a form that allows them to edit an existing squad
get '/squads/:squad_id/edit' do
  erb :edit
end

# this route should take the user to a page that shows all of the students for an individual squad
get '/squads/:squad_id/students' do
  redirect to '/squads'
end

# this route should take the user to a page that shows information about an individual student in a squad
get '/squads/:squad_id/students/:student_id' do
  redirect to '/squads/:id'
end

# this route should take the user to a page that shows them a form to create a new student
get '/squads/:squad_id/students/new' do
  redirect to '/squads/:id'
end

# this route should take the user to a page that shows them a form to edit a student's information
get '/squads/:squad_id/students/:student_id/edit' do
  #-
end

# this route should be used for creating a new squad
post '/squads' do
  #logic to add squad

  redirect to '/squads'
end

# this route should be used for creating a new student in an existing squad
post '/squads/:squad_id/students' do
  #logic to add a student that's in a squad

  redirect to '/squads'
end

# this route should be used for editing an existing squad
put '/squads/:squad_id' do

end

# this route should be used for editing an existing student in a squad
put '/squads/:squad_id/students' do 
end

# this route should be used for deleting an existing squad
delete '/squads/:squad_id' do
  id = params[:id].to_i
  @conn.exec("DELETE FROM squads WHERE id=$1", [id])
  redirect to '/squads'
end

# this route should be used for editing an existing student in a squad
delete '/squads/:squad_id/students/:student_id' do
end

### Bonus

#1. Style your application!
#2. Add a column to the students table called `is_squad_leader`, which is a `boolean`. When you list out the students in a squad, their name should be bolded.
#2. Use your knowledge of JavaScript and AJAX to make the page more dynamic.
