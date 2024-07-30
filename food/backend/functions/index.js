const functions = require('firebase-functions');
const admin = require('./firebaseAdmin');
const { deleteUserByUid, createUser } = require('./userManagement');

// Cloud Function to delete a user by UID
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


// cloud function to create a new user
exports.createUser = functions.https.onRequest(async (req, res) => {

    // Retrieve email and password from request body
    const {email, password} = req.body 

    if (!email || !password) {
        return res.status(400).send('Email and password are required');
    }

    try {
        const userRecord = await createUser(email, password);
        return res.status(201).send(`User created with UID: ${userRecord.uid}`);
        
    }

    catch(error) {
        return res.status(500).send(`Error creating user ${error.message}`);
    }

});