@echo off

CHCP 65001

SET folder_exist=savageblock
SET pubkey_exist=savageblock-public-key.gpg

if not exist %folder_exist% (
echo "错误：%folder_exist%文件夹不存在，请创建%folder_exist%文件夹，并放入keystore文件和密码文本。如已创建，请检查文件夹名称为%folder_exist%"
pause
exit
)

if not exist %pubkey_exist% (
echo "错误：加密公钥%pubkey_exist%未找到"
echo "如已存在，请检查公钥文件名称为%pubkey_exist%"
pause
exit
)

echo %DATE%
set timestamp=%DATE:~5,2%%DATE:~8,2%%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%
echo %timestamp%
set target_name=%folder_exist%_keystore_windows_%timestamp%

echo "压缩%folder_exist%文件夹......"
powershell Compress-Archive -Path %folder_exist% -DestinationPath %target_name%.zip

echo "导入加密公钥......"
gpg --import %pubkey_exist%

echo "加密keystore......"
gpg --recipient savage --output %target_name%.gpg --encrypt %target_name%.zip

del %target_name%.zip

SET gpg_file=%target_name%.gpg

if exist %gpg_file% (
echo "文件已生成，文件名: %gpg_file%"
)

pause
exit
