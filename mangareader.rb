require './provider'
require './manga'

class Mangareader < Provider

  attr_accessor :mangas, :chapters, :pages
  
  BASE_URL = 'http://www.mangareader.net'
  ALPHABETICAL_URL = 'http://www.mangareader.net/alphabetical'

  def initialize
    @old_series_url_regex = /\/(?<series_id>\d{1,3})\/(?<series_name>(\w+-?\w?)+)/
    @new_series_url_regex = /(?<series_name>(\w+-?\w?)+)/

    @chapter_regex_1 = /\/(?<series_id>\d+)-(?<chapter_id>\d+)-1\/(?<series>(\w+-?\w?)+)\/chapter-(?<chapter>\d+).html/
    @chapter_regex_2 = /\/(?<series>(\w+-?\w?)+)\/(?<chapter>\d+)/
  end

  def populate_series_list
    @mangas = Hash.new

    doc = Nokogiri::HTML(open(ALPHABETICAL_URL))

    doc.css("ul.series_alpha a").each do |link|
      manga = Manga.new
      url = link['href']

      match = @old_series_url_regex.match(url)

      if match
        manga.id   = match[:series_id]
        manga.name = match[:series_name]
      else
        match = @new_series_url_regex.match(url)
        if match 
          manga.name = match[:series_name]
        end
      end
      mangas[manga.name] = manga
    end
  end

  def populate_chapters_list(manga_name)
    @chapters = Hash.new
    manga_url = @mangas[manga_name]
    
    doc = Nokogiri::HTML(open(BASE_URL + manga_url))
    
    doc.xpath("//table[@id='listing']/tr[position()>1]").each do |n|
      url = n.xpath("td[1]/a")[0]['href']

      #compare to old chapter naming
      match = @chapter_regex_1.match(url)
      if match
        chapter = Chapter.new

        chapter.series_id = match[:series_id]
        chapter.id = match[:chapter_id]
        chapter.series = match[:series]
        chapter.number = match[:chapter]
        @chapters[match[4].to_i] = url
      end

      #compare to new chapter naming
      match = @chapter_regex_2.match(url)
      if match
        @chapters[match[1].to_i] = url
      end
      
    end
  end

  def list_mangas
    @mangas.each_key
  end

  def list_chapters
    @chapters.each_key
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
      "#{baseurl}/#{manga.id}/#{manga.name}.html"
    else
      "#{baseurl}/#{manga.name}"
    end
  end

  def get_page_url(page)
    if page.chapter.id
      "#{baseurl}/#{manga.id}-#{chapter.id}-#{page}/#{manga.name}/chapter-#{chapter.id}.html"
    else
      "#{baseurl}/#{manga.id}/#{chapter.id}/#{page}"
    end
  end

end


