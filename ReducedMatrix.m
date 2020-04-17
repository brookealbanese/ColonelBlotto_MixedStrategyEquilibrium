% ReducedMatrix - Removes resource allocation combinations based on dominated strategies
% 
% Syntax:  [NEW_STRAT] = ReducedMatrix(DOM_STRAT, RESOURCE_MATRIX, player)
% 
% Inputs:
%    DOM_STRAT       - Dominating strategies matrix
%    RESOURCE_MATRIX - Resource allocation combinations matrix
%    player          - attacker1, attacker2, or defender
% 
% Outputs:
%    NEW_STRAT - New/reduced strategies matrix
% 
% -----------------------------------------------------------------------------
function [NEW_STRAT] = ReducedMatrix(DOM_STRAT, RESOURCE_MATRIX, player)

  dom_strat_len = length(DOM_STRAT);

  if strcmp(player, 'attacker1')
      STRATEGIES = RESOURCE_MATRIX{1};
  end % if

  if strcmp(player, 'attacker2')
      STRATEGIES = RESOURCE_MATRIX{2};
  end % if

  if strcmp(player, 'defender')
      STRATEGIES = RESOURCE_MATRIX{3};
  end % if

  x = 1;
  y = 1;

  for x=1:dom_strat_len
      if DOM_STRAT(1,x) == 0                % IF STRATEGY IS NOT DOMINATED,
          NEW_STRAT(y,:) = STRATEGIES(x,:); % THEN ADD THE STRATEGY TO THE NEW MATRIX
          y = y + 1;
      end % if
  end % for

end % function