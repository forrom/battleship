require "./lib/board"

describe 'place and sink ship' do 
    it "ship can be placed" do
      
        board = Board.new(10,10)
        carrier = Carrier.new()
        expect(carrier.placed?).to be false
        board.place(carrier, 2,3, :horizontal)
        expect(carrier.placed?).to be true
    end
    it "ship can be sunk" do
        board = Board.new(10,10)
        carrier = Carrier.new()
        board.place(carrier, 2,3, :horizontal)
        board.shoot(2,3)
        board.shoot(3,3)
        board.shoot(4,3)
        board.shoot(5,3)
        board.shoot(6,3)

        expect(carrier.sunk?).to be true
    end

    it "ship not sunk until all segments are hit" do
        board = Board.new(10,10)
        carrier = Carrier.new()
        board.place(carrier, 2,3, :horizontal)
        board.shoot(2,3)
        board.shoot(3,3)
        board.shoot(4,3)
        board.shoot(5,3)

        expect(carrier.sunk?).to be false
    end
    
    it "ship not sunk if only one segment hit" do
        board = Board.new(10,10)
        carrier = Carrier.new()
        board.place(carrier, 2,3, :horizontal)
        board.shoot(6,3)

        expect(carrier.sunk?).to be false
    end
    
    it "ship can be placed vertically then sunk" do
        board = Board.new(10,10)
        carrier = Carrier.new()
        board.place(carrier, 2,3, :vertical)
        board.shoot(2,3)
        board.shoot(2,4)
        board.shoot(2,5)
        board.shoot(2,6)
        expect(carrier.sunk?).to be false
        
        board.shoot(2,7)
        expect(carrier.sunk?).to be true
    end

    it "ships cannot overlap" do
        board = Board.new(10,10)
        board.place(Carrier.new(), 0,3, :horizontal)

        carrier_vertical = Carrier.new()
        board.place(carrier_vertical, 2,3, :vertical)
        expect(carrier_vertical.placed?).to be false
    end
    
    it "ships cannot overlap with second ship" do
        board = Board.new(10,10)
        
        board.place(Carrier.new(), 0, 0, :horizontal)
        board.place(Carrier.new(), 0, 3, :horizontal)
        
        carrier3 = Carrier.new()
        board.place(carrier3, 2, 3, :vertical)
        expect(carrier3.placed?).to be false
    end

    it "second ship can be sunk" do
        board = Board.new(10,10)
        board.place(Carrier.new(), 0, 0, :horizontal)

        carrier2 = Carrier.new()
        board.place(carrier2, 0, 3, :horizontal)

        board.shoot(0,3)
        board.shoot(1,3)
        board.shoot(2,3)
        board.shoot(3,3)
        expect(carrier2.sunk?).to be false
        
        board.shoot(4,3)
        expect(carrier2.sunk?).to be true
    end

    it "ship cannot be placed if segment is outside board horizontally" do
        board = Board.new(10,10)
        carrier = Carrier.new()
        board.place(carrier, 6, 0, :horizontal)

        expect(carrier.placed?).to be false
    end

    it "ship cannot be placed if segment is outside board vertically" do
        board = Board.new(10,10)
        carrier = Carrier.new()
        board.place(carrier, 0, 6, :vertical)

        expect(carrier.placed?).to be false
    end

    it "ship cannot have negative coordinates" do
        board = Board.new(10,10)
        carrier = Carrier.new()
        board.place(carrier, -1, 3, :vertical)

        expect(carrier.placed?).to be false
    end

    it "ship can be placed next to destroyer" do
        board = Board.new(10,10)

        destroyer = Destroyer.new()
        board.place(destroyer, 0, 0, :horizontal)
        expect(destroyer.placed?).to be true

        sub = Submarine.new()
        board.place(sub, 2, 0, :horizontal)
        expect(sub.placed?).to be true
    end

    it "ship cannot be placed on destroyer" do
        board = Board.new(10,10)

        destroyer = Destroyer.new()
        board.place(destroyer, 0, 0, :horizontal)
        expect(destroyer.placed?).to be true

        sub = Submarine.new()
        board.place(sub, 1, 0, :horizontal)
        expect(sub.placed?).to be false

    end
