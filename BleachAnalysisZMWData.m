


% Load data
% Raw & Step variables loaded into workspace

%load('zmw1_1uMactin_LatA_nobump_thr150_Salapaka50.mat');
load('zmw1_1uMactin_nobump_thr300_Salapaka50');
%load('zmw2_BSA_nobump_thr300_Salapaka50.mat');
%load('zmw5_1uM_LatA_cut_thr150_Salapaka50.mat');

TraceSize = size(Step);

% #Lines: # of traces
% #Columns: length of each trace
N_traces = round(TraceSize(1));
Trace_length = TraceSize(2);

%h = waitbar(0,'Analyzing data, please wait...');

% ? Original value: 1000
BleachSampleSize = 1;

%bleaching rate
B_rate = 0.003;

DiffDown = zeros(1,N_traces);
MonDiffBleachTrace = zeros(N_traces,Trace_length);
% StepTraces normalized to monomer numbers:
MonNumTrace = zeros(N_traces,Trace_length);

% debug variable
n_bad_trace = 0;

for j = 1:round(N_traces)
    disp(j);
    %waitbar(j / N_traces)
    
    % current trace
    CurrentStepTrace = Step(j,:);
    
    %[~, ~, ~, vec,~, ~,~,~] = Int2MonNum_DoubleSteps(CurrentStepTrace);
    vec = getNumSteps(CurrentStepTrace);
    
    if vec(1) ~= min(vec)
       n_bad_trace = n_bad_trace + 1;
       
%        s1 = subplot(2,1,1);
%        s2 = subplot(2,1,2);
%        p1 = plot(s1,1:Trace_length,Raw(j,:));
%        p2 = plot(s2,1:Trace_length,vec);
%        p2.LineWidth = 3;
% %        
%        saveas(gcf,fullfile(pwd,'removed traces',sprintf('trace_%d',j)),'png');
%        
%        pause(2);
       continue;
    end
    
    % temporary bug fix for Int2MonNum_DoubleSteps problem (dimensions
    % mismatch):
    vec = vec(1:Trace_length);
    MonNumTrace(j,:) = vec;
    
    DiffMonNumTrace = diff(MonNumTrace(j,:));
    % indexes of Up step
    UpIndexes = find(DiffMonNumTrace>0);
    MockTrace = zeros(1,Trace_length);
    MockTrace(UpIndexes) = 1;
    
    % mock trace (only up steps acumulated)
    MockTrace = cumsum(MockTrace);
    

    MockTrace_Bleached = zeros(BleachSampleSize,Trace_length);
    %Ndo = zeros(BleachSampleSize,1);
    
    
    for i=1:BleachSampleSize
        MockTrace_Bleached(i,:) = ZMW_sim_Bleaching(MockTrace,B_rate)';
        
        %Ndo(i) = length(find(diff(MockTrace_Bleached(i,:))<0));
    end

    % debug:
    l = 1:Trace_length;
    %plot(l,UpTrace,l,mean(BleachUP,2)');
    
    OnlyBleachMean = mean(MockTrace_Bleached,1);
    MonDiffBleachTrace(j,:) = MonNumTrace(j,:) - OnlyBleachMean;
    
    %plot(l,MonNumTrace(j,:),l,Step(j,:)./100);
    %legend('Number of Monomers','Intensity');
    
    %NdoMT = length(find(diff(MonNumTrace(j,:))<0));
    %DiffDown(j) = NdoMT-mean(Ndo);
    
end

disp(n_bad_trace / N_traces);

%close(h);


MonDBT = mean(MonDiffBleachTrace,1);

MeanTrace = mean(MonNumTrace,1);

close all;

figure;
plot(MonDBT,'');
title('MonDiffBleach Over all Traces');

%figure;
%histogram(MonDBT);

%%
% 
% figure;
% plot(1:Trace_length,MonNumTrace,'b',1:Trace_length,MeanTrace,'r');
% title('Mean of all MonNum Traces');
% 
% figure;
% plot(1:Trace_length,Step,'b',1:Trace_length,mean(Step,1),'r',...
%     1:Trace_length,zeros(1,Trace_length),'r');
% 
