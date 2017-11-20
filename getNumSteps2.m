function [NumSteps,count_2_3_step] = getNumSteps2( steps ,realStep)


%plot(steps);
% This program converts the steps found using a step finding algorithm
% into a stepcase trace (i.e. monomer number vs. time trace).
% Rafael Correia, Aug 6th 2017
%
% Input: "steps" is the result of the step finding algorithm applied to the
% noisy data.
% Output:   "NumSteps" is the step fit for the Monomer numbers (0,1,2,...)
%           "realStep" is the step value assumed by the algorithm


    % auxiliar function
    % constructs the Number Monomer Fit Function
    function out = fun(x,xdata)

        size_data = length(xdata);
        step_size = x;           % step size
        %offset = x(2);              % "zero" offset due to background noise
        
        stepDiff = diff(steps);
        
        step_events = [1, find(stepDiff)+1, size_data+1];

        out = ones(1,size_data);
        
        % for each step pleateau
        for i = 1:(length(step_events)-1)
            v = 0;
            % search bin
            for j = ((unique((min(steps)))/step_size)-2):((unique((max(steps)))/step_size)+2)
                step_v = steps(step_events(i));
%                 low = (j - .5) * step_size + offset;
%                 high = (j + .5) * step_size + offset;
                low = (j - .5) * step_size;
                high = (j + .5) * step_size;
                if (step_v > low && step_v < high)
                    v = (low + high)/2;
                    break;
                end
            end
            
            % set value
            out(step_events(i):(step_events(i+1)-1)) = v;
        end
    end
    
    % -----------------------------------------------------------
    
    % fit
    xdata = 1:length(steps);
    step_diff = diff(steps);
    % step sizes
    step_sizes = abs(step_diff(find(step_diff)));
    
    min_step = min(step_sizes);
    if isempty(min_step)
        min_step = 0;
    end

    ans = fun(realStep, xdata);
    
    % scale down
    step_diff = diff(ans);
    step_sizes = abs(step_diff(find(step_diff)));
    min_step = min(step_sizes);
    if isempty(min_step)
        min_step = 1;
    end
    ans = round((ans - min(ans))/realStep);
    
    % add one frame steps in all step jumps bigger than 1
    step_diff = abs(diff(ans));
    indexes = find(step_diff >= 2);
    count_2_3_step = length(indexes);
    
    for i=indexes
        jump = step_diff(i);
        half_b = floor(jump/2);
        half_t = ceil(jump/2);
        ans(max(1,i-half_b):min(i+half_t,length(steps))) = round(linspace(ans(i),ans(i+1),min(i+half_t,length(steps)) - max(1,i-half_b) + 1));
    
    end
    realStep = min_step;
    NumSteps = ans;
    
end



