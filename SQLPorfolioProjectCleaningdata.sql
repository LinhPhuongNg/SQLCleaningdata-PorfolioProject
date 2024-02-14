/*

Cleaning Data in SQL Queries

*/


Select *
From PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format
Select Saledate,Convert(Date,saledate)
From PortfolioProject..nashvilleHousing

Update Nashvillehousing
SET saledate = Convert(date,saledate)

-- If it doesn't Update properly

Alter table Nashvillehousing
add SaleDateConverted Date;

Update Nashvillehousing
SET saledateconverted = Convert(date,saledate)

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data
SELECT a.ParcelID, b.PropertyAddress,b.parcelID, a.propertyAddress
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
ON a.ParcelID =b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
Where a.propertyaddress is null

UPDATE a
SET Propertyaddress =ISNULL (a.propertyaddress,b.propertyaddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
ON a.ParcelID =b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
Where a.propertyaddress is null


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)
--PropertyAddress breakdown
Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing

Select
Substring(Propertyaddress,1,CHARINDEX(',', PropertyAddress)-1) as Address,
Substring(Propertyaddress,CHARINDEX(',', PropertyAddress)+1 , LEN (propertyAddress)) as City
From PortfolioProject.dbo.NashvilleHousing

Alter table Nashvillehousing
add PropertyAddressSplit nvarchar(225);

Update Nashvillehousing
SET PropertyAddressSplit = Substring(Propertyaddress,1,CHARINDEX(',', PropertyAddress)-1)

Alter table Nashvillehousing
add PropertysplitCity nvarchar(255);

Update Nashvillehousing
SET PropertysplitCity = Substring(Propertyaddress,CHARINDEX(',', PropertyAddress)+1 , LEN (propertyAddress))

--OwnerAddress breakdown
Select owneraddress From PortfolioProject.dbo.NashvilleHousing

SELECT 
PARSENAME (replace(Owneraddress,',', '.'), 3) as Address ,
PARSENAME (replace(Owneraddress,',', '.'), 2) as City,
PARSENAME (replace(Owneraddress,',', '.'), 1) As State
FROM PortfolioProject.dbo.NashvilleHousing

Alter table Nashvillehousing
add OwnersplitAddress nvarchar(225);

Update Nashvillehousing
SET OwnerSplitAddress = PARSENAME (replace(Owneraddress,',', '.'), 3)

Alter table Nashvillehousing
add OwnersplitCity nvarchar(255);

Update Nashvillehousing
SET OwnersplitCity = PARSENAME (replace(Owneraddress,',', '.'), 2)

Alter table Nashvillehousing
add OwnersplitState nvarchar(255);

Update Nashvillehousing
SET Ownersplitstate = PARSENAME (replace(Owneraddress,',', '.'), 1)


--------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct (soldAsVacant), count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant,
CASE when SoldAsVacant ='y' then 'Yes'
when soldasvacant ='N' then 'No'
Else soldasvacant
End
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing 
SET SoldasVacant = CASE when SoldAsVacant ='y' then 'Yes'
when soldasvacant ='N' then 'No'
Else soldasvacant
End

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

Select *, Row_number() OVER( Partition by  ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID) row_num

From PortfolioProject.dbo.NashvilleHousing
Order by ParcelID
---
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress
-- Delete column
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
DELETE 
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select *
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------














