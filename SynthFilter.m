
function [SpchFrm]=SynthFilter(PrevSpFrm,ResFrm,FrmLPC,LPorder,FrmSize,plotflag);

%USAGE: [SpchFrm]=SynthFilter(PrevSpFrm,ResFrm,FrmLPC,LPorder,FrmSize,plotflag);

tempfrm=zeros(1,2*FrmSize);

tempfrm((FrmSize-LPorder):FrmSize)=PrevSpFrm((FrmSize-LPorder):FrmSize);

for(i=1:FrmSize)

	t=0;
	for(j=1:LPorder)

		t=t+FrmLPC(j+1)*tempfrm(-j+i+FrmSize);
%pause
	end
	
%	ResFrm(i);

	%s=-t+ResFrm(i)
%pause
	%tempfrm(FrmSize+i)=s;
	
	tempfrm(FrmSize+i)=-t+ResFrm(i);

%pause
end

SpchFrm=tempfrm(FrmSize+1:2*FrmSize);


if(plotflag==1)

	figure;
	subplot(2,1,1);plot(ResFrm);grid;

	subplot(2,1,2);plot(SpchFrm);grid;

end


