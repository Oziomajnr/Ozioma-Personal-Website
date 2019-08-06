---
layout:	post
title:	"Paystack Payment flow with Java , Part 2. Verifying payments."
date:	2017-11-07
---

From my previous article on
 [Initializing paystack transaction](https://medium.com/@Oziomajnr/paystack-payment-flow-with-java-part-1-initializing-transactions-9876c99c9a9f) 
 we initialized a transaction and got a payment url for the user to make payment using paystack, 
 today we would verify if the user has completed his payment.

To verify a transaction, we send a request GET request to the paysatck verification url, 
passing the** reference** we generated when making the transaction as a **path parameter.**

this is the verification URL: 
[**https://api.paystack.co/transaction/verify**](https://api.paystack.co/transaction/verify/)

The sample response we get for a successful transaction is shown below:

the 2 most important values we are interested in this Json response

A. The reference which we would use to identify the transaction we made 
(this is the reference we generated while initializing the transaction).

B. The status in the data node of the Json above, i.e data.status, 
if this status is “success” that means the user has successfully made payment and should be given the value for 
the payment he made.

Before we can do anything with the Json response, we have to model our response class to match the Json, 
so we create the Java class below.

Lets model the inner data node too and all the extra details with it

Then to make the request to verify the transaction, we use this method, passing the transaction reference as a parameter

Line 27 does the trick, it checks if the status of the data object is success and then you can place your logic 
to apply value to the payment of the user.

Note: You do not have to trigger this method manually to verify a transaction, 
Paystack makes a charge event call to the webhook url you provided on your dashboard to confirm if a
 transaction is successful or if it failed. In part 3 of this tutorial we would learn how to catch paystack charge 
 event and automatically verify transactions.
