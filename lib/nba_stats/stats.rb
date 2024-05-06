module NbaStats

  # @param [String] path
  def headers(path)
    File.open(path, 'r') do |f|
      begin
        f.readline.split(';')
      rescue
        raise Error("Can't load header from the data!")
      end
    end
  end


  def names(path, headers)
    players_name = []
    File.open(path, 'r') do |f|
      f.readline
      position_index = headers.index('Player')
      until f.eof?
        players_name << f.readline.split(';')[position_index]
      end
    end
    players_name.uniq
  end

  # @param [String] name
  # @param [String] path
  def stats(name, path, headers, autocorrect: false)
    return strict_load(name, path, headers) unless autocorrect
    names = names(path, headers)
    return strict_load(name, path, headers) if names.include? name

    spell_checker = DidYouMean::SpellChecker.new(dictionary: names)
    variants = spell_checker.correct(name)
    return strict_load(variants[0], path, headers)  if variants&.any?
    nil
  end

  private
  def strict_load(name, path, headers)
    File.open(path, 'r') do |f|
      until f.eof?
        line = f.readline
        if line.include? name
          position_index = headers.index('Pos')
          parts = line.split(";")
          return Player.new(name, position: parts[position_index])
        end
      end
    end
    nil
  end
end