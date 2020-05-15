% Main - Colonel Blotto Game With Dominating Strategies. Solve a non co-op game between 3 players (2 attackers 1 defender)
% +HDR-------------------------------------------------------------------------
% FILE NAME      : Main.m
% TYPE           : MATLAB File
% COURSE         : Binghamton University
%                  MASTERS PROJ
% -----------------------------------------------------------------------------
% PURPOSE : Colonel Blotto Game With Dominating Strategies
%           Solve a non co-op game between 3 players (2 attackers 1 defender)
% 
% -HDR-------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CLEAR THE WORKSPACE AND COMMAND WINDOW %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
clc;



%%%%%%%%%%%%%%%%%%%%%%%%
%% START ELAPSED TIME %%
%%%%%%%%%%%%%%%%%%%%%%%%
start_time = clock;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SET UP THE GAME CONFIGURABLES %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HOW MANY CYBER NODES ARE THERE?
num_cyber_nodes = 4;

% HOW ARE THE PHYSICAL NODES CONNECTED TO THE CYBER NODES?
%   [PHYSICAL_NODE_1; PHYSICAL_NODE_2]
%   [CYBER_NODE_1 CYBER_NODE_2 ... CYBER_NODE_N; CYBER_NODE_1 CYBER_NODE_2 ... CYBER_NODE_N]
CONNECTIONS = [1 1 1 0 ; 0 1 1 1];

% WHAT ARE THE AVAILABLE PLAYER RESOURCES FOR EACH GAME?
%   [GAME_1; GAME_2; GAME_3]
attacker1 = [2;2;2];
attacker2 = [2;2;2];
defender  = [4;5;6];
% attacker1 = [3;3;3];
% attacker2 = [3;3;3];
% defender  = [6;7;8];
RESOURCES = [attacker1 attacker2 defender];

% WHAT IS THE COST OF EACH PHYSICAL NODE TO EACH PLAYER WHEN DOWN?
%   [PHYSICAL_NODE_1; PHYSICAL_NODE_2]
%   A POSITIVE SIGN DENOTES AN ATTACKER (MAXIMIZER)
%   A NEGATIVE SIGN DENOTES A DEFENDER (MINIMIZER)
%   NOTE: IF THESE VALUES CHANGE, RE-EVALUATE PlayerPreference.m VALUES!!!
attacker1_cost = [1;.25];
attacker2_cost = [.25;1];
defender_cost  = [-.75;-.75];
COST = [attacker1_cost attacker2_cost defender_cost];

% HOW MANY CYBER NODES MUST BE DOWN FOR EACH PHYSICAL NODE TO BE DOWN?
%   [PHYSICAL_NODE_1; PHYSICAL_NODE_2]
threshold = [1;1];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CREATE THE RESOURCE MATRIX [RESOURCE_MATRIX] BASED ON ALL COMBINATIONS %%
%% THAT COULD BE PLAYED BETWEEN BOTH ATTACKERS VERSUS DEFENDER            %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CREATE AN ARRAY OF 2-D MATRICES CONTAINING ALL NECESSARY COMBINATIONS OF RESOURCE ALLOCATIONS
[RESOURCE_COMBOS_ARRAY] = ResourceCombos(num_cyber_nodes,RESOURCES);

% CREATE AN ARRAY OF 2-D RESOURCE MATRICES FOR EACH GAME BY SELECTING THE APPROPRIATE
%   RESOURCE ALLOCATIONS MATRIX BASED ON THE PLAYER'S AVAILABLE RESOURCES
RESOURCE_MATRIX_ARRAY_1 = {RESOURCE_COMBOS_ARRAY{attacker1(1)} RESOURCE_COMBOS_ARRAY{attacker2(1)} RESOURCE_COMBOS_ARRAY{defender(1)}};
RESOURCE_MATRIX_ARRAY_2 = {RESOURCE_COMBOS_ARRAY{attacker1(2)} RESOURCE_COMBOS_ARRAY{attacker2(2)} RESOURCE_COMBOS_ARRAY{defender(2)}};
RESOURCE_MATRIX_ARRAY_3 = {RESOURCE_COMBOS_ARRAY{attacker1(3)} RESOURCE_COMBOS_ARRAY{attacker2(3)} RESOURCE_COMBOS_ARRAY{defender(3)}};

% BUILD THE THREE 3-D GAME COST MATRICES USING THE SETTINGS AND RESPECTIVE GAME RESOURCE MATRIX ARRAY
GAME_COST_MATRIX_1 = GameBuild(0,num_cyber_nodes,RESOURCE_MATRIX_ARRAY_1,CONNECTIONS,COST,threshold);
GAME_COST_MATRIX_2 = GameBuild(0,num_cyber_nodes,RESOURCE_MATRIX_ARRAY_2,CONNECTIONS,COST,threshold);
GAME_COST_MATRIX_3 = GameBuild(0,num_cyber_nodes,RESOURCE_MATRIX_ARRAY_3,CONNECTIONS,COST,threshold);

