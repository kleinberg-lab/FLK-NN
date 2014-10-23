function dist = dist_e(vec1, vec2)
%Finds average Euclidean distance between two vectors. Ignores the NaN (i.e. missing)
%values.
% input parameters: 
%      vec1 and  vec2 : two vectors whose distance is to be computed (type: real)
% output parameters:
%      dist: calculated distance


temp_dist = (vec1 - vec2).^2;
temp_dist(isnan(temp_dist)) = '';
if isempty(temp_dist) % if all the elements of a vector is missing 
    dist = NaN;
else
    dist = sum(temp_dist)^0.5/length(temp_dist);
end
