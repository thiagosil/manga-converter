require './provider'
require './manga'
require './chapter'

class Mangareader < Provider

  attr_accessor :mangas, :chapters, :pages
  
  

  def initialize
    @BASE_URL = 'http://www.mangareader.net'
    @ALPHABETICAL_URL = 'http://www.mangareader.net/alphabetical'

    @old_series_url_regex = /\/(?<series_id>\d+)\/(?<series_name>(\w+-?\w?)+)/
    @new_series_url_regex = /(?<series_name>(\w+-?\w?)+)/

    @chapter_regex_1 = /\/(?<series_id>\d+)-(?<chapter_id>\d+)-1\/(?<series>(\w+-?\w?)+)\/chapter-(?<chapter>\d+).html/
    @chapter_regex_2 = /\/(?<series>(\w+-?\w?)+)\/(?<chapter>\d+)/
  end

  def populate_series_list
    @mangas = Hash.new

    doc = Nokogiri::HTML(open(@ALPHABETICAL_URL))

    doc.css("ul.series_alpha a").each do |link|
      manga = Manga.new
      url = link['href']

      match = @old_series_url_regex.match(url)

      if match
        manga.id   = match[:series_id].to_i
        manga.name = match[:series_name]
      else
        match = @new_series_url_regex.match(url)
        if match 
          manga.name = match[:series_name]
        end
      end
      @mangas[manga.name] = manga
    end
  end

  def populate_chapters_list(manga_name)
    @chapters = Hash.new
    
    manga = @mangas[manga_name]
    manga_url = get_series_url(@mangas[manga_name])

    doc = Nokogiri::HTML(open(manga_url))
    
    doc.xpath("//table[@id='listing']/tr[position()>1]").each do |n|
      url = n.xpath("td[1]/a")[0]['href']
      chapter = Chapter.new
      #compare to old chapter naming
      match = @chapter_regex_1.match(url)
      if match
        
        chapter.id = match[:chapter_id].to_i
        chapter.number = match[:chapter].to_i
      end

      #compare to new chapter naming
      match = @chapter_regex_2.match(url)
      if match
        chapter.number = match[:chapter].to_i
      end
      @chapters[chapter.number] = chapter
    end
  end

  def list_mangas
    if @mangas
      @mangas.values
    else
      populate_series_list
      @mangas.values
    end
  end

  def list_chapters(manga_name)
    if @chapters
      @chapters.values
    else
      populate_chapters_list(manga_name)
      @chapters.values
    end
  end

  def populate_manga_pages(chapter_number)
    @pages = Array.new
    chapter_url = @chapters[chapter_number] 

    if @chapter_regex_1.match(chapter_url)
      @old_style_url = true
    else
      @old_style_url = false
    end

    doc = Nokogiri::HTML(open(@base_url + chapter_url))
    doc.xpath("//select[@id='pageMenu']/option").each do |page|
      @pages << page.text.to_i
    end
  end

  def download_chapter(chapter)
  end

  private

  def get_series_url(manga)
    if manga.id
      "#{@BASE_URL}/#{manga.id}/#{manga.name}.html"
    else
      "#{@BASE_URL}/#{manga.name}"
    end
  end

  def get_page_url(page)
    if page.chapter.id
      "#{@BASE_URL}/#{manga.id}-#{chapter.id}-#{page}/#{manga.name}/chapter-#{chapter.id}.html"
    else
      "#{@BASE_URL}/#{manga.id}/#{chapter.id}/#{page}"
    end
  end

end


