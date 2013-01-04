class Mangareader < Provider

  def initialize
    @base_url = 'http://www.mangareader.net'
    @alphabetical_url = 'http://www.mangareader.net/alphabetical'
  end

  def populate_series_list
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
        @mangas << Manga.new(series_name)
      end
    end
  end

  def chapters_list(manga)
    doc = Nokogiri::HTML(open(manga.home_page))
    
    doc.xpath("//table[@id='listing']/tr[position()>1]").each do |n|
      url = n.xpath("td[1]/a")[0]['href']

      #compare to old chapter naming
      match = @chapter_regex_1.match(url)
      if match
        chapters << {:series_id => match[1], :chapter_id => match[2], :chapter => match[4]}
      end

      #compare to new chapter naming
      match = @chapter_regex_2.match(url)
      if match
        chapters << {:chapter => match[1]}
      end
    end
  end

end