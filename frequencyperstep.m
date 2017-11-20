function [freq] = frequencyperstep


% meanstepsize = 67;
n = 4; %number of time intervals

PathName = {
    'C:\Users\Rafael\Documents\ITQB estágio\code and pdf\';
    'C:\Users\Rafael\Documents\ITQB estágio\code and pdf\';
%       'Z:\Data\Actin Project - Alvaro Niko - 2008\ZMW\TIRF\Analysis\BiotGelsolin\biotGelsolin - LatA\1000nMactin\160321 BSA\';
%       'Z:\Data\Actin Project - Alvaro Niko - 2008\ZMW\TIRF\Analysis\BiotGelsolin\biotGelsolin - LatA\1000nMactin\160428\';
%       'Y:\Data\Actin Nuc Alvaro Maria 2015\Simulations\Conversion_Maria\'
%       'Y:\Data\Actin Nuc Alvaro Maria 2015\Simulations\Nucleation_Maria\change offrate\'
%     'Z:\Data\Actin Project - Alvaro Niko - 2008\ZMW\simus\Gelsolin_simus\';
    };

FileName = {
            'zmw2_BSA_nobump_thr300_Salapaka50';
            'zmw1_1uMactin_nobump_thr300_Salapaka50';
%             'zmw1_1uMactin_LatA_nobump_thr150_Salapaka50';
%             'zmw5_1uM_LatA_cut_thr150_Salapaka50';
%     'nucleation_N4_Polyoff_0p1_Nucoff_1';
%     'Gelsolin_Litvalues_bleachrate_0p003_bleached_Salapaka50';
  
    };

E = length(FileName);

Nsum_time = zeros(E,11);
Nvisits_sum1_n = zeros(E,11);
           
for k = 1:E
    
    clear Mon trace i Mon_elong Mon_nuc N Raw Step Y nc
    
    CurrentFileName = [PathName{k} FileName{k}];
    
    load(CurrentFileName,'Raw','Step');
%     load(CurrentFileName,'sim');
  
 Set = 1; %%if 1, then Raw or Step, if not, then intensity to monomer converted traces
    
%  trace = cell2mat(sim.trace');
%   trace = sim.bleached;
 trace = Step;
 trace1 = Raw;
%  trace = cell2mat(Step');
 Size = size(trace);   
 Nc = Size(1);
 frames = Size(2);
 part1 = round(frames/n);
 Y = zeros(frames,Nc);
 Mon = zeros(Nc,frames);
 N1 = zeros(500,100);
 Nvisits = zeros(500,100);
 nc = 0;

    for i = 1:Nc  
         clear MeanSS ModeSS
%         [~, ~, ~, Y(:,i),~, ~,MeanSS,ModeSS] = Int2MonNum_DoubleSteps(Step(i,:));
%      [Up, Down, dSt, Y1c,StepFitCorr, Frac_sidotri_up_down,meanss,modess] = Int2MonNum_DoubleSteps(Steps);
        [Y1c,stepsize] = getNumSteps(Step(i,:));
%         Mon(i,:) = (trace(i,:))/MeanSS; 
        Mon(i,:) = (trace(i,:))/stepsize; 
%         Mon(i,:) = Y1c(1,1:frames);
    end  
%     
    Mon_round = round(Mon);
%     Mon_round = trace;
    Mon_part1 = Mon_round(:,(1*part1):(2*part1));
%     Mon_part1 = Mon(:,1:(frames));
%     Mon_part2 = Mon_round(:,part1:frames);
    
    Mon_diff = diff(Mon_part1');
    Mon_diff1 = Mon_diff';
    Mon_steps = [Mon_part1(:,1),Mon_diff1];       
    Mon_steps1 = -1.*ones(Nc,frames);

if Set == 1
    for i = 1:Nc
        
        N_end1 = Mon_round(i,end);
        N_end2(i,1) = Mon_round(i,end);
        N_max = max(Mon_part1(i,:));
        N_maxround = round(N_max);
%         N_end2 = Mon_part2(i,end);
%         edges = [0.5:1:N_max];
        edges = [-0.5:1:N_max];
        Mon_steps_i = Mon_steps(i,:);
        Mon_steps_short = Mon_steps_i(Mon_steps_i ~= 0);
        N = length(Mon_steps_short);
        Mon_steps1(i,1:N) = cumsum(Mon_steps_short);
         
        if N_end1 > 6 && N_end1 < 3000
%              N1(i,1:(N_maxround)) = histc(Mon_part1(i,:),edges);
           N1(i,1:(N_maxround+1)) = histc(Mon_part1(i,:),edges);                    %how many frames does it stay at one state? 
           nc = nc + 1;
           Nvisits(i,1:(N_maxround+1)) = histc(Mon_steps1(i,1:N),edges);              %how often does a state get visited?
        end

    end
else
     for i = 1:Nc
        N_end1 = Y(end,i);
        N_max = max(Y(:,i));
        if N_end1 > 0
            N1(i,1:N_max+1) = hist(Y(:,i),N_max+1);
            nc = nc+1;
        end
    end
    
    
end

    
    N1_10 = N1(:,1:11);
    Nsum1 = sum(N1_10);
    Nsum_time(k,:) = Nsum1*0.2/(nc);
    
    Nvisits_1_10 = Nvisits(:,1:11);
    Nvisits_sum1 = sum(Nvisits_1_10);
    Nvisits_sum1_n(k,:) = Nvisits_sum1/2;
    
    N_end(:,k) = N_end2;     
 
end

Nsum_time_mean = mean(Nsum_time,1);
Nsum_time_mean = Nsum_time_mean(Nsum_time_mean ~= -1);
Nvisits_sum1_n_mean = mean(Nvisits_sum1_n,1);
% N_end_pooled = [N_end(:,1);N_end(:,2)];       %for experiments
N_end_pooled = N_end;

figure;histogram(N_end_pooled);
xlabel ('N end');
ylabel ('Events');

figure;bar(0:10,Nsum_time_mean);
    xlabel ('bound monomers');
    ylabel ('time (s)');   
   
    figure;bar(0:10,Nvisits_sum1_n_mean);
    xlabel ('bound monomers');
    ylabel ('visits');  
