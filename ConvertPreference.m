% ConvertPreference - Convert the GAME_COST_MATRIX to player preferred strategies
%                     For defender, minimal value is preferred
%                     For attackers, maximal value is preferred
% 
% Syntax:  [ CONVERTED_GAME_COST_MATRIX ] = ConvertPreference( GAME_COST_MATRIX, player )
% 
% Inputs:
%    GAME_COST_MATRIX - 3-D GAME COST MATRIX
%    player           - attacker1, attacker2, or defender
% 
% Outputs:
%    CONVERTED_GAME_COST_MATRIX - Converted GAME_COST_MATRIX to player preferred strategies
% 
% -----------------------------------------------------------------------------
function [ CONVERTED_GAME_COST_MATRIX ] = ConvertPreference( GAME_COST_MATRIX, player )

  % COLLECT THE GAME_COST_MATRIX DIMENTIONS FOR EACH PLAYER
  [size_defender,size_attacker1,size_attacker2] = size(GAME_COST_MATRIX);

  CONVERTED_GAME_COST_MATRIX = zeros(size_defender,size_attacker1,size_attacker2);

  for x = 1:size_defender
      for y = 1:size_attacker1
          for z = 1:size_attacker2
              CONVERTED_GAME_COST_MATRIX(x,y,z) = PlayerPreference(player, GAME_COST_MATRIX(x,y,z));
          end % for
      end % for
  end % for

end % function