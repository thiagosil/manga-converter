class Mangareader < Provider

  def initialize
    @base_url = 'http://www.mangareader.net'
    @alphabetical_url = 'http://www.mangareader.net/alphabetical'
  end

  def populate_series_list(doc)
    @mangas = Array.new

    doc = Nokogiri::HTML(open('http://www.mangareader.net/alphabetical'))

    doc.css("ul.series_alpha a").each do |link|
      if match = @old_series_url_regex.match(url)
        series_id = match[2]
        series_name = match[3]
        @mangas << Manga.new(series_id, series_name)
      end

      if match = @new_series_url_regex.match(url)
        series_name = match[2]
        @mangas< Manga.new(series_name)
      end
    end
  end

end