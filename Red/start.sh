#!/bin/bash
#
# SPDX-License-Identifier: Apache-2.0
#

# Finalizar al primer error, mostrar todos los mensajes de error
set -e

# Para usuarios del Bash de Git en Windows no rescribir las rutas
export MSYS_NO_PATHCONV=1

# Nombre de Projecto de Docker Compose
export COMPOSE_PROJECT_NAME=hlf-TFM_Bjlanza
# Versión de los Componentes de Hyperledger Fabric
export IMAGE_TAG=1.4.2

echo -e "\e[39m: Iniciando y creando red Hyperledger Fabric..."
# Tiramos abajo la red previa y pedimos si se quiere eliminar los volumnes y redes creadas previamente
sudo docker-compose -f docker-compose-cli.yml down --remove-orphans
sudo docker volume prune
sudo docker network prune

# Iniciamos los contenedores de Hyperledger Fabric
echo -e "\e[39m: Iniciando contenedores de la red Hyperledger Fabric..."
sudo docker-compose -f docker-compose-cli.yml up -d
# Descansar algunos segundos para permitir el completo arranque de los contenedores
sleep 20
echo "Creando Canales.."
echo -e "\e[39m: Creando bloque genesis para el Canal DataMarketplace..."
sudo docker exec -it cli peer channel create -o orderer.bjlanza.es:7050 /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/bjlanza.es/orderers/orderer.bjlanza.es/msp/tlscacerts/tlsca.bjlanza.es-cert.pem -c canaldmp -f ./channel-artifacts/channel.tx
echo -e "\e[39m: Uniendo Organización 1 al canal..."
sudo docker exec -it cli peer channel join -b canaldmp.block
echo -e "\e[39m: Exportando bloque del canal a otros pares..."
# Copiando el bloque inicial del canal del la org 1 a las cli de los otras orgs
# Copiando el bloque generado en cli a la carpeta del proyecto
sudo docker cp cli:/opt/gopath/src/github.com/hyperledger/fabric/peer/canaldmp.block .
# Copiando el bloque a los otros cli de las diferentes organizaciones
sudo docker cp canaldmp.block cli2:/opt/gopath/src/github.com/hyperledger/fabric/peer/canaldmp.block
sudo docker cp canaldmp.block cli3:/opt/gopath/src/github.com/hyperledger/fabric/peer/canaldmp.block
# Eliminando bloque del canal data market place de la carpeta de projecto
rm canaldmp.block

#Uniendo las diferentes organizaciones al canal data market place usando el bloque de configuracion del canal
sudo docker exec -it cli2 peer channel join -b canaldmp.block
sudo docker exec -it cli3 peer channel join -b canaldmp.block

echo -e "\n\e[92m \u2714 Todos los pares se han unido al canaldmp (data market place)...\e[39m"

# Listar todos los contenedores docker activos
docker ps
exit 1

# EoF