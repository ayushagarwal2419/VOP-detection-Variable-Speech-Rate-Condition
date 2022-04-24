function[ y1]= vlropHEoflpresidual_v1(he1,fs,Gd,Speech_Rate)

% % % %%%-------------------------------------------Lp analysis
% % %
% % %      %%%[res1,LPCoeffs1] = lpresidual_v5(out2,LPFL,LPOLN,P,1,0);
% % %       res1= LPres(out2,fs,20,5,10,1);
% % % %%%--------------------------------------------HE
% % %      he1=abs(hilbert(res1))';
%%%-----------------------------------------------excitation contour
framesize1=ceil(5*fs/(1000*Speech_Rate));

exccont_he=zeros(1,length(he1));

for i=1:length(he1)-framesize1
    
    mxvalue1=max(he1(i:i+framesize1-1));
    
    exccont_he(i)=mxvalue1;
end

exccont_he1=exccont_he./max(abs(exccont_he));

%%%-----------------------------------------convolution with FOGD

n1=conv( exccont_he1,Gd);
n11=n1(ceil(401/Speech_Rate):length(n1)-ceil(400/Speech_Rate));
n12=n11/max(abs(n11));
y1=n12;

end