config_time = clock;
config_time_seconds = etime(config_time,start_time);
config_time_minutes = floor(config_time_seconds/60)
config_time_seconds = rem(config_time_seconds,60)



%%%%%%%%%%%%%%%%%%%%%%
%% EVALUATE GAME #1 %%
%%%%%%%%%%%%%%%%%%%%%%

% CREATE THE DOMINATING STRATEGIES MATRICES FOR EACH PLAYER
DOM_STRAT_1_DEFENDER  = DominatingStrategies(GAME_COST_MATRIX_1, 'defender');
DOM_STRAT_1_ATTACKER1 = DominatingStrategies(GAME_COST_MATRIX_1, 'attacker1');
DOM_STRAT_1_ATTACKER2 = DominatingStrategies(GAME_COST_MATRIX_1, 'attacker2');

% REDUCE THE RESOURCE ALLOCATIONS MATRICES FOR EACH PLAYER (THROW AWAY DOMINATED STRATEGIES)
NEW_STRAT_1_DEFENDER  = ReducedMatrix(DOM_STRAT_1_DEFENDER,  RESOURCE_MATRIX_ARRAY_1, 'defender');
NEW_STRAT_1_ATTACKER1 = ReducedMatrix(DOM_STRAT_1_ATTACKER1, RESOURCE_MATRIX_ARRAY_1, 'attacker1');
NEW_STRAT_1_ATTACKER2 = ReducedMatrix(DOM_STRAT_1_ATTACKER2, RESOURCE_MATRIX_ARRAY_1, 'attacker2');

% CREATE AN ARRAY OF 2-D RESOURCE MATRICES (REDUCED)
REDUCED_RESOURCE_MATRIX_ARRAY_1 = {NEW_STRAT_1_ATTACKER1 NEW_STRAT_1_ATTACKER2 NEW_STRAT_1_DEFENDER};

% EXECUTE THE GAME CALCULATION
[BEST_RESOURCE_MATRIX_1] = findBestRspStratSet(num_cyber_nodes,CONNECTIONS,COST,threshold,REDUCED_RESOURCE_MATRIX_ARRAY_1,30);
[nash_1,payoff_1,iter_1,err_1] = findEquilibrium(num_cyber_nodes,CONNECTIONS,COST,threshold,BEST_RESOURCE_MATRIX_1);

game_1_time = clock;
game_1_time_seconds = etime(game_1_time,config_time);
game_1_time_minutes = floor(game_1_time_seconds/60)
game_1_time_seconds = rem(game_1_time_seconds,60)



%%%%%%%%%%%%%%%%%%%%%%
%% EVALUATE GAME #2 %%
%%%%%%%%%%%%%%%%%%%%%%

% CREATE THE DOMINATING STRATEGIES MATRICES FOR EACH PLAYER
DOM_STRAT_2_DEFENDER  = DominatingStrategies(GAME_COST_MATRIX_2, 'defender');
DOM_STRAT_2_ATTACKER1 = DominatingStrategies(GAME_COST_MATRIX_2, 'attacker1');
DOM_STRAT_2_ATTACKER2 = DominatingStrategies(GAME_COST_MATRIX_2, 'attacker2');

% REDUCE THE RESOURCE ALLOCATIONS MATRICES FOR EACH PLAYER (THROW AWAY DOMINATED STRATEGIES)
NEW_STRAT_2_DEFENDER  = ReducedMatrix(DOM_STRAT_2_DEFENDER,  RESOURCE_MATRIX_ARRAY_2, 'defender');
NEW_STRAT_2_ATTACKER1 = ReducedMatrix(DOM_STRAT_2_ATTACKER1, RESOURCE_MATRIX_ARRAY_2, 'attacker1');
NEW_STRAT_2_ATTACKER2 = ReducedMatrix(DOM_STRAT_2_ATTACKER2, RESOURCE_MATRIX_ARRAY_2, 'attacker2');

% CREATE AN ARRAY OF 2-D RESOURCE MATRICES (REDUCED)
REDUCED_RESOURCE_MATRIX_ARRAY_2 = {NEW_STRAT_2_ATTACKER1 NEW_STRAT_2_ATTACKER2 NEW_STRAT_2_DEFENDER};

% EXECUTE THE GAME CALCULATION
[BEST_RESOURCE_MATRIX_2] = findBestRspStratSet(num_cyber_nodes,CONNECTIONS,COST,threshold,REDUCED_RESOURCE_MATRIX_ARRAY_2,30);
[nash_2,payoff_2,iter_2,err_2] = findEquilibrium(num_cyber_nodes,CONNECTIONS,COST,threshold,BEST_RESOURCE_MATRIX_2);

game_2_time = clock;
game_2_time_seconds = etime(game_2_time,game_1_time);
game_2_time_minutes = floor(game_2_time_seconds/60)
game_2_time_seconds = rem(game_2_time_seconds,60)



%%%%%%%%%%%%%%%%%%%%%%
%% EVALUATE GAME #3 %%
%%%%%%%%%%%%%%%%%%%%%%

