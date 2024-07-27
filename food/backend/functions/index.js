const functions = require('firebase-functions');
const admin = require('./firebaseAdmin');
const { deleteUserByUid } = require('./userManagement');

// Example Cloud Function to delete a user by UID
exports.deleteUser = functions.https.onRequest(async (req, res) => {
    const uid = req.query.uid; // Retrieve UID from query parameter
    if (!uid) {
        return res.status(400).send('UID is required');
    }
    try {
        await deleteUserByUid(uid);
        return res.status(200).send('User deleted successfully');
    } catch (error) {
        return res.status(500).send('Error deleting user');
    }
});
