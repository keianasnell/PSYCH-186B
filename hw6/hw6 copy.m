% HW6: Neural network simulation that performs a parity (odd/even) judgment on input units

lrate = 1;
input_units = 8;
hidden_units = 3;
output_units = 1;
num_patterns = 8;

%idk = rand_initial_weights(input_units,num_patterns);
patterns = round(rand_initial_weights(input_units, num_patterns) + 0.5);

% % 3. Determine the desired output for each pattern, 
% % which is 1 if the number of ones in the input is even and zero if the number is odd. 
desired_output = targetIs(patterns);

% 4.  Create two matrices for the weights that connect the input to hidden units (w_fg), 
% and hidden units to the output unit (w_gh).    
w_fg = rand_initial_weights(hidden_units, input_units);
w_gh = rand_initial_weights(output_units, hidden_units);

num_epochs = 1000;
epoch = 1;
SSE = 0;
SSE_vec = zeros(1, epoch); %help

while epoch <= num_epochs
    % For each input pattern 
    for i = 1 : num_patterns
        pattern = patterns(:, i);
        input_to_hidden = w_fg * pattern;
        hidden_activation = activation_fn(input_to_hidden);
        input_to_output = w_gh * hidden_activation;
        output_activation = activation_fn(input_to_output);
        output_error = desired_output - output_activation;

        singlepattern_dw_gh = 0;
        total_dw_gh = 0;

    % ∆ w_fg= η(diag(f^' (w_fg f)) w_gh^T (diag(e))f'(w_gh g)f^T
    % 				η : learning constant 
    % 			 	f': derivative of activation function
    % 				f : input
    % 				g : output activation
    % 				e : output error
    % 				T : transpose
    
        dw_fg = lrate * diag(f_i(input_to_hidden)) * w_gh' * (diag(output_error)) * f_i(input_to_output) * pattern';
        %NEED TO FIX THIS
        w_fg = w_fg + dw_fg;
        
%         dw_gh = HELP;
%         w_gh= w_gh + dw_gh;
    end

    if SSE <= 0.01
        break
    end

    %test if loop has run 
    if epoch >= 1000 
        if SSE > 0.01
            fprintf('Warning: SSE did NOT converge; re-running the model with a new set of random weights')
            %reset sets with random weights
            patterns = randInitializeWeights(input_units,num_patterns);
            epoch = 1;
        end
    end
 end


function weights = rand_initial_weights(rows, cols)
    weights = zeros(rows, cols);
    for i = 1 : rows
        for j = 1 : cols
            weights(i,j) = rand-0.5;
        end
    end
end

function [target] = targetIs(A)
    for j = 1 : size(A,2)
        count = 0;
        for i = 1 : size(A,1)
            if A(i,j) == 1
                count = count + 1;
            end
        end
        if mod(count,2) == 1
            target(1,j) = 0;
        else 
            target(1,j) = 1;
        end
    end
end

function f = activation_fn(x)
    f = 1./(1+exp(-x));
end

function g = f_i(A)
 %   g = 1./(1+exp(-x));
    g = (exp(-A) / square((1+exp(-A))));
end