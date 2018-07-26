
class Ship
    class << self
      attr_accessor :symbol
    end
    def self.length
        @length
    end

    def segments
        @segments
    end

    def initialize ()
        @segments = []
        @hits = []
        @placed = false
    end

    def plan_segments(x, y, orientation)
        segments = []
        self.class.length.times do
            segments << [x,y]
            case orientation
            when :horizontal 
                x = x + 1
            when :vertical 
                y = y + 1
            end
        end
        segments
    end

    def place (x, y, orientation)
        @segments = plan_segments(x, y, orientation)
        @placed = true
    end

    def placed?
        @placed
    end

    def sunk?
        (@segments - @hits).empty?
    end

    def hit(x,y)
        @hits << [x,y]
    end

    def symbol(x,y)
        if @hits.include? [x,y]
            '#'
        else 
            self.class.symbol 
        end
    end

end