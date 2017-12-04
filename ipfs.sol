pragma solidity ^0.4.15;

contract IPFS {
    string storedData;

    function set(string x) {
        storedData = toIPFSHash(x);
    }

    function get() constant returns (string x) {
        return fromIPFSHash(storedData);
    }

    const fromIPFSHash = hash => {
        const bytes = bs58.decode(hash);
        const multiHashId = 2;
        // remove the multihash hash id
        return bytes.slice(multiHashId, bytes.length);
    };

    const toIPFSHash = str => {
        // remove leading 0x
        const remove0x = str.slice(2, str.length);
        // add back the multihash id
        const bytes = Buffer.from(`1220${remove0x}`, "hex");
        const hash = bs58.encode(bytes);
        return hash;
    };
}