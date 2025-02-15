warning('off', 'all')

%Read data from dat file
table = load('data/ZTD_mayg.dat');
%getting the values for column 2
days = unique(table(:, 2));
% Initialize a cell array to store mean values for columns
meanforcolumns = cell(length(days), 1);
%adding a constant value for first column for year values
year = 2022;
%opens a file ZTD_daily_mayg.dat to write to
file = fopen('data/ZTD_daily_mayg.dat', 'w');
%checks if the file is open
if file == -1
    error('Error opening file for writing');
end
%looping through unique values for rows in column 2
for i = 1:length(days)
    %the value for doy to check
    value = days(i);
    % Add first column with constant value for year 
    updated_data = [year * ones(size(table, 1), 1), table];
    %cols with the same doy in column 2
    cols = updated_data(updated_data(:, 3) == value, :);
    %Finding mean for column 5 to 9 since first column (year) is added
    meanforcolumns{i} = mean(cols(:, 5:9), 1);
    
    %writing the output to ZTD_daily_mayg.dat file
    fprintf(file, '%d %d %f %f %f %f %f', year, value, meanforcolumns{i});
    fprintf(file, '\n');
    
end
fclose(file);