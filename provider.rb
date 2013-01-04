class Provider
  
  attr_accessor :base_url, :mangas

  def find_by_id(id)
    mangas.each do |manga|
      if manga.id == id
        return manga
      end
    end
  end

  def find_by_name(name)
    mangas.each do |manga|
      if manga.name == name
        return manga
      end
    end
  end
end