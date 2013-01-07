require './provider'
require './manga'

class Mangareader < Provider

  attr_accessor :mangas, :chapters, :pages
  
  def initialize
    @base_url = 'http://www.mangareader.net'
    @alphabetical_url = 'http://www.mangareader.net/alphabetical'

    @old_series_url_regex = /\/(?<series_id>\d{1,3})\/(?<series_name>(\w+-?\w?)+)/
    @new_series_url_regex = /(?<series_name>(\w+-?\w?)+)/

    @chapter_regex_1 = /\/(?<series_id>\d+)-(?<chapter_id>\d+)-1\/(?<series>(\w+-?\w?)+)\/chapter-(?<chapter>\d+).html/
    @chapter_regex_2 = /\/(?<series>(\w+-?\w?)+)\/(?<chapter>\d+)/

    @PAGE_URL = "#{baseurl}/#{series_id}-#{chapter_id}-#{page}/#{series}/chapter-#{chapter}.html"
    @NEW_PAGE_URL = "#{baseurl}/#{series}/#{chapter}/#{page}"
  end

  def populate_series_list
    @mangas = Hash.new

    doc = Nokogiri::HTML(open('http://www.mangareader.net/alphabetical'))

    doc.css("ul.series_alpha a").each do |link|
      manga = Manga.new
      url = link['href']
      text = link.children.text

      manga = Manga.new
      match = @old_series_url_regex.match(url)
      if match
        manga.series_id   = match[:series_id]
        manga.series_name = match[:series_name]
      else
        match = @new_series_url_regex.match(url)
        if match 
          manga.series_name = match[:series_name]
        end
      end
      manga
      @mangas[text] = url
    end
  end

  def populate_chapters_list(manga_name)
    @chapters = Hash.new
    manga_url = @mangas[manga_name]
    
    doc = Nokogiri::HTML(open(@base_url + manga_url))
    
    doc.xpath("//table[@id='listing']/tr[position()>1]").each do |n|
      url = n.xpath("td[1]/a")[0]['href']
      p url
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
end


