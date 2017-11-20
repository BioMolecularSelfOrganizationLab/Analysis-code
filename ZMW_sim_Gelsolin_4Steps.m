function [simZMW] = ZMW_sim_Gelsolin_4Steps(Ac,cycles)

% Ac = 0.8;
rates_onR = [0.1 0.3 0.6];
rates_on = rates_onR.*Ac;
rates_off = [0 0.2 3];



% cycles = 9;
SNR =0;

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
    tM = zeros(ttot,1);
    
    k = 1;
    t = [dt:dt:Ttot];
    tM0 = random(makedist('exp',1/rates_on(1)));
    tMon(1) = round(tM0./dt);
    Mon(tMon(1)+1) = 1;
    tM(1) = tM0;
    
    while sum(tMon) < ttot
%         sum(tM);
%         tic
        k = k+1;
        MonTre = cumsum(Mon);
        
        
        tM3 = random(makedist('exp',1/rates_on(3)));
        tM4 = random(makedist('exp',1/rates_off(3)));
        kon3 = round(tM3./dt);
        koff3 = round(tM4./dt);
        
        
        if MonTre(end) == 1
            
            tM1 = random(makedist('exp',1/rates_on(2)));
            kon2 = round(tM1./dt);
            tMon(k) = kon2;
            tM(k) = tM1;
            Mon(sum(tMon(1:k))+1) = 1;
            
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
            
            
        else
            tM3 = random(makedist('exp',1/rates_on(3)));
            tM4 = random(makedist('exp',1/rates_off(3)));
            kon3 = round(tM3./dt);
            koff3 = round(tM4./dt);
            
            
            if kon3 < koff3
                tMon(k) = kon3;
                tM(k) = tM3;
                Mon(sum(tMon(1:k))+1) = 1;
                
            else
                tMon(k) = koff3;
                tM(k) = tM4;
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
    %     toc
    
end
simZMW.cycles = cycles;

close(h)

if cycles == 1
    tdum1 = cell2mat(simZMW.noise);
    tdum2 = cell2mat(simZMW.monomers);
    figure
    plot(t,tdum1,'Color',[0.8 0.8 0.8])
    hold on
    plot(t,tdum2,'k')
    xlabel( ' Time (s)' );
    ylabel( 'Intensity (a.u.)' );
elseif cycles == 9
    figure
    tdum1 = cell2mat(simZMW.noise);
    tdum2 = cell2mat(simZMW.monomers);
    for j = 1:cycles
        subplot(3,3,j)
        plot(t,tdum1(:,j),'Color',[0.8 0.8 0.8])
        hold on
        plot(t,tdum2(:,j),'k')
        xlabel( ' Time (s)' );
        ylabel( 'Intensity (a.u.)' );
    end
end


