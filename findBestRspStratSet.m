function [bestRspSet] = findBestRspStratSet(num_cyber_nodes,CONNECTIONS,COST,threshold,RESOURCE_MATRIX_ARRAY,repetitions)
    
    RESOURCE_MATRIX_ATTACKER1 = RESOURCE_MATRIX_ARRAY{1};
    RESOURCE_MATRIX_ATTACKER2 = RESOURCE_MATRIX_ARRAY{2};
    RESOURCE_MATRIX_DEFENDER  = RESOURCE_MATRIX_ARRAY{3};

    [a1_rows,~] = size(RESOURCE_MATRIX_ATTACKER1);
    [a2_rows,~] = size(RESOURCE_MATRIX_ATTACKER2);
    [d_rows,~] = size(RESOURCE_MATRIX_DEFENDER);   
    
    % empty matrices to track location in strategy lists
    bestXStratsLoc = [];
    bestYStratsLoc = [];
    bestZStratsLoc = [];
    
    % make sure repetitons isn't larger than number of attacker 1 or
    % attacker 2 strategies to avoid pointless repeats
    if (repetitions > a1_rows) || (repetitions > a2_rows)
        repetitions = max(a1_rows,a2_rows);
    end
    
    for r = 1:repetitions
        pickXStrat = randi(a1_rows);
        pickYStrat = randi(a2_rows);
        
        bestXStratsLoc = [bestXStratsLoc pickXStrat];
        bestYStratsLoc = [bestYStratsLoc pickYStrat]; 
        
        % combined attack strategy
        tempAttStrat = RESOURCE_MATRIX_ARRAY{1}(pickXStrat,:)+RESOURCE_MATRIX_ARRAY{2}(pickYStrat,:);
        
        % determine which nodes will be attacked based on given connections
        P1_attack = sum(tempAttStrat.*CONNECTIONS(1,:));
        P2_attack = sum(tempAttStrat.*CONNECTIONS(2,:));
        
        % pick random defender strategy to start with
        startD = randi(d_rows);
        % if we loop through more than "abort" defender strategies, 
        % break loop regardless of if we've found best response or not
        abort = ceil(d_rows*0.75); 
        cnt = 0; % used to compare against abort
        for d=startD:d_rows
            cnt = cnt + 1;
            % find the defenders best response to one or both of the
            % attacker's strategies (based on connections again)
            tempDefStrat = RESOURCE_MATRIX_ARRAY{3}(d,:);
            P1_defend = sum(tempDefStrat.*CONNECTIONS(1,:));
            P2_defend = sum(tempDefStrat.*CONNECTIONS(2,:));
            if (P1_defend > P1_attack) || (P2_defend > P2_attack)
                bestZStratsLoc = [bestZStratsLoc d];
                break;
            end
            % if we reach end of loop and haven't found best response,
            % reset d and start at the beginning
            if d==d_rows
                d=1;
            end
            % exit condition, if we've gone through more than "abort" 
            % defenders strategies
            if cnt==abort
                break;
            end
            
        end
    end 
    
    % use a unique set (no repeats) of LOCATIONS of strategies in the set
    % of strategies for each player, respectively
    bestXStratsLoc = unique(sort(bestXStratsLoc));
    bestYStratsLoc = unique(sort(bestYStratsLoc));
    bestZStratsLoc = unique(sort(bestZStratsLoc));
    
    bestRspSet{1}=[];
    bestRspSet{2}=[];
    bestRspSet{3}=[];
    
    % assemble strategies based on unique locations
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