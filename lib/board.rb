require "./lib/ship"
require "./lib/ships"


class Board
    def initialize(width, height)
        @ships = []
        @width = width;
        @height = height
        @misses = []
    end

    def place(ship, x, y, orientation)
        planned_location = ship.plan_segments(x, y, orientation)
        return if planned_location.any? do |location|
            location [0] < 0 ||
            location[1] < 0 ||
            @width <= location[0] ||
            @height <= location[1]
        end

        taken_locations = []
        @ships.each do |placed_ship|
            taken_locations += placed_ship.segments
        end

        unless (planned_location & taken_locations).empty? then
            return
        end
        
        @ships << ship
        ship.place x, y, orientation
    end

    def shoot(x,y)
        if ship = ship_at(x,y) then 
            ship.hit(x,y)
        else 
            @misses << [x,y]
        end
    end

    def ship_at(x,y)
        @ships.find {|ship| ship.segments.include? [x,y]}
    end

    def ships_remain?
        not @ships.all? {|ship| ship.sunk?}
    end

    def draw
        drawn = horizontal_border(@width)
        @height.times do |y|
            drawn << "|"
            @width.times do |x|
                if ship = ship_at(x,y) then
                    block_content = ship.symbol(x,y)
                elsif @misses.include? [x,y]
                    block_content = '-'
                else
                    block_content = '~'
                end
                drawn << " #{block_content}"
            end
            drawn << " |\n"
        end
        drawn << horizontal_border(@width)
    end

    def horizontal_border(width)
        "-"*(@width * 2 + 3)  + "\n"
    end
end



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