const express = require('express');
const app = express();

const PORT = process.env.PORT || 3000;
const RELEASE_ID = process.env.RELEASE_ID || "dev";
const APP_POOL = process.env.APP_POOL || "blue";

let chaos = false;

app.get('/version', (req, res) => {
  res.set('X-App-Pool', APP_POOL);
  res.set('X-Release-Id', RELEASE_ID);
  res.json({ pool: APP_POOL, release: RELEASE_ID });
});

app.get('/healthz', (req, res) => {
  if (chaos) return res.status(500).send("chaos");
  res.send("ok");
});

app.post('/chaos/start', (req, res) => {
  chaos = true;
  res.send("chaos started");
});

app.post('/chaos/stop', (req, res) => {
  chaos = false;
  res.send("chaos stopped");
});

app.listen(PORT, () => {
  console.log(`App ${APP_POOL} listening on ${PORT}`);
});