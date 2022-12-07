#/bin/bash

proj=savageblock
doc=""

echo "keystore文件加密程序开始运行......"
time=$(date +%Y%m%d%H%M%S)
echo "1. 记录当前时间：${time}"

echo "2. 检查$proj文件夹......"
if [ ! -d "./$proj" ]; then
    echo "错误：$proj文件夹不存在，请创建$proj文件夹，并放入keystore文件和密码文本。如已创建，请检查文件夹名称为$proj"
    exit 1
fi

echo "3. 检查加密公钥......"
if [ ! -f "./$proj-public-key.gpg" ]; then
    echo "错误：加密公钥$proj-public-key.gp未找到"
    echo "如已存在，请检查公钥文件名称为$proj-public-key.gpg"
    exit 1
fi

target_name=${proj}_keystore_unix_${time}

echo "4. 压缩$proj文件夹......"
tar czf ${target_name}.tar.gz $proj

echo "5. 导入加密公钥......"
gpg --import $proj-public-key.gpg

echo "6. 加密keystore......"
gpg --recipient savage --output ${target_name}.gpg --encrypt ${target_name}.tar.gz
rm ${target_name}.tar.gz

echo "恭喜！！您的keystore加密完成，文件名: ${target_name}.gpg"
