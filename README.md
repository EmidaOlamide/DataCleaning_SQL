# DataCleaning_SQL  
Here, I showcased my **SQL skill by cleaning Nashville Housing Data**. I used **SSMS (SQL Server Management Studio)** to write the queries.  

I did the following cleaning:

### Fixed data type
* Converted SaleDate column to 'Date' data type using cast function and I updated it as a new column to the data; Sale_date_Converted column.

### Filled missing values 
* Populated the PropertyAddress Column. The goal was to populate, through self join, the null addresses with not null addresses having the same ParcelID as the null addresses. 
* I also populated the null addresses in the owner address column with property address using a case statement.

### Split columns
* Split the property address and owners address columns to street and city using substring, charindex, and length functions

### Spelling check
* Replaced Y and N in SoldASVacant column with Yes and No respectively to ensure consistency.

### Deleting bad data
* Deleted columns not needed using Alter table statement

Check out my SQL queries. Your feedback will be greatly appreciated.  

Warm Regards,

**Olamide Emida**
