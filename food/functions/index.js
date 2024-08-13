/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
/*const functions = require("firebase-functions");
const stripe = require("stripe")("sk_test_51Pa6OlGwNxjo4qONO4Zv4saXl2vxxE63xn3wAbIC2e5Z3SqoD7di1bDE9yduk5f4MxuOQsXJS2UMDFIk1g6LYJrA00IzraCnlM");

exports.stripePaymentIntentRequest = functions.https.onRequest(async (req, res) => {
    try {
        let customerId;

        //Gets the customer who's email id matches the one sent by the client
        const customerList = await stripe.customers.list({
            email: req.body.email,
            limit: 1
        });
                
        //Checks the if the customer exists, if not creates a new customer
        if (customerList.data.length !== 0) {
            customerId = customerList.data[0].id;
        }
        else {
            const customer = await stripe.customers.create({
                email: req.body.email
            });
            customerId = customer.data.id;
        }

        //Creates a temporary secret key linked with the customer 
        const ephemeralKey = await stripe.ephemeralKeys.create(
            { customer: customerId },
            { apiVersion: '2020-08-27' }
        );

        //Creates a new payment intent with amount passed in from the client
        const paymentIntent = await stripe.paymentIntents.create({
            amount: parseInt(req.body.amount),
            currency: 'usd',
            customer: customerId,
        })

        res.status(200).send({
            paymentIntent: paymentIntent.client_secret,
            ephemeralKey: ephemeralKey.secret,
            customer: customerId,
            success: true,
        })
        
    } catch (error) {
        res.status(404).send({ success: false, error: error.message })
    }
});
*/
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const stripe = require('stripe')('sk_test_51Pa6OlGwNxjo4qONO4Zv4saXl2vxxE63xn3wAbIC2e5Z3SqoD7di1bDE9yduk5f4MxuOQsXJS2UMDFIk1g6LYJrA00IzraCnlM'); // Replace with your Stripe Secret Key

admin.initializeApp();

exports.createSubscription = functions.https.onRequest(async (req, res) => {
    const { customerId, priceId } = req.body; // Expecting customerId and priceId in request body

    if (!customerId || !priceId) {
        return res.status(400).send({ error: 'Missing customerId or priceId' });
    }

    try {
        const subscription = await stripe.subscriptions.create({
            customer: customerId,
            items: [{ price: priceId }],
            expand: ['latest_invoice.payment_intent'],
        });
        res.status(200).send(subscription);
    } catch (error) {
        console.error('Error creating subscription:', error);
        res.status(500).send({ error: error.message });
    }
});
