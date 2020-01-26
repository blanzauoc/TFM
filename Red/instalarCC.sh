#!/bin/bash
#
# SPDX-License-Identifier: Apache-2.0
#

# Installando Chaincode de tests y pruebas
echo 'Instalando test Chaincode mycc en todos los Peers..'

sudo docker exec -it cli peer chaincode install -n mycc -p github.com/chaincode -v v0
sudo docker exec -it cli2 peer chaincode install -n mycc -p github.com/chaincode -v v0
sudo docker exec -it cli3 peer chaincode install -n mycc -p github.com/chaincode -v v0

echo 'Instanciando el Chaincode de testeo mycc en canaldmp..'

sudo docker exec -it cli peer chaincode instantiate -o orderer.bjlanza.es:7050 -C canaldmp -n mycc github.com/chaincode -v v0 -c '{"Args": ["a", "100"]}'

# Definimos las variables necesarias para el CC principal
CC_SRC_PATH="github.com/chaincode/marketplacecc"
CHANNEL_NAME="canaldmp"
CC_RUNTIME_LANGUAGE="golang"
VERSION="1.0.8"

# Instalando e Instanciando Chaincode
echo 'Instalando Chaincode marketplace en el peer...'
docker exec cli peer chaincode install -n marketplacecc -v "$VERSION" -p "$CC_SRC_PATH" -l "$CC_RUNTIME_LANGUAGE"
echo 'Instanciando Chaincode marketplace en el canal canaldmp...'
docker exec cli peer chaincode instantiate -o orderer.bjlanza.es:7050 -C "$CHANNEL_NAME" -n marketplacecc -l "$CC_RUNTIME_LANGUAGE" -v "$VERSION" -c '{"Args":[]}' -P "OR ('Org1MSP.member')"

# Actualizar
# docker exec cli peer chaincode upgrade -n marketplacecc -v 2.0 -p github.com/chaincode/marketplacecc -C canaldmp -o orderer.bjlanza.es:7050 -c '{"Args":[""]}'

# Finalización de Script
echo -e '\n\e[92m \u2714 Todas la tareas realizadas.. Para consultar el MVP usar <<consultar.sh>>>...\e[39m'
exit 1
# EoF 

