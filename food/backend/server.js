const express = require('express');
const bodyParser = require('body-parser');
const {deleteUserByUid} = require('./userManagement');

const app = express();
const port = process.env.PORT || 3000;

app.use(bodyParser.json());

// root route 
app.get('/', (req, res) => {
    res.send('Server is running');
});

// endpoint to delete a user by UID
app.delete('/deleteUser/:uid', async (req, res) => {
    const { uid } = req.params;
    try {
        await deleteUserByUid(uid);
        res.status(200).send('User deleted successfully');
    }

    catch (error) {
        res.status(500).send('Error deleting user');
    }
});



app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});