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
        expect(battleship.sunk?).to be false
        
        board.shoot(2,4)
        expect(battleship.sunk?).to be false
        
        board.shoot(2,5)
        expect(battleship.sunk?).to be false
        
        board.shoot(2,6)
        expect(battleship.sunk?).to be false
        
        board.shoot(2,7)
        expect(battleship.sunk?).to be true
    end

    it "ships cannot overlap" do
        board = Board.new(10,10)

        battleship_horizontal = Battleship.new()
        board.place(battleship_horizontal, 0,3, :horizontal)
        expect(battleship_horizontal.placed?).to be true

        battleship_vertical = Battleship.new()
        expect(board.place(battleship_vertical, 2,3, :vertical))
        expect(battleship_vertical.placed?).to be false
    end
    
    it "ships cannot overlap with second ship" do
        board = Board.new(10,10)
        
        battleship1 = Battleship.new()
        board.place(battleship1, 0, 0, :horizontal)
        expect(battleship1.placed?).to be true
        
        battleship2 = Battleship.new()
        board.place(battleship2, 0, 3, :horizontal)
        expect(battleship2.placed?).to be true
        
        battleship3 = Battleship.new()
        board.place(battleship3, 2, 3, :vertical)
        expect(battleship3.placed?).to be false
    end

    it "second ship can be sunk" do
        #1. Init 10x10 board
        board = Board.new(10,10)
        #2. Place battleship size 5 at 0,0 horizontally -> verify ship is placed
        battleship1 = Battleship.new()
        board.place(battleship1, 0, 0, :horizontal)
        expect(battleship1.placed?).to be true
        #3. Place battleship size 5 at 0,3 horizontally -> verify ship is placed
        battleship2 = Battleship.new()
        board.place(battleship2, 0, 3, :horizontal)
        expect(battleship2.placed?).to be true
        #4. Shoot
        board.shoot(0,3)
        expect(battleship2.sunk?).to be false

        board.shoot(1,3)
        expect(battleship2.sunk?).to be false

        board.shoot(2,3)
        expect(battleship2.sunk?).to be false
        
        board.shoot(3,3)
        expect(battleship2.sunk?).to be false
        
        board.shoot(4,3)
        expect(battleship2.sunk?).to be true
        expect(battleship1.sunk?).to be false
    end
end