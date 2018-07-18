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
end