%% average traces: DNA       **********************************************

%% raw trace
load('C:\Users\Rafael\Documents\ITQB estágio\DNA\DNA4_8');
plot(mean(acc,1));

%% step trace
load('C:\Users\Rafael\Documents\ITQB estágio\code and pdf\DNA4_8 (stepSizes)');

plot(mean(stepFit,1));

%% num trace

load('C:\Users\Rafael\Documents\ITQB estágio\code and pdf\DNA4_8 (stepSizes)');

plot(mean(numFit,1));





%% average traces: LatA      **********************************************

%% raw trace
files = {...
    'C:\Users\Rafael\Documents\ITQB estágio\code and pdf\zmw1_1uMactin_LatA_nobump_thr150_Salapaka50',...
    'C:\Users\Rafael\Documents\ITQB estágio\code and pdf\zmw5_1uM_LatA_cut_thr150_Salapaka50'};

raw = [];

for file = 1:length(files)
    load(files{file});
    
    raw(end+1:end+size(Raw,1),1:3968) = Raw(:,1:3968);
end

plot(mean(raw,1));

%% step trace
files = {...
    'C:\Users\Rafael\Documents\ITQB estágio\code and pdf\zmw1_1uMactin_LatA_nobump_thr150_Salapaka50',...
    'C:\Users\Rafael\Documents\ITQB estágio\code and pdf\zmw5_1uM_LatA_cut_thr150_Salapaka50'};

step = [];

for file = 1:length(files)
    load(files{file});
    
    step(end+1:end+size(Step,1),1:3968) = Step(:,1:3968);
end

plot(mean(step,1));


%% num trace
files = {...
    'C:\Users\Rafael\Documents\ITQB estágio\code and pdf\zmw1_1uMactin_LatA_nobump_thr150_Salapaka50',...
    'C:\Users\Rafael\Documents\ITQB estágio\code and pdf\zmw5_1uM_LatA_cut_thr150_Salapaka50'};

num = [];

for file = 1:length(files)
    load(files{file});
    for i = 1:size(Step,1)
        fit = getNumSteps(Step(i,:));
        num(end+1,1:3968) = fit(:,1:3968);
    end
end

plot(mean(num,1));



%% average traces: Actin      **********************************************

%% raw trace
files = {...
    'C:\Users\Rafael\Documents\ITQB estágio\code and pdf\zmw1_1uMactin_nobump_thr300_Salapaka50',...
    'C:\Users\Rafael\Documents\ITQB estágio\code and pdf\zmw2_BSA_nobump_thr300_Salapaka50'};

raw = [];

for file = 1:length(files)
    load(files{file});
    
    raw(end+1:end+size(Raw,1),1:3909) = Raw(:,1:3909);
end

plot(mean(raw,1));

%% step trace
files = {...
    'C:\Users\Rafael\Documents\ITQB estágio\code and pdf\zmw1_1uMactin_nobump_thr300_Salapaka50',...
    'C:\Users\Rafael\Documents\ITQB estágio\code and pdf\zmw2_BSA_nobump_thr300_Salapaka50'};

step = [];

for file = 1:length(files)
    load(files{file});
    
    step(end+1:end+size(Step,1),1:3909) = Step(:,1:3909);
end

plot(mean(step,1));


%% num trace
files = {...
    'C:\Users\Rafael\Documents\ITQB estágio\code and pdf\zmw1_1uMactin_nobump_thr300_Salapaka50',...
    'C:\Users\Rafael\Documents\ITQB estágio\code and pdf\zmw2_BSA_nobump_thr300_Salapaka50'};

num = [];

for file = 1:length(files)
    load(files{file});
    for i = 1:size(Step,1)
        fit = getNumSteps(Step(i,:));
        num(end+1,1:3909) = fit(:,1:3909);
    end
end

plot(mean(num,1));


