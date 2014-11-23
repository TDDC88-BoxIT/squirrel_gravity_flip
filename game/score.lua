nr_of_scores_saved = 5


--@desc: reads all the high scores saved in score_table.txt and saves them in a table
--@params: none
--@return: the number of levels that have been read (nr of unlocked lvs) 
--@author: Amanda Persson
function read_from_file()
  score_board={} 
  -- text file where score is saved is opened
  file = io.open("game/score_table.txt", "r")
  -- if the does not exist the ScoreTable will be empty, 
  if file ~= nil then 
    -- the scores stored in the file are read
    local player_i =1
    local score_or_name = "name"
    local player = ""
    local score = ""
    local level_reads
    -- iterates through all text in score_table
    for line in io.lines("game/score_table.txt") do
      s_line = tostring(line)
      -- checks whether the line contains the level,name or score and stores it as such
      if string.sub(s_line,1,5) == "level" then
        level_read = string.sub(s_line,6,string.len(s_line))
        score_board[tostring(level_read)] = {}
        player_i = 1
        score_or_name = "player"
      elseif score_or_name== "player" then
        player = s_line
        score_or_name= "score"
      elseif score_or_name == "score" then
        score = s_line
        score_or_name = "player"
        score_board[tostring(level_read)][tostring(player_i)] = {player,score}
        player_i = player_i+1 
      end
    end
    io.close(file)
    return level_read
  else
    return 0
  end
end  

--@desc: Saves the new score if it is good enough, scores are added in its correct position size-wise
--@params: player's name, score , level that has been played
--@author: Gustav Beck-Norén
function score_page(player,score,level)
  local unlocked_levels = read_from_file()
  if score_board[tostring(level)] == nil then
    score_board[tostring(level)] = {}
    unlocked_levels = unlocked_levels + 1
  end
  --if the score is good enough it is saved in its correct position which is given by the score
  for i=1,nr_of_scores_saved do
    if score_board[tostring(level)][tostring(i)]==nil then
      score_board[tostring(level)][tostring(i)]={player,score}
      break
    elseif score>= tonumber(score_board[tostring(level)][tostring(i)][2]) then
      for t=nr_of_scores_saved-1,1,-1 do 
        score_board[tostring(level)][tostring(t+1)] = score_board[tostring(level)][tostring(t)]
      end
      score_board[tostring(level)][tostring(i)]={player,score}
      break
    end
  end
  save_to_file(score_board, unlocked_levels)
end 


--@desc: Saves the entire table with score in score_table.txt , replaces earlier text
--@param: table with scores, and the number of levels that has been unlocked by the player
--@author: Amanda Persson
function save_to_file(score_board, unlocked_levels)
  -- if the file does not exist it is created
  file = io.open("game/score_table.txt","w+")
  io.output(file)
  --the table with the scores is written to the file
  for level_read=1, unlocked_levels do
    io.write("level".. tostring(level_read).."\n")
  -- for each level go through the level under here
    for player_i=1,table_length(score_board[tostring(level_read)]) do
      if score_board[tostring(level_read)][tostring(player_i)] ~= nil then
        io.write(score_board[tostring(level_read)][tostring(player_i)][1].."\n".. score_board[tostring(level_read)][tostring(player_i)][2].."\n") 
      end
    end
  end
  io.close(file)
end

--@desc: Finds length of a table
--@params: a table
--@return: length of table
--@author: Amanda Persson
function table_length(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end


--@desc: Draws a string in a pretty font on the screen
--@params: a string, coordinates where the text/numbers should be drawn
--@author: Amanda Persson
function draw_score(game_score, x_coordinate, y_coordinate )
  local string_score = tostring(game_score)
  position = 1
  -- loops through the score that is stored as a string
  while position <= string.len(string_score) do
    -- calls on the print function for the digit, sends the number as a string
    local symbol = string.sub(string_score,position,position)
    if symbol ~= " " then
      draw_number(symbol,position, x_coordinate, y_coordinate)
    end
    position = position + 1
  end
end


--@desc: Draws one character that is part of a string
--@params: a character, it's index in a string, coordinates
--@author: Amanda Persson
function draw_number(number, position, x_coordinate, y_coordinate)
-- loads the picture corresponding to the correct digit or letter. Feel free to refactor 
  if number == nil then
    number = "Z"
  end
  number = string.upper(number)
  score = gfx.loadpng("images/font/"..number..".png")
  -- prints the loaded picture
  screen:copyfrom(score,nil ,{x=x_coordinate+position*30, y = y_coordinate, height = 50, width = 30}, true)
  score:destroy()
end


--@desc: Draws the high score for a level on the screen
--@params: the level that the highscore should be shown for
--@author: Amanda Persson
function draw_highscore(level) 
  local position
  local x_coordinate = 620
  local y_coordinate
  read_from_file()
  index = 1
  i=1
  while score_board[tostring(level)][tostring(i)] ~= nil and index<=5  do
    y_coordinate = 300+60*(i-1)
    position = 1
    draw_score(score_board[tostring(level)][tostring(i)][1], 380, y_coordinate)
    string_score= score_board[tostring(level)][tostring(i)][2] 
    while position <= string.len(string_score) do
      draw_number(string.sub(string_score,position,position),position, x_coordinate, y_coordinate)
      position = position + 1
    end
    index = index +1
    i = i +1
  end  
end

