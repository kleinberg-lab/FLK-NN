FLK-NN
======

Imputation of Missing Values in Time Series with Lagged Correlations

How to run the program:

1) Open Matlab command window.

2) set current working directory in MATLAB to this folder

3) write the command run_Imput_MI_FKnn(input_file,output_file,num_var) and press enter. Here "input_file" is the csv file name with path containing missing values, "output_file" is also a csv file that will store the output data matrix and "num_var" is number of variable in the input file. One example for OS X is run_Impute_MI_FKnn('./DSIM_data/missing_data/pid_1_noise10_mAmount5.csv','./DSIM_data/imputed_data/pid_1_Imp_mAmount5.csv',16)

4)Input file format is : patient_id,time, value1,value2,value3
If the data format is different, one needs to load the data into a matrix, X, and call the function "Impute_MI_FKnn(X)" in the command window.

We refer to the individual .m file for details on the function and their parameters.

Data
----

Data can be found [here](https://github.com/kleinberg-lab/DSIM-data).

