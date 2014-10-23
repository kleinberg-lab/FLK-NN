%{
function field = read_rows (inputFile, format, Row)
%this file returns the contents of row specified by the 'Row'.  
%Usage: data = read_rows ('input.csv', '%s %s %s', [4 10] );
% parameters: inputFile - name of the csv input file with path
%             Format of the row
%             Row - 2 element vector specifying start and end (row number start from 1).


fid=fopen(inputFile, 'r');
%arr = textscan(fid,format, Row(2)-Row(1)+1, 'delimiter', ',','headerlines',Row(1)); %read the data for specified column
arr = textscan(fid,format, 1, 'delimiter', ',','headerlines',Row(1)-1);
field = cell((Row(2)-Row(1)+1),length(arr));
for j = 1:length(arr)
    field(1,j) = arr{1,j};
end
for i = 2:(Row(2)-Row(1)+1)
    arr = textscan(fid,format, 1, 'delimiter', ',');
    for j = 1:length(arr)
        field(i,j) = arr{1,j};
    end
    
end

fclose(fid);
end
%}

function field = read_rows (inputFile, format, Row)
%this file returns the contents of row specified by the 'Row'.  
%Usage: data = read_rows ('input.csv', '%s %s %s', [4 10] );
% parameters: inputFile - name of the csv input file with path
%             Format of the row
%             Row - 2 elements vector specifying start and end (row number start from 1). If its a one element than it reads from Row(1) to end of file 


fid=fopen(inputFile, 'r');
if length(Row)>1
    marr = textscan(fid,format, Row(2)-Row(1)+1, 'delimiter', ',','headerlines',Row(1)-1); %read the data 
else
    marr = textscan(fid,format, -1, 'delimiter', ',','headerlines',Row-1);    
end
field = cell(length(marr{1}),size(marr,2));
for i = 1:size(marr,2)
    field(:,i) = marr{i};
end
fclose(fid);
end
%}
