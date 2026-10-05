const app = require('./app');
const eurekaClient = require('./config/eureka');

const PORT = process.env.PORT || 8083;

const server = app.listen(PORT, () => {
  console.log(`meeting microservice running on http://localhost:${PORT}`);
  console.log(`Swagger UI: http://localhost:${PORT}/swagger-ui`);
});

// Register with Eureka and start the 30s heartbeats.
eurekaClient.start(error => {
  if (error) {
    console.error('Eureka registration failed:', error);
  } else {
    console.log(`registered in Eureka as MEETING on port ${PORT}`);
  }
});

function shutdown() {
  eurekaClient.stop(() => {
    server.close(() => process.exit(0));
  });
}

process.on('SIGINT', shutdown);
process.on('SIGTERM', shutdown);
