function [MonDBT] = BleachAnalysis(traces, b_rate)

% This function receives traces and plots the Monomer diference between a
% trace that is only affected by bleaching and the input.

TraceSize = size(traces);
% #Lines: # of traces
% #Columns: length of each trace
N_traces = round(TraceSize(1));
Trace_length = TraceSize(2);

h = waitbar(0,'Analyzing data, please wait...');

% Original value: 1000
BleachSampleSize = 1;

%bleaching rate
B_rate = b_rate;

DiffDown = zeros(1,N_traces);
MonDiffBleachTrace = zeros(N_traces,Trace_length);
% StepTraces normalized to monomer numbers:
MonNumTrace = zeros(N_traces,Trace_length);

for j = 1:round(N_traces)
    
    waitbar(j / N_traces)
    
    % current trace
    CurrentStepTrace = traces(j,:);
    
    if CurrentStepTrace(1) ~= min(CurrentStepTrace)
       continue;
    end
    
    % temporary bug fix for Int2MonNum_DoubleSteps problem (dimensions
    % mismatch):
%     vec = vec(1:Trace_length);
    
    MonNumTrace(j,:) = CurrentStepTrace;
    
    DiffMonNumTrace = diff(MonNumTrace(j,:));
    % indexes of Up step
    UpIndexes = find(DiffMonNumTrace>0);
    MockTrace = zeros(1,Trace_length);
    MockTrace(UpIndexes) = 1;
    
    % mock trace (only up steps acumulated)
    MockTrace = cumsum(MockTrace);
    
    MockTrace_Bleached = zeros(BleachSampleSize,Trace_length);
    
    for i=1:BleachSampleSize
        MockTrace_Bleached(i,:) = ZMW_sim_Bleaching(MockTrace,B_rate)';
    end
    
    %figure;
    %plot(1:4000,MockTrace_Bleached,'b',1:4000,MonNumTrace(j,:),'r');
    
    OnlyBleachMean = mean(MockTrace_Bleached,1);
    MonDiffBleachTrace(j,:) = MonNumTrace(j,:) - OnlyBleachMean;
    
end

close(h);

MonDBT = mean(MonDiffBleachTrace,1);

end

