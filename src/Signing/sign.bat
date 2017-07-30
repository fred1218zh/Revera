PATH=%PATH%;%WSDK81%\bin\x86;C:\Program Files\7-Zip;C:\Program Files (x86)\7-Zip

set SIGNINGPATH=%~dp0
cd %SIGNINGPATH%

call "..\..\doc\chm\create_chm.bat"

cd %SIGNINGPATH%

rem sign using SHA-1
signtool sign /v /a /n IDRIX /i Thawte /ac thawte_Primary_MS_Cross_Cert.cer /fd sha1 /t http://timestamp.verisign.com/scripts/timestamp.dll "..\Release\Setup Files\revera.sys" "..\Release\Setup Files\revera-x64.sys"
signtool sign /v /a /n IDRIX /i Thawte /ac Thawt_CodeSigning_CA.crt /fd sha1 /t http://timestamp.verisign.com/scripts/timestamp.dll "..\Release\Setup Files\revera.exe" "..\Release\Setup Files\reveraf.exe" "..\Release\Setup Files\reverax.exe" "..\Release\Setup Files\revera-x64.exe" "..\Release\Setup Files\reveraf-x64.exe" "..\Release\Setup Files\reverax-x64.exe"

rem sign using SHA-256
signtool sign /v /a /n "IDRIX SARL" /i GlobalSign /ac GlobalSign_Root_CA_MS_Cross_Cert.crt /as /fd sha256 /tr http://timestamp.globalsign.com/?signature=sha2 /td SHA256 "..\Release\Setup Files\revera.sys" "..\Release\Setup Files\revera-x64.sys"
signtool sign /v /a /n "IDRIX SARL" /i GlobalSign /ac GlobalSign_SHA256_EV_CodeSigning_CA.cer /as /fd sha256 /tr http://timestamp.globalsign.com/?signature=sha2 /td SHA256 "..\Release\Setup Files\revera.exe" "..\Release\Setup Files\reveraf.exe" "..\Release\Setup Files\reverax.exe" "..\Release\Setup Files\revera-x64.exe" "..\Release\Setup Files\reveraf-x64.exe" "..\Release\Setup Files\reverax-x64.exe"


cd "..\Release\Setup Files\"

copy ..\..\LICENSE .
copy ..\..\License.txt .
copy ..\..\NOTICE .

del *.xml
rmdir /S /Q Languages
mkdir Languages
copy /V /Y ..\..\..\Translations\*.xml Languages\.
del Languages.zip
7z a -y Languages.zip Languages

rmdir /S /Q docs
mkdir docs\html\en
mkdir docs\EFI-DCS
copy /V /Y ..\..\..\doc\html\* docs\html\en\.
copy "..\..\..\doc\chm\User Guide.chm" docs\.
copy "..\..\..\doc\EFI-DCS\*.pdf" docs\EFI-DCS\.

del docs.zip
7z a -y docs.zip docs

"revera-setup.exe" /p

del LICENSE
del License.txt
del NOTICE
del "User Guide.chm"

del Languages.zip
del docs.zip
rmdir /S /Q Languages
rmdir /S /Q docs

cd %SIGNINGPATH%

rem sign using SHA-1
signtool sign /v /a /n IDRIX /i Thawte /ac Thawt_CodeSigning_CA.crt /fd sha1 /t http://timestamp.verisign.com/scripts/timestamp.dll "..\Release\Setup Files\revera-setup.exe"
rem sign using SHA-256
signtool sign /v /a /n "IDRIX SARL" /i GlobalSign /ac GlobalSign_SHA256_EV_CodeSigning_CA.cer /as /fd sha256 /tr http://timestamp.globalsign.com/?signature=sha2 /td SHA256 "..\Release\Setup Files\revera-setup.exe"

pause
