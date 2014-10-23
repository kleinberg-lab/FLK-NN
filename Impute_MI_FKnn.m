function Y = Impute_MI_FKnn(X,K,num_lags,max_lag)
% Impute values by MI-FKnnTL method
% Input: missing matrix (missing values indicated by NaN) (type real)
% Output: data matrix with imputed values

Y_knnTL = knnW3timeLag(X,K,num_lags,max_lag);
Y_F = FourierImpute(X);
Y = nanmean(cat(3,Y_knnTL,Y_F),3);
end

