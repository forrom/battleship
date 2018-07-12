require "./lib/board"

describe 'board' do 
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
end
