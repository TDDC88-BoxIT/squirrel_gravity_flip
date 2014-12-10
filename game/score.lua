nr_of_scores_saved = 5

--@desc: reads all the high scores saved in score_table.txt and saves them in a table
--@params: none
--@return: the number of levels that have been read (nr of unlocked lvs) 
--@author: Amanda Persson
function read_from_file()
  local score_board={} 
  -- text file where score is saved is opened
  file = io.open(file_prefix.."game/score_table.txt", "r")
  -- if the does not exist the ScoreTable will be empty, 
  if file ~= nil then 
    -- the scores stored in the file are read
    local player_i =1
    local player
    local score
    local level_reads
    -- iterates through all text in score_table
    for line in io.lines(file_prefix.."game/score_table.txt") do
      --line = tostring(line)
      -- checks whether the line contains the level,name or score and stores it as such
      if string.sub(line,1,5) == "level" then
        level_read = tonumber(string.sub(line,6,string.len(line)))
        score_board[level_read] = {}
        player_i = 1
      else
        player = string.sub(line,1,3)
        score = string.sub(line,5,string.len(line))
        score_board[level_read][player_i] = {pl = player,sc = score}
        player_i = player_i+1 
      end
    end
    io.close(file)
    --return level_read
    return score_board
  else
    return 0
  end
end  

--@desc: Saves the new score if it is good enough, scores are added in its correct position size-wise
--@params: player's name, score , level that has been played
--@author: 
function score_page(player,score,level)
  local sco = score
  local unlocked_levels
  local new_high_score = false
  -- GET SCOREBOARD FROM FILE
  local score_board = read_from_file()
  -- CHECK IF THERE ARE SOME PREVIOUS SCORES FROM THE LEVEL
  if score_board[level] == nil then
    score_board[level] = {}
  end
  unlocked_levels = #score_board
  --if the score is good enough it is saved in its correct position which is given by the score
  for i=1, nr_of_scores_saved do
    if score_board[level][i]==nil then
      score_board[level][i]={pl=player,sc=sco}
      break
    elseif sco>= tonumber(score_board[level][i].sc)  then
      -- TEMPORARILY SAVING THE SCORE IN THE SCOREBOARD TO BE ABLE TO MOVIE IT DOWN IN THE SCOREBOARD 
      local temp_sc = tonumber(score_board[level][i].sc)
      local temp_pl = score_board[level][i].pl
      -- ADDING THE NEW SCORE TO THE SCOREBOARD
      score_board[level][i]={pl = player,sc = sco}
      -- PUTTING THE TEMPORARY SCORE BACK AS THE SCORE VARIABLE AND CONTINUE THE FOR-LOOP
      sco = temp_sc
      player = temp_pl
    end
  end
  save_to_file(score_board)
end 


--@desc: Saves the entire table with score in score_table.txt , replaces earlier text
--@param: table with scores, and the number of levels that has been unlocked by the player
--@author: Amanda Persson
function save_to_file(score_board)
  -- if the file does not exist it is created
  file = io.open(file_prefix.."game/score_table.txt","w+")
  if file~=nil then
    io.output(file)
    --the table with the scores is written to the file
    for level_read=1, #score_board do
      io.write("level"..level_read.."\n")
      -- for each level go through the level under here
      for player_i=1,#score_board[level_read] do
        if score_board[level_read][player_i] ~= nil then
          io.write(score_board[level_read][player_i].pl.." "..score_board[level_read][player_i].sc.."\n") 
        end
      end
    end
    io.close(file)
  end
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

  -- Treat Numbers and Letters differently.
  -- Cause we have to draw Number every frame in the game,
  -- load them each time is too expensive, we buffer the Number, but not letters.
  if ((number >= "0" and number <= "9") or number == "A") and number_image[number] ~= nil then
    score = number_image[number]
  else
    score = gfx.loadpng("images/font/"..number..".png")
  end
  score:premultiply()
  -- prints the loaded picture
  screen:copyfrom(score,nil ,{x=x_coordinate+position*30, y = y_coordinate, height = 50, width = 30}, true)
  if number >= "0" and number <= "9" then
    score = nil
  else
    score:destroy()
  end
end


--@desc: Draws the high score for a level on the screen
--@params: the level that the highscore should be shown for, x-coordinate
--@author: Amanda Persson
function draw_highscore(level, x_coordinate) 
  local position
  local y_coordinate
  local score_board=read_from_file()
  index = 1
  i=1
  for i=1, #score_board[level] do
    y_coordinate = 180+60*(i-1)
    position = 1
    draw_score(score_board[level][i].pl, x_coordinate + 200, y_coordinate)
    string_score= score_board[level][i].sc
    while position <= string.len(string_score) do
      draw_number(string.sub(string_score,position,position),position, x_coordinate, y_coordinate)
      position = position + 1
    end
    index = index +1
    i = i +1
  end  
end

