function get_squeezed()
  stop_game()
  if(check_alive()) then
  decrease_life()
  start_game(3,"story",get_lives())
end

end
