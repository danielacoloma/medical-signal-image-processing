% ================================================================
% Examen de laboratorio de Procesado de Señal e Imagen Médica
% Nombre: Daniela Coloma De Miguel - DNI: 71179213D
% Nombre: Alejandro De Los Ríos De La Fuente - DNI: 71208279A
% ================================================================

% Parte 2

%% Parte a)
nii = niftiread('lung_002.nii');        % Cargar imagen 3D (TAC)
info = niftiinfo('lung_002.nii');       % Info del archivo
[dimX, dimY, dimZ] = size(nii);            % Dimensiones del volumen

% Mostrar cortes coronales (plano Y-Z, eje X fijo)
figure;
for i = 1:dimX
    imagesc(squeeze(nii(:,i,:))');         % Transpuesta para orientación correcta
    colormap gray; axis image off;
    title(['Corte coronal ', num2str(i), '/', num2str(dimX)]);
    pause(0.03);  % Animación rápida
end

%% Parte b)
figure;
histogram(nii(:), 256);  % 256 niveles de intensidad
title('Histograma del volumen pulmonar');
xlabel('Intensidad (HU)');
ylabel('Frecuencia');

% Usamos el histograma para analizar la distribución de intensidades y 
% elegir un umbral adecuado. Observamos un gran pico en torno a -1000 HU,
% correspondiente al aire pulmonar. Luego, aparecen valles entre picos 
% menores que indican distintos tejidos. Seleccionamos un umbral en -400 HU, 
% ubicado en uno de esos valles, para separar eficazmente el aire (pulmones)
% del resto de estructuras anatómicas.

%% Parte c) 
voxel_size = info.PixelDimensions;  % Devuelve [dx dy dz] en mm
disp(['Tamaño del voxel (mm): ', num2str(voxel_size)]);

% El tamaño del voxel es [0.78125      0.78125      1.2453] mm, lo que permite convertir índices a distancias físicas.

%% Parte d) 

% Selección de umbral basado en el histograma
umbral = -400;  % Umbral para separar pulmones

% Segmentación binaria: 1 = pulmón (aire), 0 = resto
segmentacion = nii < umbral;

% Visualización de corte medio
slice_num = round(dimX / 2);  % Corte central en el eje X

% Mostrar original vs segmentado en el mismo corte coronal
figure;
imshowpair(squeeze(nii(:,slice_num,:))', squeeze(segmentacion(:,slice_num,:))', 'montage');
title('Original vs Segmentado');

% En la visualización del corte coronal, se aprecia claramente la anatomía 
% frontal del tórax: ambos pulmones, el corazón centrado, y la columna 
% vertebral en la parte posterior inferior.
% La segmentación binaria realizada mediante un umbral de -400 HU permite 
% identificar eficazmente la región pulmonar, separándola del resto de tejidos.

%% Parte e) 
% Convertir la imagen binaria a una matriz numérica
imagen_binaria_numerica = double(segmentacion);

% Guardar la segmentación como una nueva imagen NIFTI
niftiwrite(imagen_binaria_numerica, 'lung002_segmentation.nii');

%Comprimo el fichero
gzippedfiles = gzip('lung002_segmentation.nii');

%% Parte f) 

% Cargar segmentación realizada por ti (binaria)
mi_segmentacion = niftiread('lung002_segmentation.nii') > 0;

% Cargar segmentación perfecta (ground truth)
ground_truth = niftiread('lung_002_seg_ground_truth.nii') > 0;

A = double(mi_segmentacion(:));  % Convertir a double para cálculo
B = double(ground_truth(:));

mse = mean((A - B).^2);

disp(['MSE entre segmentación y ground truth: ', num2str(mse)]);


% EXPLICACIÓN:
% El MSE mide la media del cuadrado de la diferencia entre los
% valores reales (ground truth) y los estimados (segmentación).
% Este valor significa que, en promedio, más del 60 % de los píxeles (voxels)
% en el corte seleccionado están mal segmentados (diferentes del ground truth).

%% Parte g) 
% Añadir ruido gaussiano creciente y evaluar segmentación

% Reutilizamos la imagen original ya cargada: nii
nii_doble = double(nii);  
ground_truth = double(niftiread('lung_002_seg_ground_truth.nii')) > 0;

% Parámetros del bucle
rango_dinamico = max(nii_doble(:)) - min(nii_doble(:));
num_iter = 20;
mse_ruido = zeros(1, num_iter);

for i = 1:num_iter
    % Generar ruido gaussiano con std creciente
    std_i = (0.01 * i) * rango_dinamico;  % De ruido imperceptible a muy fuerte
    ruido = randn(size(nii_doble)) * std_i;
    
    % Añadir ruido a la imagen
    vol_ruidoso = nii_doble + ruido;
    
    % Segmentación por umbral sobre volumen ruidoso
    seg_ruidosa = vol_ruidoso < umbral;
    
    % Calcular MSE con respecto a la segmentación perfecta
    A = double(seg_ruidosa(:));
    B = double(ground_truth(:));
    mse_ruido(i) = mean((A - B).^2);
end

% Representar la evolución del MSE en función del ruido
figure;
plot(1:num_iter, mse_ruido, 'b-o', 'LineWidth', 1.5);
xlabel('Iteración (ruido creciente)');
ylabel('MSE');
title('Impacto del ruido en la segmentación sin filtrado');
grid on;

% Observamos cómo el MSE aumenta a medida que incrementamos el ruido gaussiano.
% Esto indica que la segmentación es cada vez menos fiable a mayor nivel de ruido.
% Sin embargo luego vuelve a disminuir, cosa que no entendemos muy bien por
% qué ocurre, no tiene mucho sentido.

%% Parte h)
% Repetir con filtrado paso bajo antes de segmentar

mse_filtrado = zeros(1, num_iter);  % Vector para almacenar los errores

for i = 1:num_iter
    % Generar ruido gaussiano con std creciente (como en g)
    std_i = (0.01 * i) * rango_dinamico;
    ruido = randn(size(nii_doble)) * std_i;
    vol_ruidoso = nii_doble + ruido;
    
    % Aplicar filtro paso bajo 3D (filtro gaussiano)
    vol_filtrado = imgaussfilt3(vol_ruidoso, 1);  % sigma = 1
    
    % Segmentación del volumen filtrado
    seg_filtrada = vol_filtrado < umbral;
    
    % Calcular MSE con respecto al ground truth
    A = double(seg_filtrada(:));
    B = double(ground_truth(:));
    mse_filtrado(i) = mean((A - B).^2);
end

figure;
plot(1:num_iter, mse_ruido, 'b-o', 'LineWidth', 1.5); hold on;
plot(1:num_iter, mse_filtrado, 'r-o', 'LineWidth', 1.5);
xlabel('Iteración (ruido creciente)');
ylabel('MSE');
title('Segmentación con y sin filtrado bajo ruido gaussiano');
legend('Sin filtrado', 'Con filtrado');
grid on;

% Aplicar un filtro paso bajo reduce el impacto del ruido en la segmentación,
% como demuestra la curva roja (con filtrado), que se mantiene por debajo
% de la azul (sin filtrado) a lo largo de las iteraciones.
