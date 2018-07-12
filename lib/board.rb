class Board
    def initialize(width, height)
        @ships = []
    end

    def place(ship, x, y, orientation)
        @ships << ship
        ship.place x, y, orientation
    end

    def shoot(x,y)
        @ships[0].hit(x,y)
    end

end

class Battleship
    Length = 3

    def initialize ()
        @intact_segments = []
    end

    def place (x, y, orientation)
        5.times do
            @intact_segments << [x,y]
            x = x + 1
        end
    end

    def sunk?
        @intact_segments.empty?
    end

    def hit(x,y)
        @intact_segments.delete [x,y]
    end
end