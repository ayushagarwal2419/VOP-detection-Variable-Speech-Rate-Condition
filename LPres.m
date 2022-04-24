function [res,LPCs,RSE] = LPres(speech,fs,framesize,frameshift,lporder,preemp)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% USAGE : [res,LPCs,RSE] = 
%		LPres(speech,fs,framesize,frameshift,lporder,preemp)
%
% INPUTS	:
%	speech 		- speech signal (Nx1)
%	fs		- sampling rate (in Hz)
%	framesize 	- framesize for LP analysis (in ms)
%	frameshift 	- frameshift for LP analysis (in ms)
%	lporder		- order of LP analysis
%	preemp		- If 0, no preemphasis is done, otherwise an high-pass 
%			filtering is performed as per the following difference
%			eqn:	y(n) = x(n) - a x(n-1),
%			where 'x' is the speech signal and 'a = preemp'. 
% 
% OUTPUTS :
%	res	- residual signal (Nx1)
%	LPCs	- 2D array (M x p) containing LP coeffs of all frames,
%		where p is the LP order and M depends on the framesize and
%		frameshift used.
%	RSE	- Residual to signal energy ratio
%
% This matlab function generates LP residual by inverse filtering. The inverse
% filter coefficients are obtained by LPanalysis.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% METHOD: 
%	- Consider one frame at a time, compute LP coefficients of the frame
%	samples that are windowed using a hamming window.
%	- Inverse filter the unwindowed speech frame to get corresponding 
%	reisdual frame.
%	- Only FRAMESHIFT number of samples among the total 
%        FRAMESIZE number of samples are retained.
%	-Repeat same procedure for all the frames. The last frame can be of
%	size less than FRAMESIZE.
%	-In the end, hamming window lporder number of 
%        samples of the first frame 
%	 to eliminate initial poorly predicted samples.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ACKNOWLEDGEMENT	:
%	This program has been adopted from LPresidual_v3.m authored by
%	S.R.Mahadeva Prasanna.
%
% AUTHOR 		: Dhananjaya N
% DATE   		: 22/11/2004
% LAST MODIFIED 	: -
% OTHER FUNCTIONS USED	: ResFilter_v2
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	funcname	= 'LPres()';

% Validating input arguments

	error(nargchk(6,6,nargin)); % Exit if errmsg is not empty.

	if(framesize > 50)

		warning('!!! Ensure that the framesize and frameshift are in ms and not in terms of number of samples');
pause;
	
	end

% Converting unit of variuos lengths from 'time' to 'sample number'

	Nframesize	= round(framesize * fs / 1000);
	Nframeshift	= round(frameshift * fs / 1000);	
	Nspeech 	= length(speech);

% Transpose the 'speech' signal if it is not of the form 'N x 1'
	speech = speech(:); % Make it a column vector

% PREEMPHASIZING SPEECH SIGNAL
	if(preemp ~= 0)
		speech = preemphasize(speech,1);
	end

%COMPUTING RESIDUAL
	res = zeros(Nspeech,1);

%NUMBER OF FRAMES

	nframes=floor((Nspeech-Nframesize)/Nframeshift)+1;

	LPCs=zeros(nframes,(lporder+1));

	j	= 1;

	for i = 1:Nframeshift:Nspeech-Nframesize

		SpFrm	= speech(i:i+Nframesize-1);

		if(sum(abs(SpFrm)) == 0) % Handling zero energy frames

			LPCs(j,:)	= 0;

			ResFrm		= zeros(Nframesize,1);

		else
 			lpcoef	= lpc(hamming(Nframesize).*SpFrm,lporder);

			LPCs(j,:)	=real(lpcoef);

			if(i <= lporder)

			       PrevFrm=zeros(1,lporder);

			else

				PrevFrm=speech((i-lporder):(i-1));

			end

			ResFrm	= ResFilter_v2(real(PrevFrm),real(SpFrm),real(lpcoef),lporder,Nframesize,0);

		end % End of if(sum(abs(SpFrm)) == 0)


		res(i:i+Nframeshift-1)	= ResFrm(1:Nframeshift);

		j	= j+1;
		
	end

% The residual samples of the last but one frame is copied in entirity
% This line is commented on 22/11/2004 by Dhananjaya.
% A carefull analysis reveals that this will not be required. 
% The handling of last frame takes care of this.

		res(i+Nframeshift:i+Nframesize-1)	= ResFrm(Nframeshift+1:Nframesize);

%PROCESSING LASTFRAME SAMPLES, 
	if(i < Nspeech)

		SpFrm	= speech(i:Nspeech);

		if(sum(abs(SpFrm)) == 0) % Handling zero energy frames

			LPCs(j,:)	= 0;

			ResFrm		= zeros(Nframesize,1);

		else

			lpcoef	= lpc(hamming(length(SpFrm)).*SpFrm,lporder);

			LPCs(j,:)	= real(lpcoef);

			PrevFrm	= speech((i-lporder):(i-1));

			ResFrm	= ResFilter_v2(real(PrevFrm),real(SpFrm),real(lpcoef),lporder,Nframesize,0);

		end
		res(i:i+length(ResFrm)-1)	= ResFrm(1:length(ResFrm));

		j	= j+1;

	end

	hm	= hamming(2*lporder);

	for i = 1:round(length(hm)/2)

		res(i)	= res(i) * hm(i);      %attenuating first lporder samples

	end

%PLOTTING THE RESULTS

	if( ~isempty(whos('global','PLOTFLAG')))
		figure;
		subplot(2,1,1);plot(speech);grid;
		subplot(2,1,2);plot(real(res));grid;
	end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SOME MISTAKES IN THE PREVIOUS VERSIONS :
%	res  = filter(lpcoef,1,temp1); %inverse filtering
% NOTE the error in the above statement. we need to filter orginal frame, 
% not the windowed one (temp1 is original frame).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% LOG OF CHANGES:
%
%	Changes by S.R.M.Prasanna:
% 
% 24-10-2000: The program was not working for framshift=one sample. The index
%	      values are properly adjusted and now it works for this case also.
% 07-04-2002: The program was having bug in the routine of transferring
%            'Previous Frame' values to ResFilter.m. Now it has been modified
%
%	Changes by Dhananjaya N:
%
% 22/11/2004: 	* The program was restructured. 
%
%		* The binary 'preempflag' input 
%		parameter has been changed to a continuous parameter 'preemp
%		and can take values from 0 to 1.
%
%		* A new i/p parameter 'fs' (sampling rate) is added.
%
%		* The units of the parameters framesize and frameshift are 
%		changed to 'ms' from 'num of samples'.
%
%		* Zero energy frames are handled. Otherwise gives divide by 
%		zero error.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

