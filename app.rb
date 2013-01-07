require_relative 'mangareader'


mangareader = Mangareader.new

mangareader.populate_series_list

mangareader.populate_chapters_list("Zippy Ziggy")


mangareader.populate_manga_pages(1)
# mangareader.pages
#p '/1645/akiba-romance.html'.slice(/([\w+]|[-?]|[\w?])+/)
