% HW 4 -- replicating 4.19 - 4.23
%  main_program:
%     initialize_parameters;
%     initialize_state_vector;
%     make_inhibitory_weights;
%     compute_inhibited_state_vector;
%     READLN
%  end

% Global Declarations
global dim half_dim num_iter epsilon max_strength length_constant upper_limit lower_limit
global inhibitory_weights initial_state_vector state_vector

dim = 80;
half_dim = 40;
num_iter = 50;

length_constant = 2; % length constant of inhibition
epsilon = .1;        % computational constant
max_strength = 1.0;   % maximum value of inhibition

max_strength = abs(max_strength); % assures inhibition
upper_limit = 60; % maximum firing rate of model neuron
lower_limit = 0; % minimum firing rate of model neuron

inhibitory_weights = zeros(dim);
initial_state_vector = zeros(1, dim);
state_vector = zeros(1, dim);

initial_state_vector = initialize_state_vector(dim);
make_inhibitory_weights();
compute_inhibited_state_vector();

% display code %
figure;
plot(initial_state_vector,1:dim,'+k','displayname','Initial'); hold on;
plot(state_vector,1:dim,'*k', 'displayname', 'Comparison');
xlabel('Neurons');
ylabel('Firing rate');
xlim([0 100]);
ylim([50 100]);
legend('show');

function initial_state_vector = initialize_state_vector(dim)
    global initial_state_vector
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
    
end

function make_inhibitory_weights()
    make_first_vector();
    shift_elements_right();
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



