require "io/console"
module TwoThousandFortyEight

  RIGHT = 'd'
  LEFT = 'a'
  DOWN = 's'
  UP = 'w'

  def self.run
    grid = [[0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0]]
    2.times do Game.new.addRandomNumber(grid) end
    $points = 0
    Game.new.routine(grid)
    true
  end

  class Game
    def routine(grid)
      while true
        @won = false
        $moved = 0
        UserInterface.new.drawInterface(grid)

        if won?(grid) == true && @won == false
          @won = true
          print("\nCongratulations! You've beat 2048.\nDo you want to continue? (y:Yes n:No)\n")
          exit() if userInput("yn").downcase == 'n'
        end

        if lost?(grid)
          print("You lost! You have no moves left. \nDo you want to restart the game? (y:Yes n:No)\n")
          if userInput("yn").downcase == 'y' then Game.new
          else exit() end
        end

        puts("\nw:Up a:Left s:Down d:Right r:Restart e:End\n")
        direction = userInput("wasder")
        Move.new(grid,direction) if "wasd".include? direction.downcase
        if direction == 'r' then TwoThousandFortyEight.run
        elsif direction == 'e' then exit end
          
        addRandomNumber(grid) if $moved == 1
      end
    end

    def addRandomNumber(grid)
      #Adds random Number to random empty tile
      if grid.flatten.include? 0
        while true
          x = rand(0..3)
          y = rand(0..3)
          if grid[x][y] == 0
            grid[x][y] = rand(0.0..1.0) < 0.9 ? 2 : 4
            break
          end
        end
      end
    end

    def userInput(inputrange)
      #Checks constantly for userinput
      while true
        input = STDIN.getch
        #Checks if input is in inputrange
        if input == 'x' then exit end
        if inputrange.include? input.downcase then break 
        else puts("Invalid Input. Try again.") end
      end
      return input
    end

    def won?(grid)
      #If array contains 2048, you've won
      if grid.flatten.include? 2048
        return true
      end
      return false
    end

    def lost?(grid)
      #Check if grid has no empty tiles
      return false if grid.flatten.include? 0
      #Check every tile if it has a neighbour-tiles which contain the same number
      for row in 0..3
        for col in 0..3
          return false if col+1 < 4 && grid[row][col] == grid[row][col+1]
        end
      end
      for col in 0..3
        for row in 0..3
          return false if row+1 < 4 && grid[row][col] == grid[row+1][col]
        end
      end
      return true
    end
  end

  class Move
    def initialize(grid,direction)
      @merged = [[0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0]]
      case direction
      when RIGHT then $lastMove = "Right"
      when LEFT then $lastMove = "Left"
      when DOWN then $lastMove = "Down"
      when UP then $lastMove = "Up"
      end
      for i in 0..3
        case direction
        when RIGHT then shiftRight(grid,i)
        when LEFT then shiftLeft(grid,i)
        when DOWN then shiftDown(grid,i)
        when UP then shiftUp(grid,i)
        end
      end
    end

    def shiftRight(grid,row)
      col = 2
      i = 0
      3.times do
        if grid[row][col-i] > 0
          c = 0
          for c in 1..3
            if col-i+c < 4 && grid[row][col-i+c] > 0
              shift(grid,row,col-i,col-i+c,col-i+c-1,"lr")
              break
            elsif col-i+c == 3   
              moveToBack(grid,row,col-i,3,"lr")
              break
            end
          end
        end
        i += 1
      end
    end

    def shiftLeft(grid,row)
      col = 1
      i = 0
      3.times do
        if grid[row][col+i] > 0
          c = 0
          for c in 1..3
            if col+i-c < 4 && grid[row][col+i-c] > 0
              shift(grid,row,col+i,col+i-c,col+i-c+1,"lr")
              break
            elsif col+i-c == 0 
              moveToBack(grid,row,col+i,0,"lr")
              break
            end
          end
        end
        i += 1
      end
    end

    def shiftDown(grid,col)
      row = 2
      i = 0
      3.times do
        if grid[row-i][col] > 0
          c = 0
          for c in 1..3
            if row-i+c < 4 && grid[row-i+c][col] > 0
              shift(grid,row-i,col,row-i+c,row-i+c-1,"ud")
              break
            elsif row-i+c == 3  
              moveToBack(grid,row-i,col,3,"ud")
              break
            end
          end
        end
        i += 1
      end
    end

    def shiftUp(grid,col)
      row = 1
      i = 0
      3.times do
        if grid[row+i][col] > 0
          c = 0
          for c in 1..3
            if row+i-c < 4 && grid[row+i-c][col] > 0
              shift(grid,row+i,col,row+i-c,row+i-c+1,"ud")
              break
            elsif row+i-c == 0
              moveToBack(grid,row+i,col,0,"ud")
              break
            end
          end
        end
        i += 1
      end
    end

    def shift(grid,row,col,where_to_move,tile_infront,direction)
      case direction
      when 'lr'
        if grid[row][col] == grid[row][where_to_move] && @merged[row][where_to_move] == 0
          merge(grid,row,col,where_to_move,direction) 
          $moved = 1
          return
        end
        if col != tile_infront
          moveInfront(grid,row,col,tile_infront,direction)
          $moved = 1
          return
        end
      when 'ud'
        if grid[row][col] == grid[where_to_move][col]
          merge(grid,row,col,where_to_move,direction) 
          $moved = 1
          return
        end
        if row != tile_infront
          moveInfront(grid,row,col,tile_infront,direction) 
          $moved = 1
          return
        end
      end
    end

    def merge(grid,row,col,where_to_move,direction)
      case direction
      when 'lr'
        grid[row][where_to_move] = grid[row][col]*2
        grid[row][col] = 0
        @merged[row][where_to_move] = 1
      when 'ud'
        grid[where_to_move][col] = grid[row][col]*2
        grid[row][col] = 0
        @merged[where_to_move][row] = 1
      end
      $points = $points+2*grid[row][where_to_move]
      return grid
    end

    def moveInfront(grid,row,col,tile_infront,direction)
      case direction
      when 'lr'
        grid[row][tile_infront] = grid[row][col]
        grid[row][col] = 0
      when 'ud'
        grid[tile_infront][col] = grid[row][col]
        grid[row][col] = 0
      end
      return grid
    end

    def moveToBack(grid,row,col,last_tile,direction)
      case direction
      when 'lr'
        grid[row][last_tile] = grid[row][col]
        grid[row][col] = 0
        $moved = 1
      when 'ud'
        grid[last_tile][col] = grid[row][col]
        grid[row][col] = 0
        $moved = 1
      end
      return grid
    end
  end

  class UserInterface < Game
    def drawInterface(grid)
      system 'cls'
      system 'clear'

      if lost?(grid) == false
        print("\nPoints: ", $points, "\tLast move: ", $lastMove, "\n\n")
      elseTwoThousandFortyEight::Game.new.d[row][col] >= 100 && grid[row][col] < 1000 
          print("[",grid[row][col] , "] ") if grid[row][col] >= 1000 
        end
        print("\n")
      end
      lost?(grid) ? print("\n\nYou've reached ", $points, " Points.\n\n") : print("\n")
    end
  end
  #end of module
end