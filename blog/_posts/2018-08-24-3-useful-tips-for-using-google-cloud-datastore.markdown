---
layout:	post
title:	"3 Useful tips for using Google Cloud Datastore."
date:	2018-08-24
---

<p align="center">
 <img src="img/1ZS8CDu-r4vwbO-0--O8Aug.png" alt="Event bus explanation">
</p>
 
 Google Cloud Datastore is a managed, schema-less and highly scalable [NoSql](https://hackernoon.com/tagged/nosql)
 database that is especially helpful for developers who want to worry less about scaling their database as usage grow.
 It is built on top of Google’s Bigtable Database and it has a lot of powerful features and you might want to consider
 it for your next project, but before you do so here are some quick tips that you should know so as to avoid some 
 pitfalls with using this database.


***1***. **Google Cloud Datastore is not SQL, its not even close.**

&ensp;&ensp;&ensp;Google Cloud Datastore is a NOSQL database but when people and documentations try to explain the concept they tend 
to compare it with SQL e.g Entities could be compared to Tables and its properties to Columns, 
since a lot of developers are already familiar with SQL. Also Datastore also has a powerful query engine that
 allows you to query for data and even sort the data accordingly, this might make developers assume that 
 they can model their data like they do in SQL. But the truth is that Datastore’s underlying implementation 
 is quite different from SQL, here are some key differences.

*I*. *No Auto-Increment Primary Keys*:  
&ensp;&ensp;&ensp;Unlike SQL where you can generally have an Auto-increment Primary key that increments with each write,
 In Google Cloud Datastore Entities are identified by a [KEY](https://cloud.google.com/datastore/docs/reference/data/rest/v1/Key) 
 which is made unique with a combination of its [Kind and its Identifier](https://cloud.google.com/datastore/docs/concepts/entities#kinds_and_identifiers) 
 the Identifier is either an ID that Datastore automatically generates for you or a 
 [Key Name Property ](https://cloud.google.com/datastore/docs/concepts/entities#kinds_and_identifiers) 
 that you can provide as an identifier to Datastore which is a String that you are sure would be unique for each entity
  of that kind.


> Note: Identifiers are only unique within a kind and cannot be changed after the entity is created. 

*II*. *No Foreign Key Constraints*: In Datastore, you can reference other Entities using their 
[**Key**](https://cloud.google.com/datastore/docs/reference/data/rest/v1/Key) 
but no data integrity checks are done when writing or deleting these Entities so you cannot ensure that they entity 
whose key you’re referencing actually exist. You have to be careful here because this is the point where there is 
extreme likelihood of data integrity problems.

*III*. *Datastore Does not Enforce uniqueness*: Apart from the Identifier mentioned in (I) above,
 Google Cloud Datastore does not allow you to specify uniqueness for any other fields in an Entity, 
 if you wish to ensure uniqueness you would have to implement that by yourself by performing a read at 
 the point of writing the Entity.

***2***. **Know what to Index very early:**

Google Cloud Datastore makes use of [Indexes](https://cloud.google.com/datastore/docs/concepts/indexes) 
to aid querying, indexing fields in an Entity is very important to querying in datastore, in fact,
 if you do not index a field and attempt to filter in a query with that field, you would get no result even 
 if the query matches a result, this is because Datastore only looks up the indexes when querying, 
 it does not allow you to do a full table scan to get results of queries like many other database does.

There are two types of indexing in Datastore, Basic Index and Composite index, 
basic index is used on single property fields while Composite index is used when you intend to filter by multiple fields.


> It is important to know what fields you would like to index early because indexes could take too 
long to build especially when you have very many entities in your database.In fact for single property 
indexes they are not built automatically after indexing them, the index is built with each write, 
so if you have 1 million entities of that kind and you intend to intend to index a field you would have to read each 
of the 1 million entities and write them back for the index to be recorded, this can be very expensive. 
Also when you try to query with composite fields that you have not indexed, you get an error even if you have
 indexed these fields and it is not done building the indexes.

So to avoid these issues, try to think about fields you would want to use in your query and index them very early.

***3***. *How to count Entities (Sharded Counters):* 
Unlike SQL where you could easily use the query select ```count(*)``` to get the number of items in a Table,
Datastore queries do not have any such syntax, you have to keep count of your Entities by yourself using other Entities, 
so if you have an Entity called **User** and you wish to know how many users are in your database then you need to
 have another Entity lets call it UserCount . 
 The UserCount Entity would have an numeric field that would increase anytime a User is written to the database 
 and decrease when a User is deleted from the database. This is fairly simple, but a problem might arise when the 
 count needs to update frequently, lets say 20 times per second. 
 This could lead to [DataStore Contention Error](https://cloud.google.com/appengine/articles/scaling/contention) 
 which implies that each concurrent request to update the item could not be completed before their request is timeout. 
 This problem is solved using [**Sharded Counter**](https://cloud.google.com/appengine/articles/sharding_counters) 
 which simply implies creating fragments of that entity (shards) and randomly picking each of those entities 
 to update when you need to update the count, this would reduce the probability of getting the Datastore Contention error.


> Note: The higher the number of shards, the lesser the likelihood of getting the Data Contention Error,
 the [Google Cloud Samples](https://github.com/GoogleCloudPlatform/appengine-sharded-counters-java)
  has a decent example on how to implement Sharded counters.So there you have it, while Datastore promises Scalability,
   it has some downsides too which is especially in Data integrity and Querying and you should consider these things 
   before using it for a project.

**If you have other tips you would like to share, you can add it in the comments below, thanks**.