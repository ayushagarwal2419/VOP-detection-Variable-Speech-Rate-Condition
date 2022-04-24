function Ret = remtrend(h,sf,plotflag)

%disp('RemTrend')
% USAGE : ret = RemTrend(henv,sf,plotflag);

pd = floor(sf*2/1000);

for i = 1:pd
	temp = h(1:i+pd);
	Ret(i) = h(i)/mean(temp);
	Ret(i) = Ret(i)*h(i);
end;

for i = pd+1:length(h)-pd
i;
	temp1 = h(i-pd:i+pd);
	Ret(i) = h(i)/mean(temp1);
	Ret(i) = Ret(i)*h(i);
end;

for i = (length(h)-pd+1):length(h)
	temp2 = h(i:length(h));
	Ret(i) = h(i)/mean(temp2);
	Ret(i) = Ret(i)*h(i);
end;

%Ret = sqrt(Ret);

if(plotflag==1)
	figure;subplot(2,1,1);plot(h)	;grid;
	subplot(2,1,2);plot(Ret);grid;
end;		


Ind1=isnan(Ret);
Ind2=find(Ind1==1);
Ret(Ind2)=min(Ret);