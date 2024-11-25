# Sistema de Gestión de Categorías y Objetos en Assembly (MIPS)

Este proyecto implementa un **sistema de gestión de categorías y objetos** utilizando memoria dinámica en el lenguaje **assembly MIPS**. 

El sistema organiza los datos en estructuras de **listas enlazadas doblemente circulares**, permitiendo operaciones básicas como agregar, eliminar, listar categorías y objetos, además de navegar entre ellos.

El proyecto fue desarrollado en el entorno simulador **MARS**, y corresponde al **Trabajo Práctico Nº 3** de la materia Arquitectura de las Computadoras I, parte de la carrera Analista Universitario en Sistemas en el Instituto Poltécnico Superior.

## 📂 Funcionalidades

- **Gestión de Categorías**:
  - Agregar una nueva categoría.
  - Seleccionar categoría, navegando a la siguiente o a la anterior con respecto a la actual.
  - Listar las categorías existentes.
  - Eliminar la categoría seleccionada.

- **Gestión de Objetos**:
  - Anexar un objeto a la categoría seleccionada.
  - Listar objetos de la categoría seleccionada.
  - Eliminar un objeto de la categoría seleccionada a partir de su ID.

- **Gestión de Errores**:
  - El sistema devuelve códigos de error específicos para diversas situaciones:
    - `101`: Opción de menú inválida.
    - `201`: No hay categorías en la lista y se ha intentado acceder a la anterior/siguiente.
    - `202`: Solo hay una categoría en la lista y se ha intentado acceder a la anterior/siguiente.
    - `301`: No hay categorías en la lista y se ha intentado listar las categorías existentes.
    - `401`: No hay categorías en la lista y se ha intentado borrar la categoría seleccionada.
    - `501`: No hay categorías en la lista y se ha intentado anexar un objeto a la categoría seleccionada.
    - `601`: No hay categorías en la lista y se ha intentado listar los objetos anexados a la categoría actual.
    - `602`: No hay objetos anexados a la categoría seleccionada y se ha intentado listar dichos objetos.
    - `701`: No hay categorías en la lista y se ha intentado borrar un objeto de la categoría actual.

---

### 📂 Estructurado de la memoria

#### Categorías
Cada categoría es una "estructura" de **16 bytes** (o 4 words) organizada de la siguiente forma:
- **Bytes 0-4**: Puntero a la categoría anterior.
- **Bytes 4-8**: Puntero al primer objeto de la lista (si existen).
- **Bytes 8-12**: Puntero al nombre de la categoría.
- **Bytes 12-16**: Puntero a la categoría siguiente.

#### Objetos
Cada objeto también es un bloque de **16 bytes** para simplificar la administración de memoria, y está organizada así:
- **Bytes 0-4**: Puntero al objeto anterior.
- **Bytes 4-8**: ID del objeto (único en su categoría).
- **Bytes 8-12**: Puntero al nombre del objeto.
- **Bytes 12-16**: Puntero al objeto siguiente.

---

### 📂 Estructura del Código

El enunciado del trabajo ha proveido el segmento de datos y las funciones que manejan la asignación de la memoria dinámica, así como la función `newcategory` a modo de ejemplo.
Se ha hecho especial incapié en la modularización del código, cada operación que se realiza está implementada en funciones independientes, lo cual facilita su mantenimiento y depuración.

1. **Segmento `.data`**:
- Define los punteros `slist` (utlizado por las funciones `smalloc` y `sfree`), `cclist` (circular category list - apunta a la lista de categorías) y `wclist` (working category list - apunta a la categoría seleccionada en curso).
- Define el vector de direcciones `schedv` (scheduler vector), que contiene las direcciones de todas las funciones del programa.
- Define las cadenas de texto que utilizan el menu principal, los output individuales de cada función, los mensajes genéricos de error o éxito, y el carácter de nueva línea.

2. **Segmento `.text`**:
- Contiene la lógica principal e incluye:
  - Incialización del vector `schedv` y loop del menu principal.
  - Gestión de categorías (`newcategory`, `nextcategory`, `prevcategory`, `listcategories` y `delcategory`).
  - Gestión de objetos (`newobject`, `listobjects` y `delobject`).
  - Gestión de memoria dinámica (`smalloc`, `sfree`).

- Las funciones reutilizables que son usadas por varias funciones se localizan en la parte más baja del código. La mayoría han sido proveidas por la cátedra de la materia, e incluyen:
  - `addnode`: Inserta nodos en listas circulares.
  - `delnode`: Elimina nodos de listas circulares.
  - `getblock`: Reserva memoria dinámica para cadenas.
  - `smalloc` y `sfree`: Utilzadas internamente por las funciones anteriores para le correcta alocación de memoria.
  - `printerror`: Imprime mensajes de error basados en códigos.
  - `successmsg`: Imprime mensajede operación exitosa.

---

### 📚 Referencias

1. **Entorno MARS**:
[MARS MIPS Assembler and Runtime Simulator](https://computerscience.missouristate.edu/mars-mips-simulator.htm)
2. **Conceptos de Listas Enlazadas**:
[Wikipedia - Listas Enlazadas](https://es.wikipedia.org/wiki/Lista_enlazada)

---

### Autor: **Gregorio Dib**
