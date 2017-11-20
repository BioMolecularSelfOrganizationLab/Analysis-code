clear all;
xx = 1:4000;

b_rate = 0.003;         % Bleaching rate
n_traces = 10;          % Number of traces

% Simulate traces
scale = 1000;
simulations = SIM_Gelsolin(1, n_traces, b_rate, scale);

step_fit = zeros(n_traces,4000);
num_fit = zeros(n_traces,4000);
realStep = zeros(1,n_traces);

for i = 1:n_traces
    step_fit(i,:) = stepfit1_alvaro(simulations.noiseScaled{i});
    [num_fit(i,:), realStep(i)] = getNumSteps(step_fit(i,:));
end

realStep

%%
close all;
plot(xx, simulations.monomersScaled{1});
figure;
plot(xx, simulations.noiseScaled{1});
%%
close all;
n = 1;

plot(num_fit(n,:) - simulations.monomers{n}');

figure;
plot(1:4000,num_fit(n,:),1:4000,simulations.monomers{n}');
legend('Num fit','Simulations');



