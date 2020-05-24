% HW6: Neural network simulation that performs a parity (odd/even) judgment on input units

lrate = 1;
input_units = 8;
hidden_units = 3;
output_units = 1;
num_patterns = 8;

patterns = round(rand_initial_weights(input_units, num_patterns) + 0.5);

desired_output = targetIs(patterns);

w_fg = rand_initial_weights(hidden_units, input_units);
w_gh = rand_initial_weights(output_units, hidden_units);

num_epochs = 1000;
epoch = 1;
SSE = 0;
SSE_vec = zeros(1, num_epochs); 

while epoch <= num_epochs
    for i = 1 : num_patterns
        pattern = patterns(:, i);
        input_to_hidden = w_fg * pattern;
        hidden_activation = activation_fn(input_to_hidden);
        input_to_output = w_gh * hidden_activation;
        output_activation = activation_fn(input_to_output);
        output_error = desired_output(i) - output_activation;
        
        dw_fg = lrate * diag(hidden_activation.* (1 - hidden_activation)) * w_gh' * output_error * (output_activation.* (1-output_activation)) * (pattern)';   
        w_fg = w_fg + dw_fg;
       
        dw_gh = lrate * diag(output_activation .* (1 - output_activation)) * (output_error) * hidden_activation';  
        w_gh = w_gh + dw_gh;
    end
    
    input_to_hidden = w_fg * patterns;
    hidden_activation = activation_fn(input_to_hidden);
    input_to_output = w_gh * hidden_activation;
    output_activation = activation_fn(input_to_output);
    output_error = desired_output - output_activation;
    SSE = trace(output_error'*output_error);
    SSE_vec(1,epoch) = SSE; 
   
  
    if mod(epoch, 10) == 0
        fprintf("Epoch #: %d", epoch)
        fprintf("\tSSE value: %d\n", SSE)
    end
 
    if SSE <= 0.01
        break
    end

    if epoch >= 1000 
        if SSE > 0.01
            disp('Warning: SSE did NOT converge; re-running the model with a new set of random weights')
            %reset sets with random weights
            input = rand_initial_weights(input_units,num_patterns);
            epoch = 1; 
            clearvars SSE_vec
            SSE_vec = zeros(1,num_epochs);
        end
    end
    
    epoch = epoch + 1;
end
 
%Display 1
%figure 1
plot(SSE_vec);
%figure 2
figure
subplot(1,2,1);
imagesc(desired_output); 
subplot(1,2,2);
imagesc(output_activation);


% Test the model’s generalization abilities by creating a new set of patterns
total_correct = 0;
total_answers = 0;
num_tests = 100000;
vector_test = zeros(1, num_tests);
    for t = 1 : num_tests
        correct = 0;
        test = round(rand_initial_weights(input_units, num_patterns) + 0.5);
        input_to_hidden = w_fg * test; 
        hidden_activation = activation_fn(input_to_hidden); 
        input_to_output = w_gh * hidden_activation; 
        output_activation = activation_fn(input_to_output); 
        output_error = desired_output - output_activation;

        for i = 1 : num_patterns
            if abs(output_error(i)) <= 0.5
                total_correct = total_correct + 1;
                correct = correct + 1;
            end
        end
        total_answers = total_answers + num_patterns;
        vector_test(1,t) = correct / num_patterns;
    end
    
%Display 2
figure
histogram(vector_test)
accuracy = total_correct / total_answers;


%%FUNCTIONS%%
function weights = rand_initial_weights(rows, cols)
    weights = zeros(rows, cols);
    for i = 1 : rows
        for j = 1 : cols
            weights(i,j) = rand-0.5;
        end
    end
end

function target = targetIs(A)
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
