module TwoThousandFortyEight
  def self.run
    game()
    true
  end
end

"""
Idea:
Initialize Array with 16 entries 'visualizing' the 16 squares for the numbers.
Moves just calculate the new position on for each number on the array.
->  If a number collides with another while moving: 
    Check if the number's the same, if so, merge.
    Else just put the currently moving number behind the other

    Example; moveRight()
    2 | 2 | 0 | 4 >>  0 | 0 | 4 | 4
    2 | 2 | 0 | 0 >>  0 | 0 | 0 | 4
    2 | 0 | 0 | 8 >>  0 | 0 | 2 | 8

For visualization purposes: Create a new function drawing the array in a fancy way, add a points counter.

To-do:
  Add basic game logic 
  Add moveRight, moveLeft #moveRight done
  Add moveUp, moveDown
  Add function to create random numbers at random spots
  Add a basic UI for testing
  Add user input
  Improve move functions & overall game logic
  Improve the UI
  Add win condition at 2048
  Add a points counter
"""

#Game functions

def game()
  fieldArray = [8,8,0,0 ,0,2,0,2 ,2,2,2,2 ,2,4,0,0 ,0,0,0]
  drawField(fieldArray)
  print("\n")
  drawField(moveRight(fieldArray))
  return
end

def moveRight(field)
  rowCounter = 0
  4.times do
    arrayPositionCounter = 2+rowCounter
    
    until arrayPositionCounter == -1+rowCounter do

      #Check if there's a number to the right, if so; check which number. If its the same; merge else stay. If not, move number and reset field
      moveToCounter = 1
      4.times do
        #Checks if any field to the right contains a number
        if field[arrayPositionCounter+moveToCounter] > 0
          #If the number in the field and current "to-move"-field is the same; merge them together
          if field[arrayPositionCounter] == field[arrayPositionCounter+moveToCounter]
            field[arrayPositionCounter+moveToCounter] = 2*field[arrayPositionCounter]
            field[arrayPositionCounter] = 0
            break
          #Else if there is a number but not the same; move to the field infront of the already taken one
          else
            field[arrayPositionCounter+moveToCounter-1] = field[arrayPositionCounter]
            field[arrayPositionCounter] = 0
            break
          end
        end
        #If there is no number to the right, move the "to-move"-field to the last possible field of the row
        moveToCounter += 1
        if moveToCounter == 4
          field[3+rowCounter] = field[arrayPositionCounter]
          field[arrayPositionCounter] = 0
          break
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
  return field
end

def moveLeft(field)
  return field
end

def moveUp(field)
  return field
end

def moveDown(field)
  return field
end

#UI

def drawField(field)
  counter = 0
  16.times do
    print(field[counter])
    print(" | ")
    if counter == 3 or counter == 7 or counter == 11 or counter == 15
      print("\n")
    end
    counter += 1
  end
  return
end