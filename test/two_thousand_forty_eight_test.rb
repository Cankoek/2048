require "test_helper"

describe TwoThousandFortyEight do
  subject { TwoThousandFortyEight }

=begin
  #-------------------------------------------------------------------------------------------------------------
  #ShiftRight Tests
  it "1. Basic shiftRight Test" do 
    assert_equal [0,0,0,2 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shift([2,0,0,0 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0],"d")
  end

  it "2. Basic shiftRight Test" do 
    assert_equal [0,0,0,2 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shift([0,0,0,2 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0],"d")
  end

  it "Basic shiftRight Merge" do
    assert_equal [0,0,0,4 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shift([2,0,0,2 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0],"d")
  end

  it "shiftRight with four equal tiles" do
    assert_equal [0,0,4,4 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shift([2,2,2,2 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0],"d")
  end

  it "shiftRight three consecutive tiles" do
    assert_equal [0,0,2,4 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shift([0,2,2,2 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0],"d")
  end

  it "shiftRight resulting tile cannot merge" do
    assert_equal [0,0,8,8 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shift([8,0,4,4 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0],"d")
  end

  #-------------------------------------------------------------------------------------------------------------
  #ShiftLeft Test
  it "1.Basic shiftLeft Test" do 
    assert_equal [2,0,0,0 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shift([0,0,0,2 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0],"a")
  end

  it "2. Basic shiftLeft Test" do 
    assert_equal [2,0,0,0 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shift([2,0,0,0 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0],"a")
  end

  it "Basic shiftLeft Merge" do
    assert_equal [4,0,0,0 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shift([2,2,0,0 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0],"a")
  end

  it "shiftLeft with four equal tiles" do
    assert_equal [4,4,0,0 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shift([2,2,2,2 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0],"a")
  end

  it "shiftLeft three consecutive tiles" do
    assert_equal [4,2,0,0 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shift([0,2,2,2 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0],"a")
  end

  it "shiftLeft resulting tile cannot merge" do
    assert_equal [8,8,0,0 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shift([4,4,0,8 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0],"a")
  end

  #-------------------------------------------------------------------------------------------------------------
  #ShiftDown Test
  it "1. Basic shiftDown Test" do 
    assert_equal [0,0,0,0 ,0,0,0,0 ,0,0,0,0 ,2,0,0,0], subject.shift([2,0,0,0 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0],"s")
  end

  it "2. Basic shiftDown Test" do 
    assert_equal [0,0,0,0 ,0,0,0,0 ,0,0,0,0 ,2,0,0,0], subject.shift([0,0,0,0 ,0,0,0,0 ,0,0,0,0 ,2,0,0,0],"s")
  end

  it "Basic shiftDown Merge" do
    assert_equal [0,0,0,0 ,0,0,0,0 ,0,0,0,0 ,4,0,0,0], subject.shift([2,0,0,0 ,2,0,0,0 ,0,0,0,0 ,0,0,0,0],"s")
  end

  it "shiftDown with four equal tiles" do
    assert_equal [0,0,0,0 ,0,0,0,0 ,4,0,0,0 ,4,0,0,0], subject.shift([2,0,0,0 ,2,0,0,0 ,2,0,0,0 ,2,0,0,0],"s")
  end

  it "shiftDown three consecutive tiles" do
    assert_equal [0,0,0,0 ,0,0,0,0 ,2,0,0,0 ,4,0,0,0], subject.shift([2,0,0,0 ,2,0,0,0 ,2,0,0,0 ,0,0,0,0],"s")
  end

  it "shiftDown resulting tile cannot merge" do
    assert_equal [0,0,0,0 ,0,0,0,0 ,8,0,0,0 ,8,0,0,0], subject.shift([8,0,0,0 ,0,0,0,0 ,4,0,0,0 ,4,0,0,0],"s")
  end

  #-------------------------------------------------------------------------------------------------------------
  #ShiftUp Test
  it "1. Basic shiftUp Test" do 
    assert_equal [2,0,0,0 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shift([0,0,0,0 ,0,0,0,0 ,0,0,0,0 ,2,0,0,0],"w")
  end

  it "2. Basic shiftUp Test" do 
    assert_equal [2,0,0,0 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shift([2,0,0,0 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0],"w")
  end

  it "Basic shiftUp Merge" do
    assert_equal [4,0,0,0 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shift([0,0,0,0 ,0,0,0,0 ,2,0,0,0 ,2,0,0,0],"w")
  end

  it "shiftUp with four equal tiles" do
    assert_equal [4,0,0,0 ,4,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shift([2,0,0,0 ,2,0,0,0 ,2,0,0,0 ,2,0,0,0],"w")
  end

  it "shiftUp three consecutive tiles" do
    assert_equal [4,0,0,0 ,2,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shift([2,0,0,0 ,2,0,0,0 ,2,0,0,0 ,0,0,0,0],"w")
  end

  it "shiftUp resulting tile cannot merge" do
    assert_equal [8,0,0,0 ,8,0,0,0 ,0,0,0,0 ,0,0,0,0], subject.shift([4,0,0,0 ,4,0,0,0 ,0,0,0,0 ,8,0,0,0],"w")
  end
=end
  #-------------------------------------------------------------------------------------------------------------
  #Loose Test
  it "Lose test >> Actual lose" do
    assert_equal true, subject.lost?([1,2,3,4 ,5,6,7,8 ,9,10,11,12 ,13,14,15,16])
  end

  it "Lose test >> Not an actual lose (shiftRight)" do
    assert_equal false, subject.lost?([1,1,3,4 ,5,6,7,8 ,9,10,11,12 ,13,14,15,16])
  end

  it "Lose test >> Not an actual lose (shiftLeft)" do
    assert_equal false, subject.lost?([1,2,3,3 ,5,6,7,8 ,9,10,11,12 ,13,14,15,16])
  end

  it "Lose test >> Not an actual lose (shiftDown)" do
    assert_equal false, subject.lost?([1,2,3,4 ,1,6,7,8 ,9,10,11,12 ,13,14,15,16])
  end

  it "Lose test >> Not an actual lose (shiftUp)" do
    assert_equal false, subject.lost?([1,2,3,4 ,5,6,7,8 ,13,10,11,12 ,13,14,15,16])
  end

  #-------------------------------------------------------------------------------------------------------------
  #Win test
  it "Win test >> Actual win" do
    assert_equal true, subject.won?([2048,0,0,0 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0])
  end
  it "Win test >> Not an actual win" do
    assert_equal false, subject.won?([0,0,0,0 ,0,0,0,0 ,0,0,0,0 ,0,0,0,0])
  end

end