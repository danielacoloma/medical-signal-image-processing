% ================================================================
% Examen de laboratorio de Procesado de Señal e Imagen Médica
% Nombre: Daniela Coloma De Miguel - DNI: 71179213D
% Nombre: Alejandro De Los Ríos De La Fuente - DNI: 71208279A
% ================================================================

% Parte 1

%% Parte b)

% Parámetros generales
fs = 200;             
nfft = 512;         
segmento = 10;        
canal_T3 = 16;         % Canal T3 = columna 16 de la matriz

% Cargar señal ORIGINAL
load('Signal_EEG_L1.mat'); 

% Extraer 10 segundos del canal T3
x_orig = matriz_sujeto(1:fs*segmento, canal_T3)';  

% Bicoherencia y Biespectro
[bic_orig, w2_o] = bicoher(x_orig, nfft, 256, 256);
[bspec_orig, w1_o] = bispecd(x_orig, nfft, 5, 256);
f1_o = w1_o * fs;

% Visualización del Biespectro (0–20 Hz)
figure;
imagesc(f1_o, f1_o, abs(bspec_orig));
set(gcf, 'Name','Biespectro EEG original (0-20Hz)', 'Color',[1 1 1]);
xlabel('f1 (Hz)'); ylabel('f2 (Hz)'); colorbar;
title('Biespectro EEG Original (T3)');
xlim([0 20]); ylim([0 20]);

% Cargar señal LIMPIA
load('Signal_EEG_clean_L1.mat');  % contiene matriz_sujeto (ya canal T3)

% Usamos directamente la señal del canal T3 (vector fila)
x_clean = matriz_sujeto;
x_clean = x_clean(1:fs*segmento);  % limitar a 10 segundos por seguridad

% Bicoherencia y Biespectro
[bic_clean, w2_c] = bicoher(x_clean, nfft, 256, 256);
[bspec_clean, w1_c] = bispecd(x_clean, nfft, 5, 256);
f1_c = w1_c * fs;

% Visualización del Biespectro (0–20 Hz)
figure;
imagesc(f1_c, f1_c, abs(bspec_clean));
set(gcf, 'Name','Biespectro EEG limpia (0-20Hz)', 'Color',[1 1 1]);
xlabel('f1 (Hz)'); ylabel('f2 (Hz)'); colorbar;
title('Biespectro EEG Limpia (T3)');
xlim([0 20]); ylim([0 20]);

% ANÁLISIS COMPARATIVO
% En la señal original del canal T3 se observa un fuerte acoplamiento de fase
% entre frecuencias bajas (0–2 Hz), reflejado en un pico pronunciado del biespectro. 
% Esto sugiere la presencia de artefactos, típicamente oculares o de movimiento.
% En cambio, la señal limpia muestra una drástica reducción de esta actividad no
% fisiológica, con un biespectro más atenuado y uniforme, indicando que el 
% preprocesamiento ha sido efectivo eliminando componentes espurios sin afectar 
% significativamente las componentes cerebrales útiles.

%% Parte c)

% Cargar señales
load('Signal_EEG_clean_L1.mat');
load('Artifact_EEG_L1.mat');
load('Signal_EEG_L1.mat');

EEG_original = matriz_sujeto;
EEG_clean = matriz_sujeto;
EEG_art = matriz_sujeto;

% Parámetros
fs = 200;                   
duracion = 10;             
segmento = 10;   % 10 segundos = 2000 muestras
canal_T3 = 16;              
m = 3;                      % Dimensión del atractor
tau = 20;                   % Retardo temporal

% Extraer canal T3 (columna 16, sobre 2000 muestras)
x_clean = EEG_clean(segmento, canal_T3);
x_art = EEG_art(segmento, canal_T3);

% Reconstrucción del atractor (embedding en 3D)
reconstruir_atractor = @(x, m, tau) ...
    [x(1:end-2*tau), x(1+tau:end-tau), x(1+2*tau:end)];

atractor_clean = reconstruir_atractor(x_clean, m, tau);
atractor_art = reconstruir_atractor(x_art, m, tau);

% Visualizo los atractores
figure;
plot3(atractor_clean(:,1), atractor_clean(:,2), atractor_clean(:,3), 'b'); hold on;
plot3(atractor_art(:,1), atractor_art(:,2), atractor_art(:,3), 'r');
xlabel('x(t)'); ylabel('x(t + \tau)'); zlabel('x(t + 2\tau)');
legend('Señal limpia', 'Señal con artefactos');
title('Atractores tridimensionales del canal T3');
grid on;

% ANÁLISIS

% Analisis del atractor: En la figura generada, únicamente se visualiza el 
% atractor correspondiente a la señal con artefactos (en rojo), mientras que 
% el atractor de la señal limpia (en azul) no aparece representado.

% Esto sugiere que puede haberse producido un error en la carga o asignación 
% de las señales, de forma que la variable correspondiente a la señal limpia
% esté vacía, constante, o mal definida (por ejemplo, igual a la señal con
% artefactos). También es posible que los valores de la señal limpia estén 
% demasiado concentrados o cercanos a cero, lo cual hace que no se visualicen
% correctamente en la escala del gráfico.

% Optimización del retardo τ: Se puede usar el primer mínimo de la información 
% mutua o el primer cruce por cero de la autocorrelación. Esto ayuda a que 
% las coordenadas reconstruidas sean lo más independientes posibles.
