flow accounts create \
  --key "c69560acb6ff5b4db1870ec47c6f2474f862b34bb69b3508557e5733406da63cb5218bdf4ddebc525b93c8d95de1194e77cc9aec7fb0394270cea3ce2c9deee2" \
  --sig-algo "ECDSA_secp256k1" \
  --signer "emulator-account"

flow project deploy

flow transactions send ./artist/createCollection.transaction.cdc --signer="emulator-artist"

flow transactions send ./artist/print.transaction.cdc --signer="emulator-artist" \
 --args-json '[
        {   
            "type": "UInt8", 
            "value": "5"
        },
        {   
            "type": "UInt8", 
            "value": "5"
        },
        {   
            "type": "String", 
            "value": "******   **   **   ******"
        }
    ]'

flow scripts execute ./artist/displayCollection.script.cdc \
    --args-json '[
        {
            "type": "Address",
            "value": "0x01cf0e2f2f715450"
        }
    ]'