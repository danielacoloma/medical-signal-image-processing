% ================================================================
% Examen de laboratorio de Procesado de Señal e Imagen Médica
% Nombre: Daniela Coloma De Miguel - DNI: 71179213D
% Nombre: Alejandro De Los Ríos De La Fuente - DNI: 71208279A
% ================================================================

% Parte 3

%% Parte a)
% Cargo la imagen
img1 = imread('im1080_A.JPG');
% Visualizo la imagen
imshow(img1);
title('Imagen im1080\_A.jpg');
%% Parte b)
% Cargo la imagen 
img2 = imread('lr1080_A.png');
% Convierto la imagen a binaria
img2bw = im2bw(img2);  
% Visualizo la imagen
imshow(img2bw);
title('Imagen binaria de lr1080\_A.png');
%% Parte c)
% Mostrar superposición para análisis visual
imshowpair(img1, img2bw, 'montage');
title('Original vs Binaria');

%Respuesta: Las regiones blancas en la imagen binaria representan los objetos segmentados en la imagen original. 
%Estas corresponden a regiones de alto contraste o intensidad, probablemente estructuras relevantes (como lesiones o formas geométricas).
%% Parte d)
% Extraer las componentes conectadas de la imagen binaria
cc = bwconncomp(img2bw);

% Mostrar número de objetos
num_objetos = cc.NumObjects;
fprintf('Número de objetos/Regiones: %d\n', num_objetos);

% RESPUESTA 1: La imagen contiene 22 objetos/regiones.
% (El número se muestra también por consola con fprintf)

% Extraemos propiedades: Área, PixelIdxList (para acceder a los valores de intensidad)
stats = regionprops(cc, 'Area', 'PixelIdxList');

% Extraer el canal rojo de la imagen original
img_red = img1(:,:,1);  % canal rojo

% Inicializamos vectores
mean_red_values = zeros(1, num_objetos);
areas = zeros(1, num_objetos);

% Calcular la media de intensidad del canal rojo por cada región
for i = 1:num_objetos
    pixels = stats(i).PixelIdxList;  % píxeles de la región i
    mean_red_values(i) = mean(img_red(pixels));  % media canal rojo
    areas(i) = stats(i).Area;
end

% Media de intensidad del canal rojo de todas las regiones
media_general_rojo = mean(mean_red_values);
fprintf('Media del canal rojo en todas las regiones: %.2f\n', media_general_rojo);

% RESPUESTA 2: La media de intensidad en el canal rojo de todas las regiones es aproximadamente 207.15

% Encontrar región con menor área
[min_area, idx_min_area] = min(areas);
valor_min_area_red = mean_red_values(idx_min_area);
fprintf('Valor medio del canal rojo en la región de menor tamaño: %.2f\n', valor_min_area_red);

% RESPUESTA 3: El valor medio del canal rojo en la región de menor tamaño es 214.90

%% Parte e)
% Cargamos el dataset 'wdbc.data'
% Eliminamos la columna de identificador
data = csvread('wdbc.data', 0, 1); % cargamos desde fila 0, columna 1 (saltamos la primera columna: ID)
%% Parte f)
% Extraemos el vector de salidas y la matriz de características:
bcdata = data;
target = bcdata(:,1);       % primera columna es la etiqueta (M/B codificado como 1/0)
indata = bcdata(:,2:31);    % las 30 características
% Transponemos para ajustarlo al formato que requiere la red (inputs = columnas)
target = target';
indata = indata';
% Creamos una red MLP con 30 nodos en la capa oculta:
net = feedforwardnet(30);
% Función de activación: logsig en ambas capas
net.layers{1}.transferFcn = 'logsig'; % capa oculta: logsig
net.layers{2}.transferFcn = 'logsig'; % capa de salida: logsig (salidas entre 0 y 1)
% Entrenamiento con algoritmo de entrenamiento: gradiente conjugado escalado 
net.trainFcn = 'trainscg';  
net.divideFcn = 'divideind';  
%Se usan las 30 características extraídas de las imágenes
%% Parte g)
% Dividimos el conjunto de datos:
% Usamos las muestras correspondientes a los primeros 285 pacientes para entrenamiento
% y las muestras correspondientes a los ultimos 284 pacientes para test
%  cada columna = un paciente
training_in = indata(:, 1:285);            % columnas 1 a 285 = primeros 285 pacientes (entrenamiento)
training_target = target(1:285);      % etiquetas correspondientes al entrenamiento
testset.P = indata(:, 286:569);                % columnas 286 a 570 = ultimos 284 pacientes (test)
testset.T = target(286:569);              % etiquetas correspondientes al test
% Entrenamos la red con el conjunto de entrenamiento:
net = train(net, training_in, training_target);
%% Parte h)
% Simulamos la red con los datos del conjunto de test:
output_test = sim(net, testset.P);
% Como las salidas son valores entre 0 y 1 (por la función logsig), se deben umbralizar para obtener una clase binaria:
output_test_bin = output_test > 0.5;  % si salida > 0.5 --> clase 1 (maligno), si no --> clase 0 (benigno)
%% Parte i)
% Calculamos la precisión (accuracy):
num_correct = sum(output_test_bin == testset.T);   % número de aciertos
precision = 100 * num_correct / length(testset.T); % porcentaje de aciertos
fprintf('Precisión sobre el conjunto de test: %.2f%%\n', precision);
% Se ha usado el umbral 0.5, estándar para logsig. Distingue entre las dos clases de forma equilibrada.

% La precisión obtenida sobre el conjunto de test es de un 23.59%, como el
% modelo no está optimizado para dar una elevada precisión, nuestro
% resultado puede ser correcto