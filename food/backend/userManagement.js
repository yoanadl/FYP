const admin = require('./firebaseAdmin');
const { getFirestore } = require('firebase-admin/firestore');

// initialize firebase admin SDK
const auth = admin.auth();
const db = getFirestore();

// function to delete a user by UID
async function deleteUserByUid(uid) {
    try {
        // delete user from firebase auth
        await auth.deleteUser(uid);
        console.log('Successfully deleted user: ', uid);

        // delete user's document from firestore
        await deleteUserDocument(uid);
        console.log('User and Firestore document deleted successfully');
    } catch (error) {
        console.error('Error deleting user: ', error);
        throw new Error('Error deleting user');
    }
}

// Helper function to delete a user's document and associated data
async function deleteUserDocument(uid) {
    const userDocRef = db.collection('users').doc(uid);

    // Delete the user document
    await userDocRef.delete();

    // Optionally, delete subcollections if they exist
    const subcollections = await userDocRef.listCollections();
    for (const collection of subcollections) {
        const snapshot = await collection.get();
        snapshot.forEach(doc => doc.ref.delete());
    }
}

module.exports = {
    deleteUserByUid,
};
