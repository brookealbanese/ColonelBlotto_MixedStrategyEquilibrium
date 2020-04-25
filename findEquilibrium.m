function [nash,pay,iters,errs] = findEquilibrium(num_cyber_nodes,CONNECTIONS,COST,threshold,BEST_RESOURCE_MATRIX_ARRAY)
        
    BEST_RESOURCE_MATRIX_ATTACKER1 = BEST_RESOURCE_MATRIX_ARRAY{1};
    BEST_RESOURCE_MATRIX_ATTACKER2 = BEST_RESOURCE_MATRIX_ARRAY{2};
    BEST_RESOURCE_MATRIX_DEFENDER  = BEST_RESOURCE_MATRIX_ARRAY{3};

    [a1_rows,~] = size(BEST_RESOURCE_MATRIX_ATTACKER1);
    [a2_rows,~] = size(BEST_RESOURCE_MATRIX_ATTACKER2);
    [d_rows,~] = size(BEST_RESOURCE_MATRIX_DEFENDER);   
    
    numStrategies = [a1_rows a2_rows d_rows];
    gameCostMatMode1 = GameBuild(1,num_cyber_nodes,BEST_RESOURCE_MATRIX_ARRAY,CONNECTIONS,COST,threshold);
    [nash,pay,iters,errs] = NPG2(numStrategies,gameCostMatMode1);
        
end