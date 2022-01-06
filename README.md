PAV - P4: reconocimiento y verificación del locutor
===================================================

Obtenga su copia del repositorio de la práctica accediendo a [Práctica 4](https://github.com/albino-pav/P4)
y pulsando sobre el botón `Fork` situado en la esquina superior derecha. A continuación, siga las
instrucciones de la [Práctica 2](https://github.com/albino-pav/P2) para crear una rama con el apellido de
los integrantes del grupo de prácticas, dar de alta al resto de integrantes como colaboradores del proyecto
y crear la copias locales del repositorio.

También debe descomprimir, en el directorio `PAV/P4`, el fichero [db_8mu.tgz](https://atenea.upc.edu/pluginfile.php/3145524/mod_assign/introattachment/0/spk_8mu.tgz?forcedownload=1)
con la base de datos oral que se utilizará en la parte experimental de la práctica.

Como entrega deberá realizar un *pull request* con el contenido de su copia del repositorio. Recuerde
que los ficheros entregados deberán estar en condiciones de ser ejecutados con sólo ejecutar:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.sh
  make release
  run_spkid mfcc train test classerr verify verifyerr
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Recuerde que, además de los trabajos indicados en esta parte básica, también deberá realizar un proyecto
de ampliación, del cual deberá subir una memoria explicativa a Atenea y los ficheros correspondientes al
repositorio de la práctica.

A modo de memoria de la parte básica, complete, en este mismo documento y usando el formato *markdown*, los
ejercicios indicados.

## Ejercicios.

### SPTK, Sox y los scripts de extracción de características.

- Analice el script `wav2lp.sh` y explique la misión de los distintos comandos involucrados en el *pipeline*
  principal (`sox`, `$X2X`, `$FRAME`, `$WINDOW` y `$LPC`). Explique el significado de cada una de las 
  opciones empleadas y de sus valores.
  
  ![image](https://user-images.githubusercontent.com/91891272/147960946-55e1bb01-ab01-43e5-beb5-eccd086aecc1.png)
  
  `sox`: Es un comando para trabajar con archivos de audio. En este caso se utiliza para conervtir una señal 
         de audio WAVE a una señal de audio RAW, es decir, sin cabeceras. Se usa el '-t' para indicar el formato
         de salida, -e para el tipo de dato de codificación (signed) y -b para indicar el número de bits por cada 
         muestra(16 bits). 
         Es un comando con muchas otras opciones.
         
  `$X2X`: Es un programa de SPTK. Permite convertir datos de una entrada estandard a otro tipo de datos, dando el 
          resultado en una salida estándard. Con otras opciones se pueden cambiar los formatos de entrada y salida.
          En nuestro caso, con +sf, estamos convirtiendo la entrada short en float. 
          
  `$FRAME`: También es un programa de SPTK. Separa la señal de entrada en tramas de un formato y longitud determinados. 
            Con -l se especifica la longitud de la trama y con -p el período. Es decir, en este caso tenemos una trama de
            240 muestras con un período de 80 muestras.
            
  `$WINDOW`: También es un programa de SPTK. Su función es enventanar una secuencia de datos. Multiplica elemento a 
             elemento una longitud (-l) de la señal de entrada por una ventana específica, sacando el resultado
             en una salida estándard con una longitud determinada (-L).
             En este caso la longitud de la señal de entrada son 240 muestras y 240 muestras de la señal de salida. 
             La ventana aplicada es de Blackman, que es la que viene dada por defecto. 
             
  `$LPC`: También es un programa de SPTK. Calcula los coeficientes de predicción lineal(LPC) de los datos de entrada
          previamente enventanados, divididos en tramas y de longitud l, enviando el resultado a una salida
          estándard. 
          En este caso la longitud es 240 muestras y el orden del lpc (-m) es el que guardamos en la variable lpc_order.
          
          
- Explique el procedimiento seguido para obtener un fichero de formato *fmatrix* a partir de los ficheros de
  salida de SPTK (líneas 45 a 47 del script `wav2lp.sh`).
  
    ![image](https://user-images.githubusercontent.com/91891272/147961153-4a351f3b-2456-4093-826d-e1cb725aff0d.png)

    La línea 46 se corresponde con la obtención del número de columnas de la matriz, en este caso se corresponde
    con el orden del LPC + 1, débido a que el primer valor es la ganancia. 
    
    En la línea 47 obtenemos el número de filas de la matriz. Primero convertimos el archivo temporal de float a ASCII, 
    con 'wc -l' obtenemos el número de líneas del archivo en ASCII.
    Con perl se imprimen las líneas con el formato de fmatrix.    
    
  * ¿Por qué es conveniente usar este formato (u otro parecido)? Tenga en cuenta cuál es el formato de
    entrada y cuál es el de resultado.
    
    Es un formato conveniente porque permite la visualización de los datos de forma clara y ordenada. 
    Nos proporciona información sobre el número de tramas y coeficientes.
    También permite seleccionar los datos y guardar los que nos interesan, por ejemplo con la función
    fmatrix_show. 
    
- Escriba el *pipeline* principal usado para calcular los coeficientes cepstrales de predicción lineal
  (LPCC) en su fichero <code>scripts/wav2lpcc.sh</code>:
    
    ![image](https://user-images.githubusercontent.com/91891272/147963332-24f7984d-431d-45f3-b91f-fcbe977b5fcf.png)

- Escriba el *pipeline* principal usado para calcular los coeficientes cepstrales en escala Mel (MFCC) en su
  fichero <code>scripts/wav2mfcc.sh</code>:
    
    ![image](https://user-images.githubusercontent.com/91891272/147963445-88378a8a-d48c-41c6-8e8f-00f7317e1e23.png)


### Extracción de características.

- Inserte una imagen mostrando la dependencia entre los coeficientes 2 y 3 de las tres parametrizaciones
  para todas las señales de un locutor.
  
    ![image](https://user-images.githubusercontent.com/91891272/147968993-8af4f57a-a23c-4ab9-bd73-c843808142bf.png)

    ![image](https://user-images.githubusercontent.com/91891272/147969019-76afaba4-d166-4ba2-a340-1a08784f6a7f.png)

    ![image](https://user-images.githubusercontent.com/91891272/147970065-5d55c86d-8fa7-4551-b4f3-d7edf3d42ea1.png)


  + Indique **todas** las órdenes necesarias para obtener las gráficas a partir de las señales 
    parametrizadas.
    
    ![comando fmatrix_lp](https://user-images.githubusercontent.com/91891272/147964408-794b1adb-05cf-478b-8729-54e7d3622062.png)
    ![comando fmatrix_lpcc y mfcc](https://user-images.githubusercontent.com/91891272/147964438-3e098a9e-b83d-4b79-bad3-10af21076e6b.png)
    
    
  + ¿Cuál de ellas le parece que contiene más información?
    
    Observamos tres gráficas, la del LP hace una forma 'lineal', la del LPCC es dispersa y la del MFCC es aún más dispersa.
    La información es proporcional a la entropía lo cual nos hace pensar que la gráfica que contiene mayor información
    es la menos predictiva por tanto la que contiene mayor información es la gráfica del MFCC. 
    
- Usando el programa <code>pearson</code>, obtenga los coeficientes de correlación normalizada entre los
  parámetros 2 y 3 para un locutor, y rellene la tabla siguiente con los valores obtenidos.

  Para obtener los ficheros ejecutamos la siguiente orden:
  
  ![comando pearson](https://user-images.githubusercontent.com/91891272/147964522-3d88fd6d-ab68-48a1-87f7-0f5454f18b58.png)
  
  Para el LP obtenemos: 
  
  ![ro 2 3  lp(pearson)](https://user-images.githubusercontent.com/91891272/147963953-be75f104-9ca5-4a2c-810b-4082edbc7926.png)

  Para el LPCC obtenemos: 
  
  ![ro 2 3  lpcc(pearson)](https://user-images.githubusercontent.com/91891272/147963996-fed2355f-4655-4d94-a164-512d4be8c1a2.png)

  Para el MFCC obtenemos:
  
  ![ro 2 3  mfcc(pearson)](https://user-images.githubusercontent.com/91891272/147964030-c91a5c50-7a9c-4775-ac66-f12f117069a2.png)


  |                        | LP   | LPCC | MFCC |
  |------------------------|:----:|:----:|:----:|
  | &rho;<sub>x</sub>[2,3] |-0,87 | 0,18 |-0,22 |
  
  + Compare los resultados de <code>pearson</code> con los obtenidos gráficamente.
  
    Observamos que los coeficientes obtenidos por Pearson más incorrelados son el LPCC y el MFCC. 
    Esto se reafirma con las gráficas, pues vemos que las gráficas de estos coeficientes son más dispersas que la 
    del LP. 
    
    
- Según la teoría, ¿qué parámetros considera adecuados para el cálculo de los coeficientes LPCC y MFCC?

  Según la teoría para el LPCC se recomienda utilizar 13 coeficientes, al igual que para el MFCC. 
  Para el MFCC se suelen usar entre 24 y 40 filtros. 
### Entrenamiento y visualización de los GMM.

Complete el código necesario para entrenar modelos GMM.

- Inserte una gráfica que muestre la función de densidad de probabilidad modelada por el GMM de un locutor
  para sus dos primeros coeficientes de MFCC.
  
  Para el locutor 015:
  
  ![gmm mfcc 1](https://user-images.githubusercontent.com/91891272/148435949-547b2151-4bba-45fa-8ac3-ee210cbb052b.png)

- Inserte una gráfica que permita comparar los modelos y poblaciones de dos locutores distintos (la gŕafica
  de la página 20 del enunciado puede servirle de referencia del resultado deseado). Analice la capacidad
  del modelado GMM para diferenciar las señales de uno y otro.
  
  Primero observamos la gráfica del modelo del locutor 015 con el locutor 015:
  
  ![gmm mfcc 2](https://user-images.githubusercontent.com/91891272/148436140-afc08bfe-2de0-4060-a6d5-ac5b19e11d4f.png)
  
  Ahora vemos lo que sucede si cambiamos el locutor por el 000: 
  
  ![gmm mfcc 3(locutor ses000)](https://user-images.githubusercontent.com/91891272/148436335-8b38d1ab-d5e7-46bb-8737-411cf8e4e8e1.png)

  Para seguir comparando ahora vemos el modelo del 000 con el locutor 000: 
  
  ![gmm mfcc ses00 con el ses00](https://user-images.githubusercontent.com/91891272/148436469-034e2e8f-66a1-4b4a-9d61-3d06ba2e1054.png)

  Y finalmente el modelo del locutor 000 con el locutor 015: 
  
  ![gmm mfcc ses00 con el ses015](https://user-images.githubusercontent.com/91891272/148436566-b2f9c8c1-c1a4-46df-9f9d-19a40eaa3a63.png)

  Como vemos cuando tenemos un locutor diferente al modelo vemos que los puntos no siguen la misma norma de las gaussianas que se pueden ver. 
  En el caso del modelo 015 con el locutor 000 vemos que el centro de la segunda gaussiana esta más abajo que el del modelo y tiene más puntos 
  dispersos a la derecha que se salen de la gaussiana del modelo. 
  Cuando el modelo del 000 se corresponde con el locutor 000 vemos que los puntos estan bastante centrados dentro del modelo mientras que
  cuando cambiamos de locutor vemos que los puntos estan más desplazados y ergo menos centrados.
  

### Reconocimiento del locutor.

Complete el código necesario para realizar reconociminto del locutor y optimice sus parámetros.

- Inserte una tabla con la tasa de error obtenida en el reconocimiento de los locutores de la base de datos
  SPEECON usando su mejor sistema de reconocimiento para los parámetros LP, LPCC y MFCC.
  
  Para el LP:
  ![LP con VQ 67gauss 20 iteraciones](https://user-images.githubusercontent.com/91891272/148437791-63f2c9b0-3970-4ccd-944a-00bd05634183.png)
  
  Para el LPCC: 
  ![LPCC con VQ 67gauss 20 iteraciones](https://user-images.githubusercontent.com/91891272/148437881-e8d670de-bd78-4024-bde7-248133b2bd18.png)

  Para el MFCC: 
  ![image](https://user-images.githubusercontent.com/91891272/148438280-06adbb10-9e0b-49bc-933f-da84bc2fc761.png)

 
  |              | LP   | LPCC | MFCC |
  |--------------|:----:|:----:|:----:|
  | Tasa de error|8,92% |1,66% |1,40% |
  
  ![image](https://user-images.githubusercontent.com/91891272/148437974-f547cff6-bcb2-4373-abb5-4744b3b14dab.png)

  Para obtener estos valores hemos utilizado 20 iteraciones, 67 gaussianas, inicialización VQ y un umbral de 0,001.
  
### Verificación del locutor.

Complete el código necesario para realizar verificación del locutor y optimice sus parámetros.

- Inserte una tabla con el *score* obtenido con su mejor sistema de verificación del locutor en la tarea
  de verificación de SPEECON. La tabla debe incluir el umbral óptimo, el número de falsas alarmas y de
  pérdidas, y el score obtenido usando la parametrización que mejor resultado le hubiera dado en la tarea
  de reconocimiento.
 
  Debido a los resultados del apartado anterior, en este apartado utilizamos MFCC. 
  Utilizando 60 gaussianas, 20 iteraciones, inicialización VQ y un umbral de 0,001 obtenemos los siguientes resultados: 
  
  ![image](https://user-images.githubusercontent.com/91891272/148440427-c609c80b-88a4-4c55-ac99-649f6c3219dd.png)

  |              |        Umbral       | Perdidas | Falsas Alarmas | Coste |
  |--------------|:-------------------:|:--------:|:--------------:|:-----:|
  |     MFCC     | 0.0902300705533964  |  17/250  |     2/1000     |  8,6  |
  
  
### Test final

- Adjunte, en el repositorio de la práctica, los ficheros `class_test.log` y `verif_test.log` 
  correspondientes a la evaluación *ciega* final.

### Trabajo de ampliación.

- Recuerde enviar a Atenea un fichero en formato zip o tgz con la memoria (en formato PDF) con el trabajo 
  realizado como ampliación, así como los ficheros `class_ampl.log` y/o `verif_ampl.log`, obtenidos como 
  resultado del mismo.
