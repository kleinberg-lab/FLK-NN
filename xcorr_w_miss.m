function [c,cross_cov,lags] = xcorr_w_miss(X,Y,maxlags)
%find the cross correlation with missing values
%formula is c(k) = 1/(N-k) * sum((X(t)-X')(Y(t+k)-Y'))/(std(X) * std(Y)) for k = 0,1,......,N-1
%           c(k) = 1/(N-k) * sum((Y(t)-Y')(X(t+k)-X'))/(std(X) * std(Y))  for k =-1,-2......,-(N-1)
% Input parameters: 
%        X, Y : two vectors among which the cross correlation is to be computed (type: real)
%       maxlags (optional): maximum time lag it will look for. default value is minimum length among X and Y.
% Output parameters: 
%        c: cross correlation score
%        cross_cov: cross covariance score
%        lags: corresponding lags of c values

x_len = length(X);
y_len = length(Y);

if nargin < 3
    maxlags = min(x_len,y_len) - 1;
end

x_mean = nanmean(X);
y_mean = nanmean(Y);
x_std = nanstd(X);
y_std = nanstd(Y);

lags = -maxlags:maxlags;
c = Inf(size(lags));
cross_cov = Inf(size(lags));
for k = -maxlags:maxlags
    if k >= 0
        tempCrossCov = nanmean((X(1:x_len-k) - x_mean) .* (Y(1+k:y_len) - y_mean));
    else
        tempCrossCov = nanmean((Y(1:y_len + k) - y_mean).* (X(1-k:x_len) - x_mean));
    end
    cross_cov(k+maxlags+1) = tempCrossCov;
    c(k+maxlags+1) = tempCrossCov/(x_std*y_std);
end
end
