select * 
from  [Nashville Housing]

---- standrize date formate

select SaleDateConverted,CONVERT(date,SaleDate)
from [nashville housing]

--update [Nashville Housing]
--set SaleDate=CONVERT(date,SaleDate)

Alter Table [Nashville Housing]
add SaleDateConverted Date

update [Nashville Housing]
set SaleDateConverted=CONVERT(date,SaleDate)


-- Populate Property Address data

select * 
from  [Nashville Housing]
where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Nashville Housing] a join [Nashville Housing] b
on a.ParcelID=b.ParcelID 
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress =ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Nashville Housing] a join [Nashville Housing] b
on a.ParcelID=b.ParcelID 
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


---------Breaking out address into individaul columns (Address,City, State)

select PropertyAddress
from  [Nashville Housing]

select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))as Address
from [Nashville Housing]


Alter table [Nashville Housing]
add ProprtySplitAddress Nvarchar(255)


 update [Nashville Housing]
set ProprtySplitAddress =SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Alter table [Nashville Housing]
add ProprtySplitCity Nvarchar(255)



 update [Nashville Housing]
set ProprtySplitCity =SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))


select *
from [Nashville Housing]



select OwnerAddress
from [Nashville Housing]

select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from [Nashville Housing]


Alter table [Nashville Housing]
add OwnerSplitAddress Nvarchar(255)

update [Nashville Housing]
set OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3)


Alter table [Nashville Housing]
add OwnerSplitCity Nvarchar(255)

update [Nashville Housing]
set OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2)


Alter table [Nashville Housing]
add OwnerSplitSatate Nvarchar(255)

update [Nashville Housing]
set OwnerSplitSatate=PARSENAME(REPLACE(OwnerAddress,',','.'),1)

select *
from [Nashville Housing]


---------------change Y and N to YES and NO in (Sold Vacand)
select distinct( SoldAsVacant),count(SoldAsVacant)
from [Nashville Housing]
group by SoldAsVacant
order by 2


select 
case  when SoldAsVacant='Y' then 'Yes'
	when SoldAsVacant='N' then 'No'
	else SoldAsVacant
	end
from [Nashville Housing]

update [Nashville Housing]
set SoldAsVacant= case  when SoldAsVacant='Y' then 'Yes'
	when SoldAsVacant='N' then 'No'
	else SoldAsVacant
	end


	------------Remove Duplicates--
	with RowNumCTE as(
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

From [Nashville Housing]
--order by ParcelID
)
select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


Select *
From [Nashville Housing]



- -----Delete Unused Columns



Select *
From [Nashville Housing]


ALTER TABLE [Nashville Housing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
