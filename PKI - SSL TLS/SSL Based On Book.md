# SSL / TLS Personal Notes

SSL / TLS are the protocol used to secure communication. It is also used widely for HTTPS traffic. OpenSSL is the Open-Source implementation of the SSL / TLS protocols. It is widely used for internet servers including HTTPS websites.

This guide based on [OpenSSL Cookbook 3rd Edition by Ivan Ristić](https://www.feistyduck.com/library/openssl-cookbook/online/).

## Table Of Content

- [SSL / TLS Personal Notes](#ssl--tls-personal-notes)
  - [Table Of Content](#table-of-content)
  - [Versions](#versions)
  - [Certificate File Extension](#certificate-file-extension)
  - [Certificate File Extension: TLDR](#certificate-file-extension-tldr)
  - [Certificate Conversion](#certificate-conversion)
  - [Algorithms](#algorithms)
  - [OpenSSL CLI](#openssl-cli)
    - [RSA](#rsa)
    - [ECDSA](#ecdsa)
  - [Lists](#lists)
  - [Private CA](#private-ca)
    - [Create Root CA](#create-root-ca)
    - [Create Sub CA](#create-sub-ca)

## Versions

At the time of writing, ***OpenSSL Version 1.1.1*** is the version that is widely used while ***OpenSSL Version 3.0*** is the newer version. For old cryptography, ***OpenSSL Version 1.0.2g*** are used for legacy support.

## Certificate File Extension

- **Binary (DER) certificate**

    Contains an X.509 certificate in its raw form, using DER ASN.1 encoding.

- **ASCII (PEM) certificate(s)**

    Contains a base64-encoded DER certificate, with `-----BEGIN CERTIFICATE-----` used as the header and `-----END CERTIFICATE-----` as the footer. Usually seen with only one certificate per file, although some programs allow more than one certificate depending on the context. For example, older Apache web server versions require the server certificate to be alone in one file, with all intermediate certificates together in another.

- Legacy OpenSSL key format

    Contains a private key in its raw form, using DER ASN.1 encoding. Historically, OpenSSL used a format based on PKCS #1. These days, if you use the proper commands (i.e., genpkey), OpenSSL defaults to PKCS #8.

- **ASCII (PEM) key**

    Contains a base64-encoded DER key, sometimes with additional metadata (e.g., the algorithm used for password protection). The text in the header and footer can differ, depending on what underlying key format is used.

- PKCS #7 certificate(s)

    A complex format designed for the transport of signed or encrypted data, defined in RFC 2315. It’s usually seen with .p7b and .p7c extensions and can include the entire certificate chain as needed. This format is supported by Java’s keytool utility.

- PKCS #8 key

    The new default format for the private key store. PKCS #8 is defined in RFC 5208. Should you need to convert from PKCS #8 to the legacy format for whatever reason, use the pkcs8 command.

- **PKCS #12 (PFX) key and certificate(s)**

    A complex format that can store and protect a server key along with an entire certificate chain. It’s commonly seen with .p12 and .pfx extensions. This format is commonly used in Microsoft products, but is also used for client certificates. These days, the PFX name is used as a synonym for PKCS #12, even though PFX referred to a different format a long time ago (an early version of PKCS #12). It’s unlikely that you’ll encounter the old version anywhere.

## Certificate File Extension: TLDR

- DER = raw
- PEM = base-64 encoded DER
- P12 = complex format, mostly used by Microsoft's product

## Certificate Conversion

- **PEM to DER Conversion**

    ```bash
    openssl x509 -inform PEM -in fd.pem -outform DER -out fd.der
    ```

- **DER to PEM Conversion**

    ```bash
    openssl x509 -inform DER -in fd.der -outform PEM -out fd.pem
    ```

    The syntax is identical if you need to convert private keys between DER and PEM formats, but different commands are used: rsa for RSA keys, and dsa for DSA keys. If you’re dealing with the new PKCS #8 format, use the pkey tool.

- **PEM to PKCS #12 (p12) Conversion**

    The following example converts a key (fd.key), certificate (fd.crt), and intermediate certificates (fd-chain.crt) into an equivalent single PKCS #12 file:

    ```bash
    openssl pkcs12 -export \
                   -name "My Certificate" \
                   -out fd.p12 \
                   -inkey fd.key \
                   -in fd.crt \
                   -certfile fd-chain.crt
    ```

- **PKCS #12 to PEM Conversion**

    > **!!! WARNING !!!**</span>
    >
    > The command below will have the output of individual key, certificate, and intermediate certificate files in one file. You can manually split it or use the other command to split it for you.

    ```bash
    openssl pkcs12 -in fd.p12 -out fd.pem -nodes
    ```

    This command will have seperate files for the output

    ```bash
    openssl pkcs12 -in fd.p12 -nocerts -out fd.key -nodes
    openssl pkcs12 -in fd.p12 -nokeys -clcerts -out fd.crt
    openssl pkcs12 -in fd.p12 -nokeys -cacerts -out fd-chain.crt
    ```

- **PEM to PKCS #7 Conversion**

    ```bash
    openssl crl2pkcs7 -nocrl -out fd.p7b -certfile fd.crt -certfile fd-chain.crt
    ```

- **PKCS #7 to PEM Conversion**

    > **!!! WARNING !!!**</span>
    >
    > The command below will have the output of individual key, certificate, and intermediate certificate files in one file. You can manually split it or use the other command to split it for you.

    ```bash
    openssl pkcs7 -in fd.p7b -print_certs -out fd.pem
    ```

    This command will have seperate files for the output

    ```bash
    openssl pkcs7 -in fd.p12 -nocerts -out fd.key -nodes
    openssl pkcs7 -in fd.p12 -nokeys -clcerts -out fd.crt
    openssl pkcs7 -in fd.p12 -nokeys -cacerts -out fd-chain.crt
    ```

## Algorithms

**RSA** is the algorithm commonly used for web server certificate. Key size of 2048 and exponent of 65537 are considered secure but now adays Key size of 4096 and exponent of 65537 are used. In the past, Let's Encrypt use RSA for its algorithm.

**ECDSA** is the newer algorithm and also commonly used for web server certificate. Key size of 256 are considered secure but usually certificate provider will use Key size of 384. Let's Encrypt currently uses ECDSA for its algorithm.

Other algorithm such as **DSA** is obsolte, and **EdDSA** is not yet widely supported.

## OpenSSL CLI

### RSA

1. **Generate Private Key**

    ```bash
    openssl genpkey -out fd.key \
                    -algorithm RSA \
                    -pkeyopt rsa_keygen_bits:4096 \
                    -aes-256-cbc
    ```

2. **Check Key Content**

    ```bash
    openssl pkey -in fd.key -text -noout
    ```

3. **Extract Public Key**

    ```bash
    openssl pkey -in fd.key -pubout -out fd-public.key
    ```

4. **Generate CSR (Certificate Signing Request)**

    ```bash
    openssl req -new -key fd.key -out fd.csr
    ```

    - **Generate CSR from Certificate [Optional]**

        > **Notes**
        >
        > Usually used for renewing certificate.

        ```bash
        openssl x509 -x509toreq -in fd.crt -out fd.csr -signkey fd.key
        ```

    - **Unattended CSR Generation**

        Meant for automated CSR Generation with no user prompt

        ```bash
        openssl req -new -config fd.cnf -key fd.key -out fd.csr
        ```

        Content of `fd.cnf`

        ```conf
        [req]
        prompt = no
        distinguished_name = dn
        req_extensions = ext
        input_password = PASSPHRASE

        [dn]
        CN = www.feistyduck.com
        emailAddress = webmaster@feistyduck.com
        O = Feisty Duck Ltd
        L = London
        C = GB

        [ext]
        subjectAltName = DNS:www.feistyduck.com,DNS:feistyduck.com
        ```

5. **Check CSR Content**

    ```bash
    openssl req -text -in fd.csr -noout
    ```

6. **Signing Certificate**

    This is an example of self-signing a certificate.

    ```bash
    openssl x509 -req -days 365 -in fd.csr -signkey fd.key -out fd.crt
    ```

    - **Multi Domain Name Certificate**

        ```bash
        openssl x509 -req -days 365 -in fd.csr -signkey fd.key -out fd.crt -extfile fd.ext
        ```

        Content of `fd.ext`

        ```text
        subjectAltName = DNS:*.feistyduck.com, DNS:feistyduck.com
        ```

7. **Check Certificate**

    ```bash
    openssl x509 -text -in fd.crt -noout
    ```

### ECDSA

1. **Generate Private Key**

    ```bash
    openssl genpkey -out fd.key \
                    -algorithm EC  \
                    -pkeyopt ec_paramgen_curve:P-384 \
                    -aes-256-cbc
    ```

    > **Notes**
    >
    > `P-384` can be changed to anything listed on `openssl ecparam -list_curves`

2. **Check Key Content**

    ```bash
    openssl pkey -in fd.key -text -noout
    ```

3. **Extract Public Key**

    ```bash
    openssl pkey -in fd.key -pubout -out fd-public.key
    ```

4. **Generate CSR (Certificate Signing Request)**

    ```bash
    openssl req -new -key fd.key -out fd.csr
    ```

    - **Generate CSR from Certificate [Optional]**

        > **Notes**
        >
        > Usually used for renewing certificate.

        ```bash
        openssl x509 -x509toreq -in fd.crt -out fd.csr -signkey fd.key
        ```

    - **Unattended CSR Generation**

        Meant for automated CSR Generation with no user prompt

        ```bash
        openssl req -new -config fd.cnf -key fd.key -out fd.csr
        ```

        Content of `fd.cnf`

        ```conf
        [req]
        prompt = no
        distinguished_name = dn
        req_extensions = ext
        input_password = PASSPHRASE

        [dn]
        CN = www.feistyduck.com
        emailAddress = webmaster@feistyduck.com
        O = Feisty Duck Ltd
        L = London
        C = GB

        [ext]
        subjectAltName = DNS:www.feistyduck.com,DNS:feistyduck.com
        ```

5. **Check CSR Content**

    ```bash
    openssl req -text -in fd.csr -noout
    ```

6. **Signing Certificate**

    This is an example of self-signing a certificate.

    ```bash
    openssl x509 -req -days 365 -in fd.csr -signkey fd.key -out fd.crt
    ```

    - **Multi Domain Name Certificate**

        ```bash
        openssl x509 -req -days 365 -in fd.csr -signkey fd.key -out fd.crt -extfile fd.ext
        ```

        Content of `fd.ext`

        ```text
        subjectAltName = DNS:*.feistyduck.com, DNS:feistyduck.com
        ```

7. **Check Certificate**

    ```bash
    openssl x509 -text -in fd.crt -noout
    ```

## Lists

1. Cipher Lists

    ```bash
    openssl enc -list
    ```

2. ECDSA Curves List

    ```bash
    openssl ecparam -list_curves
    ```

3. List of suites

    ```bash
    openssl ciphers -s -tls1_2 -v 'ALL:COMPLEMENTOFALL @SECLEVEL=3'
    ```

    > **Notes**
    >
    > `@SECLEVEL` of 2 is considered secure, 5 is maximum
    >
    > Each line of output provides extended information on one suite. From left to right:
    >
    > 1. Suite name
    > 2. Required minimum protocol version  
    > (Some suites on the list show SSLv3 in the protocol column. This is nothing to worry about. It only means that the suite is compatible with this old (and obsolete) protocol version. Your configuration will not downgrade to SSL 3.0 if these suites are used.)
    > 3. Key exchange algorithm
    > 4. Authentication algorithm
    > 5. Encryption algorithm and strength
    > 6. MAC (integrity) algorithm

    **Recommended Suites**

    ```text
    TLS_AES_128_GCM_SHA256
    TLS_CHACHA20_POLY1305_SHA256
    TLS_AES_256_GCM_SHA384

    ECDHE-ECDSA-AES128-GCM-SHA256
    ECDHE-ECDSA-CHACHA20-POLY1305
    ECDHE-ECDSA-AES256-GCM-SHA384
    ECDHE-ECDSA-AES128-SHA
    ECDHE-ECDSA-AES256-SHA
    ECDHE-ECDSA-AES128-SHA256
    ECDHE-ECDSA-AES256-SHA384
    ECDHE-RSA-AES128-GCM-SHA256
    ECDHE-RSA-CHACHA20-POLY1305
    ECDHE-RSA-AES256-GCM-SHA384
    ECDHE-RSA-AES128-SHA
    ECDHE-RSA-AES256-SHA
    ECDHE-RSA-AES128-SHA256
    ECDHE-RSA-AES256-SHA384
    DHE-RSA-AES128-GCM-SHA256
    DHE-RSA-CHACHA20-POLY1305
    DHE-RSA-AES256-GCM-SHA384
    DHE-RSA-AES128-SHA
    DHE-RSA-AES256-SHA
    DHE-RSA-AES128-SHA256
    DHE-RSA-AES256-SHA256
    ```

    **Keywords**

    | Group Keyword | Meaning |
    |---|---|
    | DEFAULT | The default cipher list. This is determined at compile time and must be the first cipher string specified. |
    | COMPLEMENTOFDEFAULT | The ciphers included in ALL, but not enabled by default. Note that this rule does not cover eNULL, which is not included by ALL (use COMPLEMENTOFALL if necessary). |
    | ALL | All cipher suites except the eNULL ciphers, which must be explicitly enabled. |
    | COMPLEMENTOFALL | The cipher suites not enabled by ALL, currently eNULL. |
    | HIGH | “High”-encryption cipher suites. This currently means those with key lengths larger than 128 bits, and some cipher suites with 128-bit keys. |
    | MEDIUM | “Medium”-encryption cipher suites, currently some of those using 128-bit encryption. |
    | LOW | “Low”-encryption cipher suites, currently those using 64- or 56-bit encryption algorithms, but excluding export cipher suites. No longer supported. Insecure. |
    | EXP, EXPORT | Export encryption algorithms. Including 40- and 56-bit algorithms. No longer supported. Insecure. |
    | EXPORT40 | 40-bit export encryption algorithms. No longer supported. Insecure. |
    | EXPORT56 | 56-bit export encryption algorithms. No longer supported. Insecure. |
    | TLSv1.2, TLSv1.0, TLSv1, SSLv3, SSLv2 | Cipher suites that require the specified protocol version. There are two keywords for TLS 1.0 and no keywords for TLS 1.3 and TLS 1.1. These keywords do not affect protocol configuration, just the suites. |

    | Digest Keyword | Meaning |
    |---|---|
    | MD5 | Cipher suites using MD5. Obsolete and insecure. |
    | SHA, SHA1 | Cipher suites using SHA1. |
    | SHA256 | Cipher suites using SHA256. |
    | SHA384 | Cipher suites using SHA384. |

    | Authentication Keyword | Meaning |
    |---|---|
    | aDH | Cipher suites effectively using DH authentication, i.e., the certificates carry DH keys. Removed in 1.1.0. |
    | aDSS, DSS | Cipher suites using DSS authentication, i.e., the certificates carry DSS keys. |
    | aECDH | Cipher suites that use ECDH authentication. Removed in 1.1.0. |
    | aECDSA, ECDSA | Cipher suites that use ECDSA authentication.  |
    | aNULL | Cipher suites offering no authentication. This is currently the anonymous DH algorithms. Insecure. |
    | aRSA | Cipher suites using RSA authentication, i.e., the certificates carry RSA keys. |
    | aPSK | Cipher suites using PSK (Pre-Shared Key) authentication. |
    | aSRP | Cipher suites using SRP (Secure Remote Password) authentication. |

    | Key Exchange Keyword | Meaning |
    |---|---|
    | ADH | Anonymous DH cipher suites. Insecure. |
    | AECDH | Anonymous ECDH cipher suites. Insecure.  |
    | DHE, EDH | Cipher suites using ephemeral DH key agreement only. |
    | ECDHE, EECDH | Cipher suites using ephemeral ECDH. |
    | kDHE, kEDH, DH | Cipher suites using ephemeral DH key agreement (includes anonymous DH). |
    | kECDHE, kEECDH, ECDH | Cipher suites using ephemeral ECDH key agreement (includes anonymous ECDH). |
    | kRSA, RSA | Cipher suites using RSA key exchange. |
    | kPSK, kECDHEPSK, kDHEPSK, kRSAPSK | Cipher suites using PSK key exchange. |

    | Cipher Keyword | Meaning |
    |---|---|
    | AES, AESCCM, AESCCM8, AESGCM | Cipher suites using AES, AES CCM, and AES GCM. |
    | ARIA, ARIA128, ARIA256 | Cipher suites using ARIA. |
    | CAMELLIA, CAMELLIA128, CAMELLIA256 | Cipher suites using Camellia. Obsolete. |
    | CHACHA20 | Cipher suites using ChaCha20. |
    | eNULL, NULL | Cipher suites that don’t use encryption. Insecure. |
    | IDEA | Cipher suites using IDEA. Obsolete. |
    | SEED | Cipher suites using SEED. Obsolete. |
    | 3DES, DES, IDEA, RC2, RC4 | No longer supported by default. Obsolete and insecure. |

    | Misc. Keyword | Meaning |
    |---|---|
    | @SECLEVEL | Configures the security level, which sets minimum security requirements. |
    | @STRENGTH | Sorts the current cipher suite list in order of encryption algorithm key length. |
    | aGOST | Cipher suites using GOST R 34.10 (either 2001 or 94) for authentication. Requires a GOST-capable engine. |
    | aGOST01 | Cipher suites using GOST R 34.10-2001 authentication. |
    | aGOST94 | Cipher suites using GOST R 34.10-94 authentication. Obsolete. Use GOST R 34.10-2001 instead. |
    | kGOST | Cipher suites using VKO 34.10 key exchange, specified in RFC 4357. |
    | GOST94 | Cipher suites using HMAC based on GOST R 34.11-94. |
    | GOST89MAC | Cipher suites using GOST 28147-89 MAC instead of HMAC. |
    | PSK | Cipher suites using PSK in any capacity. |

4. **Processing Speed Benchmark**

    ```bash
    openssl speed -evp rsa ecdsa
    ```

    > `-evp` enables hardware accelleration

## Private CA

### Create Root CA

1. Create Config File named `root-ca.conf`

    ```conf
    [default]
    name                    = root-ca
    domain_suffix           = example.com
    aia_url                 = http://$name.$domain_suffix/$name.crt
    crl_url                 = http://$name.$domain_suffix/$name.crl
    ocsp_url                = http://ocsp.$name.$domain_suffix:9080
    default_ca              = ca_default
    name_opt                = utf8,esc_ctrl,multiline,lname,align

    [ca_dn]
    countryName             = "GB"
    organizationName        = "Example"
    commonName              = "Root CA"



    [ca_default]
    home                    = .
    database                = $home/db/index
    serial                  = $home/db/serial
    crlnumber               = $home/db/crlnumber
    certificate             = $home/$name.crt
    private_key             = $home/private/$name.key
    RANDFILE                = $home/private/random
    new_certs_dir           = $home/certs
    unique_subject          = no
    copy_extensions         = none
    default_days            = 3650
    default_crl_days        = 365
    default_md              = sha256
    policy                  = policy_c_o_match

    [policy_c_o_match]
    countryName             = match
    stateOrProvinceName     = optional
    organizationName        = match
    organizationalUnitName  = optional
    commonName              = supplied
    emailAddress            = optional



    [req]
    default_bits            = 4096
    encrypt_key             = yes
    default_md              = sha256
    utf8                    = yes
    string_mask             = utf8only
    prompt                  = no
    distinguished_name      = ca_dn
    req_extensions          = ca_ext

    [ca_ext]
    basicConstraints        = critical,CA:true
    keyUsage                = critical,keyCertSign,cRLSign
    subjectKeyIdentifier    = hash



    [sub_ca_ext]
    authorityInfoAccess     = @issuer_info
    authorityKeyIdentifier  = keyid:always
    basicConstraints        = critical,CA:true,pathlen:0
    crlDistributionPoints   = @crl_info
    extendedKeyUsage        = clientAuth,serverAuth
    keyUsage                = critical,keyCertSign,cRLSign
    nameConstraints         = @name_constraints
    subjectKeyIdentifier    = hash

    [crl_info]
    URI.0                   = $crl_url

    [issuer_info]
    caIssuers;URI.0         = $aia_url
    OCSP;URI.0              = $ocsp_url

    [name_constraints]
    permitted;DNS.0=example.com
    permitted;DNS.1=example.org
    excluded;IP.0=0.0.0.0/0.0.0.0
    excluded;IP.1=0:0:0:0:0:0:0:0/0:0:0:0:0:0:0:0



    [ocsp_ext]
    authorityKeyIdentifier  = keyid:always
    basicConstraints        = critical,CA:false
    extendedKeyUsage        = OCSPSigning
    keyUsage                = critical,digitalSignature
    subjectKeyIdentifier    = hash
    ```

2. **Create Directory Structure**

    ```bash
    mkdir root-ca
    cd root-ca
    mkdir certs db private
    chmod 700 private
    touch db/index
    openssl rand -hex 16  > db/serial
    echo 1001 > db/crlnumber
    ```

    **Directory Explanation:**

    - **certs/**  
    Certificate storage; new certificates will be placed here as they are issued.

    - **db/**  
    This directory is used for the certificate database (index) and the files that hold the next certificate and CRL serial numbers. OpenSSL will create some additional files as needed.

    - **private/**  
    This directory will store the private keys, one for the CA and the other for the OCSP responder. It’s important that no other user has access to it. (In fact, if you’re going to be serious about the CA, the machine on which the root material is stored should have only a minimal number of user accounts.)

    > **Notes**
    >
    > When creating a new CA certificate, it’s important to initialize the certificate serial numbers with a random number generator, as I do in this section. This is very useful if you ever end up creating and deploying multiple CA certificates with the same distinguished name (common if you make a mistake and need to start over); conflicts will be avoided, because the certificates will have different serial numbers.

3. **Generate Private Key and CSR, then self-signed**

    ```bash
    openssl req -new \
                -config root-ca.conf \
                -out root-ca.csr \
                -keyout private/root-ca.key
    ```

    ```bash
    openssl ca -selfsign \
                -config root-ca.conf \
                -in root-ca.csr \
                -out root-ca.crt \
                -extensions ca_ext
    ```

4. **Database Data Structure**

    Database file is located at `db/index`. Database containes data about signed certificate.

    > **Data Structure Explanation**
    >
    > 1. Status flag (V for valid, R for revoked, E for expired)
    > 2. Expiration date (in YYMMDDHHMMSSZ format)
    > 3. Revocation date or empty if not revoked
    > 4. Serial number (hexadecimal)
    > 5. File location or unknown if not known
    > 6. Distinguished name

5. **Root CA Operations**

    - **Generate CRL**

        ```bash
        openssl ca -gencrl \
                   -config root-ca.conf \
                   -out root-ca.crl
        ```

    - **Isssue Certificate**

        ```bash
        openssl ca -config root-ca.conf \
                   -in sub-ca.csr \
                   -out sub-ca.crt \
                   -extensions sub_ca_ext
        ```

    - **Revoke Certificate**

        ```bash
        openssl ca -config root-ca.conf \
                   -revoke certs/1002.pem \
                   -crl_reason keyCompromise
        ```

        > Notes
        >
        > Value of `-crl_reason` can be one of the following: `unspecified`, `keyCompromise`, `CACompromise`, `affiliationChanged`, `superseded`, `cessationOfOperation`, `certificateHold`, or `removeFromCRL`.

6. **OCSP Setup**

    1. **Create OCSP Key and CSR**

        ```bash
        openssl req -new \
                    -newkey rsa:2048 \
                    -subj "/C=GB/O=Example/CN=OCSP Root Responder" \
                    -keyout private/root-ocsp.key \
                    -out root-ocsp.csr
        ```

    2. **Use Root CA to create Certificate for OCSP**

        ```bash
        openssl ca -config root-ca.conf \
                   -in root-ocsp.csr \
                   -out root-ocsp.crt \
                   -extensions ocsp_ext \
                   -days 30
        ```

        > **Notes**
        >
        > OCSP certificate cannot be revoked due to it not having revocation information. Due to this it is best to make the Certificate life as short as possible.

    3. **Test OCSP Responder**

        Start OCSP Server

        ```bash
        openssl ocsp -port 9080
                     -index db/index \
                     -rsigner root-ocsp.crt \
                     -rkey private/root-ocsp.key \
                     -CA root-ca.crt \
                     -text
        ```

        Test the operation

        ```bash
        openssl ocsp -issuer root-ca.crt \
                     -CAfile root-ca.crt \
                     -cert root-ocsp.crt \
                     -url http://127.0.0.1:9080
        ```

        > **Notes**
        >
        > `verify OK` means that the signatures were correctly verified, and `good` means that the certificate hasn’t been revoked.

### Create Sub CA

1. Create Config File named `sub-ca.conf`

    ```conf
    [default]
    name                    = sub-ca
    domain_suffix           = example.com
    aia_url                 = http://$name.$domain_suffix/$name.crt
    crl_url                 = http://$name.$domain_suffix/$name.crl
    ocsp_url                = http://ocsp.$name.$domain_suffix:9081
    default_ca              = ca_default
    name_opt                = utf8,esc_ctrl,multiline,lname,align

    [ca_dn]
    countryName             = "GB"
    organizationName        = "Example"
    commonName              = "Sub CA"



    [ca_default]
    home                    = .
    database                = $home/db/index
    serial                  = $home/db/serial
    crlnumber               = $home/db/crlnumber
    certificate             = $home/$name.crt
    private_key             = $home/private/$name.key
    RANDFILE                = $home/private/random
    new_certs_dir           = $home/certs
    unique_subject          = no
    copy_extensions         = copy
    default_days            = 365
    default_crl_days        = 30
    default_md              = sha256
    policy                  = policy_c_o_match

    [policy_c_o_match]
    countryName             = match
    stateOrProvinceName     = optional
    organizationName        = match
    organizationalUnitName  = optional
    commonName              = supplied
    emailAddress            = optional



    [req]
    default_bits            = 4096
    encrypt_key             = yes
    default_md              = sha256
    utf8                    = yes
    string_mask             = utf8only
    prompt                  = no
    distinguished_name      = ca_dn
    req_extensions          = ca_ext

    [ca_ext]
    basicConstraints        = critical,CA:true
    keyUsage                = critical,keyCertSign,cRLSign
    subjectKeyIdentifier    = hash



    [sub_ca_ext]
    authorityInfoAccess     = @issuer_info
    authorityKeyIdentifier  = keyid:always
    basicConstraints        = critical,CA:true,pathlen:0
    crlDistributionPoints   = @crl_info
    extendedKeyUsage        = clientAuth,serverAuth
    keyUsage                = critical,keyCertSign,cRLSign
    nameConstraints         = @name_constraints
    subjectKeyIdentifier    = hash

    [crl_info]
    URI.0                   = $crl_url

    [issuer_info]
    caIssuers;URI.0         = $aia_url
    OCSP;URI.0              = $ocsp_url

    [name_constraints]
    permitted;DNS.0=example.com
    permitted;DNS.1=example.org
    excluded;IP.0=0.0.0.0/0.0.0.0
    excluded;IP.1=0:0:0:0:0:0:0:0/0:0:0:0:0:0:0:0



    [ocsp_ext]
    authorityKeyIdentifier  = keyid:always
    basicConstraints        = critical,CA:false
    extendedKeyUsage        = OCSPSigning
    keyUsage                = critical,digitalSignature
    subjectKeyIdentifier    = hash



    [server_ext]
    authorityInfoAccess     = @issuer_info
    authorityKeyIdentifier  = keyid:always
    basicConstraints        = critical,CA:false
    crlDistributionPoints   = @crl_info
    extendedKeyUsage        = clientAuth,serverAuth
    keyUsage                = critical,digitalSignature,keyEncipherment
    subjectKeyIdentifier    = hash

    [client_ext]
    authorityInfoAccess     = @issuer_info
    authorityKeyIdentifier  = keyid:always
    basicConstraints        = critical,CA:false
    crlDistributionPoints   = @crl_info
    extendedKeyUsage        = clientAuth
    keyUsage                = critical,digitalSignature
    subjectKeyIdentifier    = hash
    ```

2. **Generate Private Key and CSR, then use Root CA to Sign Certificate**

    ```bash
    openssl req -new -config sub-ca.conf \
                     -out sub-ca.csr \
                     -keyout private/sub-ca.key
    ```

    ```bash
    openssl ca -config root-ca.conf \
               -in sub-ca.csr \
               -out sub-ca.crt \
               -extensions sub_ca_ext
    ```

3. **Sub CA Operations**

    - **Generate CRL**

        ```bash
        openssl ca -gencrl \
                   -config sub-ca.conf \
                   -out sub-ca.crl
        ```

    - **Isssue Server Certificate**

        ```bash
        openssl ca -config sub-ca.conf \
                   -in server.csr \
                   -out server.crt \
                   -extensions server_ext
        ```

    - **Isssue Client Certificate**

        ```bash
        openssl ca -config sub-ca.conf \
                   -in client.csr \
                   -out client.crt \
                   -extensions client_ext
        ```

    - **Revoke Certificate**

        ```bash
        openssl ca -config sub-ca.conf \
                   -revoke certs/1002.pem \
                   -crl_reason keyCompromise
        ```

        > Notes
        >
        > Value of `-crl_reason` can be one of the following: `unspecified`, `keyCompromise`, `CACompromise`, `affiliationChanged`, `superseded`, `cessationOfOperation`, `certificateHold`, or `removeFromCRL`.

4. **OCSP Setup**

    1. **Create OCSP Key and CSR**

        ```bash
        openssl req -new \
                    -newkey rsa:2048 \
                    -subj "/C=GB/O=Example/CN=OCSP Root Responder" \
                    -keyout private/sub-ocsp.key \
                    -out sub-ocsp.csr
        ```

    2. **Use Root CA to create Certificate for OCSP**

        ```bash
        openssl ca -config root-ca.conf \
                   -in root-ocsp.csr \
                   -out root-ocsp.crt \
                   -extensions ocsp_ext \
                   -days 30
        ```

        > **Notes**
        >
        > OCSP certificate cannot be revoked due to it not having revocation information. Due to this it is best to make the Certificate life as short as possible.

    3. **Test OCSP Responder**

        Start OCSP Server

        ```bash
        openssl ocsp -port 9081
                     -index db/index \
                     -rsigner root-ocsp.crt \
                     -rkey private/root-ocsp.key \
                     -CA root-ca.crt \
                     -text
        ```

        Test the operation

        ```bash
        openssl ocsp -issuer root-ca.crt \
                     -CAfile root-ca.crt \
                     -cert root-ocsp.crt \
                     -url http://127.0.0.1:9081
        ```

        > **Notes**
        >
        > `verify OK` means that the signatures were correctly verified, and `good` means that the certificate hasn’t been revoked.
