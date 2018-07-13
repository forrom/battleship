class Board
    def initialize(width, height)
        @ships = []
    end

    def place(ship, x, y, orientation)
        planned_location = ship.plan_segments(x, y, orientation)
        taken_locations = []
        @ships.each do |placed_ship|
            taken_locations += placed_ship.initial_segments
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
        end
    end

    def ship_at(x,y)
        @ships.find {|ship| ship.initial_segments.include? [x,y]}
    end
end

class Battleship
    Length = 5 
    
    def initial_segments
        @initial_segments
    end

    def initialize ()
        @initial_segments = []
        @hit_segments = []
        @placed = false
    end

    def plan_segments(x, y, orientation)
        segments = []
        Length.times do
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
        @initial_segments = plan_segments(x, y, orientation)
        @placed = true
    end

    def placed?
        @placed
    end

    def sunk?
        (@initial_segments - @hit_segments).empty?
    end

    def hit(x,y)
        @hit_segments << [x,y]
    end
end