% DominatingStrategies - Identify dominated strategies for each player
%                        Defender minimizes, attackers maximize
% 
% Syntax:  [ DOM_STRAT_MATRIX ] = DominatingStrategies( GAME_COST_MATRIX, player )
% 
% Inputs:
%    GAME_COST_MATRIX - 3-D GAME COST MATRIX
%    player           - attacker1, attacker2, or defender
% 
% Outputs:
%    DOM_STRAT_MATRIX - Dominated strategies matrix (1 = dominated/less preferred)
% 
% -----------------------------------------------------------------------------
function [ DOM_STRAT_MATRIX ] = DominatingStrategies( GAME_COST_MATRIX, player )

  % COLLECT THE GAME_COST_MATRIX DIMENTIONS FOR EACH PLAYER
  [size_defender,size_attacker1,size_attacker2] = size(GAME_COST_MATRIX);

  % CONVERT THE GAME_COST_MATRIX TO PLAYER PREFERRED STRATEGIES
  % FOR DEFENDER, MINIMAL VALUE IS PREFERRED
  % FOR ATTACKERS, MAXIMAL VALUE IS PREFERRED
  GAME_COST_MATRIX = ConvertPreference(GAME_COST_MATRIX,player);

  % DEFENDER
  if strcmp(player, 'defender')
      DOM_STRAT_MATRIX = zeros(1,size_defender);
      for x = 1:size_defender
          for y = x+1:size_defender
              if all( all( GAME_COST_MATRIX(x,:,:) >= GAME_COST_MATRIX(y,:,:) ))
              % IF GAME_COST_MATRIX(x,:,:) >= GAME_COST_MATRIX(y,:,:) FOR ALL GAME_COST_MATRIX(y,:,:),
              % THEN GAME_COST_MATRIX(x,:,:) IS DOMINATED/LESS PREFERRED
                  DOM_STRAT_MATRIX(1,x) = 1;
              elseif all( all( GAME_COST_MATRIX(x,:,:) <= GAME_COST_MATRIX(y,:,:) ))
              % IF GAME_COST_MATRIX(x,:,:) <= GAME_COST_MATRIX(y,:,:) FOR ALL GAME_COST_MATRIX(y,:,:),
              % THEN GAME_COST_MATRIX(y,:,:) IS DOMINATED/LESS PREFERRED
                  DOM_STRAT_MATRIX(1,y) = 1;
              end % if
          end % for
      end % for
  % ATTACKER1
  elseif strcmp(player, 'attacker1') 
      DOM_STRAT_MATRIX = zeros(1,size_attacker1);
      for x = 1:size_attacker1
          for y = x+1:size_attacker1
              if all( all( GAME_COST_MATRIX(:,x,:) >= GAME_COST_MATRIX(:,y,:) ))
              % IF GAME_COST_MATRIX(:,x,:) >= GAME_COST_MATRIX(:,y,:) FOR ALL GAME_COST_MATRIX(:,y,:),
              % THEN GAME_COST_MATRIX(:,y,:) IS DOMINATED/LESS PREFERRED
                  DOM_STRAT_MATRIX(1,y) = 1;
              elseif all( all( GAME_COST_MATRIX(:,x,:) <= GAME_COST_MATRIX(:,y,:) ))
              % IF GAME_COST_MATRIX(:,x,:) <= GAME_COST_MATRIX(:,y,:) FOR ALL GAME_COST_MATRIX(:,y,:),
              % THEN GAME_COST_MATRIX(:,x,:) IS DOMINATED/LESS PREFERRED
                  DOM_STRAT_MATRIX(1,x) = 1;
              end % if
          end % for
      end % for
  % ATTACKER2
  elseif strcmp(player, 'attacker2')
      DOM_STRAT_MATRIX = zeros(1,size_attacker2);
       for x = 1:size_attacker2
          for y = x+1:size_attacker2
              if all( all( GAME_COST_MATRIX(:,:,x) >= GAME_COST_MATRIX(:,:,y) ))
              % IF GAME_COST_MATRIX(:,:,x) >= GAME_COST_MATRIX(:,:,y) FOR ALL GAME_COST_MATRIX(:,:,y),
              % THEN GAME_COST_MATRIX(:,:,y) IS DOMINATED/LESS PREFERRED
                  DOM_STRAT_MATRIX(1,y) = 1;
              elseif all( all( GAME_COST_MATRIX(:,:,x) <= GAME_COST_MATRIX(:,:,y) ))
              % IF GAME_COST_MATRIX(:,:,x) <= GAME_COST_MATRIX(:,:,y) FOR ALL GAME_COST_MATRIX(:,:,y),
              % THEN GAME_COST_MATRIX(:,:,x) IS DOMINATED/LESS PREFERRED
                   DOM_STRAT_MATRIX(1,x) = 1;
              end % if
          end % for
      end % for
  % INVALID PLAYER
  else
      error('DominatingStratigies: Invalid player')
  end % if

end % function