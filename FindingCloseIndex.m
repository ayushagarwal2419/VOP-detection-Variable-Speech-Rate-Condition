function [close_index]=FindingCloseIndex(original_epochs_loc,modified_epochs_loc)

 for i=1:length(modified_epochs_loc);
   for j=1:length(original_epochs_loc);  
temp(j)=abs(original_epochs_loc(j)-modified_epochs_loc(i));
   end
   
   [val,temp1]=min(temp);
   temp2(i)=temp1;
 end

close_index=temp2;

[a,b]=find(close_index==1); %for excluding first silence epoch interval 
close_index(b)=2;