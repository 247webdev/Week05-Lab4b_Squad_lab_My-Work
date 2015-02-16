require 'sinatra'
require 'sinatra/reloader'
require 'better_errors'
require 'pry'
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

# GET ROUTES
# This takes the user to a page that shows all of the squads
get '/squads' do
  squads = []
  @conn.exec("SELECT * FROM squads ORDER BY squad_id ASC") do |result|
      result.each do |author|
        squads << author
      end
  end
  @squads = squads
  p @squads.count
  erb :index
end

# This takes the user to a page with a form that allows them to create a new squad
get '/squads/new' do
  erb :new
end

# This takes the user to a page that shows information about a single squad
get '/squads/:squad_id' do
  squad_id = params[:squad_id].to_i
  squad = @conn.exec("SELECT * FROM squads WHERE squad_id=$1", [squad_id])
  @squad = squad[0]
  erb :show
end

# This takes the user to a page with a form that allows them to edit an existing squad
get '/squads/:squad_id/edit' do
  squad_id = params[:squad_id].to_i
  squad = @conn.exec("SELECT * FROM squads WHERE squad_id=$1", [squad_id])
  @squad = squad[0]

  students = []
  @conn.exec("SELECT * FROM students WHERE squad_id=$1", [squad_id]) do |result|
      result.each do |student|
        students << student
      end
  end
  @students = students

  erb :edit
end

# This takes the user to a page that shows all of the students for an individual squad
get '/squads/:squad_id/students' do
  redirect to '/squads'
end

# This takes the user to a page that shows information about an individual student in a squad
get '/squads/:squad_id/students/:student_id' do
  redirect to '/squads/:id'
end

# This takes the user to a page that shows them a form to create a new student
get '/squads/:squad_id/students/new' do
  redirect to '/squads/:id'
end

# This takes the user to a page that shows them a form to edit a student's information
get '/squads/:squad_id/students/:student_id/edit' do
  #-
end

# POST ROUTES
# This creates a new squad
post '/squads' do
  @conn.exec("INSERT INTO squads (name,mascot) VALUES ($1,$2)", [params[:name],params[:mascot]] )

  redirect to '/squads'
end

# This creates a new student in an existing squad
post '/squads/:squad_id/students' do
  #logic to add a student that's in a squad

  redirect to '/squads'
end

# PUT ROUTES
# this route should be used for editing an existing squad
put '/squads/:squad_id' do

end

# this route should be used for editing an existing student in a squad
put '/squads/:squad_id/students' do 
end

# DELETE ROUTES
# this route should be used for deleting an existing squad
delete '/squads/:squad_id' do
  id = params[:squad_id].to_i
  @conn.exec("DELETE FROM squads WHERE squad_id=$1", [id])
  redirect to '/squads'
end

# this route should be used for editing an existing student in a squad
delete '/squads/:squad_id/students/:student_id' do
end

# THIS ROUTE IS FOR DEMO PURPOSES ONLY
# This adds a pre-set Squad list for a quick re-population
# I know this normally would be defined as a post route by the link to this route is an <a>. Doing this way for convenience.
get '/repopulate_squads' do
  @conn.exec("INSERT INTO squads (name,mascot) VALUES ('TEST-Best Name Ever','My Little Pony')")
  @conn.exec("INSERT INTO squads (name,mascot) VALUES ('TEST-Bad Ass','Three toed sloth')")
  @conn.exec("INSERT INTO squads (name,mascot) VALUES ('TEST-Party of 5','Horny Toad')")
  redirect to '/squads'
end

# This adds a pre-set Student list for a quick re-population
# I know this normally would be defined as a post route by the link to this route is an <a>. Doing this way for convenience.
get '/repopulate_students' do
  @conn.exec("INSERT INTO students (squad_id,name,age,spirit_animal,is_squad_leader) VALUES (2,'TEST-Bob DropTable',99,'Flamingo',false)")
  @conn.exec("INSERT INTO students (squad_id,name,age,spirit_animal,is_squad_leader) VALUES (3,'TEST-SueSelectAll',88,'DragonFly',false)")
  @conn.exec("INSERT INTO students (squad_id,name,age,spirit_animal,is_squad_leader) VALUES (4,'TEST-IanInsert',77,'Dung Beatle',false)")
  redirect to '/squads'
end

### Bonus

#1. Style your application!
#2. Add a column to the students table called `is_squad_leader`, which is a `boolean`. When you list out the students in a squad, their name should be bolded.
#2. Use your knowledge of JavaScript and AJAX to make the page more dynamic.

# # Debugging output to terminal
#   p "___________________________________________________________"
#   p "                     SQUADS                                "
#   p squads
#   p "                                                           "
#   p "___________________________________________________________"
# # END debugging

# # Debugging output to terminal
#   p "___________________________________________________________"
#   p "                     squad                                "
#   p @squad
#   p "                     students                                "
#   p @students
#   p "                                                           "
#   p "___________________________________________________________"
# # END debugging

#   binding.pry


