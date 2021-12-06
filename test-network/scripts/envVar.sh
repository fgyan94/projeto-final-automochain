#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

source scriptUtils.sh
echo $FABRIC_CFG_PATH
export CORE_PEER_TLS_ENABLED=true
# export ORDERER_CA=${PWD}/organizations/ordererOrganizations/montadora.ciag/tlsca/tlsca.montadora.ciag-cert.pem
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/montadora.ciag/msp/tlscacerts/tlsca.montadora.ciag-cert.pem
export PEER0_MONTADORA_CA=${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer0.montadora.ciag/tls/ca.crt
export PEER1_MONTADORA_CA=${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer1.montadora.ciag/tls/ca.crt
export PEER2_MONTADORA_CA=${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer2.montadora.ciag/tls/ca.crt
export PEER0_SISTEMISTA_CA=${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer0.sistemista.ciag/tls/ca.crt
export PEER1_SISTEMISTA_CA=${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer1.sistemista.ciag/tls/ca.crt
export PEER2_SISTEMISTA_CA=${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer2.sistemista.ciag/tls/ca.crt

# Set OrdererOrg.Admin globals
setOrdererGlobals() {
  export CORE_PEER_LOCALMSPID="OrdererMSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/ordererOrganizations/montadora.ciag/tlsca/tlsca.montadora.ciag-cert.pem
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/ordererOrganizations/montadora.ciag/users/Admin@montadora.ciag/msp
}

# Set environment variables for the peer org
setGlobals() {
  local PORT=0
  local CORE_PEER=""
  local USING_ORG=""
  local INDEX=0
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  if [ -z "$2" ]; then
    INDEX=0
  else
    INDEX="${2}"
  fi
  infoln "Using organization ${USING_ORG}"
  if [ "$USING_ORG" = "Montadora" ]; then
    if [ $INDEX -eq 2 ]; then
      PORT=7251
      CORE_PEER=$PEER2_MONTADORA_CA
    elif [ $INDEX -eq 1 ]; then
      PORT=7151
      CORE_PEER=$PEER1_MONTADORA_CA
    else
      PORT=7051
      CORE_PEER=$PEER0_MONTADORA_CA
    fi
    export CORE_PEER_LOCALMSPID="MontadoraMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$CORE_PEER
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/montadora.ciag/users/Admin@montadora.ciag/msp
    export CORE_PEER_ADDRESS=localhost:$PORT
  elif [ "$USING_ORG" = "Sistemista" ]; then
    if [ $INDEX -eq 2 ]; then
      PORT=9251
      CORE_PEER=$PEER2_SISTEMISTA_CA
    elif [ $INDEX -eq 1 ]; then
      PORT=9151
      CORE_PEER=$PEER1_SISTEMISTA_CA
    else
      PORT=9051
      CORE_PEER=$PEER0_SISTEMISTA_CA
    fi
    export CORE_PEER_LOCALMSPID="SistemistaMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$CORE_PEER
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/sistemista.ciag/users/Admin@sistemista.ciag/msp
    export CORE_PEER_ADDRESS=localhost:$PORT

  else
    errorln "ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
parsePeerConnectionParameters() {

  PEER_CONN_PARMS=""
  PEERS=""
  while [ "$#" -gt 0 ]; do
    setGlobals $1
    if [ "$1" = "Montadora" ]; then
      PEER="peer0.montadora.ciag"
    else
      PEER="peer0.sistemista.ciag"
    fi
    ## Set peer addresses
    PEERS="$PEERS $PEER"
    PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
    ## Set path to TLS certificate
    if [ "$1" = "Montadora" ]; then
      TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_MONTADORA_CA")
    else
      TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_SISTEMISTA_CA")
    fi
    PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
    # shift by one to get to the next organization
    shift
  done
  # remove leading space for output
  PEERS="$(echo -e "$PEERS" | sed -e 's/^[[:space:]]*//')"
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}
