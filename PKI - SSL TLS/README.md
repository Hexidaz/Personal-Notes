# Dummy Guide to SSL using OpenSSL

## Table of Content

- [Dummy Guide to SSL using OpenSSL](#dummy-guide-to-ssl-using-openssl)
    - [Table of Content](#table-of-content)
    - [Steps to get SSL Certificate](#steps-to-get-ssl-certificate)
    - [Setting Up Root CA](#setting-up-root-ca)
    - [Setting Up Sub CA](#setting-up-sub-ca)
    - [Getting Server Certificate](#getting-server-certificate)

## Steps to get SSL Certificate

1. Generate Private Key
2. Generate CSR
3. Give CSR to CA for signing (in case of root CA, self sign the CSR)
4. Get Certificate from CA

## Setting Up Root CA

1. **Create Directory Structure**

    ```bash
    mkdir -p root-ca/{certs,db,private}
    chmod 700 root-ca/private
    touch root-ca/db/index
    openssl rand -hex 16  > root-ca/db/serial
    echo 1001 > root-ca/db/crlnumber
    ```

2. **Create Root CA Config File**

    Can be copied from this repo's [`root-ca.conf`](Example/root-ca.conf)

3. **Create Private Key**

    ```bash
    openssl genpkey -out root-ca/private/root.key \
                    -algorithm EC  \
                    -pkeyopt ec_paramgen_curve:P-384 \
                    -aes-256-cbc
    ```

    or

    ```bash
    openssl genpkey -out root-ca/private/root.key \
                    -algorithm EC  \
                    -pkeyopt ec_paramgen_curve:P-256 \
                    -aes-256-cbc
    ```

    or

    ```bash
    openssl genpkey -out root-ca/private/root.key \
                    -algorithm RSA \
                    -pkeyopt rsa_keygen_bits:4096 \
                    -aes-256-cbc
    ```

    or

    ```bash
    openssl genpkey -out root-ca/private/root.key \
                    -algorithm RSA \
                    -pkeyopt rsa_keygen_bits:2048 \
                    -aes-256-cbc
    ```

4. **Create CSR**

   ```bash
   openssl req -new -config root-ca.conf -key root-ca/private/root.key -out root-ca/root.csr
   ```

5. **Self Sign CSR**

    ```bash
    openssl ca -selfsign -config root-ca.conf -in root-ca/root.csr -out root-ca/root.crt -extensions ca_ext
    ```

    > **Notes**
    >
    > The content of `root.crt` also includes the raw text which explains the certificate. This can be deleted manually (delete everything before `-----BEGIN CERTIFICATE-----` ).

6. **CONGRATULATIONS, YOU ARE DONE**

7. Operations Done as CA

    - Generate CRL

        ```bash
        openssl ca -gencrl \
                   -config root-ca.conf \
                   -out root-ca/root.crl
        ```

        > **Notes**
        >
        > To be generated every 30 days if following example `root-ca.conf` file

    - Isssue Sub CA Certificate

        ```bash
        openssl ca -config root-ca.conf \
                   -in sub-ca/sub.csr \
                   -out sub-ca/sub.crt \
                   -extensions sub_ca_ext
        ```

        > **Notes**
        >
        > `sub-ca.csr` must be created by the Sub CA and given to Root CA for signing

    - Revoke Certificate

        ```bash
        openssl ca -config root-ca.conf \
                   -revoke root-ca/certs/1002.pem \
                   -crl_reason keyCompromise
        ```

        > **Notes**
        >
        > Value of `-crl_reason` can be one of the following: `unspecified`, `keyCompromise`, `CACompromise`, `affiliationChanged`, `superseded`, `cessationOfOperation`, `certificateHold`, or `removeFromCRL`.

## Setting Up Sub CA

1. **Create Directory Structure**

    ```bash
    mkdir -p sub-ca/{certs,db,private}
    chmod 700 sub-ca/private
    touch sub-ca/db/index
    openssl rand -hex 16  > sub-ca/db/serial
    echo 1001 > sub-ca/db/crlnumber
    ```

2. **Create Sub CA Config File**

    Can be copied from this repo's [`sub-ca.conf`](Example/sub-ca.conf)

3. **Create Private Key**

    ```bash
    openssl genpkey -out sub-ca/private/sub.key \
                    -algorithm EC  \
                    -pkeyopt ec_paramgen_curve:P-384 \
                    -aes-256-cbc
    ```

    or

    ```bash
    openssl genpkey -out sub-ca/private/sub.key \
                    -algorithm EC  \
                    -pkeyopt ec_paramgen_curve:P-256 \
                    -aes-256-cbc
    ```

    or

    ```bash
    openssl genpkey -out sub-ca/private/sub.key \
                    -algorithm RSA \
                    -pkeyopt rsa_keygen_bits:4096 \
                    -aes-256-cbc
    ```

    or

    ```bash
    openssl genpkey -out sub-ca/private/sub.key \
                    -algorithm RSA \
                    -pkeyopt rsa_keygen_bits:2048 \
                    -aes-256-cbc
    ```

4. **Create CSR**

   ```bash
   openssl req -new -config sub-ca.conf -key sub-ca/private/sub.key -out sub-ca/sub.csr
   ```

5. **Give CSR to Sub CA for Signing**

    On this step, you must give the generated CSR file to the Sub CA, Sub CA will then give you the signed certificate `sub.crt`

6. **CONGRATULATIONS, YOU ARE DONE**

7. Operations Done as Sub CA

    - Generate CRL

        ```bash
        openssl ca -gencrl \
                   -config sub-ca.conf \
                   -out sub-ca/sub.crl
        ```

        > **Notes**
        >
        > To be generated every 30 days if following example `sub-ca.conf` file

    - Isssue Server Certificate

        ```bash
        openssl ca -config sub-ca.conf \
                   -in server/server.csr \
                   -out server/server.crt \
                   -extensions server_ext
        ```

    - Revoke Certificate

        ```bash
        openssl ca -config sub-ca.conf \
                   -revoke sub-ca/certs/1002.pem \
                   -crl_reason keyCompromise
        ```

        > **Notes**
        >
        > Value of `-crl_reason` can be one of the following: `unspecified`, `keyCompromise`, `CACompromise`, `affiliationChanged`, `superseded`, `cessationOfOperation`, `certificateHold`, or `removeFromCRL`.

## Getting Server Certificate

1. **Create Private Key**

    ```bash
    openssl genpkey -out server.key \
                    -algorithm EC  \
                    -pkeyopt ec_paramgen_curve:P-384 \
                    -aes-256-cbc
    ```

    or

    ```bash
    openssl genpkey -out server.key \
                    -algorithm EC  \
                    -pkeyopt ec_paramgen_curve:P-256 \
                    -aes-256-cbc
    ```

    or

    ```bash
    openssl genpkey -out server.key \
                    -algorithm RSA \
                    -pkeyopt rsa_keygen_bits:4096 \
                    -aes-256-cbc
    ```

    or

    ```bash
    openssl genpkey -out server.key \
                    -algorithm RSA \
                    -pkeyopt rsa_keygen_bits:2048 \
                    -aes-256-cbc
    ```

2. **Generate Server Config File**

    Can be copied from this repo's [`server.conf`](Example/server.conf)

3. **Create CSR**

    ```bash
    openssl req -new -config server.conf -key server.key -out server.csr
    ```

4. **Give CSR to Sub CA for Signing**

    On this step, you must give the generated CSR file to Sub CA, Sub CA will then give you the signed certificate `server.crt`

5. **CONGRATULATIONS, YOU ARE DONE**
