function [visit] = visitFrequency(trace,n_divide)
%	This function gives the visit frequency and visit total duration for
%	specific plateaus.
%   The indexes match for all three output vectors.
%   'n_divide' tells into how many sub_traces we should split the 'trace'
%   visit{k} refers to the k-th sub_trace
%   visit{k}{1} is the visit frequency vector for sub_trace k
%   visit{k}{2} is the visit duration vector for sub_trace k
%   visit_freq(k) gives the visit frequency for plateau at level k - 1
%   visit_duration(k) gives the visit total duration for plateau at level k - 1
    
    sz = length(trace);
    
    sub_sz = round(sz/n_divide);
    
    for k = 1:n_divide
        w = (k - 1) * sub_sz + 1;
        sub_trace = trace(w:min(w+sub_sz,sz));
        
        levels_seq = round(sub_trace(diff([round(sub_trace),-1000]) ~= 0));
        visit_duration = [];
        visit_freq = [];

        for i = 0:round(max(sub_trace))
            visit_duration(i + 1) = length(find(round(sub_trace) == i)) / 100;
            visit_freq(i + 1) = length(levels_seq(levels_seq == i));
        end

        visit{k}{1} = visit_freq;
        visit{k}{2} = visit_duration;
    end
end