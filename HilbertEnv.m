function henv = HilbertEnv(sig,Fs,RemTrendFlag)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% USAGE	: henv = HilbertEnv(sig,Fs,RemTrendFlag)
%
% PURPOSE	:
%	Computes the magnitude of the analytic signal, obtained by taking the
%	Hilbert transform of the i/p signal. Hilbert transform of a signal 
%	shifts the phase of every freq. component of the signal by 90 degree.
%	The matlab function hilbert() returns a complex analytic signal, whose
%	real part is same as the input signal and its imaginary part is the 
%	Hilbert transform of the signal.
% 	Hilbert envelope is given by h_e[n] = sqrt(s[n]^2 + h[n]^2);
%
%	The magnitude of the analytic signal has the non-glottal closure 
%	regions (valleys between the glottal peaks) raising significantly from 
%	the zero line. The valleys are brought down, while at the same time, 
%	the glottal closure (GC) peaks are sharpened using RemTrend() function. 
%	This RemTrend() fn may be useful for detection of instants of GC and 
%	pitch detection.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if( ~ exist('RemTrendFlag'))
	RemTrendFlag = 0; % No RemTrend by default.
end

% Smooth the signal by 3 point hanning window for reducing noise
%sig	= conv(sig,hanning(3));
%sig	= sig(2:length(sig)-1);

hcmplx	= hilbert(sig);

henv	= abs(hcmplx);


if(RemTrendFlag == 1)
	henv	= remtrend(henv,Fs,4); % use 4ms window length
end

if( ~isempty(whos('global','PLOTFLAG')))
	figure;
	subplot(2,1,1);plot(sig);grid;
	subplot(2,1,2);plot(henv);grid;
end

return;

%%%%%%%%%%%%%%%% End of HilbertEnv() %%%%%%%%%%%%%%%%%%%%%

