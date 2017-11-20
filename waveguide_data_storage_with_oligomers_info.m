
f_latA_50 = {...
    'C:\Users\Rafael\Documents\ITQB estágio\code\zmw1_1uMactin_LatA_nobump_thr150_Salapaka50',...
    'C:\Users\Rafael\Documents\ITQB estágio\code\zmw5_1uM_LatA_cut_thr150_Salapaka50'};

f_actin_50 = {...
    'C:\Users\Rafael\Documents\ITQB estágio\code\zmw1_1uMactin_nobump_thr300_Salapaka50',...
    'C:\Users\Rafael\Documents\ITQB estágio\code\zmw2_BSA_nobump_thr300_Salapaka50'};


latA_NumSteps = {};
N6_NumSteps = {};
N4_NumSteps = {};

%%
oligomers_info = [];

files = f_latA_50;
for file = 1:length(files)
    n_latA = 0;
    load(files{file});
    
    sz = size(Step);
    latA_NumSteps{file} = zeros(sz(1),sz(2));
    
    for i = 1:sz(1)
        num_step = getNumSteps2(Step(i,:),50);
        if num_step(1) == 0
            if max(abs(diff(num_step))) >= 2
                % add {jump_up,jump_down,elapsed_time}
                d = diff(num_step);
                
                mn = find(d==min(d));
                mx = find(d==max(d));
                
                for f = mx
                    for l = mn
                        % only count maximum after minimum
                       if l - f < 0
                           continue;
                       end
                       
                       % only count if the sum of the jumps is larger than
                       % the time gap
                       if l - f > d(f) - d(l)
                          break;
                       else
                            % add info
                            oligomers_info = [oligomers_info;[d(f),d(f),d(l),d(f)+d(l),l-f+1,file,i]];
                       end
                    end
                end
                
            else
                n_latA = n_latA + 1;
                latA_NumSteps{file}(n_latA,:) = num_step;
            end
        end
    end
    
    latA_NumSteps{file} = latA_NumSteps{file}(1:n_latA,:);
    
    oligomers_info = flipud(sortrows(oligomers_info));
    
    oligomer_info_table = array2table(oligomers_info,'VariableNames',{'Oligomer_size','Up_jump','Down_jump','Level_change','Time_gap_in_frames','File','Trace'});
end

%%

oligomers_info = [];

files = f_actin_50;
for file = 1:length(files)
    n_6 = 0;
    n_4 = 0;
    
    load(files{file});
    
    sz = size(Step);
    
    N6_NumSteps{file} = zeros(sz(1),sz(2));
    N4_NumSteps{file} = zeros(sz(1),sz(2));
    
    for i = 1:sz(1)
        num_step = getNumSteps4(Step(i,:),50);
        
        if num_step(1) == 0
            if max(abs(diff(num_step))) >= 2
                % add {jump_up,jump_down,elapsed_time}
                d = diff(num_step);
                
                mn = find(d==min(d));
                mx = find(d==max(d));
                
                for f = mx
                    for l = mn
                        % only count maximum after minimum
                       if l - f < 0
                           continue;
                       end
                       
                       % only count if the sum of the jumps is larger than
                       % the time gap
                       if l - f > d(f) - d(l)
                          break;
                       else
                            % add info
                            oligomers_info = [oligomers_info;[d(f),d(f),d(l),d(f)+d(l),l-f+1,file,i,l-f-d(f)-d(l)]];
                       end
                    end
                end
                
            else
                if num_step(end)>6
                    n_6 = n_6 + 1;
                    N6_NumSteps{file}(n_6,:) = num_step;
                elseif num_step(end)<4
                    n_4 = n_4 + 1;
                    N4_NumSteps{file}(n_4,:) = num_step;
                end
            end
        end
    end
    
    N6_NumSteps{file} = N6_NumSteps{file}(1:n_6,:);
    N4_NumSteps{file} = N4_NumSteps{file}(1:n_4,:);
    
    oligomers_info = flipud(sortrows(oligomers_info));
    oligomer_info_table = array2table(oligomers_info,'VariableNames',{'Oligomer_size','Up_jump','Down_jump','Level_change','Time_gap_in_frames','File','Trace','ok'});
end

%%

for i = 1:100
    plot(N6_NumSteps{i});
    pause(1);
    
end

%%
dlmwrite('latA TRACE zmw1_1uMactin_nobump_thr300_Salapaka50.txt',latA_NumSteps{1},'delimiter','\t');
dlmwrite('latA TRACE zmw2_BSA_nobump_thr300_Salapaka50.txt',latA_NumSteps{2},'delimiter','\t');
dlmwrite('N6 TRACE zmw1_1uMactin_nobump_thr300_Salapaka50.txt',N6_NumSteps{1},'delimiter','\t');
dlmwrite('N6 TRACE zmw2_BSA_nobump_thr300_Salapaka50.txt',[N6_NumSteps{2}],'delimiter','\t');
dlmwrite('N3 TRACE zmw1_1uMactin_nobump_thr300_Salapaka50.txt',[N4_NumSteps{1}],'delimiter','\t');
dlmwrite('N3 TRACE zmw2_BSA_nobump_thr300_Salapaka50.txt',[N4_NumSteps{2}],'delimiter','\t');


%%

d = max(abs(diff(latA_NumSteps{1}')));



