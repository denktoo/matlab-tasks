warning('off', 'all')

%Read data from external files ZTD_daily_mayg.dat and mayg_2022avg.txt
table = load('data/ZTD_daily_mayg.dat');
data = load('data/mayg_2022avg.txt');

%symbolic variables used in calculation
syms k_3 k_2 R_v T_s T_m

%aAssigning the values to the variables that will be used in calculations
k_3 = 3.776 * 10^5;
k_2 = 16.52;
R_v = 461.495;
ZWD = 0;
Tm = 0;
PWV = 0;

%Open a PWV_daily_mayg.dat to write to
file = fopen('data/PWV_daily_mayg.dat', 'w');
%checks if the file is open
if file == -1
    error('Error opening file for writing');
end

%Looping through the rows
for i = 1:size(table, 1)
    %Check if column values are equal per row
    if any(table(i, 2) == data(:, 2))
        %Calculate ZWD where ZTD = table{i, 4} and ZHD = data(data(:, 2) == table(i, 2), 10)
        ZWD_sym = (table(i, 4) * 1000) - data(data(:, 2) == table(i, 2), 10);
        % Convert ZWD to numerical value
        ZWD = double(ZWD_sym);
        %Finding the weighted mean temperature Tm, where T_s = data(data(:, 2) == table(i, 2), 9)
        Tm_sym = 70.2 + (0.72 * data(data(:, 2) == table(i, 2), 9));
        % Convert Tm to numerical value
        Tm = double(Tm_sym);
        %Calculate PWV
        PWV = ((10^5) / (((k_3 / Tm) + k_2)*R_v))*ZWD;
        %Updating PWV_daily_mayg.dat
        fprintf(file, '%d %d %f %f %f %f %f %f %f %f', [table(i, :), ZWD, Tm, PWV]);
        fprintf(file, '\n');
    end
end
fclose(file);