function [ModLoc]=ModifyVariableEpochLocations(gciMod,Alpha);
ModLoc=[];
 [P,Q]=rat(Alpha(1),.01);
%for i=1:Q:length(gciMod)-1
i=1;
while 1
    if (i+Q) >length(gciMod)
        L=linspace(gciMod(i),gciMod(end),P+1);
       
        break;
    else
        
    L=linspace(gciMod(i),gciMod(i+Q),P+1);

    if i+Q >length(Alpha)
        break
    end
    [P1,Q1]=rat(Alpha(i+Q-1),.01);
    i=i+Q;
    Q=Q1;
    P=P1;
    end
    L1=round(L(1:end-1));
    L1=L1';
    ModLoc=[ModLoc;L1];
    
end