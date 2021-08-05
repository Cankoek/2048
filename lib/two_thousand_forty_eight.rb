module TwoThousandFortyEight
  def self.run
    game = Game.new
    true
  end
end

#-------------------------------------------------------------------------------------------------------------
#To-do:
#    Improve move functions & overall game logic               #Partially done

# Already Done:
#    Add basic game logic                                      #Done
#    Add moveRight, moveLeft                                   #Done
#    Add moveUp, moveDown                                      #Done
#    Add function to create random numbers at random spots     #Done
#    Add a basic UI for testing                                #Done
#    Add user input                                            #Done
#    Improve the UI                                            #Done
#    Add win condition at 2048                                 #Done
#    Reorganize Code                                           #Done
#    Add a check if something moved                            #Done
#    Add better classes                                        #Canceled
#    Add a points counter                                      #Done


class Game
  def initialize()
    @somethingMoved = 0
    @points = 0
    start()
  end

  def start()
    gridArray = Array.new(16,0)
    2.times do 
      gridArray = addRandomNumber(gridArray) 
    end
    routine(gridArray)
  end

#-------------------------------------------------------------------------------------------------------------
#Game Routine

  def routine(grid)
    while true
      @somethingMoved = 0
      drawInterface(grid)

      case userInput().downcase
      when 'w'
        grid = shiftUp(grid)
      when 'a'
        grid = shiftLeft(grid)
      when 's' 
        grid = shiftDown(grid)
      when 'd'
        grid = shiftRight(grid)
      when 'r'
        reset()
      when 'e'
        break
      end
      if checkWin(grid) == true
        break
      end
      if checkLoose(grid) == true
        print("\nYou lost.")
        break
      end
      if @somethingMoved == 1            #If anything moved, adds a new random number to the grid
        grid = addRandomNumber(grid)
      end
      sleep(0.01)
    end
  end

