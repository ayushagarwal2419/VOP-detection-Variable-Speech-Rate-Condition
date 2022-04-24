function [speech]=SynthSpeech_v4(Residual,LPCs,lporder,framesize,frameshift,plotflag)

%USAGE: [speech]=SynthSpeech_v4(Residual,LPCs,lporder,framesize,frameshift,plotflag)

	speech=zeros(1,length(Residual));

	j=1;
	for(i=1:frameshift:length(Residual)-framesize)

		ResFrm=Residual(i:i+framesize-1);

		%j=ceil(i/frameshift)

		a=LPCs(j,:);

		j=j+1;

if(i <= framesize)
	PrevFrm=zeros(1,framesize);
	PrevFrm(framesize-(i-2):framesize)=speech(1:i-1);
else
	PrevFrm=speech((i-framesize):(i-1));
end


%		if(i==1)

%			PrevFrm=zeros(1,framesize);

%		elseif(i==1+frameshift)

%			PrevFrm(1:frameshift)=zeros(1,frameshift);

%			PrevFrm(frameshift+1:framesize)=speech((i-frameshift):(i-1));
%		else	
%			PrevFrm=speech((i-framesize):(i-1));
%		end
			

		%SpFrm=filter(1,a,ResFrm);

		SpFrm=SynthFilter(real(PrevFrm),real(ResFrm),real(a),lporder,framesize,0);	

		speech(i:i+frameshift-1)=SpFrm(1:frameshift);
%pause

	end
		speech(i+frameshift:i+framesize-1)=SpFrm(frameshift+1:framesize);

	%PROCESSING LASTFRAME SAMPLES
if(i<length(Residual))

        ResFrm = Residual(i:length(Residual));
		
	a=LPCs(j,:);

	j=j+1;

        PrevFrm=speech((i-framesize):(i-1));

        SpFrm=SynthFilter(real(PrevFrm),real(ResFrm),real(a),lporder,framesize,0);
        %res  = filter(lpcoef,1,temp); %inverse filtering

        speech(i:i+length(SpFrm)-1)=SpFrm(1:length(SpFrm));

end


	if(plotflag==1)
		
		figure;

		subplot(2,1,1);plot(real(Residual));grid;

		subplot(2,1,2);plot(real(speech));grid;

	end
















