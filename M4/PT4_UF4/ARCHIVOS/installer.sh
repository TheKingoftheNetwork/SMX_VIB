#!/bin/bash

verificar_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "Este script debe ejecutarse como root. Por favor, ejecuta el script con privilegios de root."
        exit 1
    fi
}

emoji_inicial="⌛"
emoji_completado="✅"
emoji_error="❌"


read -p "Ingresa el nombre del servidor (ejemplo: WIN-8MV3MEMAFHO): " nombre_server
read -p "Ingresa el nombre del dominio (ejemplo: JOSED.LAN): " nombre_dominio
read -p "Ingresa el nombre usuario (ejemplo: Administrador): " nombre_usuario
read -p "Ingresa la contraseña de $nombre_usuario: " passwd
read -p "Mete el nombre de la carpeta smx (tus iniciales solo): " inciales_smx
read -p "Mete el nombre de la carpeta daw (tus iniciales solo): " iniciales_daw
read -p "Mete el nombre del grupo de AD WINDOWS (SMX solo): " grupo_smx
read -p "Mete el nombre del grupo de AD WINDOWS (DAW solo): " grupo_daw


cadena_daw="Alumnos_DAW$inciales_daw"
cadena_smx="Alumnos_SMX$inciales_smx"

actualizar_repositorios() {
    echo -ne "Actualizando APT $emoji_inicial"
    apt-get update -y > /dev/null 2>/dev/null
    if [ $? -eq 0 ]; then
        echo -ne "\rActualización de APT completada $emoji_completado\n"
    else
        echo -ne "\rError al actualizar APT $emoji_error\n"
        exit 1
    fi
}


instalar_paquetes() {
    echo -ne "Instalando paquetes necesarios $emoji_inicial"
    DEBIAN_FRONTEND=noninteractive apt-get install -y samba krb5-user winbind libnss-winbind libpam-winbind > /dev/null 2>/dev/null
    if [ $? -eq 0 ]; then
        echo -ne "\rPaquetes instalados $emoji_completado\n"
    else
        echo -ne "\rError al instalar los paquetes $emoji_error\n"
        exit 1
    fi
}


configurar_krb5_conf() {
    echo -ne "Configurando krb5.conf $emoji_inicial"
    krb5_conf_path="/etc/krb5.conf"
    
   
    {
        echo "[libdefaults]"
        echo "default_realm = $nombre_dominio"
        echo "kdc_timesync = 1"
        echo "ccache_type = 4"
        echo "forwardable = true"
        echo "proxiable = true"
        echo "rdns = false"
        echo "fcc-mit-ticketflags = true"
        echo
        
        echo "[realms]"
        echo "$nombre_dominio = {"
        echo "    kdc = $nombre_server.$nombre_dominio"
        echo "    admin_server = $nombre_server.$nombre_dominio"
        echo "}"
        
        echo "ATHENA.MIT.EDU = {"
        echo "    kdc = kerberos.mit.edu"
        echo "    kdc = kerberos-1.mit.edu"
        echo "    kdc = kerberos-2.mit.edu:88"
        echo "    admin_server = kerberos.mit.edu"
        echo "    default_domain = mit.edu"
        echo "}"
        echo "ZONE.MIT.EDU = {"
        echo "    kdc = casio.mit.edu"
        echo "    kdc = seiko.mit.edu"
        echo "    admin_server = casio.mit.edu"
        echo "}"
        
        
        echo "[domain_realm]"
        echo ".mit.edu = ATHENA.MIT.EDU"
        echo "mit.edu = ATHENA.MIT.EDU"
        echo ".media.mit.edu = MEDIA-LAB.MIT.EDU"
        echo "media.mit.edu = MEDIA-LAB.MIT.EDU"
        echo ".csail.mit.edu = CSAIL.MIT.EDU"
        echo "csail.mit.edu = CSAIL.MIT.EDU"
        echo ".whoi.edu = ATHENA.MIT.EDU"
        echo "whoi.edu = ATHENA.MIT.EDU"
        echo ".stanford.edu = stanford.edu"
        echo ".slac.stanford.edu = SLAC.STANFORD.EDU"
        echo ".toronto.edu = UTORONTO.CA"
        echo ".utoronto.ca = UTORONTO.CA"
    } > "$krb5_conf_path"
    

    if [ $? -eq 0 ]; then
        echo -ne "\rConfiguración de krb5.conf completada $emoji_completado\n"
    else
        echo -ne "\rError al configurar krb5.conf $emoji_error\n"
        exit 1
    fi
}

autenticar_krb() {
    archivo_temp=$(mktemp)

    
    echo "$passwd" > "$archivo_temp"

    
    chmod 600 "$archivo_temp"
    
    echo "$passwd" | kinit "$nombre_usuario"
    
    
    rm -f "$archivo_temp"

    if [ $? -eq 0 ]; then
        echo "Autenticación con Kerberos exitosa."
    else
        echo "Error en la autenticación con Kerberos."
    fi
}


