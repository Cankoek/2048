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
  Add moveRight, moveLeft
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
  fieldArray = [2,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0]
  print(fieldArray)
  print("\n")
  print(moveRight(fieldArray))
  return
end

def moveRight(field)
  arrayPositionCounter = 2

  until arrayPositionCounter < 0 do
    #Check if there's a number to the right, if so; check which number. If its the same; merge else stay. If not, move number and reset field
    if field[arrayPositionCounter+1] > 0
      if field[arrayPositionCounter+1] == field[arrayPositionCounter]
        field[arrayPositionCounter+1] = 2*field[arrayPositionCounter]
        field[arrayPositionCounter] = 0
      end
    else
      field[arrayPositionCounter+1] = field[arrayPositionCounter]
      field[arrayPositionCounter] = 0
    end

    arrayPositionCounter -= 1
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
  return
end