class Minesweeper
	MINES_PERSENTAGE = {
		easy: 0.1, # 10% mines on board
		medium: 0.3, # 30% mines on board
		hard: 0.5 # 50% mines on board
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
		return "Invalid coordinate!" if x > @size or y > @size or x <= 0 or y <=0
		return "Already opened!" unless @grid[y-1][x-1].is_a?(String)
		if  is_a_mine?(x,y)
			@status_ = :loss
			@grid[y-1][x-1] = "*"
			return "BOOOOM!"
		else
			calculate(x,y)
		end
	end
	#Function flag, flag a square at scesific coordinates as a mine 
	def flag(x,y)
		return "Unable to flag" if @grid[y-1][x-1] != "X"
		@grid[y-1][x-1] = "f"
	end
	#Function unflag, unflag a square at scesific coordinates
	def unflag(x,y)
		return "This square was not flaged!" if @grid[y-1][x-1] != "f"
		@grid[y-1][x-1] = "X" 
	end
	# Function display, return a view of the board
	def display
		@grid.each do |x_array|
			_display=""
			x_array.each do |x|
				_display+="#{x}"
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
		_position = coordinates_to_position(x,y) 
		#show position for debug purposes
		#p _position
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
	# Functions for debug purposes
	# def grid
	# 	@grid
	# end
	# def mines
	# 	@mines
	# end
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
		surrounding_square_positions = []
		current_row = y
		current_column = x
		
		#left
		unless current_column == 1
			surrounding_square_positions.push(coordinates_to_position(current_column-1, current_row))
			#top left
			surrounding_square_positions.push(coordinates_to_position(current_column-1, current_row-1)) unless current_row == 1
			#bottom_left
			surrounding_square_positions.push(coordinates_to_position(current_column-1, current_row+1)) unless current_row == @size
		end
		#right
		unless current_column == @size
			surrounding_square_positions.push(coordinates_to_position(current_column+1, current_row))
			#top right
			surrounding_square_positions.push(coordinates_to_position(current_column+1, current_row-1)) unless current_row == 1
			#bottom right
			surrounding_square_positions.push(coordinates_to_position(current_column+1, current_row+1)) unless current_row == @size
		end
		#top
		surrounding_square_positions.push(coordinates_to_position(current_column, current_row-1)) unless current_row == 1
		#bottom
		surrounding_square_positions.push(coordinates_to_position(current_column, current_row+1)) unless current_row == @size

		# check sarounding positions against @mines Array
		surrounding_square_mines = surrounding_square_positions&@mines

		@grid[y-1][x-1] = surrounding_square_mines.size
		#check if there are the hidden squares are only mines
		if @grid.flatten.count("X")+@grid.flatten.count("f") == @total_mines
			@status_ = :victory
			return "You won"
		end
		return surrounding_square_mines.size
	end
	def coordinates_to_position(x,y)
		return (x-1)*@size + y 
	end
end
