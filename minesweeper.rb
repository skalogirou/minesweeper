class Minesweeper
	MINES_PERSENTAGE = {
		easy: 0.1,
		medium: 0.3,
		hard: 0.5
	}
	# Function initialize , initialize game
	def initialize(size=4, level=:easy)
		@size = size
		@status_ = :in_progress
		@grid = Array.new(size) { Array.new(size,"X") }
		@total_squares = size*size # Calculate board squares
		@total_mines = (MINES_PERSENTAGE[level]*@total_squares).round() #Calculate board mines
		populate_mines(@total_mines) # Populate board with mines
	end
	#Function attempt, try to open a square at scesific coordinates
	def attempt(x,y)
		return "This game is over" if @status_!= :in_progress
		return "Invalid coordinate!" if x > @size or y > @size
		return "Already opened!" unless @grid[x-1][y-1].is_a?(String)
		if  is_a_mine?(x,y)
			@status_ = :loss
			@grid[x-1][y-1] = "*"
			return "BOOOOM!"
		else
			calculate(x,y)
		end
	end
	#Function flag, flag a square at scesific coordinates as a mine 
	def flag(x,y)
		return "Unable to flag" if @grid[x-1][y-1] != "X"
		@grid[x-1][y-1] = "f"
	end
	#Function unflag, unflag a square at scesific coordinates
	def unflag(x,y)
		return "This square was not flaged!" if @grid[x-1][y-1] != "f"
		@grid[x-1][y-1] = "X" 
	end
	# Function display, return a view of the board
	def display
		@grid.each do |y_array|
			_display=""
			y_array.each do |y|
				_display+="#{y}"
			end
			puts _display
		end
		return 0
	end
	# Function is_a_mine?, return true if the specified coordinates contain mine (bomb)
	def is_a_mine?(x,y)
		# Convert coordinates to position
		#Starting position 1 -> Coordinates (1,1) 
		#Ending position Size*Size -> Coordinates(Size,Size)
		_position = (x-1)*@size + y 
		return @mines.include?(_position) # Check the _position against the @mines Array
	end
	# Function status returns the status of the game
	def status
		if @status_ == :victory
			return "You Win!"
		elsif @status_ == :loss
			return "You Loose"
		elsif @status_ == :in_progress
			return "Still playing"
		end
	end

	private
	#Function populate_mines, populating the board with mines
	#This functions build an array containing the positions of the mines
	#Starting position 1 -> Coordinates (1,1) 
	#Ending position Size*Size -> Coordinates(Size,Size)
	def populate_mines(total_mines)
		@mines = []
		while @mines.size < total_mines do 
			_mine = rand(1..@total_squares)
			@mines.push _mine unless @mines.include?(_mine) 
		end
	end
	#Function calculate, calculates the number of mines arround specific position
	def calculate(x,y)
		_positions = []
		if y==1
			_positions = []
		elsif y==7
			_positions = []
		else
			_positions = []
		end
		@grid[x-1][y-1] = 2
		if @grid.count("X") == @total_mines
			@status_ = :victory
			return "You won"
		end
		return 2
	end
	# def grid
	# 	@grid
	# end
	# def mines
	# 	@mines
	# end
end
