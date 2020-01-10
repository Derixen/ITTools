USE CM_E01

DECLARE @ComputerName nvarchar(30)
SET @ComputerName = 'EVH06768NB'

select ProductName0

from v_GS_INSTALLED_SOFTWARE

where InstallSource0 like 'C:\Windows\ccmcache\%' and ResourceID in (select resourceid from v_r_system where name0 = @ComputerName) and ProductName0 NOT IN ('com.ricoh.gamelan.plugin.slnx.print.secureport','com.ricoh.gamelan.plugin.print.common','com.ricoh.gamelan.core','com.ricoh.gamelan.core.jre','com.ricoh.gamelan.plugin.slnx.print.rulebasedprint','com.ricoh.gamelan.plugin.slnx.base','com.ricoh.gamelan.plugin.slnx.print.secureprint','Security Vulnerabilty in Ricoh Desktop Agent UX MUI 1.7.1.0','EMET 5.52','EvoShareManager1.1','PKI Basic Client 5.8','MDOP MBAM','Trend Micro OfficeScan Agent','CopyPathMenu','Circuit Desktop App 1.2.1606','Microsoft Visual Studio 2010 Tools for Office Runtime (x64)','Greenshot 1.2.10.6','ARI CONNECT','Adobe Acrobat Reader 2017 MUI','Pulse Secure','URA V2.0 connection 1.0','Adobe Flash Player 32 NPAPI','KeePass 2.39.1','Report As SPAM','PDF-XChange PRO V6','Google Chrome','7-Zip 18.05 (x64 edition)','Mozilla Firefox (en-US)','SODOCO - Siemens Office DOcument COnfidentiality tool') 
	
Order by ProductName0