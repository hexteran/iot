rm -r /etc/sawtooth/n3/data && mkdir /etc/sawtooth/n3/data &&
rm /etc/sawtooth/path.toml &&
cp /etc/sawtooth/path3.toml /etc/sawtooth/path.toml

#sawset genesis --key $HOME/.sawtooth/keys/root.priv -o config-genesis.batch
#sawset proposal create --key $HOME/.sawtooth/keys/root.priv -o config.batch sawtooth.consensus.algorithm.name=PoET sawtooth.consensus.algorithm.version=0.1 sawtooth.poet.report_public_key_pem="$(cat /etc/sawtooth/simulator_rk_pub.pem)" sawtooth.poet.valid_enclave_measurements=$(poet enclave measurement) sawtooth.poet.valid_enclave_basenames=$(poet enclave basename)
#poet registration create --key /etc/sawtooth/keys/validator.priv -o poet.batch
#sawset proposal create --key $HOME/.sawtooth/keys/root.priv -o poet-settings.batch sawtooth.poet.target_wait_time=5 sawtooth.poet.initial_wait_time=25 sawtooth.publisher.max_batches_per_block=100
#sleep 10
#sawadm genesis config-genesis.batch config.batch poet.batch poet-settings.batch
settings-tp -vv --connect tcp://localhost:4004 &
poet-engine -vv --connect tcp://localhost:5050 --component tcp://localhost:4004 &
poet-validator-registry-tp --connect tcp://localhost:4004 &
intkey-tp-python -vv  --connect tcp://localhost:4004 &
sawtooth-rest-api -vv --connect tcp://localhost:4004 --bind 192.168.0.22:8008 &
sawtooth-validator -vv --peering static --bind network:tcp://eth0:8800 --endpoint tcp://192.168.0.22:8800 --peers tcp://192.168.0.21:8800 tcp://192.168.0.20:8800 --network-auth trust

