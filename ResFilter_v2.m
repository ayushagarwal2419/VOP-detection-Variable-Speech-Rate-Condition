function [ResFrm]=ResFilter_v2(PrevSpFrm,SpFrm,FrmLPC,LPorder,FrmSize,plotflag);

%USAGE: [ResFrm]=ResFilter_v2(PrevSpFrm,SpFrm,FrmLPC,LPorder,FrmSize,plotflag);


ResFrm=zeros(1,FrmSize);
tempfrm=zeros(1,FrmSize+LPorder);

tempfrm(1:LPorder)=PrevSpFrm;

%tempfrm(1:FrmSize)=PrevSpFrm(1:FrmSize);
tempfrm(LPorder+1:LPorder+FrmSize)=SpFrm(1:FrmSize);

%pause


for(i=1:FrmSize)

	t=0;
	for(j=1:LPorder)

                t=t+FrmLPC(j+1)*tempfrm(-j+i+LPorder);
%pause
%j+1 because, FrmLPC[j] contains 1, zeroth coefficient

	end
	
	
        ResFrm(i)=SpFrm(i)-(-t);

%pause
end

%ResFrm=tempfrm(FrmSize+1:2*FrmSize);


if(plotflag==1)

	subplot(2,1,1);plot(SpFrm);grid;

	subplot(2,1,2);plot(ResFrm);grid;

end
