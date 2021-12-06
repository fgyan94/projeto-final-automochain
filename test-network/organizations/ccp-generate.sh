#!/bin/bash
function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $7)
    local CP=$(one_line_pem $8)
    sed -e "s/\${DOMAIN}/$1/" \
        -e "s/\${ORG}/$2/" \
        -e "s/\${P0PORT}/$3/" \
        -e "s/\${P1PORT}/$4/" \
        -e "s/\${P2PORT}/$5/" \
        -e "s/\${CAPORT}/$6/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $7)
    local CP=$(one_line_pem $8)
    sed -e "s/\${DOMAIN}/$1/" \
        -e "s/\${ORG}/$2/" \
        -e "s/\${P0PORT}/$3/" \
        -e "s/\${P1PORT}/$4/" \
        -e "s/\${P2PORT}/$5/" \
        -e "s/\${CAPORT}/$6/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

DOMAIN=montadora
ORG=Montadora
P0PORT=7051
P1PORT=7151
P2PORT=7251
CAPORT=7054
PEERPEM=organizations/peerOrganizations/montadora.ciag/tlsca/tlsca.montadora.ciag-cert.pem
CAPEM=organizations/peerOrganizations/montadora.ciag/ca/ca.montadora.ciag-cert.pem

echo "$(json_ccp $DOMAIN $ORG $P0PORT $P1PORT $P2PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/montadora.ciag/connection-montadora.json
echo "$(yaml_ccp $DOMAIN $ORG $P0PORT $P1PORT $P2PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/montadora.ciag/connection-montadora.yaml

DOMAIN=sistemista
ORG=Sistemista
P0PORT=9051
P1PORT=9151
P2PORT=9251
CAPORT=8054
PEERPEM=organizations/peerOrganizations/sistemista.ciag/tlsca/tlsca.sistemista.ciag-cert.pem
CAPEM=organizations/peerOrganizations/sistemista.ciag/ca/ca.sistemista.ciag-cert.pem

echo "$(json_ccp $DOMAIN $ORG $P0PORT $P1PORT $P2PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/sistemista.ciag/connection-sistemista.json
echo "$(yaml_ccp $DOMAIN $ORG $P0PORT $P1PORT $P2PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/sistemista.ciag/connection-sistemista.yaml
