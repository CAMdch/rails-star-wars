require "json"
require "open-uri"

puts "Cleaning database"
Movie.destroy_all
Character.destroy_all

# Creating all movies
url_movie = "https://swapi.dev/api/films"
movies_serialized = URI.open(url_movie).read
movies = JSON.parse(movies_serialized)

movies["results"].each do |movie|
  new_movie = Movie.create!(title: movie["title"])
  puts "Movie : #{new_movie.title} has been created"
  # Create character
  movie["characters"].each do |character|
    url_people = character
    character_serialized = URI.open(url_people).read
    character_info = JSON.parse(character_serialized)
    if character_info["mass"].to_i >= 75
      begin
        # Creation of characters that do not already exist in the db
        if Character.exists?(name: character_info["name"])
          # creating relation between movie and character
          old_character = Character.find_by("name = ?", character_info["name"])
          Team.create!(movie_id: new_movie.id, character_id: old_character.id)
          puts "New relation with old character"
        else
          # homeworld name
          url_homeworld = character_info["homeworld"]
          homeworld_serialized = URI.open(url_homeworld).read
          homeworld_info = JSON.parse(homeworld_serialized)
          new_character = Character.create!(mass: character_info["mass"].to_i, name: character_info["name"], homeworld: homeworld_info["name"] )
          puts "Character :#{new_character.name} has been created"
          # creating relation between movie and character
          Team.create!(movie_id: new_movie.id, character_id: new_character.id)
        end
      rescue OpenURI::HTTPError => e
        puts "Can't create new character"
      end
    end
  end
end
