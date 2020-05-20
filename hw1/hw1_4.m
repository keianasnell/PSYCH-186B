% PROBLEM 4
% Estimate a crude value of pi using the Monte Carlo method.

% creates the boundaries of the circle
t = linspace(0,2*pi,300);
x = cos(t);
y = sin(t);

% set seed to make repeatable
rng('default');

a = -1;
b = 1;
num_tries = 100000;
% rand function 'draws values from a uniform distribution in the open
% interval (a,b)'
xc = (b-a).*rand(num_tries,1) + a ;
yc = (b-a).*rand(num_tries,1) + a ;

[in,on] = inpolygon(xc,yc,x,y);

% number of points inside the circle
inside = numel(xc(in))  
% number of points outside the circle
outside = numel(xc(~in))

% Given that num_tries = 1,000,000, num_tries / inside = ~1.2736
% This is close to 4 / PI = ~1.27324


% Draw circle and show points within/outside the circle
% plot(x,y, 'black')
% axis equal
% 
% hold on
% plot(xc(in),yc(in),'r+') % points inside
% plot(xc(~in),yc(~in),'bo') % points outside
% hold off

