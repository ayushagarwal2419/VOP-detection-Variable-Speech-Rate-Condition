 
clc;
close all;
clear all;
%addpath E:\Mywork\Papers\JNL\Sadhana\Data\IITG\pleasegetout
Beta1=2;
Beta2=2;
Alpha1=1;
Alpha2=1;
Gamma1=1;
Gamma2=1;
[s, Fs]=audioread('/media/ayush/AYUSH/BTP-II/TIMIT_VOP/TRAIN/FEMALE/DR1/FCJF0/SA1.wav');
s=s-mean(s);
d=s./max(abs(s));
%d=diff(d);
%d=-d;

[gci,zfSig,vgci]=EpochsbyZFF(d,Fs);% fOR FINDING EPOCHS BASED ON ZFF
gci=[1;gci;length(d)];

Gamma=linspace(Gamma1,Gamma2,length(gci));
%Gamma=ones(1,length(gci)); % No strength Modification


Beta=linspace(Beta1,Beta2,length(gci));
Beta=round(Beta*10)*10^-1;



%Beta=ones(1,length(gci))*1;

 [UvRegion]=detectingVoicedEpochs(vgci,zfSig,1);
  UvRegion=UvRegion';

%
%  for i=1:length(gci)
%       if UvRegion(gci(i))==0
%       Beta(i)=1;
%      else
%          continue;
%      end
%  end
 
 
 zfSigMod=[];
for i=2:length(gci)
    [P,Q]=rat(Beta(i),.01);
    zfFrame=zfSig(gci(i-1):gci(i)-1);
    RsamplezfFrame=resample(zfFrame,P,Q);
    zfSigMod=[zfSigMod;RsamplezfFrame];  
end

gciMod=find(diff(zfSigMod>0)==1);

%gciMod(1:5)=[];

gciMod=[1;gciMod;length(zfSigMod)];
 Beta1=Beta;
if length(Beta)<length(gciMod)
   Beta(end+1:end+(length(gciMod)-length(Beta)))=Beta(end);
else
   Beta=Beta(1:length(gciMod));
end


[ModLoc]=ModifyVariableEpochLocations(gciMod,Beta);
Alpha=linspace(Alpha1,Alpha2,length(ModLoc));
Alpha=1./Alpha;
Alpha=(round(Alpha*10))*10^-1;


[ModLoc]=ModifyVariableEpochLocations(ModLoc,Alpha);



EpochInt=[diff(gci)];
EpochInt(end+1)=EpochInt(end);

%l=length(gciMod)-length(gci);
gciMod1=round(cumsum([diff(gci)].*Beta1(1:end-1)'));

gciMod1=[1;gciMod1];
close_index=FindingCloseIndex(gciMod1,ModLoc);
%close_index(close_index'>=length(gci))=length(gci)-1;


ModLoc(end+1)=gciMod(end);
ModLoc=[ModLoc;length(zfSigMod)];

 EpochIntMod=[diff(ModLoc)];

EpochIntMod(end+1)=0;


modres=zeros(1,gciMod(end));
Temp=zeros(1,gciMod(end));

for i=2:length(close_index)-1
    Match_index=close_index(i);
    if Match_index==length(gci)
       Match_index=Match_index-1;
    end
    
    IntOrig=EpochInt(Match_index);
    IntMod=EpochIntMod(i);
    %retain_samples=residual(gci(close_index(i))-3:gci(close_index(i))-3+round(IntOrig*K));
    Frame=d(gci(Match_index)-3:gci(Match_index)-3+IntOrig);
    
    Frame=Frame.*Gamma(Match_index); % Continuous Strength Modification
    N=length(Frame);
    if IntOrig<IntMod-1
    
    Frame1=Frame(round(N*.9):end);
    
       
        ResampSeq=resample(Frame1,IntMod-N,length(Frame1));
        ResampSeq=ResampSeq(end:-1:1);
        
        [mm3,nn3]=size(ResampSeq);
        
        if mm3==1
            ResampSeq=ResampSeq';
        else
            ResampSeq=ResampSeq;
        end
        
    copy_samples=[Frame;.1*ResampSeq];
    

    else
   copy_samples=Frame;
    
   
    end
    
    Temp(ModLoc(i)-3:ModLoc(i)-3+length(copy_samples)-1)=copy_samples;
    modres=modres+Temp(1:length(modres));
    clear Temp
    Temp=zeros(1,round(length(modres)));
end

figure,subplot(211),plot(d),axis([5500,6000,-.3,.3]),subplot(212),plot(modres),axis([5500,6000,-.3,.3])
 
 modres=modres/(1.01*max(abs(modres)));
 
 

 
% % 
% 
  Voiced_start_idx=find(diff(UvRegion)>0);
  Voiced_end_idx=find(diff(UvRegion)<0); 
  modSpeech=d(1:Voiced_start_idx(1));
  
  
  
  for i=1:length(Voiced_start_idx)
      
      L1=find(gci<=Voiced_start_idx(i));
      st1=gci(1)+round(sum(diff(gci(L1)).*Beta(L1(2:end))'));
      L2=find( gci<=Voiced_end_idx(i));
      st2=gci(1)+round(sum(diff(gci(L2)).*Beta(L2(2:end))'));
      modSpeech=[modSpeech;modres(st1+1:st2)'];
      if i+1> length(Voiced_start_idx)
           modSpeech=[modSpeech;d(Voiced_end_idx(i)+1:end)];
      else
      modSpeech=[modSpeech;d(Voiced_end_idx(i)+1:Voiced_start_idx(i+1))];
      end
  end
% % 


 modSpeech=modSpeech/(1.01*max(abs(modSpeech)));
figure
a(1)=subplot(211);
plot(d)
a(2)=subplot(212);
plot(modres);

