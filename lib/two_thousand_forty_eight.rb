module TwoThousandFortyEight
  extend self

  @somethingMoved = 0
  @points = 0
  @alreadyWon = 0

  #Start functions
  def self.run
    system "cls"
    system "clear"
    grid = Array.new(16,0)
    2.times do gridArray = addRandomNumber(grid) end
    while true
      #Check win
      if @alreadyWon == 0 && checkWin(grid) == true
        drawInterface(grid)
        print("\nCongratulations! You've beat 2048.\nDo you want to continue? (y:Yes n:No)\n")
        if userInput("yn").downcase == 'n' then exit() end
      end

      #Check lose
      if checkLose(grid) == true
        drawInterface(grid)
        puts("You lost! You have no moves left. \nDo you want to restart the game? (y:Yes n:No)\n")
        if userInput("yn").downcase == 'y' then reset() else exit() end
      end

      drawInterface(grid)
      puts("\nw:Up a:Left s:Down d:Right r:Restart e:End\n")
      @somethingMoved, direction = 0, userInput("wasder")

      #Check input
      if "wasd".include? direction.downcase then grid = shift(grid,direction) end
      if direction == 'r' then reset() elsif direction == 'e' then exit end

      #If anything moved, adds a new random number to the grid
      if @somethingMoved == 1 then grid = addRandomNumber(grid) end           
      sleep(0.01)
    end
    true
  end

  #-------------------------------------------------------------------------------------------------------------
  #Shift Function
  def shift(grid,direction)
    #For each direction different values for variables. 
    counter = 0
    4.times do
      alreadyMerged = Array.new(16,0)
      if direction.downcase == 'd'
        @lastMove = 'Right'
        tilePosition = 2+counter
        maxTile = -1+counter
        lastPosition = 3+counter
      elsif direction.downcase == 'a'
        @lastMove = 'Left'
        tilePosition = 1+counter
        maxTile = 4+counter
        lastPosition = counter
      elsif direction.downcase == 's'
        @lastMove = 'Down'
        tilePosition = 8+counter
        maxTile = -4+counter
        lastPosition = 12 + counter
      elsif direction.downcase == 'w'
        @lastMove = 'Up'
        tilePosition = 4+counter
        maxTile = 16+counter
        lastPosition = counter
      end

      until tilePosition == maxTile do

        if direction.downcase == 'a' || direction.downcase == 'd' then moveToCounter = 1 end
        if direction.downcase =='s' || direction.downcase == 'w' then moveToCounter = 4 end

        4.times do
          if direction.downcase == 'd'
            moveToPosition = tilePosition+moveToCounter
            tileInfront = moveToPosition-1
          elsif direction.downcase == 'a'
            moveToPosition = tilePosition-moveToCounter
            tileInfront = moveToPosition+1
          elsif direction.downcase == 's'
            moveToPosition = tilePosition+moveToCounter
            tileInfront = moveToPosition-4
          elsif direction.downcase == 'w'
            moveToPosition = tilePosition-moveToCounter
            tileInfront = moveToPosition+4
          end
          if moveToPosition > 15 then moveToPosition = 15 end


          if grid[moveToPosition] > 0                                       #If desired tile is not empty
            if grid[moveToPosition] == grid[tilePosition]                   #If tile and desired tile contain the same number
              if alreadyMerged[moveToPosition] == 0                         #If desired tile did not merge yet this round
                grid = merge(grid, tilePosition, moveToPosition)            
                alreadyMerged[moveToPosition],@somethingMoved = 1, 1
                break 
              else
                if alreadyMerged[moveToPosition] == 1                       #Else If desired tile already merged this round
                  if tileInfront != tilePosition 
                    if grid[tilePosition] != 0                              #If tile infront is not the same as current tile
                      grid = moveInfront(grid, tilePosition, tileInfront)
                      @somethingMoved = 1
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
          if direction.downcase == 'a' || direction.downcase == 'd'  
            moveToCounter += 1
            if moveToCounter == 4                                             #If nothing happened 4 times in a row
              if grid[tilePosition] != 0                                      #If current tile is not empty
                moveToBack(grid, tilePosition,lastPosition)
                @somethingMoved = 1
                break
              end
            end
          elsif direction.downcase == 's' || direction.downcase == 'w'
            moveToCounter += 4
            if moveToCounter == 16                                            #If nothing happened 4 times in a row
              if grid[tilePosition] != 0                                      #If current tile is not empty
                moveToBack(grid, tilePosition,lastPosition)
                @somethingMoved = 1
                break
              end
            end
          end
        end
        if direction.downcase == 'a' || direction.downcase == 'd'
          if tilePosition != maxTile
            if direction.downcase == 'd' then tilePosition -= 1 end
            if direction.downcase == 'a' then tilePosition += 1 end
          end
        else
          if tilePosition >= counter
            if direction.downcase == 's' then tilePosition -= 4 end
            if direction.downcase == 'w' then tilePosition += 4 end
          end
        end
      end

      if direction.downcase == 'a' || direction.downcase == 'd'
        if counter != 12 then counter += 4 end
      elsif direction.downcase == 's' || direction.downcase == 'w'
        if counter != 4 then counter += 1 end
      end

    end
    return grid
  end

  #Move functions
  def merge(grid,tilePosition, moveToPosition)
    #Merge Numbers into desired tile, reset current tile and add points
    grid[moveToPosition] = 2*grid[tilePosition]
    grid[tilePosition] = 0
    @points = @points + grid[moveToPosition]
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
    require "io/console"
    #Checks constantly for userinput
    while true
      input = STDIN.getch
      #Checks if input is in inputrange
      if inputrange.include? input.downcase then break else puts("Invalid Input. Try again.") end
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
    for counter in (0..15) do
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
    @alreadyWon,@points = 0, 0
    run()
  end

  #-------------------------------------------------------------------------------------------------------------
  #User Interface
  def drawInterface(grid)
    #Clears the console, prints points and the grid
    system "cls"
    system "clear"
    !checkLose(grid) ? print("\nPoints: ", @points, "\tLast move: ", @lastMove, "\n\n") : print("\n\n")
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
    !checkLose(grid) ? print("\n") : print("\n\nYou've reached ", @points, " Points.\n\n")
  end
end
