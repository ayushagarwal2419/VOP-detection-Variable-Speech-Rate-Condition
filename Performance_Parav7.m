%%%% Performance parameter when we are comparing w.r.t ground truth
function [SPURIOUS_VOP, DEVIATION_OF_DETECTED_VOP, CORRECTLY_DETECTED_VOP, MISS_VOP,INSERTIONS] = Performance_Parav7(vlrop1, vlrop2, fs,Speech_Rate)

tolerance_in_ms = 10/Speech_Rate;

TOTAL_DETECTED_VOP = length(vlrop1);

TOTAL_ACTUAL_VOP = length(vlrop2);

CORRECTLY_DETECTED_VOP = 0;

DEVIATION_OF_DETECTED_VOP = 0;

SPURIOUS_VOP = 0;

MISS_VOP = 0;

%%%%%%  Calculate the distance of every ground truth with every detected
%%%%%%  VOP.
for i=1:length(vlrop2)
    for j=1:length(vlrop1)
        distance(i,j) = abs(vlrop2(i) -vlrop1(j));
    end
end

for j=1:length(vlrop1)
    count=0;
    for i=1:length(vlrop2)
        if (distance(i,j) <= tolerance_in_ms*0.001*fs)
            count = count+1;
            if(count>1)
                SPURIOUS_VOP = SPURIOUS_VOP + 1;
            end
        end
        minDist(i) = min(distance(i,:));
    end
end

for i=1:length(minDist)
    if(minDist(i)<=tolerance_in_ms*0.001*fs) %%%% The mindist is calc so that dev is calc for that VOP only.
        CORRECTLY_DETECTED_VOP = CORRECTLY_DETECTED_VOP+1;
        DEVIATION_OF_DETECTED_VOP = DEVIATION_OF_DETECTED_VOP + minDist(i) / (0.001*fs);
    elseif(minDist(i)>tolerance_in_ms*0.001*fs)
        MISS_VOP = MISS_VOP + 1;
    end
end

DEVIATION_OF_DETECTED_VOP = DEVIATION_OF_DETECTED_VOP / TOTAL_DETECTED_VOP;

if(TOTAL_DETECTED_VOP>TOTAL_ACTUAL_VOP)
    INSERTIONS = (TOTAL_DETECTED_VOP-TOTAL_ACTUAL_VOP);
else
    INSERTIONS = 0;
end

end