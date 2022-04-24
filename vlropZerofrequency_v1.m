
function[ y2,zffo, gclocssp1]= vlropZerofrequency_v1(out1,winsize,fs,Gd,Speech_Rate)
%%-----------------------------------------------------------

[zffo,gclocssp1,epssp1,f0sp1]=svlzfsig2(out1,fs,winsize);


%[zfs,gci,ES at gci,pitch fs]=svlzfsig2(out1,fs,winlength);
% epssp1=epssp1./(max(epssp1));
% epochstr=epssp1;
% meanessp1=mean(epssp1);
% epstrsp1=zeros(length(hensp1),1);
% epstrsp1(gclocssp1)=epssp1;

%%-----------------------------exc conter from 2nd order diff
zffo=zffo/max(abs(zffo));

Firstdiffzffo=diff(zffo);   %%  To calculate the strength

Seconddiffzffo=diff(Firstdiffzffo); %%  To calculate the rate of change of strength.

%% The non linear mapping function 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Teta = 0.2;
% Tau = 0.04;
% Alpha = 0.05;
% ExpSignalzffo = exp(-((Seconddiffzffo - Teta)/Tau));
% DenFactorzffo = 1 + ExpSignalzffo;
% Pmzffo = (1./DenFactorzffo) + Alpha;
% Seconddiffzffo = Pmzffo;

%Seconddiffzffo = sqrt(sqrt(Seconddiffzffo.*Seconddiffzffo));
%Seconddiffzffo = Seconddiffzffo.*Seconddiffzffo;

Seconddiffzffo=Seconddiffzffo/max(abs(Seconddiffzffo));
%%-----------------------------------------------
excfeat_2d1=abs(Seconddiffzffo);

excfeat_2d=excfeat_2d1/max(abs(excfeat_2d1));

exccont_2d=zeros(1,length(zffo));

framesize2=ceil(5*fs/(1000*Speech_Rate));
%%%% process to get the envelope

for i=1:length(excfeat_2d)-20*framesize2
    
    mxvalue2=max(excfeat_2d(i:i+framesize2-1));
    
    exccont_2d(i)=mxvalue2;
    
end

exccont_2d1=exccont_2d/max(abs(exccont_2d));

%%-------------------------------------------conv with FOGD

n2=conv(exccont_2d1, Gd);

n21=n2(ceil(401/Speech_Rate):length(n2)-ceil(400/Speech_Rate));

y2=n21/max(abs(n21));
% t4 = (ceil(0.76*fs):ceil(1.33*fs));
% t4 = (1:length(t4))./fs;
% 
% speech5 = out1(ceil(0.76*fs):ceil(1.33*fs));
% exccont_2d1 = smooth(exccont_2d1(ceil(0.76*fs):ceil(1.33*fs)));
% exccont_2d1 = smooth(exccont_2d1);
% exccont_2d1 = smooth(exccont_2d1);
% 
% exccont_2d1 = smooth(exccont_2d1);
% 
% exccont_2d1 = smooth(exccont_2d1);
% exccont_2d1 = smooth(exccont_2d1);
% exccont_2d1 = smooth(exccont_2d1);
% exccont_2d1 = smooth(exccont_2d1);
% exccont_2d1 = smooth(exccont_2d1);
% exccont_2d1 = smooth(exccont_2d1);
% exccont_2d1 = smooth(exccont_2d1);
% exccont_2d1 = smooth(exccont_2d1);
% exccont_2d1 = smooth(exccont_2d1);
% exccont_2d1 = smooth(exccont_2d1);
% exccont_2d1 = smooth(exccont_2d1);
% exccont_2d1 = smooth(exccont_2d1);
% 
% exccont_2d1 = smooth(exccont_2d1);
% exccont_2d1 = smooth(exccont_2d1);
% exccont_2d1 = smooth(exccont_2d1);
% exccont_2d1 = smooth(exccont_2d1);
% exccont_2d1 = smooth(exccont_2d1);
% exccont_2d1 = smooth(exccont_2d1);
% exccont_2d1 = smooth(exccont_2d1);
% exccont_2d1 = smooth(exccont_2d1);
% exccont_2d1 = smooth(exccont_2d1);
% exccont_2d1 = smooth(exccont_2d1);
% exccont_2d1 = smooth(exccont_2d1);
% exccont_2d1 = smooth(exccont_2d1);
% 
% 
% y2 = y2(ceil(0.76*fs):ceil(1.33*fs));
% 
% 
% figure;
% %a(1)=subplot(211);
% plot(t4, speech5);
% hold on;
% %a(2)=subplot(212);
% plot(t4, (exccont_2d1));
% hold on;
% plot(t4,y2);


end
