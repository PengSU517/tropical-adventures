#%%
import os
import subprocess

# --- 配置区域 ---
# 确保工具路径正确，若路径包含空格，shell=True 会处理它
TOOL_PATH = r"C:\Users\pengs\Downloads\win-dst-mod-tool\DST Mod Tool.exe" 
INPUT_DIR = r"C:\Program Files (x86)\Steam\steamapps\common\dont_starve\mods\workshop-1895052506\minimap"

# 将解包后的图片放在下载文件夹的一个新目录里
OUTPUT_DIR = r"C:\Users\pengs\Downloads\unpacked_pngs"
# --- --- --- ---

def batch_unpack():
    # 验证工具是否存在
    if not os.path.exists(TOOL_PATH):
        print(f"找不到工具: {TOOL_PATH}")
        return

    # 如果输出文件夹不存在，则创建它
    if not os.path.exists(OUTPUT_DIR):
        os.makedirs(OUTPUT_DIR)

    # 遍历输入目录
    for filename in os.listdir(INPUT_DIR):
        if filename.endswith(".tex"):
            input_file = os.path.join(INPUT_DIR, filename)
            
            # 处理输出文件名：去掉 .tex，去掉末尾的 _icon，加上 .png
            base_name = filename.replace(".tex", "")
            if base_name.endswith("_icon"):
                base_name = base_name[:-5]  # 移除末尾的 '_icon' (长度为5)
            
            output_file = os.path.join(OUTPUT_DIR, base_name + ".png")
            
            print(f"正在转换: {filename} -> {base_name}.png")
            
            # 构建命令。使用带引号的路径防止空格引起 Error 2
            cmd = f'"{TOOL_PATH}" "{input_file}" "{output_file}" --unpacktex'
            
            try:
                # 使用 shell=True 处理带空格的工具路径
                subprocess.run(cmd, check=True, shell=True)
            except Exception as e:
                print(f"转换出错: {filename}, 原因: {str(e)}")

if __name__ == "__main__":
    batch_unpack()
# %%