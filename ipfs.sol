pragma solidity ^0.4.15;

contract IPFS {
    string storedData;

    function set(string x) {
        storedData = toIPFSHash(x);
    }

    function get() constant returns (string x) {
        return fromIPFSHash(storedData);
    }

    const IPFS = require('ipfs-mini');
    const ipfs = new IPFS({host: 'ipfs.infura.io', port: 5001, protocol: 'https'});
    const randomData = "8803cf48b8805198dbf85b2e0d514320"; // random bytes for testing
    ipfs.add(randomData, (err, hash) => {
    if (err) {
        return console.log(err);
    }

    console.log(“HASH:”, hash);
    });
}