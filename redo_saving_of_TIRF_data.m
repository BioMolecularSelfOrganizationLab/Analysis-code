% the files should be int he same directory as the script
% the directory should have the functions:
%   -stepfit1_alvaro
%   -getNumSteps2

files = {...,
    'F1_rABCD_',...
    'F1_rABCD_1_',...
    'F1_rABCD_2_',...
    'F1_rABCD_3_',...
    'F1_rABCD_4_',...
    'F1_rABCD_5_',...
    'F1_rABCD_6_',...
    'F2_r_ABCD_Lat A 10 uM_',...
    'F2_r_ABCD_Lat A 10 uM_2_',...
    'F2_r_ABCD_Lat A 10 uM_3_',...
    'F2_r_ABCD_Lat A 10 uM_4_',...
    'F2_r_ABCD_Lat A 10 uM_5_',...
    'F2_r_ABCD_Lat A 10 uM_6_',...
    };


for file = length(files)
    load(files{file});
    
    sz = size(Step);
    
    for i = 1:sz(2)
        % get the step fit from step finding algorithm
        step_find = stepfit1_alvaro(Raw(i,:));
        
        % adjust acordingly:
        step_size = 14;
        % get the corrected num step
        step_num = getNumSteps2(step_find,step_size);
        
        % resave the Step variable
        Step(i,:) = step_num;
    end
    
    % resave traces in the file
    % As the file name already exists the system will probably ask if you
    % want to write on top of the old file. say yes on each time.
    save(files{file},'Raw','Step');
    
end