# Add values to MySQL Database (MariaDB)
# Author: Tay Kratzer tay@cimitra.com

Param(
    [string] $customerName,
    [string] $phoneNumber
 )

$mysqlProgramBinDir = 'C:\Program Files\MariaDB 10.5\bin'

$ScriptPath = $PSScriptRoot

# For debugging
# ./mysql.exe -u root -pNovell123 classicmodels -t --execute="LOAD DATA LOCAL INFILE 'C:/Users/Tay/AppData/Local/Temp/~3hsshnq0/customers.csv' INTO TABLE customers FIELDS TERMINATED BY ',' IGNORE 1 LINES ; SHOW WARNINGS";


$tempFolderToCreate = ([System.IO.Path]::GetTempPath()+'~'+([System.IO.Path]::GetRandomFileName())).Split('.')[0] 

&{
New-Item -ItemType Directory -Force -Path ${tempFolderToCreate}
} > $null

# Write-Output "${tempFolderToCreate}"

$CSV_FILE = "${tempFolderToCreate}\customers.csv"

cd ${mysqlProgramBinDir}

##-------GET THE HIGHEST CUSTOMER NUMBER---------##

$LATEST_NUMBER = ./mysql.exe --raw -N -B -u root -pNovell123 classicmodels -t --execute="SELECT MAX(customerNumber) FROM customers;" > ${CSV_FILE}

$LATEST_NUMBER = [System.IO.File]::ReadAllText(${CSV_FILE}) 

$LATEST_NUMBER = $LATEST_NUMBER -replace "[^0-9]" , '';

$A_NUMBER = $LATEST_NUMBER -join '';

&{
Write-output $A_NUMBER
} > ${CSV_FILE}


$STRING_NUMBER = Get-Content -Path ${CSV_FILE} -Raw

$a = $STRING_NUMBER

$b = $a | Out-String

$b = $b -as [int]

$c = 0

##-------INCREMENT THE HIGHEST CUSTOMER NUMBER---------##

$c = $b + 1;

$RECORD_NUMBER = $c

# Write-Output "$RECORD_NUMBER"

$NODATA = 'NULL'

##-------MAKE CSV FILE---------##

&{
Write-output "customerNumber,customerName,phone,contactLastName,contactFirstName,addressLine1,addressLine2,city,state,postalCode,country,salesRepEmployeeNumber,creditLimit" 
"${RECORD_NUMBER},${customerName},${phoneNumber},${phoneNumber},${phoneNumber},${phoneNumber},${phoneNumber},${phoneNumber},${NODATA},${NODATA},${NODATA},1002,100.00"
} > ${CSV_FILE}

cd ${mysqlProgramBinDir}


##-------IMPORT CSV FILE---------##

&{
./mysqlimport.exe --ignore-lines=1 --fields-terminated-by=, --verbose --local --user=root --password=Novell123 classicmodels $CSV_FILE 
} > $null

Write-Output ""
Write-Output "Created Database Entry for Customer : ${customerName}"
Write-Output ""

##-------QUERY DATABASE FOR RECORD WE JUST ADDED---------##

./mysql.exe -u root -pNovell123 classicmodels -t -e "SELECT customerName,phone FROM customers WHERE customerName like '${customerName}%'"; 

Write-Output ""

cd $ScriptPath

exit 0

