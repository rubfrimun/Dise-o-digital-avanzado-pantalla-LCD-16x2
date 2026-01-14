# Diseño digital avanzado de FPGA con pantalla LCD 16x2
Este proyecto implementa un controlador completo para una pantalla LCD de 16x2 caracteres basado en el estándar Hitachi HD44780, diseñado en VHDL sintetizable. El sistema fue desarrollado para una placa de desarrollo FPGA (Nexys 4) operando a 100 MHz.

Características principales:
- Diseño Síncrono: Uso de una Máquina de Estados Finitos (FSM) para gestionar la secuencia de inicialización y escritura, respetando estrictamente los tiempos de setup y hold del datasheet del LCD.
- Gestión de Tiempos: Implementación de un generador de señal de habilitación (thresh) de 1 µs para manejar los retardos precisos (39 µs para comandos, 1.52 ms para borrado).

Dos Iteraciones de Diseño:
- LCD1: Visualización estática de texto en dos filas (Nombre y Apellido).
- LCD2: Sistema interactivo que permite conmutar entre diferentes mensajes y borrar la pantalla mediante pulsadores externos, gestionando la escritura en la memoria DDRAM en tiempo real.
