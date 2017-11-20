function [Bleach] = ZMW_sim_Bleaching(MonTrace,B_rate)
% This programs adds a bleaching pattern to a trace
% Last up date 20-06-2017 Alvaro

rate = B_rate;

dt = 0.2;
Bel_di = makedist('exp',1/rate);

Up = find(diff(MonTrace)>0);
down = find(diff(MonTrace)<0);
Nup = length(Up);
TraceBle = MonTrace;
Ble = random(Bel_di,Nup,1);
tBle = round(Ble)./dt + 1;

for i = 1:length(Up)
    
    ds = down(down>Up(i));
    [ind]=ds(find(MonTrace(Up(i))==MonTrace(ds+1),1));
    
    if isempty(ind) && Up(i) + tBle(i) < 4000
        TraceBle(Up(i)+tBle(i):end) = TraceBle(Up(i)+tBle(i):end) -1;   
        
    else
        
        TraceBle(Up(i)+tBle(i):ind) = TraceBle(Up(i)+tBle(i):ind) -1;
        
    end

end

%Bleach = MonTrace + cumsum(tBlea);
 Bleach = TraceBle;

% figure
% plot([dt:dt:800],TraceBle,'r')
% hold on
% plot([dt:dt:800],MonTrace,'')
% plot([dt:dt:800],BleachTrace,'k')
% hold off