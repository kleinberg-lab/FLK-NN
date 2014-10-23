
function Y = FourierImpute( mis_mat, des_percent)
%this function imputes missing values based on Fourier method. Missing
%values are indicated by NaN. 
% Input parameter:
%        mis_mat: data matrix with missing values. (type: real)
%        des_percent (optional): Fourier descriptor amount in percentage to
%                     reconstruct the signal. (e.g. 100, 75, 50). Default value 100. (type:
%                     integer)
% output parameter:
%         Y: data matrix with imputed value.

if nargin<2
    des_percent = 100;
end
Y = mis_mat;
for var_index = 1:size(mis_mat,2) % process attribute by attribute
    sig_missing = mis_mat(:,var_index); % one attribute data

    miss_st = find(isnan(sig_missing),1,'first');
    while ~isempty(miss_st)
        miss_fi = miss_st + find(~isnan(sig_missing(miss_st:end)),1,'first') - 2;
        if isempty(miss_fi) % missing till the end of the signal
            miss_fi = length(sig_missing);
        end
        
        sig_segment = sig_missing(1:miss_st-1);
        Fsig_segment = fft(sig_segment);
        descriptor_len = ceil(length(Fsig_segment)*des_percent/100);
        temp_sig = real(ifft(Fsig_segment(1:descriptor_len), miss_fi)); 
        sig_missing (miss_st:miss_fi) = temp_sig(miss_st:miss_fi);
        miss_st = miss_fi + find(isnan(sig_missing(miss_fi+1:end)),1,'first');
    end
   
    Y(:,var_index) = sig_missing;
end