% GameBuild - Generate the game cost matrix based on blotto resource combinations
% 
% Syntax:  [GAME_COST_MATRIX] = GameBuild(mode,num_cyber_nodes,RESOURCE_MATRIX_ARRAY,CONNECTIONS,COST,threshold)
% 
% Inputs:
%    mode                  - 0      = Build 3 player game matrix (3-D)
%                            1      = Build 3 player game cost matrix (2-D)
%                            others = Invalid
%    num_cyber_nodes       - The number of cyber nodes in the system
%    RESOURCE_MATRIX_ARRAY - An array of 2-D resource matrices for each player
%    CONNECTIONS           - Interconnectivity of cyber and physical nodes
%    COST                  - The cost of each physical node to each player when down
%    threshold             - How many cyber nodes must be down for each physical node to be down
% 
% Outputs:
%    GAME_COST_MATRIX - Game cost matrix (mode 0 = 3-D matrix, mode 1 = 2-D matrix)
% 
% -----------------------------------------------------------------------------
function [GAME_COST_MATRIX] = GameBuild(mode,num_cyber_nodes,RESOURCE_MATRIX_ARRAY,CONNECTIONS,COST,threshold)

  % THREE PLAYER GAME MATRIX BASED ON BLOTTO RESOURCE COMBINATIONS
  if mode == 0
      player = 0;
  elseif mode == 1
      player = 1;
  else
      error('GameBuild: Invalid mode')
  end % if
   
  z = 0;

  RESOURCE_MATRIX_ATTACKER1 = RESOURCE_MATRIX_ARRAY{1};
  RESOURCE_MATRIX_ATTACKER2 = RESOURCE_MATRIX_ARRAY{2};
  RESOURCE_MATRIX_DEFENDER  = RESOURCE_MATRIX_ARRAY{3};
  
  [resource_matrix_attacker1_rows,~] = size(RESOURCE_MATRIX_ATTACKER1);
  [resource_matrix_attacker2_rows,~] = size(RESOURCE_MATRIX_ATTACKER2);
  [resource_matrix_defender_rows,~]  = size(RESOURCE_MATRIX_DEFENDER);

  if mode == 0
      GAME_COST_MATRIX = zeros(resource_matrix_defender_rows,resource_matrix_attacker1_rows,resource_matrix_attacker2_rows);
      i = 1; j = 1; k = 1;
  end % if

  % FOR EACH STRATEGY SET IN ATTACKER 2 COMBINATIONS
  for kk = 1:resource_matrix_attacker2_rows

      % FOR EACH STRATEGY SET IN ATTACKER 1 COMBINATIONS 
      for jj = 1:resource_matrix_attacker1_rows

          % FOR EACH STRATEGY SET IN DEFENDER COMBINATIONS
          for ii = 1:resource_matrix_defender_rows

              % CHECK IF COMBINED STRATEGIES TAKES OVER A NODE
              for ll = 1:num_cyber_nodes
                  if RESOURCE_MATRIX_ATTACKER1(jj,ll)+RESOURCE_MATRIX_ATTACKER2(kk,ll) <= RESOURCE_MATRIX_DEFENDER(ii,ll)
                      H = 0; % NOT TAKEN OVER
                  elseif RESOURCE_MATRIX_ATTACKER1(jj,ll)+RESOURCE_MATRIX_ATTACKER2(kk,ll) > RESOURCE_MATRIX_DEFENDER(ii,ll)
                      H = 1; % TAKEN OVER
                  end % if
                  % Z CONTAINS SUCCESS OR FAILURE OF EACH CYBER NODES ATTACKS FROM COMBINED EFFORTS
                  z(ll) = H;
              end % for

              % CONNECTIONS HELPS RELATE INTERCONNECTIVITY OF PHYSICAL NODES.
              % IF Y(1) = 2; ==> PHYSICAL NODE 1 SUFFERED 2 CYBER NODE LOSSES THIS COMBO
              y = CONNECTIONS*z';

              for b = 1:length(y) % COMPARE NODES WITH THRESHOLD VALUES
                  if y(b) >= threshold(b)
                      Y(b) = 1; % PHYSICAL NODE TAKEN DOWN
                  else
                      Y(b) = 0; % PHYSICAL NODE REMAINS UP
                  end % if
                  % Y NOW CONTAINS 1 IF PHYSICAL NODE IS TAKEN DOWN AND 0 IF NOT
              end % for

              % EACH PLAYER VALUES PHYSICAL NODES DIFFERENTLY
              % IF PLAYER MM IS AN ATTACKER, REWARD NODES BEING DOWN.(Y(II) = 1)
              for mm = 1:size(COST,2)
                  if sum(COST(:,mm)) > 0
                    C(mm) = Y*COST(:,mm); 
                  else
                      % OTHERWISE A DEFENDER GETS REWARDED WHEN CYBER NODES ARE NOT
                      % SUCCESSFULLY TAKEN DOWN.
                      for b = 1:length(Y)
                          if Y(b) == 0
                              C10(b) = abs(COST(b,mm));
                          elseif Y(b) == 1
                              C10(b) = 0;
                          end % if
                      end % for
                      C(mm) = sum(C10);
                  end % if
              end % for

              if mode == 0
                  % if C == [0,0,1.5]
                  if C == [0,0,abs(COST(1,3)+COST(2,3))] % [ATTACKER1, ATTACKER2, DEFENDER]
                      n = -1; % ATTACKER1 LOSS, ATTACKER2 LOSS, DEFENDER WON
                  end % if

                  % if C == [.25,1,.75]
                  if C == [COST(1,2),COST(1,1),abs(COST(1,3))] % [ATTACKER1, ATTACKER2, DEFENDER]
                      n = 0; % ATTACKER1 PARTIAL WIN, ATTACKER2 PARTIAL WIN, DEFENDER PARTIAL LOSS
                  end % if

                  % if C == [1,.25,.75]
                  if C == [COST(2,2),COST(2,1),abs(COST(2,3))] % [ATTACKER1, ATTACKER2, DEFENDER]
                      n = 1; % ATTACKER1 PARTIAL WIN, ATTACKER2 PARTIAL WIN, DEFENDER PARTIAL LOSS
                  end % if

                  % if C == [1.25,1.25,0]
                  if C == [COST(1,2)+COST(2,2),COST(1,1)+COST(2,1),0] % [ATTACKER1, ATTACKER2, DEFENDER]
                      n = 2; % ATTACKER1 WIN, ATTACKER2 WIN, DEFENDER LOSS
                  end % if

                  GAME_COST_MATRIX(i,j,k) = n; % I = DEFENDER, J = ATTACKER1, K = ATTACKER2
                  i = i + 1;

                  if i == resource_matrix_defender_rows + 1
                      i = 1;
                      j = j + 1;
                  end % if

                  if j == resource_matrix_attacker1_rows + 1
                      j = 1;
                      k = k +1;
                  end % if
              elseif mode == 1
                  % BUILD COST MATRIX.
                  GAME_COST_MATRIX(player,:) = C;
                  player = player+1;
              end % if

          end % for

      end % for

  end % for

end % function