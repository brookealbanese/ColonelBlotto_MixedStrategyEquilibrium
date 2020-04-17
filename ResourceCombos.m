% ResourceCombos - Generate all possible resource allocations based on player's available resources
% 
% Syntax:  [RESOURCE_COMBOS_ARRAY] = ResourceCombos(num_cyber_nodes,RESOURCES)
% 
% Inputs:
%    num_cyber_nodes - The number of cyber nodes in the system
%    RESOURCES       - Available resources matrix
% 
% Outputs:
%    RESOURCE_COMBOS_ARRAY - Contains strategy sets for all used resource values
% 
% -----------------------------------------------------------------------------
function [RESOURCE_COMBOS_ARRAY] = ResourceCombos(num_cyber_nodes,RESOURCES)

  % LOOK AHEAD AND SEE WHAT UNIQUE SETS NEED TO BE MADE
  UNIQUE_RESOURCES = unique(RESOURCES);

  % EACH UNIQUE SET WILL BE GENERATED
  % THE UNIQUE SET WILL BE STORED IN CELL BLOCK EQUAL TO ITS UNIQUE RESOURCE VALUE
  for unique_resources_index = 1:length(UNIQUE_RESOURCES)

      % NOTE: I'M FINDING RESOURCE COMBOS OVER ALL SETS 1:NUM_CYBER_NODES.
      % WHEN THE SET CONTAINS STRATEGIES WITH LESS NODES THEN OUR PROBLEM,
      % ZEROS ARE ADDED AND ALL PERMUATIONS ARE TAKEN.
      % IM DOING THIS TO ENSURE ALL COMBOS ARE IN OUR SET. WITHOUT THIS,
      % THIS METHOD IS MISSING 10-15% OF THE COMBOS AND EVEN SOMETIMES GENERATES NO SET!.
      % THIS METHOD STILL USES A BIT OF A REDUNDANT METHOD BUT CAN HANDLE QUITE BIG MATRIX
      % GENERATION FAST ENOUGH.
      for cyber_node_index = 1:num_cyber_nodes  
          c = nchoosek(1:UNIQUE_RESOURCES(unique_resources_index,1),cyber_node_index-1);
          m = size(c,1);
          A = zeros(m,cyber_node_index);
          for ix = 1:m
              A(ix,:) = diff([1,c(ix,:),UNIQUE_RESOURCES(unique_resources_index,1)+1]);
          end % for
          AA{cyber_node_index} = A;
      end % for

      for cyber_node_index = 1:size(AA,2)
          AA2{cyber_node_index} = [AA{cyber_node_index} zeros(size(AA{cyber_node_index},1),num_cyber_nodes-size(AA{cyber_node_index},2))];
      end % for

      combos = [AA2{1}];

      for cyber_node_index = 2:size(AA2,2)
          combos = [combos;AA2{cyber_node_index}];
      end % for

      Combos = perms(combos(1,:));

      for cyber_node_index = 2:size(combos,1)
          Combos = [Combos;perms(combos(cyber_node_index,:))];
      end % for

      % CELL RESOURCE_COMBOS_ARRAY CONTAINS STRATEGY SETS FOR ALL USED RESOURCE VALUES.
      % TO ACCESS RESOURCES 5 OVER NODES YOU LOOK IN RESOURCE_COMBOS_ARRAY{5} FOR EXAMPLE.
      RESOURCE_COMBOS_ARRAY{UNIQUE_RESOURCES(unique_resources_index)}= unique(Combos,'rows');

  end % for

end % function