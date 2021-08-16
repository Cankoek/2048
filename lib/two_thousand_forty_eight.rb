require "io/console"
module TwoThousandFortyEight
  extend self

  MOVE_RIGHT = 'd'
  MOVE_LEFT = 'a'
  MOVE_UP = 'w'
  MOVE_DOWN = 's'
  YES = 'y'
  NO = 'n'

  #Start function
  def self.run
    newGame = Game.new
    true
  end
  #-------------------------------------------------------------------------------------------------------------
  #Game function
  class Game
    def initialize
      system "cls"
      system "clear"
      $somethingmoved = 0
      $points = 0
      $alreadyWon = 0
      grid = Array.new(16,0)
      routine(grid)
    end

    def routine(grid)
      helperFunctions = Helper.new
      mover = Mover.new
      ui = UserInterface.new
      
      2.times do gridArray = helperFunctions.addRandomNumber(grid) end
      while true
        #Check win
        if $alreadyWon == 0 && helperFunctions.won?(grid)
          ui.draw(grid)
          print("\nCongratulations! You've beat 2048.\nDo you want to continue? (y:Yes n:No)\n")
          exit() if helperFunctions.userInput("yn").downcase == NO
        end

        #Check lose
        if helperFunctions.lost?(grid)
          ui.draw(grid)
          puts("You lost! You have no moves left. \nDo you want to restart the game? (y:Yes n:No)\n")
          if helperFunctions.userInput("yn").downcase == YES then Game.new
          else exit() end
        end

        ui.draw(grid)
        puts("\nw:Up a:Left s:Down d:Right r:Restart e:End\n")
        $somethingmoved = 0
        direction = helperFunctions.userInput("wasder")

        #Check input
        grid = mover.shift(grid,direction) if "wasd".include? direction.downcase
        if direction == 'r' then Game.new
        elsif direction == 'e' then exit end

        #If anything moved, adds a new random number to the grid
        helperFunctions.addRandomNumber(grid) if $somethingmoved == 1
        sleep(0.01)
      end
    end
  end
  #-------------------------------------------------------------------------------------------------------------
  #Shift function and shift helper
  class Mover
    #Shift Function
    def shift(grid,direction)
      #For each direction different values for variables. 
      counter = 0
      4.times do
        directionvalues = directionVariables(direction,counter)

        alreadyMerged = Array.new(16,0)
        tilePosition = directionvalues[0]
        maxTile = directionvalues[1]
        lastPosition = directionvalues[2]

        until tilePosition == maxTile do

          moveToCounter = 1 if direction.downcase == MOVE_RIGHT || direction.downcase == MOVE_LEFT
          moveToCounter = 4 if direction.downcase == MOVE_UP || direction.downcase == MOVE_DOWN
          
        
          4.times do
            break if grid[tilePosition] == 0
            positionvalues = positionVariables(direction, tilePosition,moveToCounter)
            moveToPosition = positionvalues[0]
            tileInfront = positionvalues[1]

            if grid[moveToPosition] > 0                                    
              if grid[moveToPosition] == grid[tilePosition] 
                case alreadyMerged[moveToPosition]
                when 0
                  grid = merge(grid, tilePosition, moveToPosition)            
                  alreadyMerged[moveToPosition]= 1
                  break 
                when 1
                  grid = moveInfront(grid, tilePosition, tileInfront)
                  break             
                end
              else
                grid = moveInfront(grid, tilePosition, tileInfront)
                break 
              end
            end

            valueToAdd = 1 if direction.downcase == MOVE_LEFT || direction.downcase == MOVE_RIGHT
            valueToAdd = 4 if direction.downcase == MOVE_DOWN || direction.downcase == MOVE_UP
            moveToCounter += valueToAdd
            if moveToCounter == 4*valueToAdd
              moveToBack(grid, tilePosition,lastPosition)
              break
            end
          end
          tilePosition = returnTilePosition(direction,tilePosition,maxTile,counter)
        end

        case direction.downcase
        when MOVE_RIGHT,MOVE_LEFT
          counter += 4 if counter != 12
        when MOVE_UP,MOVE_DOWN
          counter += 1 if counter != 4
        end

      end
      return grid
    end

    #Functions to make shift function more organized
    def positionVariables(direction,tilePosition,moveToCounter)
      case direction.downcase
      when MOVE_RIGHT
        moveToPosition = tilePosition+moveToCounter
        tileInfront = moveToPosition-1
      when MOVE_LEFT
        moveToPosition = tilePosition-moveToCounter
        tileInfront = moveToPosition+1
      when MOVE_DOWN
        moveToPosition = tilePosition+moveToCounter
        tileInfront = moveToPosition-4
      when MOVE_UP
        moveToPosition = tilePosition-moveToCounter
        tileInfront = moveToPosition+4
      end
      moveToPosition = 15 if moveToPosition > 15
      return positionArray = [moveToPosition, tileInfront]
    end

    def directionVariables(direction,counter)
      case direction.downcase
      when MOVE_RIGHT
        @lastMove = 'Right'
        tilePosition = 2+counter
        maxTile = -1+counter
        lastPosition = 3+counter
      when MOVE_LEFT
        @lastMove = 'Left'
        tilePosition = 1+counter
        maxTile = 4+counter
        lastPosition = counter
      when MOVE_UP
        @lastMove = 'Up'
        tilePosition = 4+counter
        maxTile = 16+counter
        lastPosition = counter
      when MOVE_DOWN
        @lastMove = 'Down'
        tilePosition = 8+counter
        maxTile = -4+counter
        lastPosition = 12 + counter
      end
      return valueArray = [tilePosition, maxTile, lastPosition]
    end

    def returnTilePosition(direction,tilePosition,maxTile,counter)
      case direction.downcase
      when MOVE_RIGHT 
        tilePosition -= 1 if tilePosition != maxTile
      when MOVE_LEFT
        tilePosition += 1 if tilePosition != maxTile
      when MOVE_DOWN 
        tilePosition -= 4 if tilePosition >= counter
      when MOVE_UP
        tilePosition += 4 if tilePosition >= counter
      end
    end

    #Move functions
    def merge(grid,tilePosition, moveToPosition)
      #Merge Numbers into desired tile, reset current tile and add points
      grid[moveToPosition] = 2*grid[tilePosition]
      grid[tilePosition] = 0
      $points = $points + grid[moveToPosition]
      $somethingmoved = 1
      return grid
    end

    def moveInfront(grid, tilePosition, tileInfront)
      if tileInfront != tilePosition 
        if grid[tilePosition] != 0   
          #Move current tile infront of desired tile
          grid[tileInfront] = grid[tilePosition] 
          grid[tilePosition] = 0
          $somethingmoved = 1
        end
      end
      return grid
    end

    def moveToBack(grid, tilePosition, lastPosition)
      if grid[tilePosition] != 0 
      #Move current tile to last possible tile
        grid[lastPosition] = grid[tilePosition]
        grid[tilePosition] = 0
        $somethingmoved = 1
        return grid
      end
    end
  end
  #Help functions
  class Helper
    def addRandomNumber(grid)
      #Adds random Number to random empty tile
      if grid.include? 0
        while true
          randvalue = rand(0..15)
          if grid[randvalue] == 0
            grid[randvalue] = rand(0.0..1.0) < 0.9 ? 2 : 4
            break
          end
        end
      end
      return grid
    end

    def userInput(inputrange)
      #Checks constantly for userinput
      while true
        input = STDIN.getch
        #Checks if input is in inputrange
        if inputrange.include? input.downcase then break 
        else puts("Invalid Input. Try again.") end
      end
      return input
    end

    def won?(grid)
      #If array contains 2048, you've won
      if grid.include? 2048
        $alreadyWon = 1
        return true
      end
      return false
    end

    def lost?(grid)
      #Check if grid has no empty tiles
      if grid.include? 0
        return false
      end
      #Check every tile if it has a neighbour-tiles which contain the same number
      for counter in 0..15 do
        if counter < 15 && counter != 3 && counter != 7 && counter != 11
          return false if grid[counter + 1] == grid[counter]
        end
        if counter > 0 && counter != 4 && counter != 8 && counter != 12
          return false if grid[counter - 1] == grid[counter]
        end
        if counter < 12
          return false if grid[counter + 4] == grid[counter]
        end
        if counter > 3
          return false if grid[counter - 4] == grid[counter]
        end
      end
      return true
    end
  end
  #-------------------------------------------------------------------------------------------------------------
  #Userinterface
  class UserInterface
    def draw(grid)
      #Clears the console, prints points and the grid
      system "cls"
      system "clear"
      helperFunctions = Helper.new

      if helperFunctions.lost?(grid) == false
        print("\nPoints: ", $points, "\tLast move: ", @lastMove, "\n\n")
      else
        print("\n\n")
      end

      for counter in 0..15 do
        if grid[counter] == 0
          print("[    ", "] ")
        elsif grid[counter] > 0 && grid[counter] < 10
          print("[   ",grid[counter], "] ")
        elsif grid[counter] >= 10 && grid[counter] < 100
          print("[  ",grid[counter], "] ")
        elsif grid[counter] >= 100 && grid[counter] < 1000
          print("[ ",grid[counter], "] ")
        elsif grid[counter] >= 1000
          print("[",grid[counter], "] ")
        end
        if counter == 3 or counter == 7 or counter == 11 or counter == 15 then print("\n") end
        counter += 1
      end
      if helperFunctions.lost?(grid)
        print("\n\nYou've reached ", $points, " Points.\n\n")
      else
        print("\n")
      end
    end
  end
end