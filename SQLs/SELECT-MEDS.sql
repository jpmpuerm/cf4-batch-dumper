SELECT
  --T0.caseNo,
  --T0.CHARGESLIPNO chargeSlipNo,
  --T3.itemCode,
  --T3.brandName,
  MIN(T0.CHARGEDATETIME) dateTimeCharged,
  MIN(T3.GenName) genericName,
  MIN(T3.MG) strength,
  MIN(T3.DosageForm) form,
  MIN(CASE WHEN T3.CategoryCode = 'MED' THEN
    T4.Description
  ELSE
    ''
  END) route,
  --T2.SellingPrice sellingPrice,
  --T2.DiscAmt discountAmount,
  SUM(T2.Qty) quantity,
  SUM(
    (CAST(T2.SellingPrice AS DECIMAL(20, 8)) * CAST(T2.Qty AS DECIMAL(20, 8))) 
    - CAST(T2.DiscAmt AS DECIMAL(20, 8))
  ) totalCost
FROM 
  [UERMMMC]..[CHARGES_MAIN] T0 WITH(NOLOCK)
  INNER JOIN [UERMMMC]..[PHAR_Sales_Parent] T1 WITH(NOLOCK) ON T0.CHARGESLIPNO = T1.CSNo
  INNER JOIN [UERMMMC]..[PHAR_Sales_Details] T2 WITH(NOLOCK) ON T1.SalesNo = T2.SalesNo
  INNER JOIN [UERMMMC]..[PHAR_ITEMS] T3 WITH(NOLOCK) ON T2.ItemCode = T3.ItemCode
  LEFT JOIN UERMMMC..PHAR_CATEGORY T4 ON T3.Category = T4.Code
WHERE
  --T0.CANCELED = 'N'
  T0.CANCELED <> 'Y'
  AND T1.Cancelled = 0
  AND T3.PhicGroupCode = 'MED'
  AND T0.CASENO = '0098203'
GROUP BY
  T3.ItemCode;