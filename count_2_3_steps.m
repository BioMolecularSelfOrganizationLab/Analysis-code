%% count double/triple steps

%% initialize

f_latA_50 = {...
    'C:\Users\Rafael\Documents\ITQB estágio\code and pdf\zmw1_1uMactin_LatA_nobump_thr150_Salapaka50',...
    'C:\Users\Rafael\Documents\ITQB estágio\code and pdf\zmw5_1uM_LatA_cut_thr150_Salapaka50'};

f_actin_50 = {...
    'C:\Users\Rafael\Documents\ITQB estágio\code and pdf\zmw1_1uMactin_nobump_thr300_Salapaka50',...
    'C:\Users\Rafael\Documents\ITQB estágio\code and pdf\zmw2_BSA_nobump_thr300_Salapaka50'};

f_latA_30 = {...
    'C:\Users\Rafael\Documents\ITQB estágio\code and pdf\zmw1_1uMactin_LatA_nobump_thr150_Salapaka30',...
    'C:\Users\Rafael\Documents\ITQB estágio\code and pdf\zmw5_1uM_LatA_cut_thr150_Salapaka30'};

f_actin_30 = {...
    'C:\Users\Rafael\Documents\ITQB estágio\code and pdf\zmw1_1uMactin_nobump_thr300_Salapaka30',...
    'C:\Users\Rafael\Documents\ITQB estágio\code and pdf\zmw2_BSA_nobump_thr300_Salapaka30'};

f_actin_300nM = {...
    'C:\Users\Rafael\Documents\ITQB estágio\code and pdf\zmw4_300nM_cut_thr200_Salapaka50'};


cnt_tr = {};

for j = 2:10
    cnt_tr{j} = [];
end
        
files = f_actin_50;

for file = 1:length(files)
    load(files{file});
    
    for i = 1:size(Step,1)
        [~,cnt] = getNumSteps4(Step(i,:),50);
        
        for j = 2:10
            cnt_tr{j}(end+1) = cnt(j);
        end
    end
    
    
end

histogram(cnt_tr{4});