#-------------------------------------------------------------------------------------------------------------
  #-Game Functions-

  #Shift Functions

  def shiftRight(grid)
    rowCounter = 0
    4.times do
      alreadyMerged = Array.new(16,0)
      tilePosition = 2+rowCounter
      maxTile = -1+rowCounter
      lastPosition = 3+rowCounter

      until tilePosition == maxTile do

        moveToCounter = 1
        4.times do
          moveToPosition = tilePosition+moveToCounter
          if moveToPosition > 15 then moveToPosition = 15 end               #To prevent index errors; 15 is the last position in the Grid
          tileInfront = moveToPosition-1

          if grid[moveToPosition] > 0                                       #If desired tile is not empty
            if grid[moveToPosition] == grid[tilePosition]                   #If tile and desired tile contain the same number
              if alreadyMerged[moveToPosition] == 0                         #If desired tile did not merge yet this round
                grid = merge(grid, tilePosition, moveToPosition)            
                @points = @points+grid[tilePosition]+grid[moveToPosition]
                alreadyMerged[moveToPosition],@somethingMoved = 1, 1
                break 
              else
                if alreadyMerged[moveToPosition] == 1                       #Else If desired tile already merged this round
                  if tileInfront != tilePosition                            #If tile infront is not the same as current tile
                    grid = moveInfront(grid, tilePosition, tileInfront)
                    @somethingMoved = 1
                  end
                  break
                end
              end
            else
              if tileInfront != tilePosition                                #If tile infront is not the same as current tile
                if grid[tilePosition] != 0                                  #If current tile is not empty
                  grid = moveInfront(grid, tilePosition, tileInfront)
                  @somethingMoved = 1
                end
              end
              break
            end
          end
          moveToCounter += 1
          if moveToCounter == 4                                             #If nothing happened 4 times in a row
            if grid[tilePosition] != 0                                      #If current tile is not empty
              moveToBack(grid, tilePosition,lastPosition)
              @somethingMoved = 1
              break
            end
          end
        end
        if tilePosition != maxTile
          tilePosition -= 1
        end
      end
      if rowCounter != 12
        rowCounter += 4
      end
    end
    return grid
  end

  def shiftLeft(grid)
    rowCounter = 0
    4.times do
      alreadyMerged = Array.new(16,0)
      tilePosition = 1+rowCounter
      maxTile = 4+rowCounter
      lastPosition = rowCounter

      until tilePosition == maxTile do

        moveToCounter = 1
        4.times do

          moveToPosition = tilePosition-moveToCounter
          if moveToPosition > 15 then moveToPosition = 15 end               #To prevent index errors; 15 is the last position in the Grid
          tileInfront = moveToPosition+1

          if grid[moveToPosition] > 0                                       #If desired tile is not empty
            if grid[tilePosition] == grid[moveToPosition]                   #If tile and desired tile contain the same number
              if alreadyMerged[moveToPosition] == 0                         #If desired tile did not merge yet this round
                grid = merge(grid, tilePosition, moveToPosition)
                @points = @points+grid[tilePosition]+grid[moveToPosition] 
                alreadyMerged[moveToPosition],@somethingMoved = 1, 1
                break 
              else
                if alreadyMerged[moveToPosition] == 1                       #Else If desired tile already merged this round
                  if tileInfront != tilePosition                            #If tile infront is not the same as current tile
                    grid = moveInfront(grid, tilePosition, tileInfront)
                    @somethingMoved = 1
                  end
                  break
                end
              end
            else
              if tileInfront != tilePosition                                #If tile infront is not the same as current tile
                if grid[tilePosition] != 0                                  #If current tile is not empty
                  grid = moveInfront(grid, tilePosition, tileInfront)
                  @somethingMoved = 1
                end
              end
              break
            end
          end
          moveToCounter += 1
          if moveToCounter == 4                                             #If nothing happened 4 times in a row
            if grid[tilePosition] != 0                                      #If current tile is not empty
              moveToBack(grid, tilePosition,lastPosition)
              @somethingMoved = 1
              break
            end
          end
        end
        if tilePosition != maxTile
          tilePosition += 1
        end
      end
      if rowCounter != 12
        rowCounter += 4
      end
    end
    return grid
  end

  def shiftDown(grid)
    columnCounter = 0
    4.times do
      alreadyMerged = Array.new(16,0)
      tilePosition = 8+columnCounter
      maxTile = -4+columnCounter
      lastPosition = 12 + columnCounter

      until tilePosition == maxTile do

        moveToCounter = 4
        4.times do

          moveToPosition = tilePosition+moveToCounter
          if moveToPosition >= 16 && columnCounter == 0 then moveToPosition = 12 end    
          if moveToPosition >= 16 && columnCounter == 1 then moveToPosition = 13 end
          if moveToPosition >= 16 && columnCounter == 2 then moveToPosition = 14 end
          if moveToPosition >= 16 && columnCounter == 3 then moveToPosition = 15 end
          tileInfront = moveToPosition-4

          if grid[moveToPosition] > 0                                       #If desired tile is not empty
            if grid[tilePosition] == grid[moveToPosition]                   #If tile and desired tile contain the same number
              if alreadyMerged[moveToPosition] == 0                         #If desired tile did not merge yet this round
                grid = merge(grid, tilePosition, moveToPosition)  
                @points = @points+grid[tilePosition]+grid[moveToPosition]
                alreadyMerged[moveToPosition],@somethingMoved = 1, 1
                break
              else
                if alreadyMerged[moveToPosition] == 1                       #Else If desired tile already merged this round
                  if tileInfront != tilePosition                            #If tile infront is not the same as current tile
                    if grid[tilePosition] != 0                              #If current tile is not empty
                      grid = moveInfront(grid, tilePosition, tileInfront)
                      @somethingMoved = 1#, 1  alreadyMerged[moveToPosition],
                    end
                  end
                  break
                end
              end
            else
              if tileInfront != tilePosition                                #If tile infront is not the same as current tile
                if grid[tilePosition] != 0                                  #If current tile is not empty
                  grid = moveInfront(grid, tilePosition, tileInfront)
                  @somethingMoved = 1
                end
              end
              break
            end
          end
          moveToCounter += 4
          if moveToCounter == 16                                            #If nothing happened 4 times in a row
            if grid[tilePosition] != 0                                      #If current tile is not empty
              moveToBack(grid, tilePosition,lastPosition)
              @somethingMoved = 1
              break
            end
          end
        end
        if tilePosition >= columnCounter
          tilePosition -= 4
        end
      end
      if columnCounter != 4
          columnCounter += 1
      end
    end
    return grid
  end

  def shiftUp(grid)
    columnCounter = 0
    4.times do
      alreadyMerged = Array.new(16,0)
      tilePosition = 4+columnCounter
      maxTile = 16+columnCounter
      lastPosition = columnCounter

      until tilePosition == maxTile do

        moveToCounter = 4
        4.times do

          moveToPosition = tilePosition-moveToCounter
          tileInfront = moveToPosition+4

          if grid[moveToPosition] > 0                                       #If desired tile is not empty
            if grid[tilePosition] == grid[moveToPosition]                   #If tile and desired tile contain the same number
              if alreadyMerged[moveToPosition] == 0                         #If desired tile did not merge yet this round
                grid = merge(grid, tilePosition, moveToPosition)
                @points = @points+grid[tilePosition]+grid[moveToPosition]
                alreadyMerged[moveToPosition],@somethingMoved = 1, 1
                break
              else
                if alreadyMerged[moveToPosition] == 1                       #Else If desired tile already merged this round
                  if tileInfront != tilePosition                            #If tile infront is not the same as current tile
                    if grid[tilePosition] != 0
                      grid = moveInfront(grid, tilePosition, tileInfront)
                      @somethingMoved = 1#, 1  alreadyMerged[moveToPosition],
                    end
                  end
                  break
                end
              end
            else
              if tileInfront != tilePosition                                #If tile infront is not the same as current tile
                if grid[tilePosition] != 0                                  #If current tile is not empty
                  grid = moveInfront(grid, tilePosition, tileInfront)
                  @somethingMoved = 1
                end
              end
              break
            end
          end
          moveToCounter += 4
          if moveToCounter == 16                                            #If nothing happened 4 times in a row
            if grid[tilePosition] != 0                                      #If current tile is not empty
              moveToBack(grid, tilePosition,lastPosition)
              @somethingMoved = 1
              break
            end
          end
        end
        if tilePosition >= columnCounter
          tilePosition += 4
        end
      end
      if columnCounter != 4
          columnCounter += 1
      end
    end
    return grid
  end

  def merge(grid,tilePosition, moveToPosition)
    #Merge Numbers into desired tile, reset current tile
    grid[moveToPosition] = 2*grid[tilePosition]
    grid[tilePosition] = 0
    return grid
  end

  def moveInfront(grid, tilePosition, tileInfront)
    #Move current tile infront of desired tile
    grid[tileInfront] = grid[tilePosition] 
    grid[tilePosition] = 0
    return grid
  end

  def moveToBack(grid, tilePosition, lastPosition)
    #Move current tile to last possible tile
    grid[lastPosition] = grid[tilePosition]
    grid[tilePosition] = 0
    return grid
  end

  #Maybe in the future
  def LRshift(grid, direction)
    rowCounter = 0
    4.times do
      alreadyMerged= [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

      tilePosition = direction == "d" ? 2+rowCounter : -1+rowCounter
      maxTile = direction == "d" ? -1+rowCounter : 4+rowCounter

      until tilePosition == maxTile do

        moveToCounter = 1
        4.times do
          
          moveToPosition = direction == "d" ? tilePosition + moveToCounter : tilePosition - moveToCounter
          if moveToPosition > 15 then moveToPosition = 15 end
          if moveToPosition < 0 then moveToPosition = 0 end
          tileInfront = direction == "d" ? moveToPosition-1 : moveToPosition+1
          lastPosition = direction == "d" ? 3+rowCounter : rowCounter

          if grid[moveToPosition] > 0                         #If field is not empty
            if grid[tilePosition] == grid[moveToPosition]   #If both fields contain the same number
              if alreadyMerged[moveToPosition] == 0       #If the tile (where to move) has not merged yet
                grid = merge(grid, tilePosition, moveToPosition)
                alreadyMerged[moveToPosition],@somethingMoved = 1, 1

                break
              elsif alreadyMerged[moveToPosition] == 1
                if tileInfront != tilePosition  #if Tile infront is not the same as tilePosition
                  grid = moveInfront(grid, tilePosition, tileInfront)
                  @somethingMoved = 1
                end
                break
              end            
            else
              if grid[moveToPosition] != 0
                if tileInfront != tilePosition
                  if tilePosition != 0
                    grid = moveInfront(grid, tilePosition, tileInfront)
                    @somethingMoved
                  end
                end
              end
              break
            end
          end
          moveToCounter += 1
          if moveToCounter == 4
            if tilePosition != 0
              grid = moveToBack(grid,tilePosition, lastPosition)
              @somethingMoved = 1
              break
            end
          end
        end
        if tilePosition != maxTile
          tilePosition = direction == "d" ? tilePosition-1 : tilePosition+1
        end
      end
      if rowCounter != 12
        rowCounter += 4
      end
    end
    return grid
  end 

  #Help functions
  def generateRandomInt()
    #Generates either 2 or 4 | 90%/10%
    return ranInt = rand(0.0..1.0) < 0.9 ? 2 : 4
  end

  def addRandomNumber(grid)
    #Adds random Number to random empty tile
    while true
      if grid.include? 0
        randvalue = rand(0..15)
        if grid[randvalue] == 0
          grid[randvalue] = generateRandomInt()
          break
        end
      else
        break
      end
    end
    return grid
  end

  def userInput()
    #Checks constantly for userinput
    puts("w:Up a:Left s:Down d:Right r:Reset e:End\n")
    while true
      system("stty raw -echo")
      input = STDIN.getc.chr
      system("stty -raw echo")
      if input.downcase == "w" || input.downcase == "a" || input.downcase == "s" || input.downcase == "d" || input.downcase == "e" || input.downcase == "r"
        break
      else
        puts("Invalid Input. Try again.")
      end
    end
    return input
  end

  def checkWin(grid)
    #If array contains 2048, you've won
    if grid.include? 2048
      return true
    end
    return false
  end

  def checkLoose(grid)
    #Check if grid has no empty tiles
    if grid.include? 0
      return false
    end
    #Check every tile if it has a neighbour-tiles which contain the same number
    counter = 0
    16.times do
      if counter < 15 && counter != 3 && counter != 7 && counter != 11
        plusone = counter + 1
        if grid[plusone] == grid[counter] then return false end
      end

      if counter > 0 && counter != 4 && counter != 8 && counter != 12
        minusone = counter - 1
        if grid[minusone] == grid[counter] then return false end
      end

      if counter < 12
        plusfour = counter + 4
        if grid[plusfour] == grid[counter] then return false end
      end

      if counter > 3
        minusfour = counter + 4
        if grid[minusfour] == grid[counter] then return false end
      end
      counter += 1
    end
    return true
  end

  def reset()
    #Resets points and starts again
    @points = 0
    start()
  end

#-------------------------------------------------------------------------------------------------------------
  #User Interface
  def drawInterface(grid)
    #Clears the console, prints points and the grid
    #system "clear"
    print("\nPoints: ", @points, "\n\n")   
    counter = 0

    16.times do
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
      if counter == 3 or counter == 7 or counter == 11 or counter == 15
        print("\n")
      end
      counter += 1
    end
    print("\n")
  end
end

