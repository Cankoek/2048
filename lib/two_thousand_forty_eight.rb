module TwoThousandFortyEight
  extend self

  @somethingMoved = 0
  @points = 0
  @alreadyWon = 0

  #Start functions
  def self.run
    puts("Please choose your operating system: w:Windows l:Linux")
    @operatingSystem = gets.chomp
    @operatingSystem.downcase == "w" || @operatingSystem.downcase == "l" ? start() : self.run
    true
  end
  
  def self.start()
    @points = 0
    gridArray = Array.new(16,0)
    2.times do 
      gridArray = addRandomNumber(gridArray) 
    end
    routine(gridArray)
  end

  #-------------------------------------------------------------------------------------------------------------
  #To-do:
  #    Add tests (TDD)

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
  #    Improve move functions & overall game logic               #Done

  #-------------------------------------------------------------------------------------------------------------
  #Game Routine

  def self.routine(grid)
    while true
      @somethingMoved = 0
      drawInterface(grid)

      direction = userInput()
      case direction.downcase
      when 'w'
        grid = shiftUp(grid)
        @lastMove = "Up"
      when 'a'
        grid = shiftLeft(grid)
        @lastMove = "Left"
      when 's' 
        grid = shiftDown(grid)
        @lastMove = "Down"
      when 'd'
        grid = shiftRight(grid)
        @lastMove = "Right"
      when 'r'
        reset()
      when 'e'
        exit()
      end

      if @alreadyWon == 0
        if checkWin(grid) == true 
          print("\nCongratulations! You've beat 2048.\n")
          case winInput.downcase
          when 'r'
            reset()
          when 'n'
            exit()
          end
        end
      end

      if checkLose(grid) == true
        drawLoseScreen(grid)
        case loseInput.downcase
        when 'y'
          reset()
        when 'n'
          exit()
        end

      end
      if @somethingMoved == 1            #If anything moved, adds a new random number to the grid
        grid = addRandomNumber(grid)
      end
      sleep(0.01)
    end
  end

  #-------------------------------------------------------------------------------------------------------------
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
                addPoints(grid[moveToPosition])
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
                addPoints(grid[moveToPosition])
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
                addPoints(grid[moveToPosition])
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
                addPoints(grid[moveToPosition])
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

  #Move functions
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
    puts("w:Up a:Left s:Down d:Right r:Restart e:End\n")
    while true
      if @operatingSystem == "l"
        system("stty raw -echo")
        input = STDIN.getc.chr
        system("stty -raw echo")
      else
        input = gets.chomp
      end

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
      @alreadyWon = 1
      return true
    end
    return false
  end

  def checkLose(grid)
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
    resetPoints()
    start()
  end

def addPoints(tileValue)
    @points = @points + tileValue
end

def resetPoints()
  @points = 0
end

def boolInput()
  if @operatingSystem == "l"
    system("stty raw -echo")
    input = STDIN.getc.chr
    system("stty -raw echo")
  else
    input = gets.chomp
  end

  return input
end

def loseInput()
  puts("Do you want to restart the game? y:Yes n:No")
  while true
  input = boolInput()
    if input.downcase == "y" || input.downcase == "n" 
      break
    else
      puts("Invalid Input. Try again.")
    end
  end
  return input
end

def winInput()
  puts("Do you want to continue? y:Yes n:No r:Restart ")
  while true
    input = boolInput()
    if input.downcase == "y" || input.downcase == "n" || input.downcase == "r" 
      break
    else
      puts("Invalid Input. Try again.")
    end
  end
  return input
end


#-------------------------------------------------------------------------------------------------------------
  #User Interface
  def drawInterface(grid)
    #Clears the console, prints points and the grid
    system "clear"
    system "cls"
    print("\nLast move: ", @lastMove, "\nPoints: ", @points, "\n\n")   
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

  def drawLoseScreen(grid)
    system "clear"
    system "cls"
    counter = 0
    print("\n")
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

    print("\nYou've reached ", @points, " Points\n\n")
  end

end
