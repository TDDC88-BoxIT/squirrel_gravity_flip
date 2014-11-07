--ScoreBoard={}
function ScorePage(name,score)
  
ScoreBoard={{"HanxiaoA",100},{"OskarA",500},{"AmandaA",300},{"TedA",700},{"TiktokA",150},{"HanxiaoB",200},{"OskarB",1500},{"AmandaB",1300},{"TedB",1700},{"TiktokB",1150},{"test buddy",50}}--for test

  for i=1,11 do
    if ScoreBoard[i]==nil then
        ScoreBoard[i]={name,score}
        break
    end
  end
  local comp = function(a,b)
      return a[2] > b[2] 
  end
  table.sort(ScoreBoard, comp)
  
  for i=1, #(ScoreBoard) do
    if i==11 then
      break
    end
    print(ScoreBoard[i][1],ScoreBoard[i][2])
  end
end 
