nr_of_scores_saved = 5

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
    for line in io.lines("game/score_table.txt") do
      s_line = tostring(line)
      if string.sub(s_line,1,5) == "level" then
        level_read = string.sub(s_line,6,string.len(s_line))
        score_board[tostring(level_read)] = {}
        score_or_name = "player"
      elseif score_or_name== "player" then
        player = s_line
        score_or_name= "score"
      elseif score_or_name == "score" then
        score = s_line
        score_or_name = "player"
        print("score")
        print(score)
        print("level_read")
        print(level_read)
        print("player_i")
        print(player_i)
        print("player")
        print(player)
        print("level_read")
        print(level_read)
        score_board[tostring(level_read)][tostring(player_i)] = {player,score}
        player_i = player_i+1 
      end
    end
    io.close(file)
    print("level_read")
    print(level_read)
    return level_read
  else
    return 0
  end
end  

function score_page(player,score,level)
  local unlocked_levels = read_from_file()
  if score_board[tostring(level)] == nil then
    score_board[tostring(level)] = {}
    unlocked_levels = unlocked_levels + 1
  end
  print("unlocked_levels")
  print(unlocked_levels)
  for i=1,nr_of_scores_saved do
    if score_board[tostring(level)][tostring(i)]==nil then
      score_board[tostring(level)][tostring(i)]={player,score}
      print(score_board[tostring(level)][tostring(i)][1])
      print(score_board[tostring(level)][tostring(i)][2])
      break
    elseif score>= tonumber(score_board[tostring(level)][tostring(i)][2]) then
      for t=nr_of_scores_saved,2,-1 do 
        score_board[tostring(level)][tostring(t)] = score_board[tostring(level)][tostring(t+1)]
      end
      score_board[tostring(level)][tostring(i)]={player,score}
      print(score_board[tostring(level)][tostring(i)][1])
      print(score_board[tostring(level)][tostring(i)][2])
      break
    end
  end
  save_to_file(score_board, file, unlocked_levels)
end 

function insert_score(index)

end


function save_to_file(score_board, file, unlocked_levels)
  print("score_board")
  print(score_board)
  -- if the file does not exist it is created
  file = io.open("game/score_table.txt","w+")
  io.output(file)
  --the table with the scores is written to the file
  print ("table_length(score_board)")
  print (table_length(score_board))
  for level_read=1, unlocked_levels do
    io.write("level".. tostring(level_read).."\n")
  -- for each level go through the level under here
    print ("table_length(score_board[(level_read)])")
    print (table_length(score_board[tostring(level_read)]))
    for player_i=1,table_length(score_board[tostring(level_read)]) do
      print("loop index")
      print(player_i)
      if score_board[tostring(level_read)][tostring(player_i)] ~= nil then
        print("score_board[tostring(level_read)][tostring(player_i)][1]")
        print(score_board[tostring(level_read)][tostring(player_i)][1])
        print("score_board[tostring(level_read)][tostring(player_i)][2]")
        print(score_board[tostring(level_read)][tostring(player_i)][2])
        io.write(score_board[tostring(level_read)][tostring(player_i)][1].."\n".. score_board[tostring(level_read)][tostring(player_i)][2].."\n") 
      end
    end
  end
  io.close(file)
end


function table_length(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end


function draw_number(number, position)
-- loads the picture corresponding to the correct digit
  if number == "0"  then score = gfx.loadpng("images/numbers/zero.png")
  elseif number == "1" then 
    score = gfx.loadpng("images/numbers/one.png")
  elseif number == "2" then 
    score = gfx.loadpng("images/numbers/two.png")
  elseif number == "3" then 
    score = gfx.loadpng("images/numbers/three.png")
  elseif number == "4" then 
    score = gfx.loadpng("images/numbers/four.png")
  elseif number == "5" then 
    score = gfx.loadpng("images/numbers/five.png")
  elseif number == "6" then 
    score = gfx.loadpng("images/numbers/six.png")
  elseif number == "7" then 
    score = gfx.loadpng("images/numbers/seven.png")
  elseif number == "8" then 
    score = gfx.loadpng("images/numbers/eight.png") 
  elseif number == "9" then 
    score = gfx.loadpng("images/numbers/nine.png")
  end
  -- prints the loaded picture
  screen:copyfrom(score,nil ,{x=10+position*30, y = 10, height = 50, width = 30}, true)
  score:destroy()
end


--the function that draws the score in the top left score 
function draw_score(game_score)
  local string_score = tostring(game_score)
  position = 1
  -- loops through the score that is stored as a string
  while position <= string.len(string_score) do
    -- calls on the print function for the digit, sends the number as a string
    draw_number(string.sub(string_score,position,position),position)
    position = position + 1
  end
end

