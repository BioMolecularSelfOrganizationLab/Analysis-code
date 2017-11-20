 function [Up, Down, dSt, Y1c,StepFitCorr, Frac_sidotri_up_down,meanss,modess,TT] = Int2MonNum_DoubleSteps(Steps)
% This program converts the steps found using a step finding algorithm
% into a stepcase trace (i.e. monomer number vs. time trace).
% Alvaro Crevenna, Oct 6th 2014

StepFit = Steps;

TSH = 1.64;
T2 = 1.64+1;

YYY = diff(Steps);

dSt1 = find(YYY);
Up1 = find(YYY>0);
Down1 = find(YYY<0);


YY = YYY(YYY>0);

modess = mode(YY);
meanss = mean(YY);
% TT = mode(YY);

if mode(YY) > mean(YY)
    TT = mode(YY)/2;
else % mode(YY) < mean(YY)
    TT = mode(YY);
end
% TT = 1;

YYU = abs(Steps(Up1(:)+1) - Steps(Up1(:)));
[Up_double] = find(YYU>TSH*TT & YYU<T2*TT);
[Up_triple] = find(YYU>=T2*TT);
% [Up_tetraple] = find(YYU>3.5*mean(YY));
[Up_single] = find(YYU<TSH*TT);

YYD = abs(Steps(Down1(:)) - Steps(Down1(:)+1));
[Do_double] = find(YYD>TSH*TT & YYD<T2*TT);
[Do_triple] = find(YYD>=T2*TT);
[Do_single] = find(YYD<TSH*TT);

Ndoubleup = length(Up_double);
Ntripleup = length(Up_triple);
Nsingleup = length(Up_single);

Nges = Ndoubleup + Ntripleup + Nsingleup;
Fracdoubleup = Ndoubleup * 100/Nges;
Fractripleup = Ntripleup * 100/Nges;
Fracsingleup = Nsingleup * 100/Nges;

Ndoubledo = length(Do_double);
Ntripledo = length(Do_triple);
Nsingledo = length(Do_single);

Nges = Ndoubledo + Ntripledo + Nsingledo;
Fracdoubledo = Ndoubledo * 100/Nges;
Fractripledo = Ntripledo * 100/Nges;
Fracsingledo = Nsingledo * 100/Nges;

Frac_sidotri_up_down = [Fracsingleup Fracdoubleup Fractripleup Fracsingledo Fracdoubledo Fractripledo];

% Up = Up + 1;
% Down = Down + 1;

Le = length(Steps);
Y1 = zeros(Le,1);

% Up steps
if ~isempty(Up_single)
    Y1(Up1(Up_single)+1) = 1;
end

if isempty(Up_double) == 0
    Y1(Up1(Up_double)) = 1;
    Y1(Up1(Up_double)+1) = 1;
    StepFit(Up1(Up_double)+1) = StepFit(Up1(Up_double)) + ((StepFit(Up1(Up_double)+1) - StepFit(Up1(Up_double))) *0.5);
end
if  isempty(Up_triple) == 0
    Y1(Up1(Up_triple)) = 1;
    Y1(Up1(Up_triple)+1) = 1;
    Y1(Up1(Up_triple)+2) = 1;
    
    StepFit(Up1(Up_triple)+1) = StepFit(Up1(Up_triple)) + ((StepFit(Up1(Up_triple)+1) - StepFit(Up1(Up_triple))) *0.33);
    StepFit(Up1(Up_triple)+2) = StepFit(Up1(Up_triple)+1) + ((StepFit(Up1(Up_triple)+1) - StepFit(Up1(Up_triple))) *0.66);
   
end


% Down steps
if isempty(Do_single) == 0
    Y1(Down1(Do_single)+1) = -1;
end

if isempty(Do_double) == 0
    Y1(Down1(Do_double)) = -1;
    Y1(Down1(Do_double)+1) = -1;
    
    StepFit(Down1(Do_double)+1) = StepFit(Down1(Do_double)) -((StepFit(Down1(Do_double)) - StepFit(Down1(Do_double)+1))*0.5);
    
end
if  isempty(Do_triple) == 0
    Y1(Down1(Do_triple)) = -1;
    Y1(Down1(Do_triple)+1) = -1;
    Y1(Down1(Do_triple)+2) = -1;
    
    StepFit(Down1(Do_triple)+1) = StepFit(Down1(Do_triple)) - ((StepFit(Down1(Do_triple)) - StepFit(Down1(Do_triple)+1)) *0.333);
    StepFit(Down1(Do_triple)+2) = StepFit(Down1(Do_triple)+1) - ((StepFit(Down1(Do_triple)) - StepFit(Down1(Do_triple)+1)) *0.666);
    
end

Y1c = cumsum(Y1);

dSt = find(diff(Y1c));
Up = find(diff(Y1c)>0);
Down = find(diff(Y1c)<0);

StepFitCorr = StepFit;


% Y1c = Y1d - min(Y1d);
%
% figure
% plot(Y1c,'')
% hold on
% plot(Steps,'r')
% hold off
