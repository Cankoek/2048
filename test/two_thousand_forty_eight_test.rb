require "test_helper"

describe TwoThousandFortyEight do
  subject { TwoThousandFortyEight }

  #-------------------------------------------------------------------------------------------------------------
  #ShiftRight Tests
  it "Basic shiftRight Test" do 
    assert_equal [0,0,0,2 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shiftRight([2,0,0,0 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0])
  end

  it "Basic shiftRight Merge" do
    assert_equal [0,0,0,4 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shiftRight([2,0,0,2 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0])
  end

  it "shiftRight with four equal tiles" do
    assert_equal [0,0,4,4 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shiftRight([2,2,2,2 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0])
  end

  it "shiftRight three consecutive tiles" do
    assert_equal [0,0,2,4 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shiftRight([0,2,2,2 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0])
  end

  it "shiftRight resulting tile cannot merge" do
    assert_equal [0,0,8,8 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shiftRight([8,0,4,4 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0])
  end

  #-------------------------------------------------------------------------------------------------------------
  #ShiftLeft Test
  it "Basic shiftLeft Test" do 
    assert_equal [2,0,0,0 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shiftLeft([0,0,0,2 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0])
  end

  it "Basic shiftLeft Merge" do
    assert_equal [4,0,0,0 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shiftLeft([2,2,0,0 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0])
  end

  it "shiftLeft with four equal tiles" do
    assert_equal [4,4,0,0 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shiftLeft([2,2,2,2 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0])
  end

  it "shiftLeft three consecutive tiles" do
    assert_equal [4,2,0,0 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shiftLeft([0,2,2,2 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0])
  end

  it "shiftLeft resulting tile cannot merge" do
    assert_equal [8,8,0,0 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shiftLeft([4,4,0,8 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0])
  end

  #-------------------------------------------------------------------------------------------------------------
  #ShiftDown Test
  it "Basic shiftDown Test" do 
    assert_equal [0,0,0,0 ,0,0,0,0 ,0,0,0,0 ,2,0,0,0], subject.shiftDown([2,0,0,0 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0])
  end

  it "Basic shiftDown Merge" do
    assert_equal [0,0,0,0 ,0,0,0,0 ,0,0,0,0 ,4,0,0,0], subject.shiftDown([2,0,0,0 ,2,0,0,0 ,0,0,0,0 ,0,0,0,0])
  end

  it "shiftDown with four equal tiles" do
    assert_equal [0,0,0,0 ,0,0,0,0 ,4,0,0,0 ,4,0,0,0], subject.shiftDown([2,0,0,0 ,2,0,0,0 ,2,0,0,0 ,2,0,0,0])
  end

  it "shiftDown three consecutive tiles" do
    assert_equal [0,0,0,0 ,0,0,0,0 ,2,0,0,0 ,4,0,0,0], subject.shiftDown([2,0,0,0 ,2,0,0,0 ,2,0,0,0 ,0,0,0,0])
  end

  it "shiftDown resulting tile cannot merge" do
    assert_equal [0,0,0,0 ,0,0,0,0 ,8,0,0,0 ,8,0,0,0], subject.shiftDown([8,0,0,0 ,0,0,0,0 ,4,0,0,0 ,4,0,0,0])
  end

  #-------------------------------------------------------------------------------------------------------------
  #ShiftUp Test
  it "Basic shiftUp Test" do 
    assert_equal [2,0,0,0 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shiftUp([0,0,0,0 ,0,0,0,0 ,0,0,0,0 ,2,0,0,0])
  end

  it "Basic shiftUp Merge" do
    assert_equal [4,0,0,0 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shiftUp([0,0,0,0 ,0,0,0,0 ,2,0,0,0 ,2,0,0,0])
  end

  it "shiftUp with four equal tiles" do
    assert_equal [4,0,0,0 ,4,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shiftUp([2,0,0,0 ,2,0,0,0 ,2,0,0,0 ,2,0,0,0])
  end

  it "shiftUp three consecutive tiles" do
    assert_equal [4,0,0,0 ,2,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shiftUp([2,0,0,0 ,2,0,0,0 ,2,0,0,0 ,0,0,0,0])
  end

  it "shiftUp resulting tile cannot merge" do
    assert_equal [8,0,0,0 ,8,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shiftUp([4,0,0,0 ,4,0,0,0 ,0,0,0,0 ,8,0,0,0])
  end

  #-------------------------------------------------------------------------------------------------------------


  it "Point Counter test" do
    subject.resetPoints()
    assert_equal 4, subject.addPoints(4)
  end
  
  it "runs" do
    subject.run
  end


end