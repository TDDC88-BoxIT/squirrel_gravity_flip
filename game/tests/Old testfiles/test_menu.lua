local love = require'Tests.mock_love'
require("gfx")
require("surface_class")

--screen = surface_class(love.graphics.getDimensions()) 

local test_menu = require("squirrel_game.menu")

--screen = surface_class(love.graphics.getDimensions())

describe("Makes sure that menu class variables are intilizaed properly", function()
    it("Should not be nil", function()
             
       assert.is.not_nil(t)
       
    end)
  end)
    

describe("Makes sure that the menu background surfaces are created properly", function()
    it("Should find correct file paths", function()
        
      assert.is.not_nil(test_menu.create_menu_background)
        
      end)
    end)
  
    
    