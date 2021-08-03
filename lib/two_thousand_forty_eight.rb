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
  Add moveRight, moveLeft #Done
  Add moveUp, moveDown  #Done
  Add function to create random numbers at random spots
  Add a basic UI for testing #Done
  Add user input
  Improve move functions & overall game logic
  Improve the UI
  Add win condition at 2048
  Add a points counter
"""

#Game functions

def game()
  fieldArray = [2,2,0,4 ,2,2,0,2 ,0,2,2,2 ,4,2,2,2] 
  isShifted = [0,0,0,0 ,0,0,0,0 ,0,0,0,0, 0,0,0,0 ]
  drawField(fieldArray)
  print("\n")
  drawField(shiftUp(fieldArray))
  return
end

def shiftRight(field)
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
        if field[arrPosC_plus_MoveTo] > 0
          #If the number in the field and current "to-move"-field is the same; merge them together
          if field[arrayPositionCounter] == field[arrPosC_plus_MoveTo] 
            if isShifted[arrPosC_plus_MoveTo] == 0
              field[arrPosC_plus_MoveTo] = 2*field[arrayPositionCounter]
              field[arrayPositionCounter] = 0
              isShifted[arrPosC_plus_MoveTo] = 1
              break
            else
              if isShifted[arrPosC_plus_MoveTo] == 1
                if arrPosC_plus_MoveTo-1 != arrayPositionCounter
                  field[arrPosC_plus_MoveTo-1] = field[arrayPositionCounter] 
                  field[arrayPositionCounter] = 0
                  isShifted[arrPosC_plus_MoveTo] = 1
                end
                break
              end
            end
          #Else if there is a number but not the same; move to the field infront of the already taken one
          else
            #If the "to-move" field is the field infront of the next field with a value; do nothing
            if arrPosC_plus_MoveTo-1 != arrayPositionCounter
              field[arrPosC_plus_MoveTo-1] = field[arrayPositionCounter] 
              field[arrayPositionCounter] = 0
            end
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

def shiftLeft(field)
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
        if field[arrPosC_minus_MoveTo] > 0
          #If the number in the field and current "to-move"-field is the same; merge them together
          if field[arrayPositionCounter] == field[arrPosC_minus_MoveTo] 
            if isShifted[arrPosC_minus_MoveTo] == 0
              field[arrPosC_minus_MoveTo] = 2*field[arrayPositionCounter]
              field[arrayPositionCounter] = 0
              isShifted[arrPosC_minus_MoveTo] = 1
              break
            else
              if isShifted[arrPosC_minus_MoveTo] == 1
                if arrPosC_minus_MoveTo+1 != arrayPositionCounter
                  field[arrPosC_minus_MoveTo+1] = field[arrayPositionCounter] 
                  field[arrayPositionCounter] = 0
                  isShifted[arrPosC_minus_MoveTo] = 1
                end
                break
              end
            end
          #Else if there is a number but not the same; move to the field infront of the already taken one
          else
            #If the "to-move" field is the field infront of the next field with a value; do nothing
            if arrPosC_minus_MoveTo+1 != arrayPositionCounter
              field[arrPosC_minus_MoveTo+1] = field[arrayPositionCounter]
              field[arrayPositionCounter] = 0
            end
            break
          end
        end
        #If there is no number to the left, move the "to-move"-field to the last possible field of the row
        moveToCounter += 1
        if moveToCounter == 4
          field[rowCounter] = field[arrayPositionCounter]
          field[arrayPositionCounter] = 0
          
          break
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
  return field
end

def shiftDown(field)
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
        if field[arrPosC_plus_MoveTo] > 0
          #If the number in the field and current "to-move"-field is the same; merge them together
          if field[arrayPositionCounter] == field[arrPosC_plus_MoveTo] 
            if isShifted[arrPosC_plus_MoveTo] == 0
              field[arrPosC_plus_MoveTo] = 2*field[arrayPositionCounter]
              field[arrayPositionCounter] = 0
              isShifted[arrPosC_plus_MoveTo] = 1
              break
            else
              if isShifted[arrPosC_plus_MoveTo] == 1
                if arrPosC_plus_MoveTo-4 != arrayPositionCounter
                  field[arrPosC_plus_MoveTo-4] = field[arrayPositionCounter] 
                  field[arrayPositionCounter] = 0
                  isShifted[arrPosC_plus_MoveTo] = 1
                end
                break
              end
            end
          #Else if there is a number but not the same; move to the field infront of the already taken one
          else
            #If the "to-move" field is the field infront of the next field with a value; do nothing
            if arrPosC_plus_MoveTo-4 != arrayPositionCounter
              field[arrPosC_plus_MoveTo-4] = field[arrayPositionCounter] 
              field[arrayPositionCounter] = 0
            end
            break
          end
        end
        #If there is no number to the right, move the "to-move"-field to the last possible field of the row
        moveToCounter += 4
        if moveToCounter == 16
          field[12+columnCounter] = field[arrayPositionCounter]
          field[arrayPositionCounter] = 0
          break
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
  return field
end

def shiftUp(field)
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
        if field[arrPosC_minus_MoveTo] > 0
          #If the number in the field and current "to-move"-field is the same; merge them together
          if field[arrayPositionCounter] == field[arrPosC_minus_MoveTo] 
            if isShifted[arrPosC_minus_MoveTo] == 0
              field[arrPosC_minus_MoveTo] = 2*field[arrayPositionCounter]
              field[arrayPositionCounter] = 0
              isShifted[arrPosC_minus_MoveTo] = 1
              break
            else
              if isShifted[arrPosC_minus_MoveTo] == 1
                if arrPosC_minus_MoveTo+4 != arrayPositionCounter
                  field[arrPosC_minus_MoveTo+4] = field[arrayPositionCounter] 
                  field[arrayPositionCounter] = 0
                  isShifted[arrPosC_minus_MoveTo] = 1
                end
                break
              end
            end
          #Else if there is a number but not the same; move to the field infront of the already taken one
          else
            #If the "to-move" field is the field infront of the next field with a value; do nothing
            if arrPosC_minus_MoveTo+4 != arrayPositionCounter
              field[arrPosC_minus_MoveTo+4] = field[arrayPositionCounter] 
              field[arrayPositionCounter] = 0
            end
            break
          end
        end
        #If there is no number to the right, move the "to-move"-field to the last possible field of the row
        moveToCounter += 4
        if moveToCounter == 16
          field[columnCounter] = field[arrayPositionCounter]
          field[arrayPositionCounter] = 0
          break
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
  return field
end


#UI

def drawField(field)
  counter = 0
  #Prints the 16 entries of the fieldArray
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