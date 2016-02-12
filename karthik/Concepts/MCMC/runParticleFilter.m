function [Imp, MC] = runParticleFilter(M, N, it, d)
    observations = rand(M, d);
    particles = rand(N, d);
    resultImp = zeros(M, 2);
    resultMC = zeros(M, 2);
    %Choose an observation
    obs = observations(1, :);
    
    bestDistImp = particlefilterMCMC(observations(1, :), particles, N, d, it, 0);
    bestDistMC = particlefilterMCMC(observations(1, :), particles, N, d, it, 1);
    Imp = bestDistImp;
    MC  = bestDistMC;

end