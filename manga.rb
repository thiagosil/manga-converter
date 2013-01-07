class Manga
  
  attr_accessor :id, :name, :chapters



  def get_human_name
    name.gsub(/-/," ")
  end
end