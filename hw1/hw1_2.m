% PROBLEM 2
% Write a program that will return normally distributed random variables. 
% Generate a histogram of values returned by the function

% set seed to make repeatable
rng('default');

% Creates a vector `y` of 10000 random values drawn from a normal distribution with a mean of 0 and a standard deviation of 1.
y = randn(10000,1);
s = std(y);
m = mean(y);

% Create a histogram and fits a normal curve to the data in `y`
histfit(y);

p = normcdf(y,m,s); %What to do with these values?


one_std = sum(y >= -1 & y <= 1)/100;
two_std = sum(y >= -2 & y <= 2)/100;
three_std = sum(y >= -3 & y <= 3)/100;

% In a NORMAL distribution, 68% of the observations fall within +/- 1
% std from the mean; 95% within +/- 2 std; 99.7% within +/- 3 std;
% My random values from vector y distributed in the following way:
% within one_std = 68.8% 
% within two_std = 95.6% 
% within three_std = 99.7%