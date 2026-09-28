key := "developer_key"
target := "Ziffernblatt von Konstantin.prg"

watch := "fr970"

keys:
    openssl genrsa -out "{{ key }}".pem 4096
    openssl pkcs8 -topk8 -inform PEM -outform DER -in {{ key }}.pem -out {{ key }}.der -nocrypt

build:
    monkeyc -d {{ watch }} -f monkey.jungle -o "{{ target }}"  -y {{ key }}.der -w

emulate: build
    monkeydo "{{ target }}" {{ watch }}

emulator:
    connectiq &
