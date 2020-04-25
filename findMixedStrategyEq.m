function [mixedEq,payoff,iterations,error] = findMixedStrategyEq(num_cyber_nodes,CONNECTIONS,COST,threshold,RESOURCE_MATRIX_ARRAY,repetitions)
    % The purpose of this function is to hold two out of the three players 
    % strategies constant, updating the remaining one for each repetition.
    % Consider attacker 1 to be player X, attacker 2 to be player Y, and
    % attacker 3 to be player Z
    % Ex:
    % 1. pure X, pure Y-- find best mixed for Z
    % 2. pure Y (from above), mixed Z (from above)-- find best mixed X
    % 3. mixed X (from above), mixed Z (from above)-- find best mixed Y
    % 4. mixed X (from above), mixed Y (from above)-- find best mixed Z
    % etc.
    
    RESOURCE_MATRIX_ATTACKER1 = RESOURCE_MATRIX_ARRAY{1};
    RESOURCE_MATRIX_ATTACKER2 = RESOURCE_MATRIX_ARRAY{2};
    RESOURCE_MATRIX_DEFENDER  = RESOURCE_MATRIX_ARRAY{3};

    [a1_rows,~] = size(RESOURCE_MATRIX_ATTACKER1);
    [a2_rows,~] = size(RESOURCE_MATRIX_ATTACKER2);
    [d_rows,~] = size(RESOURCE_MATRIX_DEFENDER);   
    
    s = RandStream('mlfg6331_64');
    pickXStrat = randi(a1_rows);
    pickYStrat = randi(a2_rows);
    
    for r = 0:repetitions
        if mod(r,3)==0 % player Z, col 3
            tempResourceMatrix{1} = RESOURCE_MATRIX_ARRAY{1}(pickXStrat,:);
            tempResourceMatrix{2} = RESOURCE_MATRIX_ARRAY{2}(pickYStrat,:);
            tempResourceMatrix{3} = RESOURCE_MATRIX_ARRAY{3};

            [pXStratLen,~] = size(tempResourceMatrix{1});
            [pYStratLen,~] = size(tempResourceMatrix{2});
            [pZStratLen,~] = size(tempResourceMatrix{3});
            
            numStrategies = [pXStratLen pYStratLen pZStratLen];
            gameCostMatMode1 = GameBuild(1,num_cyber_nodes,tempResourceMatrix,CONNECTIONS,COST,threshold);
            [nash,pay,iters,errs] = NPG2(numStrategies,gameCostMatMode1); 
            
            pickZStrat = randsample(s,[1:pZStratLen],1,true,nash(:,3)');
            
        elseif mod(r,3)==1 % player X, col 1
            tempResourceMatrix{1} = RESOURCE_MATRIX_ARRAY{1};
            tempResourceMatrix{2} = RESOURCE_MATRIX_ARRAY{2}(pickYStrat,:);
            tempResourceMatrix{3} = RESOURCE_MATRIX_ARRAY{3}(pickZStrat,:);

            [pXStratLen,~] = size(tempResourceMatrix{1});
            [pYStratLen,~] = size(tempResourceMatrix{2});
            [pZStratLen,~] = size(tempResourceMatrix{3});
            
            numStrategies = [pXStratLen pYStratLen pZStratLen];
            gameCostMatMode1 = GameBuild(1,num_cyber_nodes,tempResourceMatrix,CONNECTIONS,COST,threshold);
            [nash,pay,iters,errs] = NPG2(numStrategies,gameCostMatMode1); 
            
            pickXStrat = randsample(s,[1:pXStratLen],1,true,nash(:,1)');
            
        else % mod(r,3)==2 % player Y, col 2
            tempResourceMatrix{1} = RESOURCE_MATRIX_ARRAY{1}(pickXStrat,:);
            tempResourceMatrix{2} = RESOURCE_MATRIX_ARRAY{2};
            tempResourceMatrix{3} = RESOURCE_MATRIX_ARRAY{3}(pickZStrat,:);

            [pXStratLen,~] = size(tempResourceMatrix{1});
            [pYStratLen,~] = size(tempResourceMatrix{2});
            [pZStratLen,~] = size(tempResourceMatrix{3});
            
            numStrategies = [pXStratLen pYStratLen pZStratLen];
            gameCostMatMode1 = GameBuild(1,num_cyber_nodes,tempResourceMatrix,CONNECTIONS,COST,threshold);
            [nash,pay,iters,errs] = NPG2(numStrategies,gameCostMatMode1); 
            
            pickYStrat = randsample(s,[1:pYStratLen],1,true,nash(:,2)');
        end
    end
    
    mixedEq = nash;
    payoff = pay;
    iterations = iters;
    error = errs;
        
end