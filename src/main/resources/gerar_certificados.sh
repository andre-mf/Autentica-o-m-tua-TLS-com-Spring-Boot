#!/bin/bash
# Gerar o Keystore do Servidor
keytool -genkeypair -alias server -keyalg RSA -keysize 2048 -keystore server-keystore.jks -validity 3650

# Gerar o Keystore do Cliente
keytool -genkeypair -alias client -keyalg RSA -keysize 2048 -keystore client-keystore.jks -validity 3650

# Exportar Certificado do Cliente
keytool -export -alias client -keystore client-keystore.jks -file client-cert.cer

# Importar Certificado do Cliente no Truststore do Servidor
keytool -import -alias client -file client-cert.cer -keystore server-truststore.jks