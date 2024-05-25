# Reporte de Análisis y Reflexión
Diego Ortega Fernández -A01028535

24/05/2024

## Reflexión sobre la Solución y Algoritmos Implementados

La solución presentada consiste en un lexer implementado en el lenguaje de programación "Elixir", cuyo objetivo es analizar archivos de código fuente y convertirlos en documentos HTML con resaltado de sintaxis. El lexer nos ayuda a identificar las diferentes categorías léxicas como comentarios, palabras reservadas, cadenas de caracteres, operadores, etc, esto gracias a las expresiones regulares.

### Algoritmos Implementados

1. **Lectura del Archivo**: El archivo fuente se lee por completo.
2. **Tokenización**: Dividimos el archivo en líneas y cada línea es tokenizada por separado utilizando una serie de funciones especializadas para cada tipo de token.
3. **Generación de HTML**: Los tokens identificados se transforman en etiquetas HTML `<span>` con clases específicas para cada tipo de token.
4. **Escritura del Archivo HTML**: El contenido HTML se guarda en un nuevo archivo con el mismo nombre que el archivo fuente, pero con extensión `.html`.

### Complejidad y Tiempo de Ejecución

La complejidad del algoritmo de tokenización puede analizarse considerando el número de líneas en el archivo (`n`) y el número de tipos de tokens (`m`). Para cada línea, se aplican `m` expresiones regulares, por lo que la complejidad general es `O(n * m)`. Aquí, `m` es constante ya que depende del número de categorías léxicas definidas. (Sincereamente me ayudé de chat porque no sabía como sacarla :).

Si cada expresión regular que usamos para identificar tokens en una línea de código se ejecuta de manera relativamente rápida, entonces el tiempo total que lleva procesar un archivo completo va a ser afectado directamente por el tamaño del archivo. Es decir, si tenemos un archivo más grande con más líneas o líneas más largas, tomará más tiempo procesarlo en comparación con archivos más pequeños.

Ya viendo los tiempos de ejecución en las pruebas, el rendimiento es bueno para archivos de tamaño "normal". Pero, con archivos muy grandes, el tiempo necesario para procesarlos puede ser mucho mayor. Lo cual claramente significa que podríamos utilizar métodos más eficientes y para mejorar el rendimiento de nuestro código o incluso distribuir el trabajo en varios procesos para acelerar el proceso de tokenización.

## Implicaciones Éticas

1. **Privacidad y Seguridad**: Cuando analizamos y procesamos código, podemos estar trabajando con información importante. Así que es importante estár seguros de que estamos manejando esos datos de la forma más segura posible y de que estamos respetamos las políticas de privacidad.


   
2. **Acceso**: Estas herramientas de análisis de código pueden ayduarnos a hacer más fácil el aprendizaje y mejorar la productividad de los desarrolladores. Estas herramientas son accesibles para todas las personas, por lo que promueve la igualdad de oportunidades en el ámbito de la tecnología.

3. **Calidad del Software**: Automatizar partes de los procesos de desarrollo puede llevarnos a mejorar la calidad del software. Sin embargo, es de suma importancia que nosotros, como desarrolladores mantengamos la responsabilidad sobre los códigos y así no generemos una dependencia excesiva de las herramientas.

La creación de un lexer en Elixir para transformar código fuente en HTML muestra un método efectivo para el análisis léxico. A pesar de eso, es muy importante no dejar de lado las implicaciones éticas al momento de desarrollar y aplicar estas tecnologías y herramientas. Esto incluye la seguridad de los datos, asegurarnos que todos puedan utilizar estas herramientas y fomentar la responsabilidad en el desarrollo de software.
