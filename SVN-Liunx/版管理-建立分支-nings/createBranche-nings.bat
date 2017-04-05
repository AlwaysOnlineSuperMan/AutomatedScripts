ECHO off 
SET createBrancheSeq=B20161021000004
SET createBrancheMsg=B20161021000004_creater  new Project Branche
SET FILE_HOME=%cd%
SET createBranchesModelFilePath=%FILE_HOME%\SVN-createBranchesModel-nings
xcopy  %createBranchesModelFilePath% %FILE_HOME%\branches\branches_copy /e/h/i/y
rename %FILE_HOME%\branches\branches_copy\IM222678_docs %createBrancheSeq%_docs
rename %FILE_HOME%\branches\branches_copy\D_IM222678_code D_%createBrancheSeq%_code
rename %FILE_HOME%\branches\branches_copy %createBrancheSeq%
ECHO 1、%createBrancheMsg%，---nings Tools。>>%FILE_HOME%\branches\%createBrancheSeq%\D_%createBrancheSeq%_code\ChangeList.txt
ECHO  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
ECHO     欢迎使用nings自动建立版本分支工具--nings Tools。      
ECHO     分支版本:%createBrancheSeq%            
ECHO     分支描述:%createBrancheMsg%                                     
ECHO  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
ECHO on
pause