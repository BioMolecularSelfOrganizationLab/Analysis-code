
%load('zmw2_BSA_nobump_thr300_Salapaka50'); % Experimental or Simulated DATA
load('zmw5_1uM_LatA_cut_thr150_Salapaka50');

NcS = size(Step); % this is the number of traces to analyse
Nc = NcS(1);
Mon_ds = zeros(Nc,NcS(2));
Mon_scaled = zeros(Nc,NcS(2));
stepSize = zeros(Nc,1);

%% version 1

for k = 1:Nc
    [Mon_ds(k,:), stepSize(k)] = getNumSteps(Step(k,:));
    
    % get monomer scaled
    Mon_scaled(k,:) = Mon_ds(k,:).*stepSize(k);
end

% rafael
avMon_scaled = mean(Mon_scaled,1);

figure;
histogram(stepSize,'BinLimits',[0,250]);
title('Version 1');
fprintf('Version 1\nMean: %.2f\n',mean(stepSize(find(stepSize <= 250))));
% plot
% figure;
% hold on
% plot(mean(Raw));
% plot(avMon_ds,'r','LineWidth',2);
% plot(avMon_scaled,'r','LineWidth',2);
% legend('Avg Mon', 'Avg Trace');

%% version 2

for k = 1:Nc
    
    % find REAL_STEP -------------------------------
    step_diff = diff(Step(k,:));
    step_sizes = abs(step_diff(find(step_diff)));
    
    % get mode(step_size)
    xx = linspace(min(step_sizes),max(step_sizes),100);
    gamma_dist = fitdist(step_sizes','Gamma');
    shape = gamma_dist.a;
    scale = gamma_dist.b;
    gamma_func = gampdf(xx,shape,scale);
    realStep = xx(find(gamma_func == max(gamma_func)));
    % ----------------------------------------------
    
    % ---- data from DNA4_8 -----
    DNA_mode = 70.0411;
    DNA_STD = 45.9186;
    % ---------------------------

    if ~isempty(realStep)
        if abs(realStep - DNA_mode) < DNA_STD
            [Mon_ds(k,:)] = getNumSteps2(Step(k,:),realStep);
            stepSize(k) = realStep;
            % get monomer scaled
            Mon_scaled(k,:) = Mon_ds(k,:).*stepSize(k);
        end
    end
    
end

% find indexes of non-zero (rejected) traces
indx = find(stepSize);
fprintf('Versio 2\n%i out of %i belong to the range.\n',length(indx),size(Step,1));
avMon_scaled = mean(Mon_scaled(indx),1);

figure;
histogram(stepSize,'BinLimits',[0,250]);
title('Version 2');
fprintf('Mean: %.2f\n\n',mean(stepSize(find(stepSize <= 250))));