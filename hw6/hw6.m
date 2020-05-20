% HW6: Neural network simulation that performs a parity (odd/even) judgment on input units


lrate = 1;
input_units = 8;
hidden_units = 3;
output_units = 1;
num_patterns = 8;
% You can create these patterns by rounding random uniform variates created using rand().  
 
% # 2. Set up the patterns that the network will be trained on ( A matrix of ones and zeros )
% # The number of rows equal to the number of input units. 
% # The number of columns = the number of patterns that the network will be trained on 
train = np.round(rand_initial_weights(input_units, num_patterns) + 0.5)
patterns = zeroes();
for i = 1 :range(train.shape(0)):
    patterns.append(train(:,i));  
end


% # 3. Determine the desired output for each pattern, 
% # which is 1 if the number of ones in the input is even and zero if the number is odd. 
desired_output = targetIs(train)

% # 4.  Create two matrices for the weights that connect the input to hidden units (w_fg), 
% # and hidden units to the output unit (w_gh).  
% # Fill these matrices with uniform random numbers between –0.5 and 0.5.  
w_fg = rand_initial_weights(hidden_units, input_units)
w_gh = rand_initial_weights(output_units, hidden_units)
% # print(w_fg.shape) # 3x8
% # print(w_gh.shape) # 1x3

num_epochs = 1000
epoch = 1
SSE = 0
SSE_vec = []
reset = 0  %number of times had to reset because failed to converge



function weights = rand_initial_weights(rows, cols)
    weights = np.zeros((rows, cols)) %rewrite
    for i = 1 : range(rows)
        for j 1 : range(cols)
            weights(i,j) = random.uniform(0,1) - 0.5 %rewrite
        end
    end
end


%# The Sigmoid Function ( a smooth, monotonically increasing, differentiable function )
function x = sigmoid(A)
    x = 1./(1+np.exp(-A)) %rewrite
end