// const bool isProduction = bool.fromEnvironment('dart.vm.product');
const bool isProduction = false;

const testConfig = {
  'baseUrl': 'http://gondarpham.freeddns.org/api/',
  'blockchainNodeUrl': 'http://192.168.1.11:25100/'
};

const productionConfig = {
  'baseUrl': 'http://gondarpham.freeddns.org/',
  'blockchainNodeUrl': 'some-url.com',
};

final environment = isProduction ? productionConfig : testConfig;
