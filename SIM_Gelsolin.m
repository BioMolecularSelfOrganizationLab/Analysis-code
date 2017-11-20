function [simZMW] = SIM_Gelsolin(C,cycles,Brate, ScaleFactor)

clear kon koff

% kon = [0.03 0.0000001 0.0000001 0.0000001 0.0000001 0.0000001 0.0000001]; % in (�M.s)^-1
% koff = [0.0000001 0.0000001 0.0000001 0.0000001 0.0000001 0.0000001 0.0000001]; % in (s)^-1

% Literature Values Gelsolin - MFC
% kon = [0.025 0.8 0.12 0.12 0.12 0.12 0.12]; % in (�M.s)^-1
% koff = [0.0000001 0.0000002 0.00000072 0.00000072 0.00000072 0.00000072 0.00000072]; % in (s)^-1

% Literature Values Gelsolin - Pollard
%kon = [0.025 0.8 0.5 0.5 0.5 0.5 0.5]; % in (�M.s)^-1
%koff = [0.00001 0.02 0.32 0.32 0.32 0.32 0.32]; % in (s)^-1
% ko = 0.03;
% kf = 0.0001;
% kf1 = 0.01;
% kon = [3*ko ko ko ko ko ko ko]; % in (�M.s)^-1
% koff = [1*kf1 0.06 0.06 kf kf kf kf]; % in (s)^-1

% Brate;
kf = 0.000000000001;
ko = 0.04;
kon = [ko ko ko ko ko ko ko]; 
%koff = [0.01 0.04 0.04 kf kf kf kf]; % in (s)^-1
koff = [kf kf kf kf kf kf kf];

P = 1;
Kon = kon.*C;
SNR = 1;
% cycles;
dt = 0.2;
% h = waitbar(0,'Simulating, please wait...');

E1 = makedist('exp',1/Kon(1)/dt);
S1 = makedist('exp',1/koff(1)/dt);
E2 = makedist('exp',1/Kon(2)/dt);
S2 = makedist('exp',1/koff(2)/dt);
E3 = makedist('exp',1/Kon(3)/dt);
S3 = makedist('exp',1/koff(3)/dt);
E4 = makedist('exp',1/Kon(4)/dt);
S4 = makedist('exp',1/koff(4)/dt);
E5 = makedist('exp',1/Kon(5)/dt);
S5 = makedist('exp',1/koff(5)/dt);
E6 = makedist('exp',1/Kon(6)/dt);
S6 = makedist('exp',1/koff(6)/dt);
E7 = makedist('exp',1/Kon(7)/dt);
S7 = makedist('exp',1/koff(7)/dt);


for i = 1:cycles
    
    clear MonTre k tMon Mon
