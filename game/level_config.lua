
-- READS THE UNLOCKED LEVEL FROM THE SPECIFIED FILE. RETURNS AN INTEGER
function read_unlocked_level()
	local file_path = file_prefix .. "game/score_table.txt"
	local unlocked_level = nil
	file = io.open(file_path, "r")
  while true do
    local line = file:read()
    if not line then break end
    if string.sub(line,1,5) == "level" then
			unlocked_level = tonumber(string.sub(line,6,string.len(line)))
    end
  end

	file:close()
	return unlocked_level
end
