const express = require('express');
const admin = require('firebase-admin');
const cors = require('cors');
const WebSocket = require('ws');
const http = require('http');

admin.initializeApp({
  credential: admin.credential.cert('./service-account.json'),
});
const db = admin.firestore();

const app = express();

app.use(cors({
  origin: 'website origin',
  methods: ['GET', 'POST']
}));

app.use(express.json());


app.post('/login', async (req, res) => {
  const { userId } = req.body;

  try {
    const userRef = db.collection('users').doc(userId);
    const doc = await userRef.get();

    if (!doc.exists) {
      res.status(404).send('User not found');
    } else {
      res.status(200).send('Login attempt recognized');

      // Debug: Log the 'Login attempt' message being sent to the client
      const ws = connections[userId];
      if (ws) {
        ws.send('Login attempt');
      }
    }
  } catch (error) {
    res.status(500).send('Error recognizing login attempt');
  }
});
const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

let connections = {};

wss.on('connection', (ws, req) => {
  const params = new URLSearchParams(req.url.split('?')[1]);
  const userId = params.get('userId');

  if (userId) {
    connections[userId] = ws;

    // Listen to incoming messages from the website
    ws.on('message', (message) => {
      if (message === 'login_attempt') {
        // Check if the user is logged in on the Android app
        const userRef = db.collection('users').doc(userId);
        userRef.get().then((doc) => {
          if (doc.exists) {
            const data = doc.data();
            if (data && data.loginStatus === 'approve') {
              // Send the login status back to the website
              ws.send('logged_in');
            } else {
              ws.send('logged_out');
            }
          } else {
            ws.send('logged_out');
          }
        }).catch((error) => {
          console.error('Error checking login status:', error);
          ws.send('error');
        });
      }
    });

    // Clean up WebSocket connection when closed
    ws.on('close', () => {
      delete connections[userId];
    });
  }
});

const port = process.env.PORT || 3000;
server.listen(port, () => console.log(`Server running on port ${port}`));
