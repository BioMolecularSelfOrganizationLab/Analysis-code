
%% get DNA: mode & SD
    load('C:\Users\Rafael\Documents\ITQB estágio\Code\zmw1_1uMactin_LatA_nobump_thr150_Salapaka30.mat');
    
    sz = size(Raw);
    stepSizes = [];
    
    for i = 1:sz(1)
        % step sizes
        step_diff = diff(Step(i,:));
        step_size = abs(step_diff(find(step_diff)));
        stepSizes(end+1:end+length(step_size)) = step_size;
    end
    
    
    stepSizes(find(stepSizes==max(stepSizes))) = 0;
   
    
    xx = linspace(0,max(stepSizes),1000);
    gamma_dist = fitdist(stepSizes','Gamma');
    shape = gamma_dist.a
    scale = gamma_dist.b
    gamma_func = gampdf(xx,shape,scale);
    
    close all;
    hold on;
    histogram(stepSizes,100);
    plot(xx,80000*gamma_func,'LineWidth',3);
    legend('Step sizes','Gamma distribution fit');
    
    mode = xx(find(gamma_func == max(gamma_func)))
    st_dv = std(stepSizes)

%% get NumFit traces with DNA mode & SD as getNumFit parameters

load('C:\Users\Rafael\Documents\ITQB estágio\code and pdf\zmw1_1uMactin_LatA_nobump_thr150_Salapaka50');

n = 5;

sz = size(Step);
numFit = zeros(sz(1),sz(2));
stepSizes = {};

wb = waitbar(0,'Processing data');
for i=1:sz(1)
    waitbar(i/sz(1),wb);
    
    % step sizes
    step_diff = diff(Step(i,:));
    stepSizes{i} = abs(step_diff(find(step_diff)));
    
    
    length(stepSizes{i})
    
    % get step size mode
    [stp_size_N,stp_size_edges] = histcounts(stepSizes{i},10);
    idx_max = find(stp_size_N == max(stp_size_N));
    stp_size_mode = (stp_size_edges(idx_max(1)) + stp_size_edges(idx_max(1)+1))/2;
    
    [numFit(i,:),~] = getNumSteps(Step(i,:));
end

close(wb);

%%
hist(stepSizes{5});
%%
xx = linspace(min(stepSizes),max(stepSizes),100);

gamma_dist = fitdist(stepSizes','Gamma');
shape = gamma_dist.a;
scale = gamma_dist.b;
gamma_func = gampdf(xx,shape,scale);

normal_dist = fitdist(stepSizes','Normal');
mu = normal_dist.mu;
sigma = normal_dist.sigma;
normal_func = normpdf(xx,mu,sigma);

poisson_dist = fitdist(stepSizes','Poisson');
lambda = poisson_dist.lambda;
%poisson_func = poisspdf(linspace(min(stepSizes),max(stepSizes),100),lambda);
poisson_func = ((lambda.^xx)*(exp(1)^(-lambda)))./gamma(xx);
%%
close all;
hold on;
histogram(stepSizes);   
title('dna'),
disp(mean('stepSizes'));

plot(xx,4000*normal_func);
plot(xx,4000*gamma_func);
plot(xx,35*poisson_func);

legend('step sizes','normal','gamma','poisson');