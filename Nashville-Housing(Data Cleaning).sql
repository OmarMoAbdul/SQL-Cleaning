Select * 
From portifolio..NashvilleHousing

-- Standardize Date format...

Select SaleDate
From portifolio..NashvilleHousing

Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = CAST(SaleDate as date)

Select SaleDateConverted
From portifolio..NashvilleHousing
-----------------------------------------------------------

--Populate Property Address data

Select *
From portifolio..NashvilleHousing
--Where PropertyAddress is null
Order by ParcelID

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
From portifolio..NashvilleHousing a
join portifolio..NashvilleHousing b
 on a.ParcelID = b.ParcelID
AND a.[UniqueID ]<> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
From portifolio..NashvilleHousing a
join portifolio..NashvilleHousing b
 on a.ParcelID = b.ParcelID
AND a.[UniqueID ]<> b.[UniqueID ]
Where a.PropertyAddress is null

----------------------------------------------------

--- Breaking out Address into individual columns (Address,City,State)
 
Select PropertyAddress
From portifolio..NashvilleHousing
--Where PropertyAddress is null
--Order by ParcelID



Select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))
From portifolio..NashvilleHousing


Alter Table NashvilleHousing
Add PropertySAddress Nvarchar(255);

Update NashvilleHousing
Set PropertySAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 

Alter Table NashvilleHousing
Add PropertySCity Nvarchar(255);

Update NashvilleHousing
Set PropertySCity= SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))



Select *
From portifolio..NashvilleHousing

Select OwnerAddress
From portifolio..NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
From portifolio..NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress,',','.'),2)
From portifolio..NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From portifolio..NashvilleHousing


Alter Table NashvilleHousing
Add OwnerSAddress Nvarchar(255);

Update NashvilleHousing
Set OwnerSAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)
 

Alter Table NashvilleHousing
Add OwnerSCity Nvarchar(255);

Update NashvilleHousing
Set OwnerSCity= PARSENAME(REPLACE(OwnerAddress,',','.'),2)


Alter Table NashvilleHousing
Add OwnerState Nvarchar(255);

Update NashvilleHousing
Set OwnerState= PARSENAME(REPLACE(OwnerAddress,',','.'),1)

Select *
From portifolio..NashvilleHousing



--------------------------------------------------

--- Change Y and N to Yes and No in "SoldAsVacant" field


Select distinct SoldAsVacant,COUNT(SoldAsVacant)
From portifolio..NashvilleHousing
Group by SoldAsVacant
Order by 2



Select SoldAsVacant
,Case When SoldAsVacant = 'Y' Then 'Yes'
      When SoldAsVacant = 'N' Then 'No'
      Else SoldAsVacant
      End
From portifolio..NashvilleHousing


Update portifolio..NashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
       When SoldAsVacant = 'N' Then 'No'
       Else SoldAsVacant
       End

-----------------------------------------------------------

--- Remove dublicates...

With RowNum as (

Select *,
ROW_NUMBER() Over(
     
	 Partition by ParcelID,
	 PropertyAddress,SalePrice,
	 SaleDate,LegalReference
	 Order by UniqueID
	 )row_num 

From portifolio..NashvilleHousing
)

Select * 
From RowNum
Where row_num>1
Order by PropertyAddress




Select * 
From portifolio..NashvilleHousing



























