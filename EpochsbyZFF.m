function [epochlocs,zsp1,vgclocssp1]=EpochsbyZFF(speech,samplingfreq);


% INPUT= SPEECH AND SAMPLING FREQUENCY
%OUTPUT= EPOCH LOCATIONS
%DESCRIPTION : THE PROGRAM COMPUTES THE INSTANTS OF SIGNIFICANT EXCITATION
%               LOCATIONS BY ZERO FREQUENCY FILTERING METHOD






sp1sig=speech;

sp1sig=sp1sig./(1.01*max(abs(sp1sig)));

fs=samplingfreq; %original timit at 16k

%sound(sp1sig,fs);

%compute lp residual

ressp1=LPres(sp1sig,fs,20,10,10,1);

%compute Hilbert envelope

hensp1=HilbertEnv(ressp1,fs,1);

%clear ressp1

%avgpitchperiod=HilbertAvgPitch(hensp1,fs,(30*fs)/1000,(10*fs)/1000)
%t0=pitch_hilbert_instant_parameters(sp1sig);
%avgpitchperiod=mean(t0);
%winlength=round(avgpitchperiod);

winlength=6;
[zsp1,gclocssp1,epssp1,f0sp1]=svlzfsig2(sp1sig,fs,winlength);
zsp1=zsp1/(1.01*max(abs(zsp1)));
epochlocs=gclocssp1;

epssp1=epssp1./(max(epssp1));

epochstr=epssp1;

meanessp1=mean(epssp1);

epstrsp1=zeros(length(hensp1),1);
epstrsp1(gclocssp1)=epssp1;

%voicing decision
epssp1=epssp1>0.2*meanessp1;

vgclocssp1=gclocssp1(epssp1);
vf0sp1=f0sp1(epssp1);

meanF0=mean(vf0sp1);
sdevF0=std(vf0sp1);


%use this for computing Jitter
vf0sp1=medfilt1(vf0sp1,5);


%use this for computing Shimmer
vepochstr=epochstr(epssp1);


%comment below plot for jitter shimmer study
xind=[1:length(sp1sig)]/fs;
 
% figure;
% subplot(4,1,1);plot(xind,sp1sig./(1.05*max(sp1sig)));axis([min(xind),max(xind),-1.1,1.1]);grid;
% subplot(4,1,2);plot(xind,zsp1./(1.05*max(zsp1)));axis([min(xind),max(xind),-1.1,1.1]);grid;
% subplot(4,1,3);plot(xind,epstrsp1/(1.05*max(epstrsp1)));axis([min(xind),max(xind),0,1.1]);grid;
% subplot(4,1,4);plot(vgclocssp1/fs,vf0sp1,'.','markersize',15);axis([min(xind),max(xind),10,400]);grid;

