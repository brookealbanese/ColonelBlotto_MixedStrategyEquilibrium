% PlayerPreference - Coverts payoff values to preference values based on player
%                    This is done to allow interger comparisions to identify dominant
%                    strategies for each player.
%                    For defender, minimal value is preferred
%                    For attackers, maximal value is preferred
% 
% Syntax:  [ preference_value ] = PlayerPreference( player, payoff_value )
% 
% Inputs:
%    player       - attacker1, attacker2, or defender
%    payoff_value - single payoff value of game cost matrix
% 
% Outputs:
%    preference_value - player preference value based on payoff value
% 
% -----------------------------------------------------------------------------
function [ preference_value ] = PlayerPreference( player, payoff_value )

  % DEFENDER
  if strcmp(player, 'defender') % FOR DEFENDER, MINIMAL VALUE IS PREFERRED
      if payoff_value == -1     % DEFENDER WON
          preference_value = 0;   % MOST PREFERRED
      elseif payoff_value == 0  % DEFENDER PARTIAL LOSS
          preference_value = 1;
      elseif payoff_value == 1  % DEFENDER PARTIAL LOSS
          preference_value = 1;
      else                      % DEFENDER LOSS
          preference_value = 2;   % LEAST PREFERRED
      end % if
  % ATTACKER1
  elseif strcmp(player, 'attacker1') % FOR ATTACKERS, MAXIMAL VALUE IS PREFERRED
      preference_value = payoff_value; % ATTACKER1'S PERFERRED STRATEGIES ARE ALREADY IN ASCENDING ORDER
                                       % PAYOFF VALUE OF 2 IS MOST PREFERRED, -1 IS LEAST PREFERRED
  % ATTACKER2
  elseif strcmp(player, 'attacker2') % FOR ATTACKERS, MAXIMAL VALUE IS PREFERRED
      if payoff_value == 1      % ATTACKER2 PARTIAL WIN
          preference_value = 0;
      elseif payoff_value == 0  % ATTACKER2 PARTIAL WIN
          preference_value = 1;
      else                      % PAYOFF VALUE OF 2 IS MOST PREFERRED, -1 IS LEAST PREFERRED
          preference_value = payoff_value;
      end % if
  % INVALID PLAYER
  else
      error('playerPreference: Invalid player')
  end % if

end % function