% CREATE THE DOMINATING STRATEGIES MATRICES FOR EACH PLAYER
DOM_STRAT_3_DEFENDER  = DominatingStrategies(GAME_COST_MATRIX_3, 'defender');
DOM_STRAT_3_ATTACKER1 = DominatingStrategies(GAME_COST_MATRIX_3, 'attacker1');
DOM_STRAT_3_ATTACKER2 = DominatingStrategies(GAME_COST_MATRIX_3, 'attacker2');

% REDUCE THE RESOURCE ALLOCATIONS MATRICES FOR EACH PLAYER (THROW AWAY DOMINATED STRATEGIES)
NEW_STRAT_3_DEFENDER  = ReducedMatrix(DOM_STRAT_3_DEFENDER,  RESOURCE_MATRIX_ARRAY_3, 'defender');
NEW_STRAT_3_ATTACKER1 = ReducedMatrix(DOM_STRAT_3_ATTACKER1, RESOURCE_MATRIX_ARRAY_3, 'attacker1');
NEW_STRAT_3_ATTACKER2 = ReducedMatrix(DOM_STRAT_3_ATTACKER2, RESOURCE_MATRIX_ARRAY_3, 'attacker2');

% CREATE AN ARRAY OF 2-D RESOURCE MATRICES (REDUCED)
REDUCED_RESOURCE_MATRIX_ARRAY_3 = {NEW_STRAT_3_ATTACKER1 NEW_STRAT_3_ATTACKER2 NEW_STRAT_3_DEFENDER};

% EXECUTE THE GAME CALCULATION
[BEST_RESOURCE_MATRIX_3] = findBestRspStratSet(num_cyber_nodes,CONNECTIONS,COST,threshold,REDUCED_RESOURCE_MATRIX_ARRAY_3,30);
[nash_3,payoff_3,iter_3,err_3] = findEquilibrium(num_cyber_nodes,CONNECTIONS,COST,threshold,BEST_RESOURCE_MATRIX_3);

game_3_time = clock;
game_3_time_seconds = etime(game_3_time,game_2_time);
game_3_time_minutes = floor(game_3_time_seconds/60)
game_3_time_seconds = rem(game_3_time_seconds,60)



%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GENERATE RESULTS PLOT %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure1 = figure;
  fig1_x_axis = categorical({'Game 1', 'Game 2', 'Game 3'});
  fig1_x_axis = reordercats(fig1_x_axis,{'Game 1', 'Game 2', 'Game 3'});

    fig1_bar1 = bar(fig1_x_axis,[RESOURCES(1,:); RESOURCES(2,:); RESOURCES(3,:)]);
    legend({'Attacker 1','Attacker 2','Defender'},'Location','bestoutside');
    title('Player Available Resources Per Game');
    ylabel('Available Resources');
    fig1_bar1_y_axis_min = 0;
    fig1_bar1_y_axis_max = max(unique(RESOURCES)) + 1;
    ylim([fig1_bar1_y_axis_min fig1_bar1_y_axis_max]);
    grid on;
    box on;

figure2 = figure;
  fig2_x_axis = categorical({'Game 1', 'Game 2', 'Game 3'});
  fig2_x_axis = reordercats(fig2_x_axis,{'Game 1', 'Game 2', 'Game 3'});
    fig2_bar1_x_axis = categorical({'Game 1', 'Game 2', 'Game 3'});
    fig2_bar1_x_axis = reordercats(fig2_bar1_x_axis,{'Game 1', 'Game 2', 'Game 3'});
    fig2_bar1 = bar(fig2_bar1_x_axis,[etime(game_1_time,config_time); etime(game_2_time,game_1_time); etime(game_3_time,game_2_time)]);
    title('Elapsed Time Per Game');
    ylabel('Time (Seconds)');
    grid on;
    box on;

figure3 = figure;
    fig3_x_axis = categorical({'Game 1', 'Game 2', 'Game 3'});
    fig3_x_axis = reordercats(fig3_x_axis,{'Game 1', 'Game 2', 'Game 3'});
    
    fig3_bar2 = bar(fig3_x_axis,[payoff_1(1,:); payoff_2(1,:); payoff_3(1,:)]);
    legend({'Attacker 1','Attacker 2','Defender'},'Location','bestoutside');
    title('Payoff at Nash Equilibrium');
    ylabel('Payoff');
    fig3_bar2_y_axis_min = 0;
    fig3_bar2_y_axis_max = max(unique([payoff_1; payoff_2; payoff_3])) * 1.1;
    ylim([fig3_bar2_y_axis_min fig3_bar2_y_axis_max]);
    grid on;
    box on;
    
    
%%%%%%%%%%%%%%%%%%%%%%%
%% STOP ELAPSED TIME %%
%%%%%%%%%%%%%%%%%%%%%%%
stop_time = clock;
elapsed_seconds = etime(stop_time,start_time);
elapsed_minutes = floor(elapsed_seconds/60)
elapsed_seconds = rem(elapsed_seconds,60)


