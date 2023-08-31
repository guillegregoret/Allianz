# "Allianz" - Análisis y Optimización de Tiempos en el Ciclo de Vida de la Infraestructura Utilizando Enfoques de Infraestructura como Código

## Descripción

Este proyecto, titulado "Análisis y Optimización de Tiempos en el Ciclo de Vida de la Infraestructura Utilizando Enfoques de Infraestructura como Código", representa nuestro trabajo final de carrera realizado en el marco de la Ingeniería en Sistemas de Información en la UTN FRSF, Santa Fe, Argentina. "Allianz" se centra en la administración y configuración de infraestructuras utilizando Terraform.

## Alumno

-   **Nombre:** Guillermo Andrés Gregoret
-   **Legajo:** 24687
-   **Correo Electrónico:** [ggregoret@frsf.utn.edu.ar](mailto:ggregoret@frsf.utn.edu.ar)

## Introducción
El presente proyecto final de carrera tiene como objetivo principal solucionar la problemática relacionada con la falta de automatización en la aplicación de cambios en el proceso de desarrollo de software. Esta problemática ha generado ineficiencias y la posibilidad de errores en el proceso de copia de los cambios en los diferentes ambientes.

En este contexto, los objetivos generales del proyecto son mejorar los tiempos que la empresa posee al implementar cambios para desplegarlos en testing, staging y producción. Para alcanzar este objetivo, se plantean una serie de objetivos específicos que incluyen el análisis de la problemática actual del cliente, la definición del método para automatizar los deploys, la comparación de alternativas en infraestructura como código (IaC) para la implementación, la realización del código IaC, el análisis de la optimización del tiempo al utilizar IaC y la comparación de los proveedores de servicios en la nube para la implementación.
 
La solución propuesta en este proyecto incluye la implementación de prácticas de CI/CD y automatización en el proceso de desarrollo de software, utilizando herramientas y tecnologías como Terraform para la gestión de la infraestructura como código. De esta manera, se espera mejorar la eficiencia y la calidad del proceso de desarrollo de software, reduciendo la posibilidad de errores y asegurando un seguimiento adecuado de los cambios.

## Contenido del Repositorio

El repositorio contiene:

-   **Documentación:** En la carpeta "docs" encontrarás documentos relevantes para comprender la estructura y el funcionamiento del proyecto.
    
-   **Código Terraform:** La carpeta "terraform" contiene los archivos de configuración de Terraform utilizados para definir la infraestructura como código.
    

## Estructura del Proyecto

    |-- logstash
    |   |-- Dockerfile
    |
    |-- infrastructure
    |   |-- main.tf
    |   |-- variables.tf
    |   |-- output.tf
    |   |-- ...
    |
    |-- README.md 

## Instrucciones de Uso

1.  Clona este repositorio en tu máquina local.
    
2.  Asegúrate de tener Terraform instalado. Puedes encontrar las instrucciones [aquí](https://www.terraform.io/).
    
3.  Configura las variables en "variables.tf" según tus necesidades.
    
4.  Ejecuta `terraform init` para inicializar el directorio de trabajo.
    
5.  Utiliza `terraform plan` para revisar los cambios en la infraestructura.
    
6.  Ejecuta `terraform apply` para crear los recursos.
    
7.  ¡Disfruta de tu infraestructura desplegada!