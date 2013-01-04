class Manga
  
  attr_accessor :id, :name, :chapters

  def initialize(name)
    @name = name
  end

  def initialize(id, name)
    @id = id
    @name = name
  end

end