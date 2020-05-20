% HW 4 -- replicating 4.26 - 4.29
%  main_program:
%     initialize_parameters;
%     initialize_state_vector;
%     make_inhibitory_weights;
%     compute_inhibited_state_vector;
%     READLN
%  end

% For the simulations of Winner-Take-All (WTA) networks, the self-inhibition
% can be turned off by setting the self inhibition term in each unit 
% to zero.  This is done by zeroing element [I] in the vector 
% Inhibitory_weights[I] where I runs from 1 to Dimensionality,
% that is, Inhibitory_weights [I][I]:= 0.  
% For a good WTA network, both the space constant and the maximum value 
% of the inhibition should be large. 

% Global Declarations
global dim half_dim num_iter epsilon max_strength length_constant upper_limit lower_limit
global inhibitory_weights initial_state_vector state_vector
global winner_take_all

dim = 80;
half_dim = 40;
num_iter = 50;

length_constant = 10; % length constant of inhibition
epsilon = .1;        % computational constant
max_strength = 2.0;   % maximum value of inhibition

max_strength = abs(max_strength); % assures inhibition
upper_limit = 60; % maximum firing rate of model neuron
lower_limit = 0; % minimum firing rate of model neuron

inhibitory_weights = zeros(dim);
initial_state_vector = zeros(1, dim);
state_vector = zeros(1, dim);

winner_take_all = true;

initial_state_vector = initialize_state_vector(dim);
make_inhibitory_weights();
compute_inhibited_state_vector();

% display code %
figure;
plot(initial_state_vector,1:dim,'+k','displayname','Initial'); hold on;
plot(state_vector,1:dim,'*k', 'displayname', 'Comparison');
xlabel('Neurons');
ylabel('Firing rate');
xlim([0 50]);
ylim([0 50]);
legend('show');

function initial_state_vector = initialize_state_vector(dim)
    global initial_state_vector dim winner_take_all
    i = 1;
    for i = i : 20
        initial_state_vector(i) = 10;
    end
    for i = 21 : 60
        initial_state_vector(i) = 40;
    end
    for i = 61 : dim
        initial_state_vector(i) = 10;
    end
    
    if (winner_take_all == true)
        initial_state_vector = ones(1, dim) * 10;
        
        % UNCOMMENT FOR PROBLEM 27
        for i = 17 : 20
            initial_state_vector(i) = initial_state_vector(i - 1) + 10;
        end
        for i = 21 : 24
            initial_state_vector(i) = initial_state_vector(i - 1) - 10;
        end

        % UNCOMMENT FOR PROBLEM 28/29
%         initial_state_vector(1,14:23) = [20 30 20 10 10 20 30 40 30 20];

    end
            
end

function make_inhibitory_weights()
    global dim inhibitory_weights winner_take_all
    make_first_vector();
    shift_elements_right();
    
    %zeroing element [I] in the vector Inhibitory_weights[I] where I runs from 1 to Dimensionality,
    % that is, Inhibitory_weights [I][I]:= 0
    if (winner_take_all == true)
        for i = 1 : dim
            for j = 1 : dim
                if i == j
                    inhibitory_weights(i, j) = 0;
                end
            end
        end 
    end
end

function make_first_vector()
    global dim half_dim max_strength length_constant inhibitory_weights
    for i = 1 : (half_dim)
        inhibitory_weights(1,i) = -(max_strength)*exp(-(i-1)/length_constant);
    end
    for i = (half_dim + 1) : dim
        inhibitory_weights(1,i) = -(max_strength)*exp(-((dim+1)-i)/length_constant);
    end
end

function shift_elements_right()
    global dim inhibitory_weights
    for i = 1 : (dim - 1)
        for j = 1 : (dim - 1)
            inhibitory_weights(i+1, j+1) = inhibitory_weights(i, j);
            inhibitory_weights(i+1, 1) = inhibitory_weights(i, dim);
        end
    end
end

function compute_inhibited_state_vector()
    global dim num_iter epsilon initial_state_vector inhibitory_weights state_vector
    new_state_vector = zeros(1, dim);
    state_vector = initial_state_vector;

    for i = 1 : num_iter
        for j = 1 : dim
            % add a small amount of delta_v to state_v
            err = initial_state_vector(j) + dot(inhibitory_weights(j,:), state_vector) - state_vector(j);
            new_state_vector(j) = state_vector(j) + epsilon * err;
        end
        
        new_state_vector = limit_state_vector(new_state_vector);
        
        if i == num_iter
            convergence_test(state_vector, new_state_vector); 
        end   
        
        state_vector = new_state_vector;
    end
end


function new_state_vector = limit_state_vector(n_state_vector)
    new_state_vector = n_state_vector;
    global dim upper_limit lower_limit
    for i = 1 : dim
        if new_state_vector(i) > upper_limit
            new_state_vector(i) = upper_limit;
        end
        if new_state_vector(i) < lower_limit
            new_state_vector(i) = lower_limit;
        end
    end
end

function convergence_test(state_vector, new_state_vector)
    s_v_length = norm(state_vector);
    new_s_v_length = norm(new_state_vector);
    dif = abs(s_v_length - new_s_v_length);
end


