% PROBLEM 1
% Write a program to generate a large number of random numbers using your particular random function
% As the simplest possible check of the generator, make sure that the values indeed are uniformly distributed between zero and one.

% set seed to make repeatable
rng('default');

a = 0;
b = 1;
% rand function 'draws values from a uniform distribution in the open
% interval (a,b)'
r = (b-a).*rand(50000,1) + a ;

% verify that the values in r are within the specified range:
%   r_range = [min(r) max(r)]

% create histogram with 10 bins
histogram(r,10)