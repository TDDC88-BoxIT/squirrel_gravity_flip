require("game.level_handler")

describe("Tests for the level_handler.lua :", function()
    
describe ("Tests for CheckCollision", function()
    
    it("Should not be nil", function()     
      assert.is.not_nil(CheckCollision(1,1,1,1,1,1,1,1,1,1))
    end)
    
    it("Should return nil", function()    
    assert.is_nil(CheckCollision(1,1,1,1,5,1,5,1,1,1))
    end)
  end) 

end)