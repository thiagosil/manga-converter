require 'sinatra'
require 'haml'
require_relative 'mangareader'

#moofle

set :haml, :format => :html5

get '/' do
  manga_list
  haml :select_manga
end

get '/mangas/:manga_name' do
  @mr = Mangareader.new
  @mangas = @mr.list_mangas
  @chapters = @mr.list_chapters(params[:manga_name])
  haml :select_chapters
end

get '/main' do
  haml :index
end

private

def manga_list
  @mr = Mangareader.new
  @mangas = @mr.list_mangas
end