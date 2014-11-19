
-- READS THE UNLOCKED LEVEL FROM THE SPECIFIED FILE
function read_unlocked_level()
	local file_path = "game/score_table.txt"
	local unlocked_level = nil

	file = io.open(file_path, "r")

	for line in file:lines() do 
      	if string.sub(line,1,5) == "level" then
			unlocked_level = string.sub(line,6,string.len(line))
		end
	end

	file:close()
	return unlocked_level
end
