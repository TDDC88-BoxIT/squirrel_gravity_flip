

function read_from_file()
  ScoreBoard={} 
  -- text file where score is saved is opened
  file = io.open("game/score_table.txt", "r")
  -- if the does not exist the ScoreTable will be empty, 
  if file == nil then 
    ScoreBoard = {}
  else
    -- the scores stored in the file are read
    local i =1
    for line in io.lines("game/score_table.txt") do
      -- this assumes that we keep the player names as 3 letters
      s_line = tostring(line)
      local player = string.sub(s_line,1,3)
      local score = tonumber(string.sub(s_line,4,string.len(s_line)))
      ScoreBoard[i] = {player,score}
      i = i+1 
    end
    io.close(file)
  end
end  

function score_page(name,score)
  read_from_file()
  local nr_of_scores_svd = 11
  for i=1,nr_of_scores_svd do
    if ScoreBoard[i]==nil then
        -- if there is space left, the score is saved
        ScoreBoard[i]={name,score}
        break
    end
  end
  if table_length(ScoreBoard)>2 then
    -- the score is compared to earlier scores and then stored if it's good enough 
    local comp = function(a,b)
        return a[2] > b[2]
    end
    table.sort(ScoreBoard, comp)
    table.remove(ScoreBoard,11)
  end 
  save_to_file(ScoreBoard, file)
end 

function save_to_file(ScoreBoard, file)
  -- if the file does not exist it is created
  file = io.open("game/score_table.txt","w+")
  io.output(file)
  --the table with the scores is written to the file
  for i=1,table_length(ScoreBoard) do
    io.write(ScoreBoard[i][1] .. tostring(ScoreBoard[i][2]) .. "\n")
  end
  io.close(file)
end


function table_length(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end


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