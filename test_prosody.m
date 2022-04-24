clc; clear all; close all;
%%
[s,fs] = audioread('/media/ayush/AYUSH/BTP-II/BTP-II_Ayush_Agarwal/Speech Rate/BTP-II_Code_VOP_by_ZPZBF_HE/VOP_Variable_Epoch/merged/10099.wav');
Beta = 1;

[modres] = Duration_modification_V2working(s,fs,Beta);

audiowrite('Male099.wav',modres,fs);