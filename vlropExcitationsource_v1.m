function[y,vlrop,total,pp3] =vlropExcitationsource_v1(out2,y1,y2,y3,y4,y5,y6,TH,plotflag)
%%-------------------------------------------------------------------------
%y1=0;
%y3=0;
%y2=0;

%% for making equal length (for y5 only)

if (length(y1)-length(y5) < 5) && (length(y1)-length(y5) > 0)
    y5 = [y5 zeros(1, (length(y1)-length(y5)))];
end

%%
% length(y1)
% length(y2)
% length(y3)
% length(y5)

%n31=y1+y2+y5+y6;
%% For all the evidence
n31=1*y1+1*y2+y3+y5+(0.4*y6);

% Only for ZFF evidence
%n31=y2;
%n31=y1+y2+(.7*y3)+(.8*y4);
y=n31/max(abs(n31));
% y=y-0.025;
%%%%--------------------------------------------------------- peak picking
[vlrop,pp3] = peakpicking_v1(y,TH);
% [pks,vlrop] = findpeaks(y,'MinPeakHeight',0.06,'MinPeakDistance',800);
% pp3 = zeros(1,length(y));
% pp3(vlrop) = 1; 
%%%--------------------------------------------------------------comparison
total=length(vlrop);

if plotflag==1 
    %%%%------------------------------------------------------
     Fs=8000;    
    %%%------------figures------------------------------------
        
    oneidxpp3=find(pp3~=0);toneidxpp3=oneidxpp3.*(1/Fs);
    abcd=[1:length(out2)]/Fs;
    
%     figure();
%     subplot(4,1,1);plot( abcd,out2);hold on;stem(toneidxpp3,pp3(oneidxpp3),'r^');grid;axis([min(abcd),max(abcd),-1,1]);text(max(abcd+.03),0,'(a)');
%     subplot(4,1,2);plot(abcd,y1);hold on;grid;axis([min(abcd),max(abcd),-1,1]);text(max(abcd+.03),0,'(b)')
%     subplot(4,1,3);plot(abcd,y2);hold on;grid;axis([min(abcd),max(abcd),-1,1]);text(max(abcd+.03),0,'(c)')
%     subplot(4,1,4);plot(abcd,y);hold on;stem(toneidxpp3,pp3(oneidxpp3),'r^');grid;axis([min(abcd),max(abcd),-1,1]);text(max(abcd+.03),0,'(d)')
%     xlabel('Time(sec)')    
    
end

end
