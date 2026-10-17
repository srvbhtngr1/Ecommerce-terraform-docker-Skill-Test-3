const http = require('http');
const PORT = process.env.PORT || 3000;
const SERVICES = {
  user: process.env.USER_URL || 'http://user-service:3001',
  products: process.env.PRODUCTS_URL || 'http://products-service:3002',
  orders: process.env.ORDERS_URL || 'http://orders-service:3003',
  cart: process.env.CART_URL || 'http://cart-service:3004',
};

async function status() {
  const out = {};
  await Promise.all(Object.entries(SERVICES).map(async ([name, url]) => {
    try {
      const r = await fetch(url + '/health', { signal: AbortSignal.timeout(2000) });
      out[name] = r.ok ? 'UP' : 'DOWN';
    } catch (e) { out[name] = 'DOWN'; }
  }));
  return out;
}

const page = `<!DOCTYPE html>
<html><head><meta charset="utf-8"><title>E-commerce Frontend</title>
<style>
body{font-family:Arial,sans-serif;max-width:640px;margin:60px auto;text-align:center}
h1{color:#1a7f37} li{list-style:none;margin:8px 0;font-size:18px}
.UP{color:#1a7f37;font-weight:bold}.DOWN{color:#c62828;font-weight:bold}
</style></head><body>
<h1>Frontend is Live</h1>
<p>Multi-service e-commerce app deployed with Terraform and Docker</p>
<h3>Backend services</h3><ul id="s"><li>Checking...</li></ul>
<script>
fetch('/api/status').then(r=>r.json()).then(d=>{
  document.getElementById('s').innerHTML = Object.entries(d)
   .map(([k,v])=>'<li>'+k+' service: <span class="'+v+'">'+v+'</span></li>').join('');
});
</script></body></html>`;

http.createServer(async (req, res) => {
  if (req.url === '/api/status') {
    res.setHeader('Content-Type', 'application/json');
    res.end(JSON.stringify(await status()));
  } else if (req.url === '/health') {
    res.setHeader('Content-Type', 'application/json');
    res.end(JSON.stringify({ service: 'frontend', status: 'UP' }));
  } else {
    res.setHeader('Content-Type', 'text/html');
    res.end(page);
  }
}).listen(PORT, '0.0.0.0', () => console.log('Frontend is Live on port ' + PORT));
