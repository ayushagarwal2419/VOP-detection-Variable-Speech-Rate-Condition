clc;
clear all;
close all;
%%
[d,fs]=audioread('/media/ayush/AYUSH1/BTP-II/BTP-II_Ayush_Agarwal/Speech Rate/BTP-II_Code_VOP_by_ZPZBF_HE/VOP_Variable_Epoch/merged/10115.wav');%%115
d=d(:,1);
d=resample(d,8000,fs);
fs=8000;
d=d-mean(d);
d=d./max(abs(d));

fileID = fopen('/media/ayush/AYUSH1/BTP-II/BTP-II_Ayush_Agarwal/Speech Rate/BTP-II_Code_VOP_by_ZPZBF_HE/VOP_Variable_Epoch/merged/10115.lab','r');
info = textscan(fileID,'%s %s %s');
loc_time=info{1};
loc_time = str2double(loc_time);
loc_samples = loc_time*fs;

%%

Sp_Rate1 = 1; %%%%% for duration modification
Beta1 = round(1/Sp_Rate1,1);

speech1 = Duration_modification_V1working(d,fs,Beta1); 
speech1 = speech1-mean(speech1);
speech1 = speech1./max(abs(speech1));
t1=(1:1:length(speech1))./fs;
%%%%%%%%%%%%%%%

loc_samples1 = floor(loc_samples*Beta1); %%%% scaling of ground truth according to speech rate

stgrlabel1=zeros(size(speech1,1),1);
stgrlabel1(loc_samples1)=1;
stgrlabel1 = [stgrlabel1, zeros(1,length(speech1)-length(stgrlabel1))];
%%%%%%%%%%%%%%%%

window1 = 1;

%%%%% Fixed speech rate condition
[EVIvlrop_he1,EVIvlrop_zf1,total_vlrop1, vlrop1, PP1, EVIvlrop1]=VLR_vlrop_vlrep_v2(speech1,1);
%%%%% Variable speech rate condition
[EVIvlrop_he11,EVIvlrop_zf11,total_vlrop11, vlrop11, PP11, EVIvlrop11]=VLR_vlrop_vlrep_v2(speech1,window1);

%%

Sp_Rate2 = 2; %%%%% for duration modification
Beta2 = round(1/Sp_Rate2,1);

speech2 = Duration_modification_V1working(d,fs,Beta2);
speech2 = speech2-mean(speech2);
speech2 = speech2./max(abs(speech2));
t2=(1:1:length(speech2))./fs;

%%%%%%%%%%%%%%%


loc_samples2 = floor(loc_samples*Beta2); %%%% scaling of ground truth according to speech rate

stgrlabel2=zeros(size(speech2,1),1);
stgrlabel2(loc_samples2)=1;
stgrlabel2 = [stgrlabel2, zeros(1,length(speech2)-length(stgrlabel2))];
%%%%%%%%%%%%%%%%


window2 = 2;
%%%%% Fixed speech rate condition
[EVIvlrop_he2,EVIvlrop_zf2,total_vlrop2, vlrop2, PP2, EVIvlrop2]=VLR_vlrop_vlrep_v2(speech2,1);
%%%%% Variable speech rate condition
[EVIvlrop_he22,EVIvlrop_zf22,total_vlrop22, vlrop22, PP22, EVIvlrop22]=VLR_vlrop_vlrep_v2(speech2,window2);

%%
Sp_Rate3 = 0.5; %%%%% for duration modification
Beta3 = round(1/Sp_Rate3,1);

speech3 = Duration_modification_V1working(d,fs,Beta3);
speech3 = speech3-mean(speech3);
speech3 = speech3./max(abs(speech3));
t3=(1:1:length(speech3))./fs;

%%%%%%%%%%%%%%%
loc_samples3 = floor(loc_samples*Beta3); %%%% scaling of ground truth according to speech rate

stgrlabel3=zeros(size(speech3,1),1);
stgrlabel3(loc_samples3)=1;
stgrlabel3 = [stgrlabel3, zeros(1,length(speech3)-length(stgrlabel3))];
%%%%%%%%%%%%%%%%

window3 = 0.5;
%%%%% Fixed speech rate condition
[EVIvlrop_he3,EVIvlrop_zf3,total_vlrop3, vlrop3, PP3, EVIvlrop3]=VLR_vlrop_vlrep_v2(speech3,1);
%%%%% Variable speech rate condition
[EVIvlrop_he33,EVIvlrop_zf33,total_vlrop33, vlrop33, PP33, EVIvlrop33]=VLR_vlrop_vlrep_v2(speech3,window3);

%%%%% Equilizing the length as per the time
EVIvlrop3 = [EVIvlrop3,zeros(1,length(speech3)-length(EVIvlrop3))];
PP3 = [PP3,zeros(1,length(speech3)-length(PP3))];

