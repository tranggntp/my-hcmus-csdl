﻿
---VIẾT CÁC CÂU TRUY VẤN 51-58 TRONG BT QL CHUYẾN BAY
USE QLCB

--51
--EXCEPT
SELECT MACB
FROM CHUYENBAY CB
WHERE NOT EXISTS (
SELECT LMB.MALOAI
FROM LOAIMB LMB 
WHERE HANGSX='Boeing'
EXCEPT 
SELECT LB.MALOAI
FROM LICHBAY LB
WHERE CB.MACB=LB.MACB)
--NOT EXISTS
SELECT MACB
FROM CHUYENBAY CB
WHERE NOT EXISTS (SELECT *
FROM LOAIMB LMB 
WHERE HANGSX='Boeing' AND NOT EXISTS (SELECT *
FROM LICHBAY LB
WHERE CB.MACB=LB.MACB AND LB.MALOAI=LMB.MALOAI))
--COUNT
SELECT CB.MACB
FROM CHUYENBAY CB JOIN LICHBAY LB ON CB.MACB=LB.MACB
JOIN LOAIMB LMB ON LB.MALOAI=LMB.MALOAI
WHERE HANGSX='Boeing'
GROUP BY CB.MACB
HAVING COUNT(DISTINCT LMB.MALOAI)=(SELECT COUNT(*) FROM LOAIMB WHERE HANGSX='Boeing')

--52
--EXCEPT
SELECT MANV, TEN
FROM NHANVIEN NV
WHERE LOAINV=1 AND NOT EXISTS (
SELECT LMB.MALOAI
FROM LOAIMB LMB
WHERE HANGSX='Airbus'
EXCEPT
SELECT KN.MALOAI
FROM KHANANG KN
WHERE KN.MANV=NV.MANV)
--NOT EXISTS
SELECT MANV, TEN
FROM NHANVIEN NV
WHERE LOAINV=1 AND NOT EXISTS (SELECT *
FROM LOAIMB LMB
WHERE HANGSX='Airbus' AND NOT EXISTS (SELECT *
FROM KHANANG KN
WHERE KN.MANV=NV.MANV AND LMB.MALOAI=KN.MALOAI))
--COUNT
SELECT NV.MANV, TEN
FROM NHANVIEN NV JOIN KHANANG KN ON KN.MANV=NV.MANV
JOIN LOAIMB LMB ON KN.MALOAI=LMB.MALOAI
WHERE LOAINV=1 AND HANGSX='Airbus'
GROUP BY NV.MANV, TEN
HAVING COUNT(DISTINCT LMB.MALOAI)=(SELECT COUNT(*) FROM LOAIMB WHERE HANGSX='Airbus')

--53
--EXCEPT
SELECT TEN
FROM NHANVIEN NV
WHERE LOAINV=0 AND NOT EXISTS (
SELECT CB.MACB
FROM CHUYENBAY CB
WHERE CB.MACB='100'
EXCEPT
SELECT PC.MACB
FROM PHANCONG PC
WHERE PC.MANV=NV.MANV)
--NOT EXISTS
SELECT TEN
FROM NHANVIEN NV
WHERE LOAINV=0 AND NOT EXISTS (SELECT *
FROM CHUYENBAY CB
WHERE CB.MACB='100' AND NOT EXISTS (SELECT *
FROM PHANCONG PC
WHERE PC.MANV=NV.MANV AND PC.MACB=CB.MACB))
--COUNT
SELECT TEN
FROM NHANVIEN NV JOIN PHANCONG PC ON PC.MANV=NV.MANV
JOIN CHUYENBAY CB ON PC.MACB=CB.MACB
WHERE LOAINV=0 AND CB.MACB='100'
GROUP BY TEN
HAVING COUNT(DISTINCT CB.MACB)=(SELECT COUNT(*) FROM CHUYENBAY WHERE MACB='100')

--54
--EXCEPT
SELECT DISTINCT NGAYDI
FROM LICHBAY LB
WHERE NOT EXISTS (
SELECT LMB.MALOAI
FROM LOAIMB LMB 
WHERE HANGSX='Boeing'
EXCEPT 
SELECT LB1.MALOAI
FROM LICHBAY LB1
WHERE LB.MACB=LB1.MACB)
--NOT EXISTS
SELECT DISTINCT NGAYDI
FROM LICHBAY LB
WHERE NOT EXISTS (SELECT *
FROM LOAIMB LMB 
WHERE HANGSX='Boeing' AND NOT EXISTS (SELECT *
FROM LICHBAY LB1
WHERE LB.MACB=LB1.MACB AND LMB.MALOAI=LB1.MALOAI))
--COUNT
SELECT DISTINCT NGAYDI
FROM LICHBAY LB JOIN LOAIMB LMB ON LB.MALOAI=LMB.MALOAI
WHERE HANGSX='Boeing'
GROUP BY LB.NGAYDI
HAVING COUNT(DISTINCT LMB.MALOAI)=(SELECT COUNT(*) FROM LOAIMB WHERE HANGSX='Boeing')

