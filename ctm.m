function val = ctm(x)
    % Medida de la tendencia central (CTM)
    % Devuelve una medida de la concentración del diagrama de fase
    d = diff(x);
    d1 = d(1:end-1);
    d2 = d(2:end);
    dist = sqrt(d1.^2 + d2.^2);
    r = 0.1 * max(dist);
    val = sum(dist < r) / length(dist);
end
