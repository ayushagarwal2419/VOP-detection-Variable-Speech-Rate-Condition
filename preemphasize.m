function [y] = preemphasize(sig,factor)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage : [y] = preemphasize(sig,factor)
% If factor = 1, it is equivalent to diff() operation or it is a weighted diff.
% Can be implemented as a general filtering operation 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author	: Dhananjaya N
% Date		: 5th Apr 2005
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bcoefs	= [1 -factor];
acoefs	= 1;

y	= filter(bcoefs,acoefs,sig);

return;
