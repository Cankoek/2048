module TwoThousandFortyEight
  def self.run
    game = Game.new
    true
  end
end

#-------------------------------------------------------------------------------------------------------------
#To-do:
#    Add a check if something moved
#    Reorganize Code
#    Add better classes
#    Add a points counter
#    Improve move functions & overall game logic

# Already Done:
#    Add basic game logic                                      #Done
#    Add moveRight, moveLeft                                   #Done
#    Add moveUp, moveDown                                      #Done
#    Add function to create random numbers at random spots     #Done
#    Add a basic UI for testing                                #Done
#    Add user input                                            #Done
#    Improve the UI                                            #Done
#    Add win condition at 2048                                 #Done




class Game
  def initialize()
    @somethingMoved = 0
    gridArray = [0,0,0,0 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0]
    2.times do
      gridArray = addRandomNumber(gridArray)
    end
    
    routine(gridArray)
  end

  #Game Routine
  def routine(grid)
    while true
      @somethingMoved = 0
      drawGrid(grid)
      direction = userInput()

      case direction.downcase
      when 'w'
        grid = shiftUp(grid)
      when 'a'
        grid = shiftLeft(grid)
      when 's' 
        grid = shiftDown(grid)
      when 'd'
        grid = shiftRight(grid)
      end

      if checkWin(grid) == true
        break
      end
      if checkLoose(grid) == true
        print("\nYou lost.")
        break
      end
      if @somethingMoved == 1
        grid = addRandomNumber(grid)
      end
      sleep(0.01)
    end
  end

  #Game Functions
  def shiftRight(grid)
    rowCounter = 0
    4.times do
      arrayPositionCounter = 2+rowCounter
      isShifted = [0,0,0,0 ,0,0,0,0 ,0,0,0,0, 0,0,0,0 ]
      until arrayPositionCounter == -1+rowCounter do

        #Check if there's a number to the right, if so; check which number. If its the same; merge else stay. If not, move number and reset field
        moveToCounter = 1
        4.times do

          #New variable to fix an issue with array length; Without, Ruby wouldnt work because theres an if-check checking an out of range array index
          arrPosC_plus_MoveTo = arrayPositionCounter+moveToCounter
          if arrPosC_plus_MoveTo >= 16
            arrPosC_plus_MoveTo = 15
          end

          #Checks if any field to the right contains a number
          if grid[arrPosC_plus_MoveTo] > 0
            #If the number in the field and current "to-move"-field is the same; merge them together
            if grid[arrayPositionCounter] == grid[arrPosC_plus_MoveTo] 
              if isShifted[arrPosC_plus_MoveTo] == 0
                grid[arrPosC_plus_MoveTo] = 2*grid[arrayPositionCounter]
                grid[arrayPositionCounter] = 0
                isShifted[arrPosC_plus_MoveTo] = 1
                @somethingMoved = 1
                break
              else
                if isShifted[arrPosC_plus_MoveTo] == 1
                  if arrPosC_plus_MoveTo-1 != arrayPositionCounter
                    grid[arrPosC_plus_MoveTo-1] = grid[arrayPositionCounter] 
                    grid[arrayPositionCounter] = 0
                    isShifted[arrPosC_plus_MoveTo] = 1
                    @somethingMoved = 1
                  end
                  break
                end
              end
            #Else if there is a number but not the same; move to the field infront of the already taken one
            else
              #If the "to-move" field is the field infront of the next field with a value; do nothing
              if arrPosC_plus_MoveTo-1 != arrayPositionCounter
                if grid[arrayPositionCounter] != 0
                  grid[arrPosC_plus_MoveTo-1] = grid[arrayPositionCounter] 
                  grid[arrayPositionCounter] = 0
                  @somethingMoved = 1
                end
              end
              break
            end
          end
          #If there is no number to the right, move the "to-move"-field to the last possible field of the row
          moveToCounter += 1
          if moveToCounter == 4
            if grid[arrayPositionCounter] != 0
              grid[3+rowCounter] = grid[arrayPositionCounter]
              grid[arrayPositionCounter] = 0
              @somethingMoved = 1
              break
            end
          end
        end
        #Checks the min arrayPosCounter for each row
        if arrayPositionCounter != -1+rowCounter
          arrayPositionCounter -= 1
        end
      end
      #Makes sure that rowCounter has a maximum value of 12
      if rowCounter != 12
        rowCounter += 4
      end
    end
    return grid
  end

  def shiftLeft(grid)
    rowCounter = 0
    4.times do
      arrayPositionCounter = 1+rowCounter
      isShifted = [0,0,0,0 ,0,0,0,0 ,0,0,0,0, 0,0,0,0]
      until arrayPositionCounter == 4+rowCounter do

        #Check if there's a number to the left, if so; check which number. If its the same; merge else stay. If not, move number and reset field
        moveToCounter = 1
        4.times do
          #New variable to fix an issue with array length; Without Ruby wouldnt work because theres an if-check checking an out of range array index
          arrPosC_minus_MoveTo = arrayPositionCounter-moveToCounter

          #Checks if any field to the left contains a number
          if grid[arrPosC_minus_MoveTo] > 0
            #If the number in the field and current "to-move"-field is the same; merge them together
            if grid[arrayPositionCounter] == grid[arrPosC_minus_MoveTo] 
              if isShifted[arrPosC_minus_MoveTo] == 0
                grid[arrPosC_minus_MoveTo] = 2*grid[arrayPositionCounter]
                grid[arrayPositionCounter] = 0
                isShifted[arrPosC_minus_MoveTo] = 1
                @somethingMoved = 1
                break
              else
                if isShifted[arrPosC_minus_MoveTo] == 1
                  if arrPosC_minus_MoveTo+1 != arrayPositionCounter
                    grid[arrPosC_minus_MoveTo+1] = grid[arrayPositionCounter] 
                    grid[arrayPositionCounter] = 0
                    isShifted[arrPosC_minus_MoveTo] = 1
                    @somethingMoved = 1
                  end
                  break
                end
              end
            #Else if there is a number but not the same; move to the field infront of the already taken one
            else
              #If the "to-move" field is the field infront of the next field with a value; do nothing
              if arrPosC_minus_MoveTo+1 != arrayPositionCounter
                if grid[arrayPositionCounter] != 0
                  grid[arrPosC_minus_MoveTo+1] = grid[arrayPositionCounter]
                  grid[arrayPositionCounter] = 0
                  @somethingMoved = 1
                end
              end
              break
            end
          end
          #If there is no number to the left, move the "to-move"-field to the last possible field of the row
          moveToCounter += 1
          if moveToCounter == 4
            if grid[arrayPositionCounter] != 0
              grid[rowCounter] = grid[arrayPositionCounter]
              grid[arrayPositionCounter] = 0
              @somethingMoved = 1
              break
            end
          end
        end
        #Checks the max arrayPosCounter for each row
        if arrayPositionCounter != 4+rowCounter
          arrayPositionCounter += 1
        end
      end
      #Makes sure that rowCounter has a maximum value of 12
      if rowCounter != 12
        rowCounter += 4
      end
    end
    return grid
  end

  def shiftDown(grid)
    columnCounter = 0
    4.times do
      arrayPositionCounter = 8+columnCounter
      isShifted = [0,0,0,0 ,0,0,0,0 ,0,0,0,0, 0,0,0,0]
      #Checks min ArrPos
      until arrayPositionCounter == -4+columnCounter do

        #Check if there's a number to the right, if so; check which number. If its the same; merge else stay. If not, move number and reset field
        moveToCounter = 4
        4.times do

          #New variable to fix an issue with array length; Without, Ruby wouldnt work because theres an if-check checking an out of range array index
          arrPosC_plus_MoveTo = arrayPositionCounter+moveToCounter
          if arrPosC_plus_MoveTo >= 16 && columnCounter == 0
            arrPosC_plus_MoveTo = 12
          end
          if arrPosC_plus_MoveTo >= 16 && columnCounter == 1
              arrPosC_plus_MoveTo = 13
          end
          if arrPosC_plus_MoveTo >= 16 && columnCounter == 2
              arrPosC_plus_MoveTo = 14
          end
          if arrPosC_plus_MoveTo >= 16 && columnCounter == 3
              arrPosC_plus_MoveTo = 15
          end

          #Checks if any field to the right contains a number
          if grid[arrPosC_plus_MoveTo] > 0
            #If the number in the field and current "to-move"-field is the same; merge them together
            if grid[arrayPositionCounter] == grid[arrPosC_plus_MoveTo] 
              if isShifted[arrPosC_plus_MoveTo] == 0
                grid[arrPosC_plus_MoveTo] = 2*grid[arrayPositionCounter]
                grid[arrayPositionCounter] = 0
                isShifted[arrPosC_plus_MoveTo] = 1
                @somethingMoved = 1
                break
              else
                if isShifted[arrPosC_plus_MoveTo] == 1
                  if arrPosC_plus_MoveTo-4 != arrayPositionCounter
                    if grid[arrayPositionCounter] != 0
                      grid[arrPosC_plus_MoveTo-4] = grid[arrayPositionCounter] 
                      grid[arrayPositionCounter] = 0
                      isShifted[arrPosC_plus_MoveTo] = 1
                      @somethingMoved = 1
                    end
                  end
                  break
                end
              end
            #Else if there is a number but not the same; move to the field infront of the already taken one
            else
              #If the "to-move" field is the field infront of the next field with a value; do nothing
              if arrPosC_plus_MoveTo-4 != arrayPositionCounter
                if grid[arrayPositionCounter] != 0
                  grid[arrPosC_plus_MoveTo-4] = grid[arrayPositionCounter] 
                  grid[arrayPositionCounter] = 0
                  @somethingMoved = 1
                end
              end
              break
            end
          end
          #If there is no number to the right, move the "to-move"-field to the last possible field of the row
          moveToCounter += 4
          if moveToCounter == 16
            if grid[arrayPositionCounter] != 0
              grid[12+columnCounter] = grid[arrayPositionCounter]
              grid[arrayPositionCounter] = 0
              @somethingMoved = 1
              break
            end
          end
        end
        #Checks the min arrayPosCounter for each row
        if arrayPositionCounter >= columnCounter
          arrayPositionCounter -= 4
        end
      end
      #Makes sure that columnCounter has a maximum value of 12
      if columnCounter != 4
          columnCounter += 1
      end
    end
    return grid
  end

  def shiftUp(grid)
    columnCounter = 0
    4.times do
      arrayPositionCounter = 4+columnCounter
      isShifted = [0,0,0,0 ,0,0,0,0 ,0,0,0,0, 0,0,0,0]
      #Checks max ArrPos
      until arrayPositionCounter == 16+columnCounter do

        #Check if there's a number to the right, if so; check which number. If its the same; merge else stay. If not, move number and reset field
        moveToCounter = 4
        4.times do

          #New variable to fix an issue with array length; Without, Ruby wouldnt work because theres an if-check checking an out of range array index
          arrPosC_minus_MoveTo = arrayPositionCounter-moveToCounter

          #Checks if any field to the right contains a number
          if grid[arrPosC_minus_MoveTo] > 0
            #If the number in the field and current "to-move"-field is the same; merge them together
            if grid[arrayPositionCounter] == grid[arrPosC_minus_MoveTo] 
              if isShifted[arrPosC_minus_MoveTo] == 0
                grid[arrPosC_minus_MoveTo] = 2*grid[arrayPositionCounter]
                grid[arrayPositionCounter] = 0
                isShifted[arrPosC_minus_MoveTo] = 1
                @somethingMoved = 1
                break
              else
                if isShifted[arrPosC_minus_MoveTo] == 1
                  if arrPosC_minus_MoveTo+4 != arrayPositionCounter
                    if grid[arrayPositionCounter] != 0
                      grid[arrPosC_minus_MoveTo+4] = grid[arrayPositionCounter] 
                      grid[arrayPositionCounter] = 0
                      isShifted[arrPosC_minus_MoveTo] = 1
                      @somethingMoved = 1
                    end
                  end
                  break
                end
              end
            #Else if there is a number but not the same; move to the field infront of the already taken one
            else
              #If the "to-move" field is the field infront of the next field with a value; do nothing
              if arrPosC_minus_MoveTo+4 != arrayPositionCounter
                if grid[arrayPositionCounter] != 0
                  grid[arrPosC_minus_MoveTo+4] = grid[arrayPositionCounter] 
                  grid[arrayPositionCounter] = 0
                  @somethingMoved = 1
                end
              end
              break
            end
          end
          #If there is no number to the right, move the "to-move"-field to the last possible field of the row
          moveToCounter += 4
          if moveToCounter == 16
            if grid[arrayPositionCounter] != 0
              grid[columnCounter] = grid[arrayPositionCounter]
              grid[arrayPositionCounter] = 0
              break
            end
          end
        end
        #Checks the min arrayPosCounter for each row
        if arrayPositionCounter >= columnCounter
          arrayPositionCounter += 4
        end
      end
      #Makes sure that columnCounter has a maximum value of 12
      if columnCounter != 4
          columnCounter += 1
      end
    end
    return grid
  end

  def generateRandomInt()
    #Generates either 2 or 4 | 90%/10%
    return ranInt = rand(0.0..1.0) < 0.9 ? 2 : 4
  end

  def addRandomNumber(grid)
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
    puts("w:Up a:Left s:Down d:Right\n")
    while true
      system("stty raw -echo")
      input = STDIN.getc.chr
      print(input)
      system("stty -raw echo")
      if input.downcase == "w" || input.downcase == "a" || input.downcase == "s" || input.downcase == "d"
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
    #Check if array is full of numbers.
    if grid.include? 0
      return false
    end
    #Check for every position if it has a neighbour which has the same value
    counter = 0
    16.times do
      if counter < 15 && counter != 3 && counter != 7 && counter != 11
        plusone = counter + 1
        if grid[plusone] == grid[counter]
          return false
        end
      end
      if counter > 0 && counter != 4 && counter != 8 && counter != 12
        minusone = counter - 1
        if grid[minusone] == grid[counter]
          return false
        end
      end
      if counter < 12
        plusfour = counter + 4
        if grid[plusfour] == grid[counter]
          return false
        end
      end
      if counter > 3
        minusfour = counter + 4
        if grid[minusfour] == grid[counter]
          return false
        end
      end
      counter += 1
    end
    return true
  end
  
  #User Interface
  def drawGrid(grid)
    #system "clear"
    print("\n")
    counter = 0
    #Draws the grids
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

