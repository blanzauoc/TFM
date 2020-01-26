#!/bin/bash
#
# SPDX-License-Identifier: Apache-2.0
#

# Test de la red HLF

sudo docker exec -it cli peer chaincode invoke -o orderer.bjlanza.es:7050 -n mycc -c '{"Args":["set", "a", "20"]}' -C canaldmp

#sleep 5

#sudo docker exec -it cli peer chaincode query -n mycc -c '{"Args":["query","a"]}' -C canaldmp
#sudo docker exec -it cli2 peer chaincode invoke -o orderer.bjlanza.es:7050 -n mycc -c '{"Args":["set", "a", "40"]}' -C canaldmp

#sleep 5

#sudo docker exec -it cli2 peer chaincode query -n mycc -c '{"Args":["query","a"]}' -C canaldmp
#sudo docker exec -it cli3 peer chaincode invoke -o orderer.bjlanza.es:7050 -n mycc -c '{"Args":["set", "a", "60"]}' -C canaldmp

#sleep 5

echo 'Querying For Result on Org1 Peer'

sudo docker exec -it cli peer chaincode query -n mycc -c '{"Args":["query","a"]}' -C canaldmp

echo 'Invocando y consultando el Chaincode MarketPlace'

sudo docker exec -it cli peer chaincode invoke -o orderer.bjlanza.es:7050 -n marketplacecc -c '{"Args":["crearTransaccion", "bjlanza", "Qwzsrerewredfwerwerews", "UOC", "test01"]}' -C canaldmp
sudo docker exec -it cli peer chaincode invoke -o orderer.bjlanza.es:7050 -n marketplacecc -c '{"Args":["crearDato", "bjlanza", "Qwzs4343dsgdg4rbths", "TFM", "Ejemplo de dato para el TFM", "dato", "alfanumerico","geografico","hdfs1.bjlanza.es"]}' -C canaldmp

#Consultas
sudo docker exec -it cli peer chaincode query -n marketplacecc -c '{"Args":["consultarTransaccionPorCreator","bjlanza"]}' -C canaldmp
sudo docker exec -it cli peer chaincode query -n marketplacecc -c '{"Args":["consultarTransaccionPorReceptor","UOC"]}' -C canaldmp

#Los hash dependen de los bloques cambian con cada salvado y por tanto hay que modificar las consultas
#sudo docker exec -it cli peer chaincode query -n marketplacecc -c '{"Args":["consultarTransaccion","d2d14d9d-0368-11ea-8dc6-0242ac12000f"]}' -C canaldmp
sudo docker exec -it cli peer chaincode invoke -o orderer.bjlanza.es:7050 -n marketplacecc -c '{"Args":["cambiarDescripcionDato", "2120c7e7-0386-11ea-b890-0242ac1a000b", "DataMarketplace Chain"]}' -C canaldmp


#Consultar estado de la red blockchain
sudo docker exec -it cli peer channel fetch newest canaldmp.block -c canaldmp --orderer orderer.bjlanza.es:7050
#Comprobamos el estado en varios Peers (nodos) para consultar que se ha actualizado la red
sudo docker exec -it cli peer channel getinfo -c canaldmp
sudo docker exec -it cli3 peer channel getinfo -c canaldmp

echo -e '\n\e[92m \u2714 Todas las tareas realizadas... \e[39m'

exit 1

sudo docker exec -it cli peer chaincode invoke -o orderer.bjlanza.es:7050 -n marketplacecc -c '{"Args":["crearSubscripcion", "Borja", "Qwz4683246823u47384", "Datos geograficos", "Conjunto de datos geográficos de la provincia de León", "Dataset", "datos geograficos","coordenadas"]}' -C canaldmp
sudo docker exec -it cli peer chaincode query -n marketplacecc -c '{"Args":["consultarTransaccionPorCreator","Borja"]}' -C canaldmp
