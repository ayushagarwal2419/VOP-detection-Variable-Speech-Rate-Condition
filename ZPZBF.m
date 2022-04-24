function [zpbh,zpzbf,gci,pzc]=ZPZBF(speech,fs,r,CutOffFreq)

%%%%%%%%%%% This is a function code for ZP-ZBF %%%%%%%%%%%

% speech - the speech file
% fs - the sampling freq of input speech
% r - radius for the filter 
% CutOffFreq - the cut off freq of high pass filter

% zpbh - the output zero phase zero band filtering method
% zpzbf - the output of zero phase zero band filter
% gci - location of glottal closure instants
% pzc - positive zero crossings

%%%% Modified on : 26/03/2020 
%%%% Created by : Ayush Agarwal, Jagabandhu Mishra & S R Mahadeva Prasanna
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Pre-emphasis
dchannel1=diff(speech);
dchannel1(end+1)=dchannel1(end);
dchannel1=dchannel1/(1*(max(abs(dchannel1))));

 
B = 1;%numerator
A = [1 -2*r r.^2];% denominator
h = filtfilt(B,A,dchannel1); %%%% bidirectional filter
zpzbf = h;
zpzbf = zpzbf-mean(zpzbf);
zpzbf = zpzbf./(1*(max(abs(zpzbf))));

[B1zphp,A1zphp] = butter(2,CutOffFreq/fs*2,'high');

zpbh = filtfilt(B1zphp,A1zphp,zpzbf);%%%% bidirectional filter
zpbh = (zpbh-mean(zpbh));
zpbh = zpbh./(1*(max(abs(zpbh))));

gci=find(diff((zpbh>0))==1);       %%%%%%%  pick zero crossing
z=zeros(1,length(speech));
for i=1:length(gci)
    z(gci(i))= 0.5;
end
pzc=z;
end
