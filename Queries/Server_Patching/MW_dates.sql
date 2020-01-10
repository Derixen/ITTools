-----last saturday

SELECT Convert (date, DATEADD(dd,-(DATEPART( WEEKday , DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,convert(datetime,GETDATE(),112))+1,0)))-1),DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,convert(datetime,GETDATE(),112))+1,0))))

----- last sunday

SELECT Convert (date, DATEADD(dd,-(DATEPART( WEEKday , DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,convert(datetime,GETDATE(),112))+1,0)))-1),DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,convert(datetime,GETDATE(),112))+1,0))))


----next sat  MW

SELECT NextSaturdayMW = case when ( Convert (date, DATEADD(dy, DATEDIFF(dy, getdate(), DATEADD(mm, DATEDIFF(mm, 0, getdate()), 30)) / 7 * 7+1, getdate()))) > GETDATE () 
then (Convert (date, DATEADD(dy, DATEDIFF(dy, getdate(), DATEADD(mm, DATEDIFF(mm, 0, getdate()), 30)) / 7 * 7+1, getdate()))) 
else (Convert (date, DATEADD(dd,(7 - (DATEPART(dw,DATEADD(month,DATEDIFF(mm,0,getdate())+1,0)) + @@DATEFIRST) % 7) % 7,DATEADD(month,DATEDIFF(mm,0,getdate())+1,0)))) end


----next mont first SUN

SELECT firstsunday = Convert (date, DATEADD(dd,(7 - (DATEPART(dw,DATEADD(month,DATEDIFF(mm,0,getdate())+1,0)) + @@DATEFIRST) % 7) % 7,DATEADD(month,DATEDIFF(mm,0,getdate())+1,1)))


----next sunday mw
SELECT NextSundayMW = case when ( Convert (date, DATEADD(dd,-(DATEPART( WEEKday , DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,convert(datetime,GETDATE(),112))+1,0)))-1),DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,convert(datetime,GETDATE(),112))+1,0))))) > GETDATE () 
then ( Convert (date, DATEADD(dd,-(DATEPART( WEEKday , DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,convert(datetime,GETDATE(),112))+1,0)))-1),DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,convert(datetime,GETDATE(),112))+1,0))))) 
else (Convert (date, DATEADD(dd,(7 - (DATEPART(dw,DATEADD(month,DATEDIFF(mm,0,getdate())+1,0)) + @@DATEFIRST) % 7) % 7,DATEADD(month,DATEDIFF(mm,0,getdate())+1,1)))) end





select Convert (date, DATEADD(dy, DATEDIFF(dy, getdate(), DATEADD(mm, DATEDIFF(mm, 0, getdate()), 30)) / 7 * 7, getdate())) AS LastSatDay

select DATEADD(dw, -(DATEPART(dw, GETDATE()) + 1) % 7, GETDATE())