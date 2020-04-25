function [bestRspSet] = findBestRspStratSet(num_cyber_nodes,CONNECTIONS,COST,threshold,RESOURCE_MATRIX_ARRAY,repetitions)
    
    RESOURCE_MATRIX_ATTACKER1 = RESOURCE_MATRIX_ARRAY{1};
    RESOURCE_MATRIX_ATTACKER2 = RESOURCE_MATRIX_ARRAY{2};
    RESOURCE_MATRIX_DEFENDER  = RESOURCE_MATRIX_ARRAY{3};

    [a1_rows,~] = size(RESOURCE_MATRIX_ATTACKER1);
    [a2_rows,~] = size(RESOURCE_MATRIX_ATTACKER2);
    [d_rows,~] = size(RESOURCE_MATRIX_DEFENDER);   
    
    % empty matrices to track location
    bestXStratsLoc = [];
    bestYStratsLoc = [];
    bestZStratsLoc = [];
    
    % make sure repetitons isn't larger than number of attacker 1 or
    % attacker 2 strategies
    if (repetitions > a1_rows) || (repetitions > a2_rows)
        repetitions = max(a1_rows,a2_rows);
    end
    
    for r = 1:repetitions
        pickXStrat = randi(a1_rows);
        pickYStrat = randi(a2_rows);
        
        bestXStratsLoc = [bestXStratsLoc pickXStrat];
        bestYStratsLoc = [bestYStratsLoc pickYStrat]; 
        
        tempAttStrat = RESOURCE_MATRIX_ARRAY{1}(pickXStrat,:)+RESOURCE_MATRIX_ARRAY{2}(pickYStrat,:);
        P1_attack = sum(tempAttStrat(1:3));
        P2_attack = sum(tempAttStrat(2:4));
        
        startD = randi(d_rows);
        for d=startD:d_rows
            tempDefStrat = RESOURCE_MATRIX_ARRAY{3}(d,:);
            P1_defend = sum(tempDefStrat(1:3));
            P2_defend = sum(tempDefStrat(2:4));
            if (P1_defend > P1_attack) || (P2_defend > P2_attack)
                bestZStratsLoc = [bestZStratsLoc d];
                break;
            end
        end
    end 
    
    bestXStratsLoc = unique(sort(bestXStratsLoc));
    bestYStratsLoc = unique(sort(bestYStratsLoc));
    bestZStratsLoc = unique(sort(bestZStratsLoc));
    
    bestRspSet{1}=[];
    bestRspSet{2}=[];
    bestRspSet{3}=[];
    
    for a1=bestXStratsLoc(1):a1_rows
        if a1 == bestXStratsLoc(1)
            bestRspSet{1} = [bestRspSet{1}; RESOURCE_MATRIX_ARRAY{1}(a1,:)];
            [~,c]=size(bestXStratsLoc);
            if c > 1
                bestXStratsLoc = bestXStratsLoc(2:end);
            else
                break;
            end
        end
    end
    for a2=bestYStratsLoc(1):a2_rows
        if a2 == bestYStratsLoc(1)
            bestRspSet{2} = [bestRspSet{2}; RESOURCE_MATRIX_ARRAY{2}(a2,:)];
            [~,c]=size(bestYStratsLoc);
            if c > 1
                bestYStratsLoc = bestYStratsLoc(2:end);
            else
                break;
            end
        end
    end
    for d=bestZStratsLoc(1):d_rows
        if d == bestZStratsLoc(1)
            bestRspSet{3} = [bestRspSet{3}; RESOURCE_MATRIX_ARRAY{3}(d,:)];
            [~,c]=size(bestZStratsLoc);
            if c > 1
                bestZStratsLoc = bestZStratsLoc(2:end);
            else
                break;
            end
        end
    end    
end