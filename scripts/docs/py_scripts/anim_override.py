import os
import shutil


## python scripts/docs/py_scripts/sg_override.py
def backup_directory(src, dst):
    """
    备份目录的函数。
    :param src: 源目录路径。
    :param dst: 目标备份目录路径。
    """
    try:
        # 确保目标目录存在
        os.makedirs(dst, exist_ok=True)
        
        # 使用shutil.copytree复制整个目录
        shutil.copytree(src, dst, dirs_exist_ok=True)
        print(f"备份成功: {dst}")
    except Exception as e:

        print(f"备份失败: {e}")

#！！！假设mod仓库位于steam库下dst的mod文件夹内！！！
current_file_path = os.path.abspath(__file__) # 获得当前fix_force_override.py所处的绝对路径
tropical_adventrues_root_path = os.path.dirname(os.path.dirname(current_file_path)) # 获得热带冒险mod的根目录
tropical_adventrues_root_path = tropical_adventrues_root_path.replace("\scripts\docs", "") 

#！！！假设dst的databundles文件夹内的scripts文件夹已经解压！！！
dst_path = os.path.dirname(os.path.dirname(tropical_adventrues_root_path)) + r"\data"
tropical_adventrues_prefabs_path = tropical_adventrues_root_path + r"\anim"

dst_prefabs_path = dst_path + r"\anim"
backup_prefabs_path = tropical_adventrues_prefabs_path + r"_backup"
print("热带冒险根目录：", tropical_adventrues_root_path, )
print("饥荒联机版脚本根目录：", dst_path)
print("热带冒险prefabs目录：", tropical_adventrues_prefabs_path)
print("饥荒联机版prefabs目录：", dst_prefabs_path)
# 查找热带冒险中暴力覆盖原版的prefab文件

# 指定要查找的文件扩展名，例如 '.lua'
file_extension = '.zip'

# 获取两个目录中的文件列表，并转换为集合
tropical_adventure_files = {f for f in os.listdir(tropical_adventrues_prefabs_path) if f.endswith(file_extension)}
dst_files = {f for f in os.listdir(dst_prefabs_path) if f.endswith(file_extension)}

# 找到交集
intersection_files = sorted(tropical_adventure_files.intersection(dst_files))

# 打印结果
print("两个目录中指定类型文件的交集有：")
for file in intersection_files:
    print('tro_' + file)

# 重命名热带冒险mod中的文件名，添加前缀TA_

# 调用函数进行备份
# backup_directory(tropical_adventrues_prefabs_path, backup_prefabs_path)
 
# 遍历交集中的文件名，并重命名
for file_name in intersection_files:
    # 构造原始文件的完整路径
    original_file_path = os.path.join(tropical_adventrues_prefabs_path, file_name)
    
    # 构造新文件名，添加前缀'TA_'
    new_file_name = 'tro_' + file_name
    
    # 构造新文件的完整路径
    new_file_path = os.path.join(tropical_adventrues_prefabs_path, new_file_name)
    
    # 重命名文件
    # os.rename(original_file_path, new_file_path)
    # print(f"文件已重命名为: {new_file_path}")


    ###### 对原版更改：
    # 构造原始文件的完整路径
    dst_original_file_path = os.path.join(dst_prefabs_path, file_name)
    
    # 构造新文件名，添加前缀'TA_'
    dst_new_file_name = 'tro_' + file_name
    
    # 构造新文件的完整路径
    dst_new_file_path = os.path.join(dst_prefabs_path, dst_new_file_name)
    
    # 重命名文件
    # os.rename(dst_original_file_path, dst_new_file_path)
    # print(f"文件已重命名为: {new_file_path}")

    # python scripts/docs/py_scripts/anim_override.py