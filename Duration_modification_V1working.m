% clc;
% close all;
% clear all;
% [s ,Fs]=audioread('/media/ayush/AYUSH/BTP-II/TIMIT/TRAIN/DR5/FBJL0/SA1.wav');
%[orig_speech,FS] = audioread('/media/ayush/AYUSH/BTP-II/BTP-II_Ayush_Agarwal/Speech Rate/Speech_Rate_Prog/F1.wav');

function [speech] = Duration_modification_V1working(s,Fs,Beta)

s=s(:,1);
s=resample(s,8000,Fs);
s=s-mean(s);
d=s./max(abs(s));
Fs=8000;

% % 
%  [EstiSpeechRate] = SpeechRate(d,Fs) ;
% % speechRateOrigSpeech=SpeechRate(orig_speech,FS);
%  desiredSpeechRate = 4;
%  Beta=round(EstiSpeechRate/desiredSpeechRate,1);

% Beta = 2.5;
[P,Q]=rat(Beta,.1);

K=0.7;

%path='/home/govind/Work/prosody/test_dur2a.wav';
% d=d(1:2000);
% d=s(1:8000)
[residual,LPCoeffs]=LPres(d,Fs,20,5,10,0);

%[GCI1,HRT]=instants_FOGD_V2(d,Fs,Windowlength,Sigma);
%[GCI2,HRT]=instants_Gabor_V2(d,Fs,Sigma,0.1175,Windowlength);
%[gci,zfSig]=epochMypgm(d,Fs,Windowlength)
[gci,zfSig]=EpochsbyZFF(d,Fs);% fOR FINDING EPOCHS BASED ON ZFF
gci=[1;gci;length(residual)];
EpochInt=[diff(gci)];
EpochInt(end+1)=EpochInt(end);
zfSigMod=resample(zfSig,P,Q);

gciMod=find(diff(zfSigMod>0)==1);

EpochIntzfSigMod=[diff(gciMod);0];
ModLoc=[];
%%%%%% Modified epoch locations (linear decimation or interpolation)
for i=1:Q:length(gciMod)-1
    i;
    if i+Q >length(gciMod)
        L=linspace(gciMod(i),gciMod(end),P+1);
    else
        L=linspace(gciMod(i),gciMod(i+Q),P+1);
    end
    L1=round(L(1:end-1));
    L1=L1';
    ModLoc=[ModLoc;L1];
end

ModLoc(end+1)=gciMod(end);
ModLoc=[1;ModLoc;length(zfSigMod)];
EpochIntMod=[diff(ModLoc)];

% figure(1);
% a1=subplot(311);
% plot(ModLoc,[EpochIntMod;0],'-*');
% axis([0,length(zfSigMod),1,200]);
% title('Mod Locations');
% a2=subplot(312);
% plot(gciMod,[EpochIntzfSigMod],'-*');
% title('Resampled');
% % axis([0,length(zfSigMod),1,400]);
% a3=subplot(313);
% plot(gci,EpochInt,'-*');
% axis([0,length(zfSig),0,200]);
% title('Original');
% linkaxes([a1,a2]);

EpochIntMod(end+1)=EpochIntMod(end);
[close_index]=FindingCloseIndex(gci*Beta,ModLoc);

for i=2:length(close_index)-1
    Match_index=close_index(i);
    if Match_index==length(gci)
        Match_index=Match_index-1;
    end
    
    IntOrig=EpochInt(Match_index);
    IntMod=EpochIntMod(i);
    %retain_samples=residual(gci(close_index(i))-3:gci(close_index(i))-3+round(IntOrig*K));
    Frame=residual(gci(Match_index)-3:gci(Match_index)-3+IntOrig);
    N=length(Frame);
    retain_samples=Frame(1:round(K*N));
    x=Frame(round(K*N)+1:end);
    
    p=abs(IntMod-round(K*N));
    q=length(x);
    if p==0
        p=1;
    end
    y=resample(x,p,q);
    [mm1,nn1]=size(y);
    if mm1==1
        y=y';
    else
        y=y;
    end
    copy_samples=[retain_samples;y];
    
    modres(ModLoc(i)-3:ModLoc(i)-3+length(copy_samples)-1)=copy_samples;
end

for i=1:150 %%%%% kept to keep the stretch
    LPCoeffs(end+1,:)=LPCoeffs(end,:);
end
framesize=160;%20ms
frameshift=40;%5ms
[speech]= SynthSpeech_v4(modres,LPCoeffs,10,framesize,round(Beta*frameshift),0);
speech = speech-mean(speech);
speech = speech./max(abs(speech));
% speechRateOfSynSpeech = SpeechRate(speech,Fs);

% audiowrite('TIMITSA1_0.4x.wav',speech,Fs);

% figure(2);
% b(1)=subplot(211);
% plot(d);
% title(' speech');
% b(2)=subplot(212);
% plot(speech);
% title('syn speech');
% b(3)=subplot(313);
% plot(orig_speech);
% title('normal speech');
%linkaxes(b)
end