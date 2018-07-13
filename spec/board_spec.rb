require "./lib/board"

describe 'place and sink ship' do 
    it "ship can be placed" do
      
        board = Board.new(10,10)
        battleship = Battleship.new()
        expect(battleship.placed?).to be false
        board.place(battleship, 2,3, :horizontal)
        expect(battleship.placed?).to be true
    end
    it "ship can be sunk" do
        board = Board.new(10,10)
        battleship = Battleship.new()
        board.place(battleship, 2,3, :horizontal)
        board.shoot(2,3)
        board.shoot(3,3)
        board.shoot(4,3)
        board.shoot(5,3)
        board.shoot(6,3)

        expect(battleship.sunk?).to be true
    end

    it "ship not sunk until all segments are hit" do
        board = Board.new(10,10)
        battleship = Battleship.new()
        board.place(battleship, 2,3, :horizontal)
        board.shoot(2,3)
        board.shoot(3,3)
        board.shoot(4,3)
        board.shoot(5,3)

        expect(battleship.sunk?).to be false
    end
    
    it "ship not sunk if only one segment hit" do
        board = Board.new(10,10)
        battleship = Battleship.new()
        board.place(battleship, 2,3, :horizontal)
        board.shoot(6,3)

        expect(battleship.sunk?).to be false
    end
    
    it "ship can be placed vertically then sunk" do
        board = Board.new(10,10)
        battleship = Battleship.new()
        board.place(battleship, 2,3, :vertical)
        board.shoot(2,3)
        board.shoot(2,4)
        board.shoot(2,5)
        board.shoot(2,6)
        expect(battleship.sunk?).to be false
        
        board.shoot(2,7)
        expect(battleship.sunk?).to be true
    end

    it "ships cannot overlap" do
        board = Board.new(10,10)
        board.place(Battleship.new(), 0,3, :horizontal)

        battleship_vertical = Battleship.new()
        board.place(battleship_vertical, 2,3, :vertical)
        expect(battleship_vertical.placed?).to be false
    end
    
    it "ships cannot overlap with second ship" do
        board = Board.new(10,10)
        
        board.place(Battleship.new(), 0, 0, :horizontal)
        board.place(Battleship.new(), 0, 3, :horizontal)
        
        battleship3 = Battleship.new()
        board.place(battleship3, 2, 3, :vertical)
        expect(battleship3.placed?).to be false
    end

    it "second ship can be sunk" do
        board = Board.new(10,10)
        board.place(Battleship.new(), 0, 0, :horizontal)

        battleship2 = Battleship.new()
        board.place(battleship2, 0, 3, :horizontal)

        board.shoot(0,3)
        board.shoot(1,3)
        board.shoot(2,3)
        board.shoot(3,3)
        expect(battleship2.sunk?).to be false
        
        board.shoot(4,3)
        expect(battleship2.sunk?).to be true
    end
end