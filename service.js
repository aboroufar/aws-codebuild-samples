const express = require('express');
const calc = require('./calculator.js');
const numeral = require('numeral');
const path = require('path');

const PORT = process.env.PORT || 8080;
const HOST = '0.0.0.0';

const app = express();

const USE_CACHE = process.env.USE_CACHE === 'true';
const REDIS_HOST = process.env.REDIS_HOST || 'localhost';
const REDIS_PORT = process.env.REDIS_PORT || 6379;

function createCache() {
  if (USE_CACHE) {
    const client = require('redis').createClient(REDIS_PORT, REDIS_HOST, {
      connect_timeout: 500,
    });

    client.on('error', function (err) {
      console.error('Redis Client Error:', err);
    });

    const cache = require('express-redis-cache')({
      client: client,
      expire: 60,
    });

    cache.on('message', (message) => console.log('cache', message));
    cache.on('error', (error) => console.error('cache', error));

    return cache;
  }
  return null;
}

const cache = createCache();

function cacheRoute() {
  if (cache) {
    return cache.route();
  }
  return function (req, res, next) {
    next();
  };
}

function parseA(req) {
  return numeral(req.query.a).value();
}

function parseB(req) {
  return numeral(req.query.b).value();
}

function sendResult(value, res) {
  const formattedValue = numeral(value).format('0,0[.]0[00000000000000000]');
  res.setHeader('content-type', 'text/plain');
  res.send(formattedValue);
}

app.use(function (req, res, next) {
  res.header('Access-Control-Allow-Origin', '*');
  next();
});

app.get('/', function (req, res) {
  res.sendFile(path.join(__dirname, 'index.html'));
});

app.get('/add', cacheRoute(), function (req, res) {
  const a = parseA(req);
  const b = parseB(req);
  sendResult(calc.add(a, b), res);
});

app.get('/subtract', cacheRoute(), function (req, res) {
  const a = parseA(req);
  const b = parseB(req);
  sendResult(calc.subtract(a, b), res);
});

app.get('/multiply', cacheRoute(), function (req, res) {
  const a = parseA(req);
  const b = parseB(req);
  sendResult(calc.multiply(a, b), res);
});

app.get('/divide', cacheRoute(), function (req, res) {
  const a = parseA(req);
  const b = parseB(req);
  sendResult(calc.divide(a, b), res);
});

// Run HTTP listener only if executed directly via Node.js
if (require.main === module) {
  const server = app.listen(PORT, HOST, () => {
    console.log(`Calculator service listening on http://${HOST}:${PORT}`);
  });

  server.on('close', function () {
    if (cache && cache.client) {
      cache.client.end(true);
    }
  });
}

module.exports = app;