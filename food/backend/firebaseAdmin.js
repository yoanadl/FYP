
const admin = require('firebase-admin');
const path = require('path');

const serviceAccountPath = path.resolve(__dirname, 'config/fyp-goodgrit-a8601-firebase-adminsdk-kdzva-f01025aa8a.json');

const serviceAccount = require(serviceAccountPath);

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});

module.exports = admin;


