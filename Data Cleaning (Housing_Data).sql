SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Average]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [portfolio_project].[dbo].[NationalHousing]


  Select *
  FROM portfolio_project.dbo.NationalHousing

  -- Standardize date format

  Select SaleDate, CONVERT(Date,SaleDate)AS SaleDateConverted
  FROM portfolio_project.dbo.NationalHousing

  UPDATE NationalHousing
  SET SaleDate = SaleDateConverted

  Select SaleDate, SaleDateConverted
  FROM portfolio_project.dbo.NationalHousing

  ALTER TABLE NationalHousing
  ADD SaleDateConverted Date

  UPDATE NationalHousing
  SET SaleDateConverted = CONVERT(Date,SaleDate)
  
 -- Populate Propert Address Data

 Select PropertyAddress
  FROM portfolio_project.dbo.NationalHousing
  Where PropertyAddress IS NULL

  Select *
  FROM portfolio_project.dbo.NationalHousing
  --Where PropertyAddress IS NULL
  ORDER BY ParcelID

  Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
  FROM portfolio_project.dbo.NationalHousing a
  JOIN portfolio_project.dbo.NationalHousing b
       on a.ParcelID = b.ParcelID
	   AND a.[UniqueID ]<> b.[UniqueID ]
  Where a.PropertyAddress IS NULL

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM portfolio_project.dbo.NationalHousing a
  JOIN portfolio_project.dbo.NationalHousing b
       on a.ParcelID = b.ParcelID
	   AND a.[UniqueID ]<> b.[UniqueID ]
  Where a.PropertyAddress IS NULL


-- Breaking Out Address into Individual Columns (Address, City, State)

Select PropertyAddress
  FROM portfolio_project.dbo.NationalHousing
  --Where PropertyAddress IS NULL
  --ORDER BY ParcelID

  SELECT 
  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1, LEN (PropertyAddress)) as City
  FROM portfolio_project.dbo.NationalHousing

  ALTER TABLE NationalHousing
  ADD PropertySplitAddress Nvarchar(255)

  UPDATE NationalHousing
  SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

  ALTER TABLE NationalHousing
  ADD PropertySplitCity Nvarchar(255)

  UPDATE NationalHousing
  SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1, LEN (PropertyAddress))

  
  SELECT *
  FROM portfolio_project.dbo.NationalHousing

  SELECT OwnerAddress
  FROM portfolio_project.dbo.NationalHousing

  SELECT 
  PARSENAME(REPLACE(OwnerAddress, ',','.'),3),
  PARSENAME(REPLACE(OwnerAddress, ',','.'),2),
  PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
  FROM portfolio_project.dbo.NationalHousing

  ALTER TABLE NationalHousing
  ADD OwnerSplitAddress Nvarchar(255)

  UPDATE NationalHousing
  SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)

  ALTER TABLE NationalHousing
  ADD OwnerSplitCity Nvarchar(255)

  UPDATE NationalHousing
  SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)

  ALTER TABLE NationalHousing
  ADD OwnerSplitState Nvarchar(255)

  UPDATE NationalHousing
  SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)

  SELECT *
  FROM portfolio_project.dbo.NationalHousing

  -- Changing Y and N to 'Yes' and 'No'

  SELECT DISTINCT SoldAsVacant, COUNT(SoldAsVacant)
  FROM portfolio_project.dbo.NationalHousing
  Group by SoldAsVacant
  Order by 2

  SELECT SoldAsVacant,
  CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
  FROM portfolio_project.dbo.NationalHousing

  UPDATE NationalHousing
  SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

-- Removing Duplicates

WITH Row_Num_CTE AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER BY UniqueID
			 ) row_num
FROM portfolio_project.dbo.NationalHousing
--Order by ParcelID
)
DELETE
FROM Row_Num_CTE
WHERE row_num > 1


-- Delete unused Columns

Select *
FROM portfolio_project.dbo.NationalHousing

ALTER TABLE portfolio_project.dbo.NationalHousing
DROP COLUMN OwnerAddress, PropertyAddress,TaxDistrict

ALTER TABLE portfolio_project.dbo.NationalHousing
DROP COLUMN SaleDate