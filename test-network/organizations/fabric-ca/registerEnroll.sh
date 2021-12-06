#!/bin/bash

source scriptUtils.sh

function createMontadora() {

  infoln "Montadora - Enroll the CA admin"
  mkdir -p organizations/peerOrganizations/montadora.ciag/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/montadora.ciag/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-montadora --tls.certfiles ${PWD}/organizations/fabric-ca/montadora.ciag/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-montadora.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-montadora.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-montadora.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-montadora.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/montadora.ciag/msp/config.yaml

  infoln "Montadora - Register peer0"
  set -x
  fabric-ca-client register --caname ca-montadora --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/montadora.ciag/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Montadora - Register peer1"
  set -x
  fabric-ca-client register --caname ca-montadora --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/montadora.ciag/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Montadora - Register peer2"
  set -x
  fabric-ca-client register --caname ca-montadora --id.name peer2 --id.secret peer2pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/montadora.ciag/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Montadora - Register User"
  set -x
  fabric-ca-client register --caname ca-montadora --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/montadora.ciag/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Montadora - Register Admin"
  set -x
  fabric-ca-client register --caname ca-montadora --id.name montadoraAdmin --id.secret montadoraAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/montadora.ciag/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/peerOrganizations/montadora.ciag/peers
  mkdir -p organizations/peerOrganizations/montadora.ciag/peers/peer0.montadora.ciag

  infoln "Montadora - Generate the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-montadora -M ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer0.montadora.ciag/msp --csr.hosts peer0.montadora.ciag --tls.certfiles ${PWD}/organizations/fabric-ca/montadora.ciag/tls-cert.pem
  { set +x; } 2>/dev/null
  cp ${PWD}/organizations/peerOrganizations/montadora.ciag/msp/config.yaml ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer0.montadora.ciag/msp/config.yaml

  infoln "Montadora - Generate the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-montadora -M ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer1.montadora.ciag/msp --csr.hosts peer1.montadora.ciag --tls.certfiles ${PWD}/organizations/fabric-ca/montadora.ciag/tls-cert.pem
  { set +x; } 2>/dev/null
  cp ${PWD}/organizations/peerOrganizations/montadora.ciag/msp/config.yaml ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer1.montadora.ciag/msp/config.yaml

  infoln "Montadora - Generate the peer2 msp"
  set -x
  fabric-ca-client enroll -u https://peer2:peer2pw@localhost:7054 --caname ca-montadora -M ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer2.montadora.ciag/msp --csr.hosts peer2.montadora.ciag --tls.certfiles ${PWD}/organizations/fabric-ca/montadora.ciag/tls-cert.pem
  { set +x; } 2>/dev/null
  cp ${PWD}/organizations/peerOrganizations/montadora.ciag/msp/config.yaml ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer2.montadora.ciag/msp/config.yaml

  infoln "Montadora - Generate the peer0-tls certificates"
  mkdir -p ${PWD}/organizations/peerOrganizations/montadora.ciag/msp/tlscacerts
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-montadora -M ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer0.montadora.ciag/tls --enrollment.profile tls --csr.hosts peer0.montadora.ciag --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/montadora.ciag/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer0.montadora.ciag/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer0.montadora.ciag/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer0.montadora.ciag/tls/signcerts/* ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer0.montadora.ciag/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer0.montadora.ciag/tls/keystore/* ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer0.montadora.ciag/tls/server.key
  cp ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer0.montadora.ciag/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/montadora.ciag/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/montadora.ciag/tlsca
  cp ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer0.montadora.ciag/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/montadora.ciag/tlsca/tlsca.montadora.ciag-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/montadora.ciag/ca
  cp ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer0.montadora.ciag/msp/cacerts/* ${PWD}/organizations/peerOrganizations/montadora.ciag/ca/ca.montadora.ciag-cert.pem

  infoln "Montadora - Generate the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-montadora -M ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer1.montadora.ciag/tls --enrollment.profile tls --csr.hosts peer1.montadora.ciag --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/montadora.ciag/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer1.montadora.ciag/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer1.montadora.ciag/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer1.montadora.ciag/tls/signcerts/* ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer1.montadora.ciag/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer1.montadora.ciag/tls/keystore/* ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer1.montadora.ciag/tls/server.key
  cp ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer1.montadora.ciag/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/montadora.ciag/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/montadora.ciag/tlsca
  cp ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer1.montadora.ciag/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/montadora.ciag/tlsca/tlsca.montadora.ciag-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/montadora.ciag/ca
  cp ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer1.montadora.ciag/msp/cacerts/* ${PWD}/organizations/peerOrganizations/montadora.ciag/ca/ca.montadora.ciag-cert.pem
  
  infoln "Montadora - Generate the peer2-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer2:peer2pw@localhost:7054 --caname ca-montadora -M ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer2.montadora.ciag/tls --enrollment.profile tls --csr.hosts peer2.montadora.ciag --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/montadora.ciag/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer2.montadora.ciag/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer2.montadora.ciag/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer2.montadora.ciag/tls/signcerts/* ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer2.montadora.ciag/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer2.montadora.ciag/tls/keystore/* ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer2.montadora.ciag/tls/server.key
  cp ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer2.montadora.ciag/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/montadora.ciag/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/montadora.ciag/tlsca
  cp ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer2.montadora.ciag/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/montadora.ciag/tlsca/tlsca.montadora.ciag-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/montadora.ciag/ca
  cp ${PWD}/organizations/peerOrganizations/montadora.ciag/peers/peer2.montadora.ciag/msp/cacerts/* ${PWD}/organizations/peerOrganizations/montadora.ciag/ca/ca.montadora.ciag-cert.pem

  mkdir -p organizations/peerOrganizations/montadora.ciag/users
  mkdir -p organizations/peerOrganizations/montadora.ciag/users/User1@montadora.ciag

  infoln "Montadora - Generate the Montadora User msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-montadora -M ${PWD}/organizations/peerOrganizations/montadora.ciag/users/User1@montadora.ciag/msp --tls.certfiles ${PWD}/organizations/fabric-ca/montadora.ciag/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/montadora.ciag/msp/config.yaml ${PWD}/organizations/peerOrganizations/montadora.ciag/users/User1@montadora.ciag/msp/config.yaml

  mkdir -p organizations/peerOrganizations/montadora.ciag/users/Admin@montadora.ciag

  infoln "Montadora - Generate the Montadora Admin msp"
  set -x
  fabric-ca-client enroll -u https://montadoraAdmin:montadoraAdminpw@localhost:7054 --caname ca-montadora -M ${PWD}/organizations/peerOrganizations/montadora.ciag/users/Admin@montadora.ciag/msp --tls.certfiles ${PWD}/organizations/fabric-ca/montadora.ciag/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/montadora.ciag/msp/config.yaml ${PWD}/organizations/peerOrganizations/montadora.ciag/users/Admin@montadora.ciag/msp/config.yaml

}

function createSistemista() {

  infoln "Sistemista - Enroll the CA admin"
  mkdir -p organizations/peerOrganizations/sistemista.ciag/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/sistemista.ciag/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-sistemista --tls.certfiles ${PWD}/organizations/fabric-ca/sistemista.ciag/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-sistemista.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-sistemista.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-sistemista.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-sistemista.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/sistemista.ciag/msp/config.yaml

  infoln "Sistemista - Register peer0"
  set -x
  fabric-ca-client register --caname ca-sistemista --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/sistemista.ciag/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Sistemista - Register peer1"
  set -x
  fabric-ca-client register --caname ca-sistemista --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/sistemista.ciag/tls-cert.pem
  { set +x; } 2>/dev/null
  
  infoln "Sistemista - Register peer2"
  set -x
  fabric-ca-client register --caname ca-sistemista --id.name peer2 --id.secret peer2pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/sistemista.ciag/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Sistemista - Register User"
  set -x
  fabric-ca-client register --caname ca-sistemista --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/sistemista.ciag/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Sistemista - Register Admin"
  set -x
  fabric-ca-client register --caname ca-sistemista --id.name sistemistaAdmin --id.secret sistemistaAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/sistemista.ciag/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/peerOrganizations/sistemista.ciag/peers
  mkdir -p organizations/peerOrganizations/sistemista.ciag/peers/peer0.sistemista.ciag

  infoln "Sistemista - Generate the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-sistemista -M ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer0.sistemista.ciag/msp --csr.hosts peer0.sistemista.ciag --tls.certfiles ${PWD}/organizations/fabric-ca/sistemista.ciag/tls-cert.pem
  { set +x; } 2>/dev/null
  cp ${PWD}/organizations/peerOrganizations/sistemista.ciag/msp/config.yaml ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer0.sistemista.ciag/msp/config.yaml

  infoln "Sistemista - Generate the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca-sistemista -M ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer1.sistemista.ciag/msp --csr.hosts peer1.sistemista.ciag --tls.certfiles ${PWD}/organizations/fabric-ca/sistemista.ciag/tls-cert.pem
  { set +x; } 2>/dev/null
  cp ${PWD}/organizations/peerOrganizations/sistemista.ciag/msp/config.yaml ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer1.sistemista.ciag/msp/config.yaml

  infoln "Sistemista - Generate the peer2 msp"
  set -x
  fabric-ca-client enroll -u https://peer2:peer2pw@localhost:8054 --caname ca-sistemista -M ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer2.sistemista.ciag/msp --csr.hosts peer2.sistemista.ciag --tls.certfiles ${PWD}/organizations/fabric-ca/sistemista.ciag/tls-cert.pem
  { set +x; } 2>/dev/null
  cp ${PWD}/organizations/peerOrganizations/sistemista.ciag/msp/config.yaml ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer2.sistemista.ciag/msp/config.yaml

  infoln "Sistemista - Generate the peer0-tls certificates"
  mkdir -p ${PWD}/organizations/peerOrganizations/sistemista.ciag/msp/tlscacerts
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-sistemista -M ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer0.sistemista.ciag/tls --enrollment.profile tls --csr.hosts peer0.sistemista.ciag --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/sistemista.ciag/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer0.sistemista.ciag/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer0.sistemista.ciag/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer0.sistemista.ciag/tls/signcerts/* ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer0.sistemista.ciag/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer0.sistemista.ciag/tls/keystore/* ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer0.sistemista.ciag/tls/server.key
  cp ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer0.sistemista.ciag/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/sistemista.ciag/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/sistemista.ciag/tlsca
  cp ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer0.sistemista.ciag/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/sistemista.ciag/tlsca/tlsca.sistemista.ciag-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/sistemista.ciag/ca
  cp ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer0.sistemista.ciag/msp/cacerts/* ${PWD}/organizations/peerOrganizations/sistemista.ciag/ca/ca.sistemista.ciag-cert.pem

  infoln "Sistemista - Generate the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca-sistemista -M ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer1.sistemista.ciag/tls --enrollment.profile tls --csr.hosts peer1.sistemista.ciag --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/sistemista.ciag/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer1.sistemista.ciag/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer1.sistemista.ciag/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer1.sistemista.ciag/tls/signcerts/* ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer1.sistemista.ciag/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer1.sistemista.ciag/tls/keystore/* ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer1.sistemista.ciag/tls/server.key
  cp ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer1.sistemista.ciag/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/sistemista.ciag/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/sistemista.ciag/tlsca
  cp ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer1.sistemista.ciag/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/sistemista.ciag/tlsca/tlsca.sistemista.ciag-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/sistemista.ciag/ca
  cp ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer1.sistemista.ciag/msp/cacerts/* ${PWD}/organizations/peerOrganizations/sistemista.ciag/ca/ca.sistemista.ciag-cert.pem

  infoln "Sistemista - Generate the peer2-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer2:peer2pw@localhost:8054 --caname ca-sistemista -M ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer2.sistemista.ciag/tls --enrollment.profile tls --csr.hosts peer2.sistemista.ciag --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/sistemista.ciag/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer2.sistemista.ciag/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer2.sistemista.ciag/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer2.sistemista.ciag/tls/signcerts/* ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer2.sistemista.ciag/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer2.sistemista.ciag/tls/keystore/* ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer2.sistemista.ciag/tls/server.key
  cp ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer2.sistemista.ciag/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/sistemista.ciag/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/sistemista.ciag/tlsca
  cp ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer2.sistemista.ciag/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/sistemista.ciag/tlsca/tlsca.sistemista.ciag-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/sistemista.ciag/ca
  cp ${PWD}/organizations/peerOrganizations/sistemista.ciag/peers/peer2.sistemista.ciag/msp/cacerts/* ${PWD}/organizations/peerOrganizations/sistemista.ciag/ca/ca.sistemista.ciag-cert.pem

  mkdir -p organizations/peerOrganizations/sistemista.ciag/users
  mkdir -p organizations/peerOrganizations/sistemista.ciag/users/User1@sistemista.ciag

  infoln "Sistemista - Generate the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-sistemista -M ${PWD}/organizations/peerOrganizations/sistemista.ciag/users/User1@sistemista.ciag/msp --tls.certfiles ${PWD}/organizations/fabric-ca/sistemista.ciag/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/sistemista.ciag/msp/config.yaml ${PWD}/organizations/peerOrganizations/sistemista.ciag/users/User1@sistemista.ciag/msp/config.yaml

  mkdir -p organizations/peerOrganizations/sistemista.ciag/users/Admin@sistemista.ciag

  infoln "Sistemista - Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://sistemistaAdmin:sistemistaAdminpw@localhost:8054 --caname ca-sistemista -M ${PWD}/organizations/peerOrganizations/sistemista.ciag/users/Admin@sistemista.ciag/msp --tls.certfiles ${PWD}/organizations/fabric-ca/sistemista.ciag/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/sistemista.ciag/msp/config.yaml ${PWD}/organizations/peerOrganizations/sistemista.ciag/users/Admin@sistemista.ciag/msp/config.yaml

}

function createOrderer() {

  infoln "Orderer Montadora - Enroll the CA admin"
  mkdir -p organizations/ordererOrganizations/montadora.ciag

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/montadora.ciag
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/orderer/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/montadora.ciag/msp/config.yaml

  infoln "Orderer Montadora - Register orderer0"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer0 --id.secret orderer0pw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/orderer/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Orderer Montadora - Register orderer1"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer1 --id.secret orderer1pw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/orderer/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Orderer Montadora - Register orderer2"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer2 --id.secret orderer2pw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/orderer/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Orderer Montadora - Register the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/orderer/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Orderer Montadora - Register the orderer user"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererUser --id.secret ordererUserpw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/orderer/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/ordererOrganizations/montadora.ciag/orderers

  infoln "Orderer Montadora - Generate the orderer0 msp"
  mkdir -p organizations/ordererOrganizations/montadora.ciag/orderers/orderer0.montadora.ciag
  set -x
  fabric-ca-client enroll -u https://orderer0:orderer0pw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer0.montadora.ciag/msp --csr.hosts orderer0.montadora.ciag --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/orderer/tls-cert.pem
  { set +x; } 2>/dev/null
  cp ${PWD}/organizations/ordererOrganizations/montadora.ciag/msp/config.yaml ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer0.montadora.ciag/msp/config.yaml

  infoln "Orderer Montadora - Generate the orderer1 msp"
  mkdir -p organizations/ordererOrganizations/montadora.ciag/orderers/orderer1.montadora.ciag
  set -x
  fabric-ca-client enroll -u https://orderer1:orderer1pw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer1.montadora.ciag/msp --csr.hosts orderer1.montadora.ciag --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/orderer/tls-cert.pem
  { set +x; } 2>/dev/null
  cp ${PWD}/organizations/ordererOrganizations/montadora.ciag/msp/config.yaml ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer1.montadora.ciag/msp/config.yaml

  infoln "Orderer Montadora - Generate the orderer2 msp"
  mkdir -p organizations/ordererOrganizations/montadora.ciag/orderers/orderer2.montadora.ciag
  set -x
  fabric-ca-client enroll -u https://orderer2:orderer2pw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer2.montadora.ciag/msp --csr.hosts orderer2.montadora.ciag --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/orderer/tls-cert.pem
  { set +x; } 2>/dev/null
  cp ${PWD}/organizations/ordererOrganizations/montadora.ciag/msp/config.yaml ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer2.montadora.ciag/msp/config.yaml

  infoln "Orderer Montadora - Generate the orderer0-tls certificates"
  mkdir -p ${PWD}/organizations/ordererOrganizations/montadora.ciag/msp/tlscacerts
  set -x
  fabric-ca-client enroll -u https://orderer0:orderer0pw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer0.montadora.ciag/tls --enrollment.profile tls --csr.hosts orderer0.montadora.ciag --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/orderer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer0.montadora.ciag/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer0.montadora.ciag/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer0.montadora.ciag/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer0.montadora.ciag/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer0.montadora.ciag/tls/keystore/* ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer0.montadora.ciag/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer0.montadora.ciag/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer0.montadora.ciag/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer0.montadora.ciag/msp/tlscacerts/tlsca.orderer0.montadora.ciag-cert.pem

  cp ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer0.montadora.ciag/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/montadora.ciag/msp/tlscacerts/tlsca.orderer0.montadora.ciag-cert.pem

  infoln "Orderer Montadora - Generate the orderer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer1:orderer1pw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer1.montadora.ciag/tls --enrollment.profile tls --csr.hosts orderer1.montadora.ciag --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/orderer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer1.montadora.ciag/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer1.montadora.ciag/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer1.montadora.ciag/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer1.montadora.ciag/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer1.montadora.ciag/tls/keystore/* ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer1.montadora.ciag/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer1.montadora.ciag/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer1.montadora.ciag/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer1.montadora.ciag/msp/tlscacerts/tlsca.orderer1.montadora.ciag-cert.pem
  cp ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer1.montadora.ciag/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/montadora.ciag/msp/tlscacerts/tlsca.orderer1.montadora.ciag-cert.pem


  infoln "Orderer Montadora - Generate the orderer2-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer2:orderer2pw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer2.montadora.ciag/tls --enrollment.profile tls --csr.hosts orderer2.montadora.ciag --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/orderer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer2.montadora.ciag/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer2.montadora.ciag/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer2.montadora.ciag/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer2.montadora.ciag/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer2.montadora.ciag/tls/keystore/* ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer2.montadora.ciag/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer2.montadora.ciag/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer2.montadora.ciag/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer2.montadora.ciag/msp/tlscacerts/tlsca.orderer2.montadora.ciag-cert.pem
  cp ${PWD}/organizations/ordererOrganizations/montadora.ciag/orderers/orderer2.montadora.ciag/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/montadora.ciag/msp/tlscacerts/tlsca.orderer2.montadora.ciag-cert.pem


  
  infoln "Orderer Montadora - Generate the admin msp"
  mkdir -p organizations/ordererOrganizations/montadora.ciag/users
  mkdir -p organizations/ordererOrganizations/montadora.ciag/users/Admin@orderer.montadora.ciag
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/montadora.ciag/users/Admin@orderer.montadora.ciag/msp --tls.certfiles ${PWD}/organizations/fabric-ca/orderer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/montadora.ciag/msp/config.yaml ${PWD}/organizations/ordererOrganizations/montadora.ciag/users/Admin@orderer.montadora.ciag/msp/config.yaml

  infoln "Orderer Montadora - Generate the user msp"
  mkdir -p organizations/ordererOrganizations/montadora.ciag/users/User@orderer.montadora.ciag
  set -x
  fabric-ca-client enroll -u https://ordererUser:ordererUserpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/montadora.ciag/users/User@orderer.montadora.ciag/msp --tls.certfiles ${PWD}/organizations/fabric-ca/orderer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/montadora.ciag/msp/config.yaml ${PWD}/organizations/ordererOrganizations/montadora.ciag/users/User@orderer.montadora.ciag/msp/config.yaml

}
