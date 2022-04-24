function [UvRegion]=detectingVoicedEpochs(vgclocssp1,s,Beta)


[m,n]=size(vgclocssp1);
if m==1
    vgclocssp1=vgclocssp1';
end

voicedGciDiff=[diff(vgclocssp1);0];

UvRegion(length(s))=0;

for i=1:length(vgclocssp1)
    
    if (voicedGciDiff(i)<160*Beta)& (voicedGciDiff(i)>20*Beta)
        
        UvRegion(vgclocssp1(i):vgclocssp1(i)+voicedGciDiff(i))=1;
    else
        UvRegion(vgclocssp1(i):vgclocssp1(i)+voicedGciDiff(i))=0;
        
    end
end