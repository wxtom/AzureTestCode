
$resourceGroup ="XXXX"
$storageAccount = "XXX"
$tableName = "XXXX"
$storageAccountKey = "XXXX"

$ctx = New-AzureStorageContext -StorageAccountName $storageAccount -StorageAccountKey $storageAccountKey
[Reflection.Assembly]::LoadFrom(".\System.Spatial.dll") | Out-Null
$table = Get-AzureStorageTable -Name $tableName -Context $ctx 
$csvPath ='c:\tom\test3.csv'
$cols = "Label_Usage,Label_Value,Usage_Location" #should be corrensponding to your csv column exclude Partitionkey and RowKey
$csv = Import-Csv -Path $csvPath
$number = 0;
[Microsoft.WindowsAzure.Storage.Table.TableBatchOperation]$batchOperation = New-Object -TypeName Microsoft.WindowsAzure.Storage.Table.TableBatchOperation
foreach($line in $csv)
{    $number = $number+1
     $entity = New-Object -TypeName Microsoft.WindowsAzure.Storage.Table.DynamicTableEntity -ArgumentList $line.partitionkey, $line.rowKey 
     $colArray = $cols.split(",")
     Write-Host "$($line.partitionkey), $($line.rowKey)" #output partitionkey and rowKey value

     foreach($colName in $colArray)
        {
         Write-Host "$colName,$($line.$colName)" #output column name and value
        $entity.Properties.Add($colName,$line.$colName)
     }
	 if($number -le 100)
	{
		$batchOperation.Insert($entity)
	}
	else
	{	$number =0
		$result = $table.CloudTable.ExecuteBatch($batchOperation)
		Microsoft.WindowsAzure.Storage.Table.TableBatchOperation]$batchOperation = New-Object -TypeName Microsoft.WindowsAzure.Storage.Table.TableBatchOperation
	
	}
     
}
