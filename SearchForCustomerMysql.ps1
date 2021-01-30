
Param(
    [string] $customerName,
    [string] $phoneNumber
 )

$customerEmpty = [string]::IsNullOrWhiteSpace($customerName)

$phoneEmpty = [string]::IsNullOrWhiteSpace($phoneNumber)

$ScriptPath = $PSScriptRoot

$mysqlProgramBinDir = 'C:\Program Files\MariaDB 10.5\bin'


if(!$customerEmpty -And $phoneEmpty){
cd ${mysqlProgramBinDir}
Write-Output ""
./mysql.exe -u root -pNovell123 classicmodels -t -e "SELECT customerName,phone FROM customers WHERE customerName like '${customerName}%'";
Write-Output ""
Set-Location $ScriptPath
exit 0
}

if(!$phoneEmpty -And $customerEmpty){
cd ${mysqlProgramBinDir}
Write-Output ""
./mysql.exe -u root -pNovell123 classicmodels -t -e "SELECT customerName,phone FROM customers WHERE phone like '${phoneNumber}%'";
Write-Output ""
Set-Location $ScriptPath
exit 0
}


if(!$customerEmpty){
cd ${mysqlProgramBinDir}
./mysql.exe -u root -pNovell123 classicmodels -t -e "SELECT customerName,phone FROM customers WHERE customerName like '${customerName}%'";
Set-Location $ScriptPath
}else{
Write-Output ""
Write-Output "Enter a Customer Name or Phone Number"
Write-Output ""
}
