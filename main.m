%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by: Martin Åsell 2022-01-10
% About:
%   Script to solve the problems in the course "Teknisk Termodynamik"
%   The script relies on several functions (5) to solve all of the problems.
%   As is now you don't have to change anything, just make sure you have
%   the functions in the same directory and run 'main.m' (this file).
%   The script is also divided into different sections to easier run just
%   one part of the script (select which section and press CTRL+ENTER).
% 
%   In addition you need to have the datasets (found in the course
%   homepage)
%   - Uppsala_stralning_2008_2018.txt
%   - Uppsala_temperaturer_2008_2018.txt
%   In the same directory as all the files
% 
% Functions:
%   - temp_func.m
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Part 0, 
clear; close;
temp_data = importdata('Uppsala_temperaturer_2008_2018.txt').data;
radiation_data = importdata('Uppsala_stralning_2008_2018.txt').data;

temp_inside = 21;
T_L = 10;
Q_in = zeros(length(temp_data),1);
Q_out = zeros(size(Q_in));
COP = zeros(size(Q_in));

for i=1:length(temp_data)
  W_loss = 2*(temp_inside - temp_data(i,5)) / 3.6;
  Q_out(i) = 24*W_loss;
  
  W_in = W_loss*(1-((273+T_L)/(273+temp_func(temp_data(i,5)))));
  
  if temp_data(i,5) < 21
    COP(i) = 1 / (1 - (273+T_L)/(273+temp_func(temp_data(i,5))));
  end
  Q_in(i) = 24*W_in;
end

days_per_month = zeros(12,1);
for i=1:12
  days_per_month(i) = sum(temp_data(:,2)==i);
end

Q_out_month = zeros(12,1);
COP_month = zeros(12,1);
Q_in_month = zeros(12,1);
for month=1:12
  heat = 0;
  cop = 0;
  h_h = 0;
  for i=1:length(temp_data)
    if temp_data(i,2) == month
      heat = heat + Q_out(i);
      cop = cop + COP(i);
      h_h = h_h + Q_in(i);
    end
  end
  Q_out_month(month) = heat / days_per_month(month);
  COP_month(month) = cop / days_per_month(month);
  Q_in_month(month) = h_h / days_per_month(month);
end
 
figure(1)
subplot(3,1,1);
bar(Q_out_month);
title('Average Energy loss per month')
xlabel('month')
ylabel('Energy loss [kWh]')
subplot(3,1,2);
bar(Q_in_month);
title('Average Energy consumption per month')
xlabel('month')
ylabel('Energy used [kWh]')
subplot(3,1,3);
bar(COP_month);
title('Average COPper month')
xlabel('month')
ylabel('COP')


days_per_year = zeros(10,1);
for i=1:10
  days_per_year(i) = sum(temp_data(:,1)==i+2007);
end

Q_in_year = zeros(400,10);
for i=1:length(temp_data)
  W_loss = 2 * (temp_inside - temp_data(i,5))/3.6;
  W_in = W_loss*(1-((273+10)/(273+temp_func(temp_data(i,5)))));
  Q_in_year(i,(temp_data(i,1)-2007)) = 24*W_in;
  
end
Q_year = sum(Q_in_year,1);
x = [2008 2009 2010 2011 2012 2013 2014 2015 2016 2017];

figure(2)
bar(x,Q_year)
title('Average Energy Consumption Per Year');
xlabel('Year');
ylabel('Energy Consumption [kWh]');


Q_sun = zeros(length(radiation_data),1);
Q_HP = zeros(size(Q_sun));

% Q_in_year = zeros(400,10);
% Q_sun_in_year = zeros(size(Q_in_year));


for i=1:length(Q_sun)
  W_loss = 2*(temp_inside-temp_data(i,5))/3.6;
  W_sun = 100 * 0.07 * radiation_data(i,4)*(1/1000);
  W_in = W_loss*(1-((273+T_L)/(273+temp_func(temp_data(i,5)))));
  Q_HP(i) = 24*W_in;
  if Q_HP(i) < 0
    Q_HP(i) = 0;
  end
  Q_sun(i) = 24*W_sun;
  if Q_HP(i) <= Q_sun(i)
    Q_sun(i) = Q_HP(i);
  end
end
total_sun = sum(Q_sun);
total_HP = sum(Q_HP);
avg = total_sun/total_HP*100;

figure(3)
plot(Q_sun./Q_HP*100);
title('Percentage of energy delivered by solar panels')
xlabel('days')
ylabel('Percentage')

fprintf('Medelvärde av energin levererat av solcellerna = %f \n',avg)