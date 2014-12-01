require("game.physic")

describe("Tests for the physic.lua :", function()
  
  describe("Tests for CurveY-function", function()
        
    it("Should not return nil", function()
        assert.is.not_nil(CurveY(1))       
    end)

    it("Should return an number type", function()  
      local expected = type(1)
      assert.are.same(expected, type(CurveY(1)))
    end)
    
    --Pending (Dont know how to check this things, but think it's good to test them
    --Good idea to have these test in all cases with numbers
    pending("Should be able to handle negative number value", function()      
        assert.has_no.errors(CurveY(-1))
    end)

    --Pending (Dont know how to check this things, but think it's good to test them
    --Good idea to have these test in all cases with numbers
    pending("Should be able to handle MAX_VALUE type", function()      
        assert.has_no.errors(CurveY(-1))
    end)
  end)

  describe ("Tests for getNewYStep", function()
    
    it("Should not be nil", function()     
      assert.is.not_nil(getNewYStep(1))
    end)
    
    it("Should return an number type", function()     
      local expected = type(1)
      assert.are.same(expected, type(getNewYStep(1)))
    end)
  end)

  describe ("Tests for getNewXStep", function()
    
    it("Should not be nil", function()
      assert.is.not_nil(getNewXStep(1))
    end)
    
    it("Should return an number type", function()      
      local expected = type(1)
      assert.are.same(expected, type(getNewXStep(1)))
    end)
  end)    

  describe ("Tests for CheckCollision2", function()
    
    it("Should not be nil", function()     
      assert.is.not_nil(CheckCollision2(1,1,1,1,1,1,1,1))
    end)
    
    it("Should return nil", function()    
    assert.is_nil(CheckCollision2(1,1,1,1,5,1,5,1))
    end)
  end)   

end)