--55
--EXCEPT
SELECT MALOAI
FROM LOAIMB LMB
WHERE HANGSX='Boeing' AND NOT EXISTS (
SELECT LB.NGAYDI
FROM LICHBAY LB 
EXCEPT
SELECT LB1.NGAYDI
FROM LICHBAY LB1
WHERE LB1.MALOAI=LMB.MALOAI)
--NOT EXISTS
SELECT MALOAI
FROM LOAIMB LMB
WHERE HANGSX='Boeing' AND NOT EXISTS (SELECT *
FROM LICHBAY LB 
WHERE NOT EXISTS (SELECT *
FROM LICHBAY LB1
WHERE LB1.MALOAI=LMB.MALOAI AND LB.NGAYDI=LB1.NGAYDI))
--COUNT
SELECT LMB.MALOAI
FROM LOAIMB LMB JOIN LICHBAY LB ON LMB.MALOAI=LB.MALOAI
WHERE HANGSX='Boeing'
GROUP BY LMB.MALOAI
HAVING COUNT(DISTINCT NGAYDI)=(SELECT COUNT(DISTINCT NGAYDI) FROM LICHBAY LB1 JOIN LOAIMB LMB1 ON LB1.MALOAI=LMB1.MALOAI
WHERE HANGSX='Boeing') 

--56
--EXCEPT
SELECT MAKH, TEN
FROM KHACHHANG KH
WHERE NOT EXISTS (
SELECT DC.NGAYDI
FROM DATCHO DC
WHERE DC.NGAYDI>='2000-1-1' AND DC.NGAYDI>='2000-10-31'  
EXCEPT
SELECT DC1.NGAYDI
FROM DATCHO DC1
WHERE DC1.MAKH=KH.MAKH)
--NOT EXISTS
SELECT MAKH, TEN
FROM KHACHHANG KH
WHERE NOT EXISTS (SELECT *
FROM DATCHO DC
WHERE DC.NGAYDI>='2000-1-1' AND DC.NGAYDI>='2000-10-31' AND NOT EXISTS (SELECT *
FROM DATCHO DC1
WHERE DC1.MAKH=KH.MAKH AND DC.NGAYDI=DC1.NGAYDI))
--COUNT
SELECT KH.MAKH, TEN
FROM KHACHHANG KH JOIN DATCHO DC ON DC.MAKH=KH.MAKH
WHERE DC.NGAYDI>='2000-1-1' AND DC.NGAYDI>='2000-10-31'  
GROUP BY KH.MAKH, TEN
HAVING COUNT(DISTINCT DC.NGAYDI)=(SELECT COUNT(DISTINCT NGAYDI) FROM DATCHO 
WHERE NGAYDI>='2000-1-1' AND NGAYDI>='2000-10-31')

--57
SELECT MANV, TEN
FROM NHANVIEN NV
WHERE LOAINV=1 AND MANV NOT IN (SELECT MANV FROM KHANANG WHERE NOT EXISTS (
SELECT LMB.MALOAI
FROM LOAIMB LMB
WHERE HANGSX='Airbus'
EXCEPT
SELECT KN.MALOAI
FROM KHANANG KN
WHERE KN.MANV=NV.MANV))
--NOT EXISTS
SELECT MANV, TEN
FROM NHANVIEN NV
WHERE LOAINV=1 AND MANV NOT IN (SELECT MANV FROM KHANANG WHERE NOT EXISTS (SELECT *
FROM LOAIMB LMB 
WHERE HANGSX='Airbus' AND NOT EXISTS (SELECT *
FROM KHANANG KN
WHERE KN.MANV=NV.MANV AND LMB.MALOAI=KN.MALOAI)))
--COUNT
SELECT NV.MANV, TEN
FROM NHANVIEN NV
WHERE LOAINV=1 AND MANV NOT IN (SELECT MANV FROM KHANANG KN JOIN MAYBAY MB ON MB.MALOAI=KN.MALOAI
JOIN LOAIMB LMB ON MB.MALOAI=LMB.MALOAI
WHERE HANGSX='Airbus'
GROUP BY KN.MANV
HAVING COUNT(DISTINCT LMB.MALOAI)=(SELECT COUNT(*) FROM LOAIMB WHERE HANGSX='Airbus'))

--58
--EXCEPT
SELECT DISTINCT SBDI
FROM CHUYENBAY CB
WHERE NOT EXISTS (
SELECT LMB.MALOAI
FROM LOAIMB LMB 
WHERE HANGSX='Boeing'
EXCEPT
SELECT LB.MALOAI
FROM LICHBAY LB 
WHERE CB.MACB=LB.MACB)
--NOT EXISTS
SELECT DISTINCT SBDI
FROM CHUYENBAY CB
WHERE NOT EXISTS (SELECT *
FROM LOAIMB LMB
WHERE HANGSX='Boeing' AND NOT EXISTS (SELECT *
FROM LICHBAY LB 
WHERE CB.MACB=LB.MACB AND LB.MALOAI=LMB.MALOAI))
--COUNT
SELECT DISTINCT SBDI
FROM CHUYENBAY CB JOIN LICHBAY LB ON LB.MACB=CB.MACB 
JOIN MAYBAY MB ON MB.MALOAI=LB.MALOAI 
JOIN LOAIMB LMB ON MB.MALOAI=LMB.MALOAI
WHERE HANGSX='Boeing'
GROUP BY SBDI
HAVING COUNT(DISTINCT LMB.MALOAI)=(SELECT COUNT(*) FROM LOAIMB WHERE HANGSX='Boeing')