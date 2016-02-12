function [Imp, MC] = runParticleFilterIterations(M, N, it, d)
    observations = rand(M, d);
    particles = rand(N, d);
    resultImp = zeros(M, 2);
    resultMC = zeros(M, 2);
    %Choose an observation
    obs = observations(1, :);
    
    %bestDistImp = zeros(1, N);
    %bestDistMC = zeros(1, N);
    IT = [100, 200, 400, 800, 1500, 2000, 2500, 3500, 5000];
    fig = figure;
    for i=1:9
        it = IT(1, i);
        bestDistImp = particlefilterMCMC(observations(1, :), particles, N, d, it, 0);
        bestDistMC = particlefilterMCMC(observations(1, :), particles, N, d, it, 1);

        Imp = bestDistImp;
        MC  = bestDistMC;
        subplot(3, 3, i);
        X=1:it
        plot(X, Imp, X, MC);

    end
    print(fig, 'Iterationplot','-dpng')
end