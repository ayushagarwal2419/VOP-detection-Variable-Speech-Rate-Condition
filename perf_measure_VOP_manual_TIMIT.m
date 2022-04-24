clc;
clear all;
close all;
%%
test_path='/media/ayush/AYUSH/BTP-II/TIMIT data_with_labels/merged';

dd=dir(test_path);
files=char(dd.name);
files=files(3:end,:);

l=1;
for i=1:2:410
    
    l
        
    [s,fs]=audioread(strcat(test_path,'/',files(i+1,:)));
    Sp_Rate = 0.5;
    Beta = round(1/Sp_Rate,1);
    
    [d] = Duration_modification_V2working(s,fs,Beta);
    d = d-mean(d);
    d = d./max(abs(d));
    
    fileID = fopen(strcat(test_path,'/',files(i,:)),'r');
    info = textscan(fileID,'%s %s %s');
    loc_time=info{1};
    loc_time = str2double(loc_time);
    loc_samples = loc_time*fs;
    
    loc_samples = floor(loc_samples*Beta);
    
    Ground_truth_total_VOP(l) = length(loc_samples);
    
    stgrlabel=zeros(size(d,1),1);
    stgrlabel(loc_samples)=1;
    stgrlabel = [stgrlabel, zeros(1,length(d)-length(stgrlabel))];
    
    window1 = 1;
    [EVIvlrop_he1,EVIvlrop_zf1,total_vlrop1(l), vlrop1, PP1, EVIvlrop1]=VLR_vlrop_vlrep_v2(d,window1);
    t1=(1:1:length(d))./fs;
    
    locations = find(PP1);
    locations = locations';
    [SPURIOUS_VLROP(l), DEVIATION_OF_DETECTED_VLROPs(l), CORRECTLY_DETECTED_VLROP(l), MISS_VLROP(l),INSERTIONS(l)] = Performance_Parav7(locations, loc_samples, fs, window1);
    
    l=l+1;
end

%%%%% w.r.t TOTAL GROUND TRUTH VOPs

Total_files = l-1;
TOTAL_DETECTED_VOPs = sum(total_vlrop1)
TOTAL_ACTUAL_VOPs = sum(Ground_truth_total_VOP)
AVG_DEVIATION = sum(DEVIATION_OF_DETECTED_VLROPs)/Total_files
AVG_DELETIONS = 100*sum(MISS_VLROP)/TOTAL_ACTUAL_VOPs
AVG_INSERTIONS = 100*sum(INSERTIONS)/TOTAL_ACTUAL_VOPs
%AVG_SPURIOUS_VLROP = 100*sum(SPURIOUS_VLROP)/TOTAL_ACTUAL_VOPs
AVG_CORRECTLY_DETECTED_VLROP = 100*sum(CORRECTLY_DETECTED_VLROP)/TOTAL_ACTUAL_VOPs

%%%%% w.r.t TOTAL DETECTED VOPs

% Total_files = l-1;
% TOTAL_DETECTED_VOPs = sum(total_vlrop1)
% TOTAL_ACTUAL_VOPs = sum(Ground_truth_total_VOP)
% AVG_DEVIATION = sum(DEVIATION_OF_DETECTED_VLROPs)/Total_files
% AVG_DELETIONS = 100*sum(MISS_VLROP)/TOTAL_DETECTED_VOPs
% AVG_INSERTIONS = 100*sum(INSERTIONS)/TOTAL_DETECTED_VOPs
% %AVG_SPURIOUS_VLROP = 100*sum(SPURIOUS_VLROP)/TOTAL_ACTUAL_VOPs
% AVG_CORRECTLY_DETECTED_VLROP = 100*sum(CORRECTLY_DETECTED_VLROP)/TOTAL_DETECTED_VOPs