SELECT 
    FORMAT(h.OrderDate, 'yyyy-MM') AS MonthYear,
    sp.Name AS Country,
    c.Name AS Region,
    pc.Name AS ProductCategory,
    psc.Name AS ProductSubcategory,
    p.Name AS Product,
    CASE WHEN h.OnlineOrderFlag = 1 THEN 'Online' ELSE 'Reseller' END AS Channel,
    COUNT(DISTINCT h.SalesOrderID) AS TransactionCount,
    COUNT(DISTINCT h.CustomerID) AS UniqueCustomers,
    SUM(d.OrderQty) AS SalesVolume,
    SUM(h.SubTotal) AS Revenue,
    SUM(d.OrderQty * p.StandardCost) AS TotalCost,
    SUM(h.SubTotal) / NULLIF(COUNT(DISTINCT h.SalesOrderID), 0) AS AvgTransactionValue,
    SUM(d.OrderQty * p.StandardCost) / NULLIF(COUNT(DISTINCT h.SalesOrderID), 0) AS CostPerSale,
    SUM(h.SubTotal) / NULLIF(COUNT(DISTINCT h.CustomerID), 0) AS RevenuePerCustomer,
    CAST(COUNT(DISTINCT h.SalesOrderID) AS FLOAT) / NULLIF(COUNT(DISTINCT h.CustomerID), 0) AS AvgTransactionPerCustomer
FROM [AdventureWorks2012].[Sales].[SalesOrderHeader] h
INNER JOIN [AdventureWorks2012].[Sales].[SalesOrderDetail] d ON h.SalesOrderID = d.SalesOrderID
INNER JOIN [AdventureWorks2012].[Production].[Product] p ON d.ProductID = p.ProductID
INNER JOIN [AdventureWorks2012].[Production].[ProductSubcategory] psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
INNER JOIN [AdventureWorks2012].[Production].[ProductCategory] pc ON psc.ProductCategoryID = pc.ProductCategoryID
INNER JOIN [AdventureWorks2012].[Person].[Address] a ON h.ShipToAddressID = a.AddressID
INNER JOIN [AdventureWorks2012].[Person].[StateProvince] sp ON a.StateProvinceID = sp.StateProvinceID
INNER JOIN [AdventureWorks2012].[Person].[CountryRegion] c ON sp.CountryRegionCode = c.CountryRegionCode
GROUP BY 
    FORMAT(h.OrderDate, 'yyyy-MM'),
    sp.Name,
    c.Name,
    pc.Name,
    psc.Name,
    p.Name,
    h.OnlineOrderFlag
ORDER BY 
    MonthYear,
    Country,
    Region,
    ProductCategory,
    ProductSubcategory,
    Product,
    Channel;