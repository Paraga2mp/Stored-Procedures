# Stored-Procedures
Stored procedure scripts for commonly used functionality of the Chinook database


Scenario

The Invoice Payments enhancements you made for The Chinook Company’s database system were a great success. Not only has the enhancement greatly improved their financial accounting
system, they have noticed the database’s performance has increased when adding new Invoices and Payments. (Thank you, Stored Procedures!)
The company has realized they make better, more efficient use of their database if they convert more of its commonly-used functionality over to using more stored procedures. 
They’re also interested in tracking when records are added or removed from certain tables. They’ve hired you back on to tackle a new enhancement.
Being a music-based company, the data their employees have to administer the most are the Tracks, Artists, Albums, as well as Genres and Mediatypes. For each of these five 
tables, they have requested you create separate stored procedures for adding new records or deleting existing ones.
They want to log whenever a record is added or deleted, so they have asked you to create a new RecordLogging table, which will be used in conjunction with the new add/delete 
procedures, to log any changes to records in the desired tables.
Requirements

Your solution should add the following to the existing Chinook database:

1.	A new table called RecordLogging will be added. See ERD below.
2.	A new stored procedure called uspAddRecordLog will be created, to add logging records and track data changes. The data they would like to track for each record changed is:
a.	The affected table’s name
b.	The record’s ID, if applicable. This would typically be the Primary Key for a newly-inserted record, or -1 for other cases.
c.	The action type of the change, ie. INSERT or DELETE.
d.	When logging an error, the SQL Server error number should be recorded, and the IsError flag set to True. For records that are not errors, set the error number to zero.
e.	Every log record, of any type, must be automatically time-stamped when it is added to the Logging table.
3.	For each of the five tables (Tracks, Artists, Albums, Genres and Mediatypes), add a new stored procedure called usp<TableName>_Insert. These stored procedures should:
a.	Accept values for all applicable fields, of the appropriate datatypes and sizes.
b.	Parameters should be nullable where appropriate. See each table’s constraints for details.
c.	Have an output parameter, which will return the ID of the newly-created record. 
d.	Contain a transaction and error handling, so that should the insert statement fail, it will be reverted. Otherwise, it will be committed.
e.	If the insert action is successful, a call to the uspAddRecordLog proc will be used to create a logging record. See screenshots below for details that should be captured 
for a successful insert.
f.	If the insert action is NOT successful, a different call to the uspAddRecordLog proc will be used to create a logging record to save basic error details. See screenshots 
below for details that should be captured for a failed insert.
4.	For each of the five tables (Tracks, Artists, Albums, Genres and Mediatypes), add a new stored procedure called usp<TableName>_DeleteByID. These stored procedures should:
a.	Accept the PK ID for the table as a parameter.
b.	Use the incoming ID value to attempt to delete the record associated with that ID.
c.	Contain a transaction and error handling, so that should the delete statement fail, it will be reverted. Otherwise, it will be committed.
d.	If the delete action is successful, a call to the uspAddRecordLog proc will be used to create a logging record. See screenshots below for details that should be captured for
a successful delete.
e.	If the delete action is NOT successful, a different call to the uspAddRecordLog proc will be used to create a logging record to save basic error details. See screenshots 
below for details that should be captured for a failed delete.