end

describe "board has ships remaining?" do
    it "no ships remaining if all sunk" do
        board = Board.new(10,10)
        board.place(Submarine.new(), 0,0, :horizontal)
        board.place(Destroyer.new(), 0,1, :horizontal)

        board.shoot(0,0)
        board.shoot(1,0)
        board.shoot(2,0)
        board.shoot(0,1)
        board.shoot(1,1)

        expect(board.ships_remain?).to be false
    end

    it "ships remaining if one out of two sunk" do
        board = Board.new(10,10)
        board.place(Submarine.new(), 0,0, :horizontal)
        board.place(Destroyer.new(), 0,1, :horizontal)

        board.shoot(0,0)
        board.shoot(1,0)
        board.shoot(2,0)
        board.shoot(0,1)

        expect(board.ships_remain?).to be true
    end

    it "ships remaining if none sunk" do
        
        board = Board.new(10,10)
        board.place(Submarine.new(), 0,0, :horizontal)
        board.place(Destroyer.new(), 0,1, :horizontal)

        board.shoot(1,0)
        board.shoot(2,0)
        board.shoot(0,1)

        expect(board.ships_remain?).to be true
    end
end

describe "board drawing" do
    it "drawing 4x3 empty board" do
        board = Board.new(4,3)

        expected_board = <<~EOS
            -----------
            | ~ ~ ~ ~ |
            | ~ ~ ~ ~ |
            | ~ ~ ~ ~ |
            -----------
        EOS

        expect(board.draw).to eq expected_board
    end

    
    it "drawing 2x1 empty board" do
        board = Board.new(2,1)

        expected_board = <<~EOS
            -------
            | ~ ~ |
            -------
        EOS

        expect(board.draw).to eq expected_board
    end
    
    it "drawing 4x3 board with sub and destroyer" do
        board = Board.new(4,3)
        board.place(Submarine.new(), 1,1, :horizontal)
        board.place(Destroyer.new(), 0,1, :vertical)

        expected_board = <<~EOS
            -----------
            | ~ ~ ~ ~ |
            | D S S S |
            | D ~ ~ ~ |
            -----------
        EOS
        
        expect(board.draw).to eq expected_board
    end
        
    it "drawing 4x3 board with sub and hit destroyer" do
        board = Board.new(4,3)
        board.place(Submarine.new(), 1,1, :horizontal)
        board.place(Destroyer.new(), 0,1, :vertical)
        board.shoot(0,2)

        expected_board = <<~EOS
            -----------
            | ~ ~ ~ ~ |
            | D S S S |
            | # ~ ~ ~ |
            -----------
        EOS
        
        expect(board.draw).to eq expected_board
    end

    it "drawing 4x3 board with hit sub and hit destroyer" do
        board = Board.new(4,3)
        board.place(Submarine.new(), 1,1, :horizontal)
        board.place(Destroyer.new(), 0,1, :vertical)
        
        board.shoot(0,2)
        board.shoot(2,1)

        expected_board = <<~EOS
            -----------
            | ~ ~ ~ ~ |
            | D S # S |
            | # ~ ~ ~ |
            -----------
        EOS
        
        expect(board.draw).to eq expected_board
    end

    
    it "drawing 4x3 board with miss in water" do
        board = Board.new(4,3)
        
        board.shoot(0,2)

        expected_board = <<~EOS
            -----------
            | ~ ~ ~ ~ |
            | ~ ~ ~ ~ |
            | - ~ ~ ~ |
            -----------
        EOS
        
        expect(board.draw).to eq expected_board
    end
end