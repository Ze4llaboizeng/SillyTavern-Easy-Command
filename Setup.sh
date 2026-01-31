#!/bin/bash

clear
echo "========================================"
echo "      SillyTavern Launcher & Manager      "
echo "========================================"
echo ""

# ---------------------------------------------------------
# [NEW] ส่วนตรวจสอบและซ่อมแซม NPM อัตโนมัติ (เพิ่มใหม่)
# ---------------------------------------------------------
echo ">> กำลังตรวจสอบความพร้อมของระบบ (Node.js/NPM)..."

# เช็คว่ามี npm ไหม
if ! command -v npm &> /dev/null; then
    echo "!! ตรวจไม่พบ NPM (หรือไฟล์เสีย) !!"
    echo ">> กำลังเรียกหน่วยกู้ภัย Yarn มาซ่อมแซม..."

    # 1. ถ้าไม่มี yarn ก็ติดตั้ง yarn ก่อน
    if ! command -v yarn &> /dev/null; then
        echo "   - ติดตั้ง Yarn..."
        pkg install yarn -y
    fi

    # 2. ใช้ yarn ติดตั้ง npm
    echo "   - กำลังใช้ Yarn ดาวน์โหลด NPM..."
    yarn global add npm

    # 3. ตั้งค่า Path ชั่วคราวเพื่อให้ใช้งานได้ทันทีในรอบนี้
    export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

    # 4. เช็คซ้ำอีกรอบ
    if command -v npm &> /dev/null; then
        echo ">> [OK] กู้คืน NPM สำเร็จ! (Version: $(npm -v))"
        
        # ฝัง Path ลงถาวรเผื่อเปิดรอบหน้า
        if ! grep -q "yarn/global/node_modules/.bin" ~/.bashrc; then
             echo 'export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"' >> ~/.bashrc
        fi
    else
        echo "!! [ERROR] ซ่อมแซมล้มเหลว กรุณาแคปหน้าจอส่งผู้พัฒนา !!"
        read -p "กด Enter เพื่อจบการทำงาน"
        exit 1
    fi
else
    echo ">> [OK] พบ NPM เรียบร้อย (Version: $(npm -v))"
fi
echo "----------------------------------------"
# ---------------------------------------------------------

# ตรวจสอบว่ามีโฟลเดอร์ SillyTavern อยู่หรือไม่
if [ -d "SillyTavern" ]; then
    echo ">> ตรวจพบโฟลเดอร์ SillyTavern แล้ว"
    echo "----------------------------------------"
    echo "ตัวเลือก:"
    echo " [y] อัพเดทและเปิดใช้งาน (Update & Start)"
    echo " [n] เปิดใช้งานเลย ไม่ต้องอัพเดท (Start Only)"
    echo "----------------------------------------"
    read -p "คุณต้องการอัพเดท SillyTavern ก่อนใช้งานหรือไม่? (y/n): " update_choice

    cd SillyTavern

    if [[ "$update_choice" == "y" || "$update_choice" == "Y" ]]; then
        echo ">> กำลังรันโหมดอัพเดท..."
        git pull
        
        if [ $? -eq 0 ]; then
            echo ">> อัพเดทเสร็จสิ้น! กำลังเปิดโปรแกรม..."
            ./start.sh
        else
            echo "!! การอัพเดทมีปัญหา ลองตรวจสอบอินเทอร์เน็ต !!"
        fi

    else
        echo ">> ข้ามการอัพเดท..."
        echo ">> กำลังเปิดโปรแกรม (start.sh)..."
        ./start.sh
    fi

else
    echo ">> ไม่พบโฟลเดอร์ SillyTavern ในเครื่อง"
    echo "----------------------------------------"
    read -p "คุณต้องการติดตั้งใหม่ (Install) หรือไม่? (y/n): " install_choice

    if [[ "$install_choice" == "y" || "$install_choice" == "Y" ]]; then
        echo ">> กำลังเริ่มติดตั้งผ่านสคริปต์อัตโนมัติ..."
        echo ">> คำสั่ง: curl -sL ... | bash"
        curl -sL https://raw.githubusercontent.com/Rawi1005/st-autoinstall/main/install.sh | bash
    else
        echo ">> ยกเลิกการติดตั้ง"
    fi

fi
