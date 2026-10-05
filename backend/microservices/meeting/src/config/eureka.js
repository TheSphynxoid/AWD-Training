const Eureka = require('eureka-js-client').Eureka;

const PORT = process.env.PORT || 8083;
const EUREKA_HOST = process.env.EUREKA_HOST || 'localhost';
const EUREKA_PORT = process.env.EUREKA_PORT || 8761;

const client = new Eureka({
  instance: {
    app: 'MEETING',
    hostName: 'localhost',
    ipAddr: '127.0.0.1',
    port: PORT,
    vipAddress: 'MEETING',
    statusPageUrl: `http://localhost:${PORT}/api/meetings/hello`,
    healthCheckUrl: `http://localhost:${PORT}/api/meetings/hello`,
    dataCenterInfo: {
      '@class': 'com.netflix.appinfo.InstanceInfo$DefaultDataCenterInfo',
      name: 'MyOwn',
    },
  },
  eureka: {
    host: EUREKA_HOST,
    port: EUREKA_PORT,
    // Spring's Eureka server serves /eureka/apps/, not the /eureka/v2/apps/ default.
    servicePath: '/eureka/apps/',
  },
});

module.exports = client;
