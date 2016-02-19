function samples = simpleMCMC(N, d)
    
    samples = zeros(N, d);
    prev_X = [1, 10];
    for i=0:N-1
       u = rand(1);
       X_sample = samplePosterior(prev_X, d);
       if(u < checkRatio(X_sample, prev_X))
           samples(i+1,:) = X_sample;
           prev_X = X_sample;
       else
           samples(i+1, :) = prev_X;
       end
    end
end

function sample = samplePosterior(prev_mean, d)
    sample = mvnrnd(prev_mean, 2*eye(d), 1);
end


function check = checkRatio(prev, new)
    ratio =  likelihood(prev)/likelihood(new)
    if ratio < 1
        check = ratio;
    else
        check = 1;
    end
    check
end

function val = likelihood(X)
    %Assuming ground is at mean=[0, 10, 0, 12, 50, 100]
    mean = [20, 10]; %, 12, 50, 100];
    dist = mean-X;
    dist = dist*dist'
    val = exp(-dist/(2*10));
end