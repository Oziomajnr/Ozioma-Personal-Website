---
layout:	post
title:	"Your singleton might not be “Single”."
date:	2017-10-04
---

b'\n\n\n\n![](/img/0*CAvq1Jb3ynFuSwnG.)Source: <https://dzone.com/articles/java-singletons-using-enum>[Singleton](https://en.wikipedia.org/wiki/Singleton_pattern) have been a very popular design pattern as it is proven t+

o have some advantages compared to global variables, the [**Gang of four**](https://en.wikipedia.org/wiki/Design_Patterns) book listed the following benefits of using singleton:

1. Controlled access to sole instance.
2. Reduced name space.
3. Permits refinement of operations and representation.
4. Permits a variable number of instances.
5. More flexible than class operations.
Web application developers have often found it useful as a form of caching mechanism using it to hold some data that needs to be accessed so often that that fetching it from the database might be a performance overhead, example of that might be **access token** for API authorization.

But Singleton have often been described as an software [**Anti Pattern**](https://en.wikipedia.org/wiki/Anti-pattern#Software_design)** **mainly because of of its unpredictable nature. The primary properties of a singleton is

1. There must be exactly one instance of a class.
2. The single instance must be accessible to clients from a well-known access point.
The implication of the first property is that a singleton must class must be properly implemented such that multiple instances of that class should not exist, this is usually not the case as there are many reasons why multiple instances of your singleton class might exist, here are some reasons:

1. Multi threading: If your singleton class is not properly implemented with lock and synchronization then when it is accessed from multiple threads different instances would be created.
2. Class loaders: If your Singleton is loaded by different class loaders then the it would have multiple instances.
3. Shared Server: If your application is running on a shared server then different instances of your application can be spurned to serve your requests.
The article the article [Simply Singleton](https://www.javaworld.com/article/2073352/core-java/simply-singleton.html) describes how you can overcome 1 and 2 above but those methods have their own implications, problem 3 is the major reason why I would not recommend using Singleton to hold data that is important to the business logic of your application.

Recently I was working on a project where the authorization token to access the APIs for different user was stored in a singleton class like this

the ConcurrentHashMap is used to store the user token information and then since it is assumed that there is just one instance of this class the hashmap would always give the correct data for authorization.

The bug in this code is not obvious when a single instance of your application is running (this was our case as we had configured our Google App Engine application to use just one instance in our test environment since it was running in the flexible environment where Google does not automatically manage the instance up and down time) but after we allowed multiple instance of our application to run at the same time then we had multiple instances of our singleton class so while the access token might be set in INSTANCE1 the instance serving our request might be INSTANCE2 and then the client would get the error that the token is not found on the server. In some cloud framework like Google App Engine standard environment, when your application is + not serving request, its instances could be shut down to dynamically to save cost so when your singleton class is re-instantiated then all the data would be gone.

If you have data that has to be accessed often you could use a cache system like [Redis Lab](https://redislabs.com/lp/memcached-java/) to cache the data. The google app engine standard environment also has its own [Memcache](https://cloud.google.com/appengine/docs/standard/python/memcache/) for use cases like this.

So if you are not absolutely sure that your singleton would have one and only one instance then you should **never **use it to handle data that has to do with the business logic of your application.

\n\n'