%     waitbar(i / cycles)
    Ttot = 800;
    ttot = Ttot/dt;
    Mon = zeros(ttot,1);
    k = 1;
    tMon = 0;
        
    MonTre = cumsum(Mon);
    
    while sum(tMon) < ttot
    
        switch MonTre(end)
            case 0
                tMon(k) = ceil(random(E1));
                if sum(tMon(1:k))< ttot
                    Mon(sum(tMon(1:k))) = 1;
                end
                
            case 1
                kon_E2 = ceil(random(E2));
                koff_S1 = ceil(random(S1));
                if  kon_E2 < koff_S1
                    tMon(k) = kon_E2;
                    if sum(tMon(1:k))< ttot
                        Mon(sum(tMon(1:k))) = 1;
                    end
                else
                    tMon(k) = koff_S1;
                    if sum(tMon(1:k))< ttot
                        Mon(sum(tMon(1:k))) = -1;
                    end
                end
                
            case 2
                kon_E3 = ceil(random(E3));
                koff_S2 = ceil(random(S2));
                if  kon_E3 < koff_S2
                    tMon(k) = kon_E3;
                    if sum(tMon(1:k))< ttot
                        Mon(sum(tMon(1:k))) = 1;
                    end
                else
                    tMon(k) = koff_S2;
                    if sum(tMon(1:k))< ttot
                        Mon(sum(tMon(1:k))) = -1;
                    end
                end
                
            case 3
                kon_E4 = ceil(random(E4));
                koff_S3 = ceil(random(S3));
                if  kon_E4 < koff_S3
                    tMon(k) = kon_E4;
                    if sum(tMon(1:k))< ttot
                        Mon(sum(tMon(1:k))) = 1;
                    end
                else
                    tMon(k) = koff_S3;
                    if sum(tMon(1:k))< ttot
                        Mon(sum(tMon(1:k))) = -1;
                    end
                end
                          
            case 4
                kon_E5 = ceil(random(E5));
                koff_S4 = ceil(random(S4));
                if  kon_E5 < koff_S4
                    tMon(k) = kon_E5;
                    if sum(tMon(1:k))< ttot
                        Mon(sum(tMon(1:k))) = 1;
                    end
                else
                    tMon(k) = koff_S4;
                    if sum(tMon(1:k))< ttot
                        Mon(sum(tMon(1:k))) = -1;
                    end
                end   
                
            case 5
                kon_E6 = ceil(random(E6));
                koff_S5 = ceil(random(S5));
                if  kon_E6 < koff_S5
                    tMon(k) = kon_E6;
                    if sum(tMon(1:k))< ttot
                        Mon(sum(tMon(1:k))) = 1;
                    end
                else
                    tMon(k) = koff_S5;
                    if sum(tMon(1:k))< ttot
                        Mon(sum(tMon(1:k))) = -1;
                    end
                end
                
            case 6
                kon_E7 = ceil(random(E7));
                koff_S6 = ceil(random(S6));
                if  kon_E7 < koff_S6
                    tMon(k) = kon_E7;
                    if sum(tMon(1:k))< ttot
                        Mon(sum(tMon(1:k))) = 1;
                    end
                else
                    tMon(k) = koff_S6;
                    if sum(tMon(1:k))< ttot
                        Mon(sum(tMon(1:k))) = -1;
                    end
                end
                
            otherwise
                kon_E7 = ceil(random(E7));
                koff_S7 = ceil(random(S7));
                if  kon_E7 < koff_S7 
                    tMon(k) = kon_E7;
                    if sum(tMon(1:k))< ttot
                        Mon(sum(tMon(1:k))) = 1;
                    end
                else
                    tMon(k) = koff_S7;
                    if sum(tMon(1:k))< ttot
                        Mon(sum(tMon(1:k))) = -1;
                    end
                end
        end
        MonTre = cumsum(Mon);
        k = k+1;
    end
    simZMW.monomers{i} = MonTre;
    simZMW.noise{i} = MonTre + (1/SNR)*randn(numel(MonTre),1);
    simZMW.bleach{i} = ZMW_sim_Bleaching(MonTre,Brate);
    
    simZMW.monomersScaled{i} = MonTre.*ScaleFactor;
    simZMW.noiseScaled{i} = MonTre.*ScaleFactor + (ScaleFactor/SNR)*randn(numel(MonTre),1);
    simZMW.bleachScaled{i} = ZMW_sim_Bleaching(MonTre,Brate).*ScaleFactor;
%     simZMW.kon{i} = kon_E;
%     simZMW.koff{i} = koff_S;
    
end

t = [dt:dt:Ttot];
simZMW.time = t;
simZMW.tmon = tMon;
simZMW.cycles = cycles;
simZMW.dt = dt;
% simZMW.kon = kon_E;
% simZMW.koff = koff_S;
simZMW.k = k;

% close(h)
% 
% if cycles ==9
%     figure;
%     tdum1 = cell2mat(simZMW.noise);
%     tdum2 = cell2mat(simZMW.monomers);
%     tdum3 = cell2mat(simZMW.bleach);
%     for j = 1:cycles
%         subplot(3,3,j)
%         plot(t,tdum1(:,j),'Color',[0.8 0.8 0.8])
%         hold on
%         plot(t,tdum2(:,j),'k')
%         plot(t,tdum3(:,j),'r')
%         ylim([0 max(tdum1(:,j))])
%         xlim([0 800])
%         xlabel( ' Time (s)' );
%         ylabel( 'Intensity (a.u.)' );
%     end
% end
% 
% if P == 1
%     figure;
%     tdum1 = cell2mat(simZMW.noise);
%     tdum2 = cell2mat(simZMW.monomers);
%     tdum3 = cell2mat(simZMW.bleach);
%     av1 = mean(tdum1,2);
%     av2 = mean(tdum2,2);
%     av3 = mean(tdum3,2);
%     
%     %plot(t,av1,'Color',[0.8 0.8 0.8])
%     %hold on
%     %plot(t,av2,'k')
%     plot(t,av3,'r')
%     %ylim([0 max(av1)])
%     xlabel( ' Time (s)' );
%     ylabel( 'Monomer number' );
%     
% end

%save ('ZMW_sim_conversionN3_dt0p2.mat','simZMW');