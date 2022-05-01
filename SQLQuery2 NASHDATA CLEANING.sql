--CLEANING DATA IN SQL QUERIES

SELECT*
FROM [PROJECT PORTOFOLIO]..NASHDATA

--STANDARDIZE DATE FORMAT

SELECT SaleDateConverted,CONVERT(Date,SaleDate)
FROM [PROJECT PORTOFOLIO]..NASHDATA

UPDATE NASHDATA
SET SaleDate=CONVERT(Date,SaleDate)

ALTER TABLE NASHDATA
ADD SaleDateConverted Date;

UPDATE NASHDATA 
SET SaleDateConverted = CONVERT(Date,SaleDate)

--POPULATE PROPERTY ADDREDD DATA

SELECT *
FROM [PROJECT PORTOFOLIO]..NASHDATA
--WHERE PropertyAddress is null
ORDER BY ParcelID


SELECT a.ParcelID, a.PropertyAddress , b.ParcelID , b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [PROJECT PORTOFOLIO]..NASHDATA a
JOIN [PROJECT PORTOFOLIO]..NASHDATA b
 	 ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress= ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [PROJECT PORTOFOLIO]..NASHDATA a
JOIN [PROJECT PORTOFOLIO]..NASHDATA b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]


--- BREAKING OUT ADDRESS INTO INDVIDUAL COLUMNS(ADDRESS,CITY,STATE)

SELECT PropertyAddress
FROM [PROJECT PORTOFOLIO]..NASHDATA
--WHERE PropertyAddress is null
--ORDER BY ParcelID

SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',' , PropertyAddress)-1) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress)+1, LEN(PropertyAddress)) AS Address

FROM [PROJECT PORTOFOLIO]..NASHDATA



ALTER TABLE NASHDATA
ADD PropertySplitAddress NVARCHAR(255);

UPDATE NASHDATA 
SET PropertySplitAddress  = SUBSTRING(PropertyAddress,1,CHARINDEX(',' , PropertyAddress)-1)

ALTER TABLE NASHDATA
ADD PropertySplitCity NVARCHAR(255);

UPDATE NASHDATA 
SET PropertySplitCity =  SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress)+1, LEN(PropertyAddress))


SELECT*
FROM [PROJECT PORTOFOLIO]..NASHDATA




SELECT OwnerAddress
FROM [PROJECT PORTOFOLIO]..NASHDATA

SELECT
PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,3)
, PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,2)
, PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,1)
FROM [PROJECT PORTOFOLIO]..NASHDATA


ALTER TABLE NASHDATA
ADD OwmerSplitAddress NVARCHAR(255);


UPDATE NASHDATA 
SET OwmerSplitAddress  = PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,3)

ALTER TABLE NASHDATA
ADD OwnerSplitCity NVARCHAR(255);

UPDATE NASHDATA 
SET OwnerSplitCity =  PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,2)

ALTER TABLE NASHDATA
ADD OwmerSplitState NVARCHAR(255);

UPDATE NASHDATA 
SET OwmerSplitState  = PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,1)


SELECT *
FROM [PROJECT PORTOFOLIO]..NASHDATA



--CHANGE Y AND N TO YES AND IN SOLD AS VACANT FIELD

SELECT DISTINCT(SoldAsVacant)
FROM [PROJECT PORTOFOLIO]..NASHDATA

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant='Y' THEN 'YES'
	   WHEN SoldAsVacant= 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
FROM [PROJECT PORTOFOLIO]..NASHDATA


UPDATE NASHDATA
SET SoldAsVacant = CASE WHEN SoldAsVacant='Y' THEN 'YES'
	   WHEN SoldAsVacant= 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END


--REMOVE DUPLICATES


WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				  UniqueID
				  )row_num
FROM [PROJECT PORTOFOLIO]..NASHDATA
)

SELECT*
FROM RowNumCTE
WHERE Row_Num > 1
ORDER BY PropertyAddress


---DELETE UNUSED COLUMN


SELECT*
FROM [PROJECT PORTOFOLIO]..NASHDATA

ALTER TABLE [PROJECT PORTOFOLIO]..NASHDATA
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress








