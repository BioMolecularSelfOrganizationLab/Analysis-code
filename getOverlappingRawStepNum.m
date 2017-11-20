% save to a folder graphs with overlapping:\
%   - Raw data
%   - StepFit
%   - NumFit

load('C:\Users\Rafael\Documents\ITQB estágio\TIRF\TIRF_data_F1_g_ABCD_1');
f = figure;

stepSize = 14;

sz = size(Raw);

for i = 1:sz(1)
    cla;
    hold on;
    
    raw = plot(Raw(i,:));
    step = plot(Step(i,:),'k');
    [numFit] = getNumSteps3(Step(i,:),stepSize);
    %[~,~,~,numFit,~,~,~,~,~] = Int2MonNum_DoubleSteps(Step(i,:));
    %dif = diff(Step(i,:));
    %stepSize = mean(abs(dif(find(dif ~= 0))));
    
    
    num = plot(numFit.*stepSize,'r');
    legend('Raw','StepFit','NumFit');
    
    step.LineWidth = 3;
    num.LineWidth = 2;
    
    saveas(f,strcat(...
        'C:\Users\Rafael\Documents\ITQB estágio\TIRF\overlapping traces TIRF F1 (step_size = 14)\',...
        num2str(i)),'png');
end