function[ vlrop,pp]=peakpicking_v1(evidence,vlrop_th)

%%%%%%%% To find all negative to positive zero-crossing  points %%%%%%%%
line_th=0;
N=3;

% npz_spu=zeros(1,length(evidence));
% 
% for i=N+1:length(evidence)-N
%     
%     x1=evidence(i-N:i);
%     x2=evidence(i+1:i+N);
%     
%     if(x1<=line_th), t1=1;  else   t1=0;    end
%     if(x2>line_th),  t2=1;  else   t2=0;    end
%     
%     if(x1<line_th),  t11=1;  else   t11=0;  end
%     if(x2>=line_th), t22=1;  else   t22=0;  end
%     
%     npz_spu(i)=max(t1*t2,t11*t22);
%     
% end

gci=find(diff((evidence>0))==1);       %%%%%%%  pick zero crossing
z=zeros(1,length(evidence));
for i=1:length(gci)
    z(gci(i))= 0.5;
end
npz_spu=z;


%%%% To remove the spurious  negative  to positive  zero crossing  %%%%

npz_indices1=find(npz_spu~=0);

for i=1:length( npz_indices1)-1
    if   max(evidence(npz_indices1(i):npz_indices1(i+1)))==0
        npz_indices1(i)=0;
    end
end

if max(evidence(npz_indices1(end):end))==0;
    npz_indices1(end)=0;
end
ind_npz_final=npz_indices1(npz_indices1~=0);


%%%%%%%%% To find peak location between two zerocrossings %%%%%%%%%

maxvalue_indices=[];

if  max(evidence(1:ind_npz_final(1)))==0;
    
    for j=1:length(ind_npz_final)-1
        maxvalue_indices(j)=max(find(evidence(ind_npz_final(j):ind_npz_final(j+1))==max(evidence(ind_npz_final(j):ind_npz_final(j+1)))));
    end
    
    maxvalue_indices(end+1)= max(find(evidence(ind_npz_final(end):end)==max(evidence(ind_npz_final(end):end))));
    
    peak_loc=ind_npz_final+maxvalue_indices;
    
else    
    
    for j=1:length(ind_npz_final)-1
        maxvalue_indices(j)=max(find(evidence(ind_npz_final(j):ind_npz_final(j+1))==max(evidence(ind_npz_final(j):ind_npz_final(j+1)))));
    end
    
    maxvalue_indices(end+1)= max(find(evidence(ind_npz_final(end):end)==max(evidence(ind_npz_final(end):end))));
    peak_loc=ind_npz_final+maxvalue_indices;
    
    maxvalue_indices_abnormal= max(find(evidence(1:ind_npz_final(1))==max(evidence(1:ind_npz_final(1)))));
    peak_loc=[maxvalue_indices_abnormal,peak_loc];
end

%%-------------------------------------------------------------------
peak_loc=peak_loc(peak_loc>160);% to avoid vlrop in first 10 ms
le=length(evidence)-160;
peak_loc=peak_loc(peak_loc<le);%to avoid vlrop in last 10 ms



for i=1:length(peak_loc);
    if evidence(peak_loc(i))<vlrop_th
        peak_loc(i)=0;
    end
end

vlrop=peak_loc(peak_loc~=0);

pp=zeros(1,length(evidence));
pp(vlrop)=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

