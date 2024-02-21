Select *
From PorfolioProject..Nashville

Select SaleDateConverted, CONVERT(Date,SaleDate)
From PorfolioProject..Nashville

Update Nashville
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE Nashville
Add SaleDateConverted Date;

Update Nashville
Set SaleDateConverted = CONVERT(Date,SaleDate)

Select *
From PorfolioProject..Nashville
--Where PropertyAddress is null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PorfolioProject..Nashville a
Join PorfolioProject..Nashville b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PorfolioProject..Nashville a
Join PorfolioProject..Nashville b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

Select PropertyAddress
From PorfolioProject..Nashville

Select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address ,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address

From PorfolioProject..Nashville

Alter Table Nashville
Add PropertySplitAddress Nvarchar(255);

Update Nashville
Set PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Alter Table Nashville
Add PropertySplitCity Nvarchar(255);

Update Nashville
Set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

Select*
From PorfolioProject..Nashville

Select OwnerAddress
From PorfolioProject..Nashville

Select
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From PorfolioProject..Nashville

Alter Table Nashville
Add OwnerSplitAddress Nvarchar(255);

Update Nashville
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Alter Table Nashville
Add OwnerSplitCity Nvarchar(255);

Update Nashville
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

Alter Table Nashville
Add OwnerSplitState Nvarchar(255);

Update Nashville
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PorfolioProject..Nashville
Group by SoldAsVacant

Select SoldAsVacant,
CASE When SoldAsVacant = '1' THEN 'Yes'
	 When SoldAsVacant = '0' Then 'No'
	 Else SoldAsVacant
	 END
From PorfolioProject..Nashville

Update Nashville
Set SoldAsVacant =	CASE When SoldAsVacant = '1' THEN 'Yes'
					When SoldAsVacant = '0' Then 'No'
					Else SoldAsVacant
					END

With RowNumCTE AS (
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
					UniqueID
					)row_num
From PorfolioProject..Nashville
--Order by UniqueID
)

Select *
From RowNumCTE
Where row_num >1
Order by UniqueID

Select *
From PorfolioProject..Nashville

Alter Table PorfolioProject..Nashville
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict

Alter Table PorfolioProject..Nashville
Drop Column SaleDate

