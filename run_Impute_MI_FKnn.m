function run_Impute_MI_FKnn(input_f,output_f,num_var)
%Implements MI-FKnnTL method. 
%  input arguments: 
%       input_f: input CSV file name with path, containing missing values. (Type: string)
%                Rows corresponds to instances and columns corresponds to variables.
%                data format: patient_id,time,value1,value2,value2,.....
%       num_var: number of variables in the data (Type: integer)
% output parameter:
%         output_f: output CSV file name with path. (Type: string)

% Usage: run_Impute_MI_FKnn('./DSIM_data/missing_data/pid_1_noise10_mAmount5.csv','./DSIM_data/imputed_data/pid_1_Imp_mAmount5.csv',16) 


format = [repmat('%s ',1,num_var+1),'%s%*[^\n\r]'];
temp_X = read_rows (input_f, format, 1);
X = str2double(temp_X(:,3:end));
Y_temp = Impute_MI_FKnn(X,5,3,60);
Y = cat(2,temp_X(:,1),temp_X(:,2),num2cell(Y_temp));
formatW = ['%s,%s,',repmat('%f,',1,num_var-1),'%f\n'];
fidW = fopen(output_f,'w');
for p = 1:size(Y,1)
    fprintf(fidW, formatW,Y{p,:});
end
fclose(fidW);
end

