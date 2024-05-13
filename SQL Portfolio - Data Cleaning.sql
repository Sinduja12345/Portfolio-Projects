--Cleaning data in SQL queries

select * from Nashvillehousing

--Standiaze date format

select saledate ,convert(date,saledate)
from Nashvillehousing

update Nashvillehousing set saledate=convert(date,saledate)

alter table Nashvillehousing
add  saledateupdated date

update Nashvillehousing set saledateupdated=convert(date,saledate)

sp_rename 'Nashvillehousing.saledateupdate','saledateupdated','column'

--populate property address data

select *
from Nashvillehousing
order by ParcelID


select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress) as newpropertyaddress
from Nashvillehousing a
join Nashvillehousing b
on a.ParcelID=b.ParcelID and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


update a
set PropertyAddress= isnull(a.PropertyAddress,b.PropertyAddress)
from Nashvillehousing a
join Nashvillehousing b
on a.ParcelID=b.ParcelID and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

--Breaking propertyaddress into indiviual column (address,city,state)

select PropertyAddress,
substring(PropertyAddress,1,charindex(',' , PropertyAddress)-1) as address
--substring(propertyaddress,charindex(',' , PropertyAddress)+1,len(propertyaddress)) as address
from Nashvillehousing


alter table Nashvillehousing
add  PropertysplitAddress nvarchar(255)

update Nashvillehousing
set PropertysplitAddress=substring(PropertyAddress,1,charindex(',' , PropertyAddress)-1)


alter table Nashvillehousing
add  Propertysplitcity nvarchar(255)


update Nashvillehousing
set Propertysplitcity=substring(propertyaddress,charindex(',' , PropertyAddress)+1,len(propertyaddress))


select 
--parsename(replace(owneraddress, ',' ,','),1),
--parsename(replace(owneraddress, ',' ,','),2),
parsename(replace(owneraddress, ',' ,','),3)
from Nashvillehousing
where OwnerAddress is not null

--change y, n into yes ,no in soldasvacant field

select distinct(soldAsvacant),count(soldASvacant)
from Nashvillehousing
group by soldAsvacant
order by soldAsvacant

select soldAsvacant,
case when soldAsvacant = 'y' then 'yes'
	when soldAsvacant = 'N' then 'No'
	else SoldAsVacant
	end
from Nashvillehousing

select * from Nashvillehousing where  SoldAsVacant='N'

update Nashvillehousing
set SoldAsVacant=case when soldAsvacant = 'y' then 'yes'
	when soldAsvacant = 'N' then 'No'
	else SoldAsVacant
	end


-- Remove Duplicates

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



Select *
From PortfolioProject.dbo.NashvilleHousing





