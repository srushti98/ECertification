module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
       gas: 4700000,
       gasPrice : 0,
      network_id: "*" // Match any network id
    }
  }
};
