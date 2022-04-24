%function[Finalvlrop,Finalvlrep,vlrop_exi]=VLR_vlrop_vlrep_v1(out,pf)
function [EVIvlrop_he,EVIvlrop_zf,total_vlrop_exi1,vlrop_exi ,PPvlrop, EVIvlrop_exi]=VLR_vlrop_vlrep_v2(out,Speech_Rate)
% 
fs=8000;
% Speech_Rate = 1.01*Speech_Rate;

[G,Gd]= gausswin((800/Speech_Rate)+1,(133/Speech_Rate)+1);
%%%---------------------------------------------LP Residual
res1= LPres(out,fs,20,10,10,1);
%%------------------------------------------HE of LP residual
hensp1=HilbertEnv(res1,fs,0);
he2=abs(hensp1);
he1=he2/max(abs(he2));

winlength=6;

THexivlrop=.06; % original

%%%%---------------------------------- %%From HE of LP residual

[EVIvlrop_he]= vlropHEoflpresidual_v1(he1,fs,Gd,Speech_Rate);

%%%%------------------------------ %%From zerofrequency filtered output
[ EVIvlrop_zf,zffo, gclocssp1]= vlropZerofrequency_v1(out,winlength,fs,Gd,Speech_Rate);

% [EVIvlrop_zf,zpzbf, epoc]=vlropZPZBF(out,winlength,fs,Gd,Speech_Rate);

%%%%------------------------%% From Excitation source information
[EVIvlrop_exi,vlrop_exi,total_vlrop_exi1,PPvlrop]=...
    vlropExcitationsource_v1(out,EVIvlrop_he,EVIvlrop_zf,0, 0, 0, 0, THexivlrop,0);
