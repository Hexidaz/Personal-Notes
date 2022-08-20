mkdir -p root-ca/{certs,db,private}
chmod 700 root-ca/private
touch root-ca/db/index
openssl rand -hex 16  > root-ca/db/serial
echo 1001 > root-ca/db/crlnumber

openssl genpkey -out root-ca/private/root.key \
                -algorithm EC  \
                -pkeyopt ec_paramgen_curve:P-384 \
                -aes-256-cbc

openssl req -new -config root-ca.conf -key root-ca/private/root.key -out root-ca/root.csr

openssl ca -selfsign -config root-ca.conf -in root-ca/root.csr -out root-ca/root.crt -extensions ca_ext





mkdir -p sub-ca/{certs,db,private}
chmod 700 sub-ca/private
touch sub-ca/db/index
openssl rand -hex 16  > sub-ca/db/serial
echo 1001 > sub-ca/db/crlnumber

openssl genpkey -out sub-ca/private/sub.key \
                -algorithm EC  \
                -pkeyopt ec_paramgen_curve:P-384 \
                -aes-256-cbc

openssl req -new -config sub-ca.conf -key sub-ca/private/sub.key -out sub-ca/sub.csr

openssl ca -config root-ca.conf \
            -in sub-ca/sub.csr \
            -out sub-ca/sub.crt \
            -extensions sub_ca_ext






openssl genpkey -out server.key \
                    -algorithm EC  \
                    -pkeyopt ec_paramgen_curve:P-384 \
                    -aes-256-cbc

openssl req -new -config server.conf -key server.key -out server.csr

openssl ca -config sub-ca.conf \
            -in server/server.csr \
            -out server/server.crt \
            -extensions server_ext