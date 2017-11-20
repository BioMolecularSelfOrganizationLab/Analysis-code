%% Initialize

stepSize = 14;

n_divide = 6;

% data_duration{1} is LatA
% data_duration{2} is for N_end < 3
% data_duration{3} is for N_end > 6
data_duration = {};

f_latA_50 = {...
    'C:\Users\Rafael\Documents\ITQB estágio\code\zmw1_1uMactin_LatA_nobump_thr150_Salapaka50',...
    'C:\Users\Rafael\Documents\ITQB estágio\code\zmw5_1uM_LatA_cut_thr150_Salapaka50'};

f_actin_50 = {...
    'C:\Users\Rafael\Documents\ITQB estágio\code\zmw1_1uMactin_nobump_thr300_Salapaka50',...
    'C:\Users\Rafael\Documents\ITQB estágio\code\zmw2_BSA_nobump_thr300_Salapaka50'};

f_latA_30 = {...
    'C:\Users\Rafael\Documents\ITQB estágio\code\zmw1_1uMactin_LatA_nobump_thr150_Salapaka30',...
    'C:\Users\Rafael\Documents\ITQB estágio\code\zmw5_1uM_LatA_cut_thr150_Salapaka30'};

f_actin_30 = {...
    'C:\Users\Rafael\Documents\ITQB estágio\code\zmw1_1uMactin_nobump_thr300_Salapaka30',...
    'C:\Users\Rafael\Documents\ITQB estágio\code\zmw2_BSA_nobump_thr300_Salapaka30'};

f_TIRF_latA = {'C:\Users\Rafael\Documents\ITQB estágio\TIRF\TIRF_data_F2_g_ABCD_Lat A 10 uM_1'};

f_TIRF_actin = {'C:\Users\Rafael\Documents\ITQB estágio\TIRF\TIRF_data_F1_g_ABCD_1'};

%% LatA

files = f_TIRF_latA;

for file = 1:length(files)
    
    load(files{file});
    
    sz = size(Step);
    
    % get visits data (frequency and duration)
    visits = {};
    for i = 1:sz(1)
        fit = getNumSteps2(Step(i,:),stepSize);
        %[~,~,~,fit,~,~,~,~,~] = Int2MonNum_DoubleSteps(Step(i,:));
        visits{i} = visitFrequency(fit,n_divide);
    end
    
    % for each sub_trace compute total_time for each level
    
    for i = 1:n_divide
        if file == 1
            data_duration{1}{i} = zeros(1,11);
        end
        
        % for each level
        for j = 1:11
            sum = 0;
            % for each trace
            for k = 1:sz(1)
                if length(visits{k}{i}{2}) >= j
                    sum = sum + visits{k}{i}{2}(j);
                end
            end
            
            % the level j at sub_trace i has a total visitation time of sum
            data_duration{1}{i}(j) = data_duration{1}{i}(j) + sum;
        end
    end
    
    
end


%% Actin

files = f_TIRF_actin;

for file = 1:length(files)
    
    load(files{file});
    
    sz = size(Step);
    end_file = zeros(1,sz(1));
    
    % get visits data (frequency and duration)
    visits = {};
    for i = 1:sz(1)
        fit = getNumSteps2(Step(i,:),stepSize);
        %[~,~,~,fit,~,~,~,~,~] = Int2MonNum_DoubleSteps(Step(i,:));
        end_file(i) = fit(end);
        visits{i} = visitFrequency(fit,n_divide);
    end
    
    % for each sub_trace compute total_time for each level
    
    for i = 1:n_divide
        if file == 1
            data_duration{2}{i} = zeros(1,11);
            data_duration{3}{i} = zeros(1,11);
        end
        
        % for each level
        for j = 1:11
            sum1 = 0;
            sum2 = 0;
            % for each trace
            for k = 1:sz(1)
                if length(visits{k}{i}{2}) >= j
                    % separate by population
                    if end_file(k) < 4
                        sum1 = sum1 + visits{k}{i}{2}(j);
                    elseif end_file(k) > 6
                        sum2 = sum2 + visits{k}{i}{2}(j);
                    end
                end
            end
            
            % the level j at sub_trace i has a total visitation time of sum
            data_duration{2}{i}(j) = data_duration{2}{i}(j) + sum1;
            data_duration{3}{i}(j) = data_duration{3}{i}(j) + sum2;
        end
    end
    
    
end





%% plot

f1 = figure('Name','LatA / Actin N_end < 4 / Actin N_end > 6');
ax = axes('Units', 'normalized', 'Position', [0 0 1 0.5]);

for k = 1:3
    for i = 1:n_divide
        s_p = subplot(3,n_divide,(k-1)*n_divide + i,'Parent',f1);

        b = bar(s_p,data_duration{k}{i},'XData',0:10);
        xlim([-1,11]);
        
        
        sub_sz = round(sz(2)/n_divide);
        w = (i - 1) * sub_sz + 1;
        title(sprintf('%d to %d',round(w/5),round(min(w+sub_sz,sz(2))/5)));
    end
end

