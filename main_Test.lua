-- NEEDED FILES FOR RUNNING THE TESTS
require("game.luaunit")
require("game.game")
require("game.input_handler")
require("game.level_handler")

--UNIT TESTS
require("game.tests.test_collision_handler")
require("game.tests.test_power_up")
require("game.tests.test_fail_and_success_handler")
require("game.tests.test_level_config")
require("game.tests.test_score")

--Try
os.exit(LuaUnit.run())
