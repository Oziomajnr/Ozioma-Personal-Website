---
layout:	post
title:	"Paystack Payment flow with Java , Part 1. Initializing transactions"
date:	2017-11-01
---

I recently had to implement Paystack payment into a java web application and I was impressed with the payment flow and how easy it was to implement. One part I liked so much is that you do not have to send a request after initiating payment to verify if the payment was successful instead they send you a request to verify a transaction or to notify you of its failure.

Today, I would demonstrate how to initialize a paystack transaction, and generate a payment url.

First of all, lets understand the paystack payment flow, these are the steps.

1. Register to get an api key.
2. Initialize a transaction to generate a payment url.
3. Verify the transaction.
4. **Register to get an API key.**
Go to <https://paystack.com/> register to create an account then get a test api key, it is usually of the format **sk\_test\_xxxxxxxxxxxxxxxxxxxxxxxxxx. **This key would be sent as an Authorization header when making request to the paystack api.

2. **Initialize a transaction to generate a payment url.**

To initialize a Paystack transaction, we send a post request to the paysatck api and a payment url is generated which the payer can use to pay for a product or service. To initialize the transaction, lets model our request object first, we would create a class called InitTransactionRequest.Java

this is the content of the class

we also have to model the response we would get from Paystack when we make the Api call, that response would contain the payment url that the user would be routed to to make the payment.

So since we have both the request and response lets call the api, remember we have to pass the test secret key as a Header with key Authorization and value Bearer + secret key.

so here is a method that would make the request and return the response

you would need the following dependencies for the method to work

Note: You should try to abstract you api secret key as much as possible.

So we after getting the result in our response class, we can pass the authorization url to the front end so that the user could be routed to the url.

So that is a simple demonstration on how to initialize a paystack transaction, **next **we would verify if the user has paid and apply value to the payment.

'