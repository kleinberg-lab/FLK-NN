function Y = knnW3timeLag(miss_mat,K,num_L, max_lag)
%This function impute missing value with KnnLag method.
%  input arguments: 
%       miss_mat: data matrix with missing values (indicated by NaN) (type real)
%       K: number of nearest neighbor in Knn (type integer)
%       num_L: number time lag matrices (type integer)
%       max_lag: maximum lags in terms of time points (type integer)
% output parameter:
%         Y: data matrix with imputed value. (type real)


[corr_coef, cov_coef, time_lag_mat_3] = find_t_lag(miss_mat,num_L,max_lag); 
[num_r,num_var] = size(miss_mat);
v_min(1:num_var) = nanmin(miss_mat(:,1:num_var));
v_max(1:num_var) = nanmax(miss_mat(:,1:num_var));
Y = miss_mat;

for var_index = 1:num_var
    sig_missing = miss_mat(:,var_index); 
    missing_val_ind = find(isnan(sig_missing));
    
    for j = 1:length(missing_val_ind)
        NN_all = [];
        for lagM_index = 1:num_L
            time_lag_mat = time_lag_mat_3(:,:,lagM_index);
            
            rel_var = find(time_lag_mat(var_index,:) ~= Inf);
            miss_val_vec = [];

            for p = 1:length(rel_var) %find out the corresponding vector of missing value by using the time lags
                if ((missing_val_ind(j)+time_lag_mat(var_index,rel_var(p))) < 1) || ((missing_val_ind(j)+time_lag_mat(var_index,rel_var(p))) > num_r)
                    rel_var(p) = Inf;
                    continue;
                else
                    miss_val_vec = cat(2, miss_val_vec,miss_mat(missing_val_ind(j)+time_lag_mat(var_index,rel_var(p)),rel_var(p)));
                end            
            end
            rel_var(rel_var == Inf) = '';
            rel_var(isnan(miss_val_vec)) = '';
            miss_val_vec(isnan(miss_val_vec)) = ''; %#ok<AGROW>

            if isempty(rel_var) 
                continue;
            end
            attr_v_min = v_min(rel_var);
            attr_v_max = v_max(rel_var);
            miss_val_vec = (miss_val_vec - attr_v_min)./(attr_v_max - attr_v_min); %min-max normalization

            %find the lower bound and upper bound of search space
            lower_ind = min(time_lag_mat(var_index,rel_var));       
            if lower_ind < 0
                lower_ind = -lower_ind+1;
            else
                lower_ind = 1;
            end
            upper_ind = max(time_lag_mat(var_index,rel_var));
            if upper_ind > 0
                upper_ind = num_r - upper_ind;       
            else
                upper_ind = num_r;
            end

            NN_val = Inf(K, 3);  % store candidate value, distance, and mean of exiting variables correlation
            
            %find the nearest neighbors from the search space.
            for r = lower_ind:upper_ind
                if r == missing_val_ind(j) || isnan(miss_mat(r,var_index))
                    continue;
                end
                temp_row_vec = Inf(1,length(rel_var));
                for p = 1:length(rel_var)
                    temp_row_vec(p) = miss_mat(r+time_lag_mat(var_index,rel_var(p)),rel_var(p));
                end
               
                non_nan_vec = temp_row_vec(~isnan(temp_row_vec));
                if length(non_nan_vec) < num_var/3
                    continue;
                end

                temp_row_missVal = miss_mat(r,var_index);
                temp_row_vec = (temp_row_vec - attr_v_min)./(attr_v_max - attr_v_min);

                vec_dist = dist_e(temp_row_vec, miss_val_vec);

                if vec_dist < NN_val(K, 2)
                    NN_val(K,1) = temp_row_missVal;
                    NN_val(K,2) = vec_dist;
                    obs_vars = rel_var;
                    obs_vars(isnan(temp_row_vec)) = []; 
                    NN_val(K,3) = mean(corr_coef(var_index,obs_vars,lagM_index));
                    NN_val = sortrows(NN_val, 2);
                end

            end
            NN_all = cat(1,NN_all,NN_val);
            
        end
        if ~isempty(NN_all)
            NN_all(:,2) = NN_all(:,2).*abs(2-NN_all(:,3));
            NN_all = sortrows(NN_all,2);
            m_val = mean(NN_all(1:5,1));

            if ~isinf(m_val)
                sig_missing(missing_val_ind(j)) = m_val; 
            end
        end
    end
    Y(:,var_index) = sig_missing;
end
end

function [corr_coef, cov_coef, t_lag_mat_3] = find_t_lag(miss_mat,num_lags,max_lag)
%This sub function finds the time lag by using cross correlation

[num_r,num_var] = size(miss_mat); %#ok<ASGLU>
t_lag_mat_3 = Inf(num_var,num_var,num_lags);
corr_coef = Inf(num_var,num_var,num_lags);
cov_coef = Inf(num_var,num_var,num_lags);
for i = 1:num_var - 1
    for j = i+1:num_var
        [c,cross_cov,lags]= xcorr_w_miss(miss_mat(:,i),miss_mat(:,j),max_lag);
        for k = 1:num_lags
            [m_val,maxInd] = max(abs(c));
            t_lag_mat_3(i,j,k) = lags(maxInd);
            t_lag_mat_3(j,i,k) = -lags(maxInd);
            corr_coef(i,j,k) = m_val;
            corr_coef(j,i,k) = m_val;
            cov_coef(i,j,k) = cross_cov(maxInd);
            cov_coef(j,i,k) = cross_cov(maxInd);
            c(maxInd) = 0;
        end
    end
end
% finding variance
for i = 1:num_var 
    cov_coef(i,i,1:num_lags) = nanvar(miss_mat(:,i));
    corr_coef(i,i,1:num_lags) = 1;
end
end