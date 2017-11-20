function [simZMW] = ZMW_sim_Gelsolin_2(Ac,cycles)

% Ac =1;
rates_onR = [0.05 0.05 0.05 0.05 0.05 0.05];
rates_on = rates_onR.*Ac;
rates_off = [0.05 0.05 0.05 0.05 0.05 0.05];


% cycles = 1000;
SNR = 1;

h = waitbar(0,'Please wait, simulating traces...');

for i = 1:cycles
    clear MonTre t tM  k tMon Mon
    waitbar(i / cycles)
    
    %     clear all
    Ttot = 800;
    dt = 0.2;
    ttot = Ttot/dt;
    Mon = zeros(ttot,1);
    MonTre = zeros(ttot,1);
    tM = zeros(ttot,1);     %time until next step
    tMon = zeros(ttot,1);
    
    k = 1;
    t = [dt:dt:Ttot];
    tM0 = random(makedist('exp',1/rates_on(1)));
    tMon(1) = round(tM0./dt);
    Mon(tMon(1)+1) = 1;
    tM(1) = tM0;
    
    while sum(tMon) < ttot
        
        k = k+1;
        MonTre = cumsum(Mon);
        
        if MonTre(end) == 1
            
            tM2 = random(makedist('exp',1/rates_on(2)));
            kon2 = round(tM2./dt);
            tM1 = random(makedist('exp',1/rates_off(1)));
            koff1 = round(tM1./dt);
            
            
            if kon2 < koff1
                tMon(k) = kon2;
                tM(k) = tM2;
                Mon(sum(tMon(1:k))+1) = 1;
                
            else
                tMon(k) = koff1;
                tM(k) = tM1;
                Mon(sum(tMon(1:k))+1) = -1;
            end
            
            
            
        elseif MonTre(end) == 2
            tM2 = random(makedist('exp',1/rates_off(2)));
            koff2 = round(tM2./dt);
            tM3 = random(makedist('exp',1/rates_on(3)));
            kon3 = round(tM3./dt);
            
            if kon3 < koff2
                tMon(k) = kon3;
                tM(k) = tM3;
                Mon(sum(tMon(1:k))+1) = 1;
                
            else
                tMon(k) = koff2;
                tM(k) = tM2;
                Mon(sum(tMon(1:k))+1) = -1;
            end
            
        elseif MonTre(end) == 3
            tM3 = random(makedist('exp',1/rates_off(3)));
            koff3 = round(tM3./dt);
            tM4 = random(makedist('exp',1/rates_on(4)));
            kon4 = round(tM4./dt);
            
            if kon4 < koff3
                tMon(k) = kon4;
                tM(k) = tM4;
                Mon(sum(tMon(1:k))+1) = 1;
                
            else
                tMon(k) = koff3;
                tM(k) = tM3;
                Mon(sum(tMon(1:k))+1) = -1;
            end
            
            
        elseif MonTre(end) == 4
            tM4 = random(makedist('exp',1/rates_off(4)));
            koff4 = round(tM4./dt);
            tM5 = random(makedist('exp',1/rates_on(5)));
            kon5 = round(tM5./dt);
            
            if kon5 < koff4
                tMon(k) = kon5;
                tM(k) = tM5;
                Mon(sum(tMon(1:k))+1) = 1;
                
            else
                tMon(k) = koff4;
                tM(k) = tM4;
                Mon(sum(tMon(1:k))+1) = -1;
            end
            
            
        else
            tM5 = random(makedist('exp',1/rates_on(5)));
            tM6 = random(makedist('exp',1/rates_off(5)));
            kon6 = round(tM5./dt);
            koff5 = round(tM6./dt);
            
            
            if kon6 < koff5
                tMon(k) = kon6;
                tM(k) = tM5;
                Mon(sum(tMon(1:k))+1) = 1;
                
            else
                tMon(k) = koff5;
                tM(k) = tM6;
                Mon(sum(tMon(1:k))+1) = -1;
            end
            
        end
        
        %         koff3 < kon3 & MonTre(end) > 2 & MonTre(end) > 0
        %         tMon(k) = koff3;
        %         tM(k) = tM4;
        %         Mon(sum(tMon(1:k))+1) = -1;
        %
        %         kon2 < koff2 & MonTre(end) == 1
        %         tMon(k) = kon2;
        %         tM(k) = tM1;
        %         Mon(sum(tMon(1:k))+1) = 1;
        
        
    end
    %     toc
    simZMW.time{i} = t;
    simZMW.monomers{i} = MonTre;
    simZMW.Tmon{i} = tMon;
    simZMW.TM{i} = tM;
    simZMW.noise{i} = MonTre + (1/SNR)*randn(numel(MonTre),1);
    simZMW.bleach{i} = ZMW_sim_Bleaching(MonTre,0.03);
    % simZMW.bleach{i} = AddBleaching(MonTre);
    
    %     toc
    
end
simZMW.cycles = cycles;
simZMW.onrates = rates_on;
simZMW.offrates = rates_off;
close(h)

if cycles == 1
    tdum1 = cell2mat(simZMW.noise);
    tdum2 = cell2mat(simZMW.monomers);
    tdum3 = cell2mat(simZMW.bleach);
    figure
    plot(t,tdum1,'Color',[0.8 0.8 0.8])
    hold on
    plot(t,tdum2,'k')
    plot(t,tdum3,'r')
    ylim([0 max(tdum1)])
    xlim([0 800])
    xlabel( ' Time (s)' );
    ylabel( 'Intensity (a.u.)' );
elseif cycles == 9
    figure
    tdum1 = cell2mat(simZMW.noise);
    tdum2 = cell2mat(simZMW.monomers);
    tdum3 = cell2mat(simZMW.bleach);
    for j = 1:cycles
        subplot(3,3,j)
        plot(t,tdum1(:,j),'Color',[0.8 0.8 0.8])
        hold on
        plot(t,tdum2(:,j),'k')
        plot(t,tdum3(:,j),'r')
        ylim([0 max(tdum1(:,j))])
        xlim([0 800])
        xlabel( ' Time (s)' );
        ylabel( 'Intensity (a.u.)' );
    end
end

save ('ZMW_sim_condsorting_dt0p2.mat','simZMW');