sobrescribir_nsswitch_conf() {
    
    nsswitch_conf="/etc/nsswitch.conf"
    
    
    nuevo_contenido="passwd:         files systemd winbind
group:          files systemd winbind
shadow:         files systemd
gshadow:        files systemd

hosts:          files mdns4_minimal [NOTFOUND=return] dns
networks:       files

protocols:      db files
services:       db files
ethers:         db files
rpc:            db files

netgroup:       nis"

    
    cp "$nsswitch_conf" "${nsswitch_conf}.bak"

    
    echo "$nuevo_contenido" > "$nsswitch_conf"

    if [ $? -eq 0 ]; then
        echo "El archivo nsswitch.conf ha sido sobrescrito exitosamente."
    else
        echo "Hubo un error al sobrescribir nsswitch.conf."
    fi
}




configurar_samba() {
    echo -ne "Configurando smb.conf de Samba $emoji_inicial"
    smb_conf_path="/etc/samba/smb.conf"

    > $smb_conf_path
    {
        echo "[global]"
        echo "workgroup = $nombre_dominio"
        echo "netbios name = $nombre_server"
        echo "server string = Samba J Version %v"
        echo "security = ads"
        echo "realm = $nombre_dominio"
        echo "socket options = TCP_NODELAY IPTOS_LOWDELAY SO_RCVBUF=131072 SO_SNDBUF=131072"
        echo "use sendfile = true"
        echo
        echo "idmap config * : backend = tdb"
        echo "idmap config * : range = 100000-299999"
        echo "idmap config TEST : backend = rid"
        echo "idmap config TEST : range = 10000-99999"
        echo "winbind separator = +"
        echo "winbind enum users = yes"
        echo "winbind enum groups = yes"
        echo "winbind use default domain = yes"
        echo "winbind refresh tickets = yes"
        echo
        echo "restrict anonymous = 2"
        echo "log file = /var/log/samba/log.%m"
        echo "max log size = 50"
        echo
        echo "[Alumnos_SMX$inciales_smx]"
        echo "comment = Carpeta SMXJD"
        echo "path = /home/alumnos/smx$inciales_smx"
        echo "browsable = yes"
        echo "read only = no"
        echo "valid users = @$grupo_smx"
        echo
        echo "[Alumnos_DAW$inciales_daw]"
        echo "comment = Carpeta DAWJD"
        echo "path = /home/alumnos/daw$inciales_daw"
        echo "browsable = yes"
        echo "read only = no"
        echo "valid users = @$grupo_daw"
        echo
        echo "[alumnos]"
        echo "comment = Carpeta Alumnos"
        echo "path = /home/alumnos"
        echo "browsable = yes"
        echo "read only = yes"
        echo "valid users = 'Usuarios del dominio'"
    } > "$smb_conf_path"
    
    if [ $? -eq 0 ]; then
        echo -ne "\rConfiguración de smb.conf de Samba completada $emoji_completado\n"
    else
        echo -ne "\rError al configurar smb.conf de Samba $emoji_error\n"
        exit 1
    fi
}

ads_join() {
    
    echo "$passwd" | sudo net ads join -U "$nombre_usuario@$nombre_dominio" > /dev/null 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo "Unión al dominio $nombre_dominio exitosa."
    else
        echo "Error al unir al dominio $nombre_dominio."
    fi
}

winbind_restart() {
    /etc/init.d/winbind restart > /dev/null 2>/dev/null

    
    if [ $? -eq 0 ]; then
        echo -ne "\rReiniciando winbind $emoji_completado\n"
    else
        echo -ne "\rError al reiniciar winbind $emoji_error\n"
    fi
}


recuperar_usuarios_grupos() {
    echo -ne "Recuperando usuarios y grupos $emoji_inicial"
    
    wbinfo -u > /dev/null 2>/dev/null
    wbinfo -g > /dev/null 2>/dev/null
    
    
    if [ $? -eq 0 ]; then
        echo -ne "\rRecuperando usuarios y grupos $emoji_completado\n"
    else
        echo -ne "\rError al recuperar usuarios y grupos $emoji_error\n"
    fi
}

carpetas() {
    echo -ne "Creando carpetas y configurando permisos $emoji_inicial"
    
    mkdir /home/alumnos
    mkdir -p /home/alumnos/smx$inciales_smx
    mkdir -p /home/alumnos/daw$inciales_daw
    
    chgrp $grupo_smx /home/alumnos/smx$inciales_smx
    chgrp $grupo_daw /home/alumnos/daw$inciales_daw
    chown root /home/alumnos/smx$inciales_smx
    chown root /home/alumnos/daw$inciales_daw
    chgrp "Usuarios del dominio" /home/alumnos
    
    if [ $? -eq 0 ]; then
        echo -ne "\rCreando carpetas y configurando permisos $emoji_completado\n"
    else
        echo -ne "\rError al crear carpetas y configurar permisos $emoji_error\n"
    fi
}


verificar_root
actualizar_repositorios
instalar_paquetes
configurar_krb5_conf
sobrescribir_nsswitch_conf
configurar_samba
autenticar_krb
ads_join
winbind_restart
recuperar_usuarios_grupos
carpetas
