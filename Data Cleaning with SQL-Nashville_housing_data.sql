/****** Script for SelectTopNRows command from SSMS  ******/
-- Data Cleaning of Nashville housing data with SQL Queries
-- By Olamide Emida, Google Certified Data Analyst

-- Let's see all columns in the data

SELECT *
FROM [PortfolioProjects].[dbo].[Nashville_housing]


-- Converting SaleDate column to Date data type and updating it as a new column; Sale_date_Converted

SELECT SaleDate
FROM [PortfolioProjects].[dbo].[Nashville_housing]

SELECT CAST(SaleDate as date) sale_date_converted
FROM [PortfolioProjects].[dbo].[Nashville_housing]

ALTER TABLE [PortfolioProjects].[dbo].[Nashville_housing]
ADD sale_date_converted date

UPDATE [PortfolioProjects].[dbo].[Nashville_housing]
SET sale_date_converted = CAST(SaleDate as date)


/*Populating the PropertyAddress Column. The goal is to populate the null addresses with not
null addresses having the same ParcelID with the null addresses through self join.*/

SELECT *
FROM [PortfolioProjects].[dbo].[Nashville_housing]
WHERE PropertyAddress IS NULL

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, COALESCE(a.PropertyAddress, b.PropertyAddress)
FROM [PortfolioProjects].[dbo].[Nashville_housing] a
JOIN [PortfolioProjects].[dbo].[Nashville_housing] b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] != b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = COALESCE(a.PropertyAddress, b.PropertyAddress)
FROM [PortfolioProjects].[dbo].[Nashville_housing] a
JOIN [PortfolioProjects].[dbo].[Nashville_housing] b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] != b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


-- Splitting the property address to street and city columns

SELECT PropertyAddress
FROM [PortfolioProjects].[dbo].[Nashville_housing]

SELECT PropertyAddress, 
  SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1),
  SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) + 2, LEN(PropertyAddress))
FROM [PortfolioProjects].[dbo].[Nashville_housing]

ALTER TABLE [PortfolioProjects].[dbo].[Nashville_housing]
ADD PropertySplitAddress VARCHAR(255)

UPDATE [PortfolioProjects].[dbo].[Nashville_housing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE [PortfolioProjects].[dbo].[Nashville_housing]
ADD PropertySplitCity VARCHAR(255)

UPDATE [PortfolioProjects].[dbo].[Nashville_housing]
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) + 2, LEN(PropertyAddress))


-- Populating the null addresses in the owner address column with property adddress.

SELECT *
FROM [PortfolioProjects].[dbo].[Nashville_housing]
WHERE OwnerAddress IS NULL

SELECT PropertyAddress, OwnerAddress
FROM [PortfolioProjects].[dbo].[Nashville_housing]
WHERE OwnerAddress IS NULL

SELECT PropertyAddress, OwnerAddress, 
  CASE WHEN OwnerAddress IS NULL
		THEN PropertyAddress
		ELSE OwnerAddress
  END
FROM [PortfolioProjects].[dbo].[Nashville_housing]

UPDATE [PortfolioProjects].[dbo].[Nashville_housing]
SET OwnerAddress = 
 CASE WHEN OwnerAddress IS NULL
	THEN PropertyAddress
	ELSE OwnerAddress
 END


 -- Splitting the owner address to street and city columns

SELECT OwnerAddress,
  SUBSTRING(Owneraddress, 1, CHARINDEX(',', OwnerAddress)-1),
  SUBSTRING(Owneraddress, CHARINDEX(',', OwnerAddress) + 2, LEN(OwnerAddress))
FROM [PortfolioProjects].[dbo].[Nashville_housing]

ALTER TABLE [PortfolioProjects].[dbo].[Nashville_housing]
ADD OwnerSplitAddress VARCHAR(255)

UPDATE [PortfolioProjects].[dbo].[Nashville_housing]
SET OwnerSplitAddress = SUBSTRING(Owneraddress, 1, CHARINDEX(',', OwnerAddress)-1)

ALTER TABLE [PortfolioProjects].[dbo].[Nashville_housing]
ADD OwnerSplitCity VARCHAR(255)

UPDATE [PortfolioProjects].[dbo].[Nashville_housing]
SET OwnerSplitCity = SUBSTRING(Owneraddress, CHARINDEX(',', OwnerAddress) + 2, LEN(OwnerAddress))


-- Replacing Y and N in SoldASVacant column with Yes and No respectively

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM [PortfolioProjects].[dbo].[Nashville_housing]
GROUP BY SoldAsVacant
ORDER BY 2 DESC

SELECT SoldAsVacant,
CASE 
  WHEN SoldAsVacant = 'N' THEN 'No'
  WHEN SoldAsVacant = 'Y' THEN 'Yes'
  ELSE SoldAsVacant
END
FROM [PortfolioProjects].[dbo].[Nashville_housing]

UPDATE [PortfolioProjects].[dbo].[Nashville_housing]
SET SoldAsVacant = 
CASE 
  WHEN SoldAsVacant = 'N' THEN 'No'
  WHEN SoldAsVacant = 'Y' THEN 'Yes'
  ELSE SoldAsVacant
END


-- Deleting columns not needed
ALTER TABLE [PortfolioProjects].[dbo].[Nashville_housing]
DROP COLUMN SaleDate, TaxDistrict


-- Let's see the cleaned data

SELECT *
FROM [PortfolioProjects].[dbo].[Nashville_housing]