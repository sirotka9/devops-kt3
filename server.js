const http = require('node:http');
const app = require('./app');

http.createServer(app).listen(3000, '0.0.0.0', () => {
  console.log('Server: http://localhost:3000');
});
