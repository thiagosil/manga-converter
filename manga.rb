class Manga
  
  attr_accessor :id, :name, :chapters

  def initialize(data)
    @id = data[:id]
    @name = data[:name]
  end

end