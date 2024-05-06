module NbaStats
  class Player

  attr_accessor :name, :position

    # @param [String] name
    # @param [String] position
    def initialize(name, position: nil)

      @name = name
      @position = position
    end


  end
end