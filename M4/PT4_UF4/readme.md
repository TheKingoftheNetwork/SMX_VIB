# INSTALACIÓN LINUX SERVER CON SAMBA Y UNIR A ACTIVE DIRECTORY

Primeramente tendremos que tener instalado active directory en el Windows Server una vez hecho entonces podremos continuar con la instalación de todos los paquetes necesarios


## INSTALACIÓN DE PAQUETES/LIBRERIAS NECESARIAS

Procederemos a la instalación de los paquetes necesarios para poder hacer la práctica esos paquetes son los que siguen:

1. samba
2. krb5-user
3. winbind
4. libnss-winbind
5. libpam-winbind

Con esta linea de código instalas todos los paquetes necesarios sin necesidad de confirmar la instalación y actualizar los repositorios:
```bash
apt-get update -y

# Esta línea quitará las NCURSES de configuración, lo hago así para configurarlo de 0 para no tener problemas. Y además el output no se mostrará.
DEBIAN_FRONTEND=noninteractive apt-get install -y samba krb5-user winbind libnss-winbind libpam-winbind > /dev/null 2>/dev/null
```


## CONFIGURACIÓN KRB5.CONF
Ahora siguiendo el ejemplo que dejé en la carpeta archivos, rellenaremos según nuestros parámetros del dominio

1. [KRB5.CONF](https://github.com/TheKingoftheNetwork/SMX_VIB/blob/main/M4/PT4_UF4/ARCHIVOS/krb5.conf)
