function MSE = mse(x, m, r, scale)
    % Entropía multiescala (MSE)
    MSE = zeros(1, scale);
    for s = 1:scale
        y = mean(reshape(x(1:s*floor(length(x)/s)), s, []), 1); % coarse-graining
        MSE(s) = sampen(y, m, r, 'chebychev');
    end
end
