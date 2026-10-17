const http = require('http');
const PORT = process.env.PORT || 3003;
const NAME = 'orders';

const server = http.createServer((req, res) => {
  res.setHeader('Content-Type', 'application/json');
  if (req.url === '/health') {
    res.end(JSON.stringify({ service: NAME, status: 'UP', uptime: process.uptime() }));
  } else {
    res.end(JSON.stringify({ message: NAME + ' Service Running', port: Number(PORT) }));
  }
});

server.listen(PORT, '0.0.0.0', () => console.log(NAME + ' Service Running on port ' + PORT));
