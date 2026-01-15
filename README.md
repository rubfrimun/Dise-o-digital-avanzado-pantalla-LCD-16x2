# 📟 Controlador de Display LCD 16x2 en VHDL (FPGA)

![Language](https://img.shields.io/badge/Language-VHDL-blue)
![Platform](https://img.shields.io/badge/Platform-Xilinx%20FPGA-red)
![Tool](https://img.shields.io/badge/Tool-Vivado-green)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

> **Nota:** Este proyecto implementa un controlador completo para visualizadores LCD basados en el controlador Hitachi HD44780, diseñado bajo restricciones estrictas de temporización y síntesis.

---

## Hardware

![Foto del Proyecto](nexys-4-0.png)
*(Nexys 4 Artix-7 FPGA Trainer Board)*

---

## 📝 Descripción del Proyecto

Este repositorio contiene el diseño, simulación e implementación de un controlador para pantallas LCD de 16x2 caracteres, desarrollado en **VHDL** para la placa de desarrollo **Digilent Nexys 4 (Artix-7)**.

El objetivo principal fue crear un diseño síncrono capaz de manejar los complejos requisitos de temporización del LCD (tiempos de espera en microsegundos y milisegundos) operando con un reloj de sistema de **100 MHz**.

### Módulos del Proyecto

El repositorio incluye dos iteraciones del diseño:

1.  **LCD1 (Estático):**
    *   Implementa la secuencia de inicialización completa.
    *   Escribe de forma automática el nombre (Fila 1) y apellidos (Fila 2) del autor.
    *   Basado en una Carta ASM lineal.

2.  **LCD2 (Interactivo):**
    *   Amplía el diseño anterior añadiendo interactividad.
    *   **Entradas:**
        *   `m1`: Muestra Nombre y Apellido.
        *   `m2`: Muestra un mensaje personalizado alternativo.
        *   `cl`: Borra la pantalla (Comando Clear Display).
    *   Gestión de memoria DDRAM dinámica.

---

## ⚙️ Arquitectura y Diseño

El núcleo del controlador es una **Máquina de Estados Finitos (FSM)** que gestiona el bus de datos de 8 bits y las señales de control (`RS`, `RW`, `E`).

### Estrategia de Temporización
Dado que el reloj de la FPGA es de 10ns y el LCD requiere esperas lentas (ej. 1.52 ms para borrado), se implementó una señal de habilitación (`thresh`) que genera un pulso cada **1 µs**. Esto permite un control preciso de los tiempos de espera definidos en el datasheet sin contadores excesivamente grandes en la máquina de estados.

### Diagrama de Flujo (Carta ASM)
El diseño sigue la secuencia de comandos estricta del fabricante:
1.  **Power On:** Espera de 20ms.
2.  **Function Set:** Interfaz de 8 bits, 2 líneas, fuente 5x8.
3.  **Display ON/OFF:** Cursor y parpadeo desactivados.
4.  **Clear Display:** Limpieza de RAM.
5.  **Entry Mode Set:** Incremento automático de dirección.

---

## 💻 Simulación (Testbench)

Se realizaron simulaciones funcionales y post-route para verificar los tiempos de *Setup* y *Hold* de las señales `RS` y `RW` respecto al flanco de bajada de `E`.

---

## 🔌 Conexión de Hardware (Pinout)

El diseño utiliza los puertos PMOD **JC** y **JD** de la Nexys 4.

### Mapa de Pines (Constraints)

| Señal VHDL | Función LCD | Pin FPGA | Puerto Físico |
| :--- | :--- | :--- | :--- |
| **clk** | Reloj (100MHz) | E3 | - |
| **reset** | Reset Global | C12 | BTNC |
| **init** | Iniciar (Solo LCD1) | M18 | BTNU |
| **RS** | Register Select | K1 | JC[1] |
| **RW** | Read/Write | F6 | JC[2] |
| **E** | Enable | J2 | JC[3] |
| **DB[0..7]** | Bus de Datos | H4, H1, G1... | JD[1..10] |

*Nota: Consultar los archivos `.xdc` en la carpeta `constraints/` para la asignación exacta de los pines del bus de datos.*

---

## 📂 Estructura del Repositorio

```text
├── constraints/       # Archivos de restricciones físicas (.xdc)
├── doc/               # Documentación (Diagramas, Datasheets)
├── img/               # Imágenes para este README
├── src/               # Código Fuente VHDL (.vhd)
│   ├── lcd1_design.vhd
│   └── lcd2_design.vhd
├── tb/                # Testbenches para simulación
└── README.md          # Este archivo
