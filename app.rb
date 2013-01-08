require_relative 'mangareader'


mr = Mangareader.new

mr.populate_series_list


mr.populate_chapters_list("zippy-ziggy")


#mr.populate_manga_pages(1)
# mangareader.pages
#p '/1645/akiba-romance.html'.slice(/([\w+]|[-?]|[\w?])+/)
