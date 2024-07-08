Máquina Expendedora de Refrescos en VHDL
Este repositorio contiene el código VHDL para la implementación de una máquina expendedora de refrescos en Vivado. La máquina expendedora está diseñada para aceptar monedas de 10c, 20c, 50c y 1€, y solo permite el pago del importe exacto para adquirir un refresco.

Funcionalidades
1. Entradas
Monedas: La máquina expendedora cuenta con entradas para las monedas disponibles: 10c, 20c, 50c y 1€. Estas entradas indican la cantidad de cada tipo de moneda que se ha introducido.

Producto: Entradas que indican la selección de producto. Pueden ser configuradas para diferentes opciones de refrescos.

2. Salidas
Error: Una señal de error se activa si se introduce un importe mayor al necesario o si se produce algún otro problema durante la operación. La máquina "devolverá" todas las monedas en caso de error.

Producto: Cuando se alcanza el importe exacto del refresco (1€), se activa una señal para dispensar el producto.

3. Estructura del Repositorio
src/: Contiene el código VHDL de la máquina expendedora.

sim/: Incluye archivos relacionados con la simulación.

doc/: Documentación relacionada con el diseño y funcionamiento de la máquina expendedora.