%%%%% Equilizing the length as per the time
EVIvlrop33 = [EVIvlrop33,zeros(1,length(speech3)-length(EVIvlrop33))];
PP33 = [PP33,zeros(1,length(speech3)-length(PP33))];

%% Plots

time_n1 = 1/fs;
time_n2 = length(speech1)/fs;

time_f1 = 1/fs;
time_f2 = length(speech2)/fs;

time_s1 = 1/fs;
time_s2 = length(speech3)/fs;

% time_n1 = 2172/fs;
% time_n2 = 10171/fs;
% 
% time_f1 = 1086/fs;
% time_f2 = 9085/fs;
% 
% time_s1 = 4344/fs;
% time_s2 = 12343/fs;

t1= t1(time_n1*fs:time_n2*fs);
t1 = (1:length(t1))./fs;

t2= t2(time_f1*fs:time_f2*fs);
t2 = (1:length(t2))./fs;

t3= t3(time_s1*fs:time_s2*fs);
t3 = (1:length(t3))./fs;

speech1 = speech1(time_n1*fs:time_n2*fs);
speech2 = speech2(time_f1*fs:time_f2*fs);
speech3 = speech3(time_s1*fs:time_s2*fs);

stgrlabel1 = stgrlabel1(time_n1*fs:time_n2*fs);
stgrlabel2 = stgrlabel2(time_f1*fs:time_f2*fs);
stgrlabel3 = stgrlabel3(time_s1*fs:time_s2*fs);

EVIvlrop1 = EVIvlrop1(time_n1*fs:time_n2*fs);
EVIvlrop2 = EVIvlrop2(time_f1*fs:time_f2*fs);
EVIvlrop3 = EVIvlrop3(time_s1*fs:time_s2*fs);

EVIvlrop11 = EVIvlrop11(time_n1*fs:time_n2*fs);
EVIvlrop22 = EVIvlrop22(time_f1*fs:time_f2*fs);
EVIvlrop33 = EVIvlrop33(time_s1*fs:time_s2*fs);

PP1 = PP1(time_n1*fs:time_n2*fs);
PP2 = PP2(time_f1*fs:time_f2*fs);
PP3 = PP3(time_s1*fs:time_s2*fs);

PP11 = PP11(time_n1*fs:time_n2*fs);
PP22 = PP22(time_f1*fs:time_f2*fs);
PP33 = PP33(time_s1*fs:time_s2*fs);

figure(1);
a(1) = subplot(321);
plot(t1,speech1,'k');
hold on;
plot(t1,-stgrlabel1,'k');
hold on;
plot(t1,PP11);
a(2) = subplot(322);
plot(t1,EVIvlrop11);
hold on;
plot(t1,PP11);

a(3) = subplot(323);
plot(t2,speech2,'k');
hold on;
plot(t2,-stgrlabel2,'k');
hold on;
plot(t2,PP22);
a(4) = subplot(324);
plot(t2,EVIvlrop22);
hold on;
plot(t2,PP22);

a(5) = subplot(325);
plot(t3,speech3,'k');
hold on;
plot(t3,-stgrlabel3,'k');
hold on;
plot(t3,PP33);
a(6) = subplot(326);
plot(t3,EVIvlrop33);
hold on;
plot(t3,PP33);

linkaxes([a(1), a(2)],'x');
linkaxes([a(3), a(4)],'x');
linkaxes([a(5), a(6)],'x');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(2);
b(1) = subplot(321);
plot(t1,speech1,'k');
hold on;
plot(t1,-stgrlabel1,'k');
hold on;
plot(t1,PP1);
b(2) = subplot(322);
plot(t1,EVIvlrop1);
hold on;
plot(t1,PP1);

b(3) = subplot(323);
plot(t2,speech2,'k');
hold on;
plot(t2,-stgrlabel2,'k');
hold on;
plot(t2,PP2);
b(4) = subplot(324);
plot(t2,EVIvlrop2);
hold on;
plot(t2,PP2);

b(5) = subplot(325);
plot(t3,speech3,'k');
hold on;
plot(t3,-stgrlabel3,'k');
hold on;
plot(t3,PP3);
b(6) = subplot(326);
plot(t3,EVIvlrop3);
hold on;
plot(t3,PP3);

linkaxes([b(1), b(2)],'x');
linkaxes([b(3), b(4)],'x');
linkaxes([b(5), b(6)],'x');

%linkaxes(a);
t4 = (ceil(0.76*fs):ceil(1.34*fs));
t4 = (1:length(t4))./fs;
speech5 = speech1(ceil(0.76*fs):ceil(1.34*fs));
% speech5 = speech5-mean(speech5);
% speech5 = speech5./(max(abs(speech5)));
figure(3);
plot(t4,speech5,'k');
hold on;
%plot(t4,PP11(ceil(0.76*fs):ceil(1.34*fs)));
plot(t4,stgrlabel1(ceil(0.76*fs):ceil(1.34*fs)));