#!/bin/bash

if command -v free &> /dev/null; then
    MEM_GB=$(free -g | awk '/^Mem:/{print $2}')
else
    MEM_GB=2 
fi
ARCH=$(uname -m)
# ------------------------------------------------

clear
echo "========================================"
echo "      SillyTavern Launcher & Manager      "
echo "========================================"
echo ""

function check_and_fix_npm() {
    echo ">> กำลังตรวจสอบความพร้อมของ NPM..."
    if ! command -v npm &> /dev/null; then
        echo "!! ไม่พบคำสั่ง npm หรือ npm มีปัญหา"
        echo ">> กำลังพยายามซ่อมแซมโดยใช้ Yarn..."
        
        if ! command -v yarn &> /dev/null; then
            echo "   - ไม่พบ Yarn.. กำลังติดตั้ง Yarn via pkg..."
            pkg install yarn -y
        fi

        echo "   - กำลังสั่ง Yarn ให้ติดตั้ง npm..."
        yarn global add npm
        
        echo "   - กำลังตั้งค่า Path..."
        export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
        if ! grep -q "yarn/global/node_modules/.bin" ~/.bashrc; then
             echo 'export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"' >> ~/.bashrc
        fi

        echo ">> ซ่อมแซม npm เสร็จสิ้น! (Version: $(npm -v))"
    else
        echo ">> NPM ปกติดี (Version: $(npm -v))"
    fi
    echo "----------------------------------------"
}

function smart_install_modules() {
    echo -e "\n\e[94m>> กำลังติดตั้ง/อัปเดต node_modules (Smart Install)...\e[0m"
    
    if [ "$MEM_GB" -lt 1 ] || [[ "$ARCH" =~ ^(arm|i686)$ ]]; then
        echo -e "\e[93m[⚙️] Low-memory/ARM detected; using optimized install...\e[0m"
        export NODE_OPTIONS="--max-old-space-size=2048"
        npm ci --no-optional
    else
        npm ci
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "\e[92m>> ติดตั้ง Modules เสร็จสิ้น!\e[0m"
    else
        echo -e "\e[91m!! การติดตั้ง Modules ล้มเหลว\e[0m"
        exit 1
    fi
}


if [ -d "SillyTavern" ]; then
    echo ">> ตรวจพบโฟลเดอร์ SillyTavern แล้ว"
    echo "----------------------------------------"
    echo "ตัวเลือก:"
    echo " [y] อัพเดทและเปิดใช้งาน (Update & Start)"
    echo " [n] เปิดใช้งานเลย ไม่ต้องอัพเดท (Start Only)"
    echo "----------------------------------------"
    
    read -p "เลือกโหมด (y/n): " update_choice < /dev/tty

    cd SillyTavern
    
    check_and_fix_npm

    if [[ "$update_choice" == "y" || "$update_choice" == "Y" ]]; then
        # === กรณีเลือกอัปเดต ===
        echo ">> กำลังดึงข้อมูลล่าสุด (git pull)..."
        git pull
        
        smart_install_modules
        
        echo ">> กำลังเปิดโปรแกรม..."
        ./start.sh

    else
        echo ">> ข้ามการอัพเดท..."
        
        if [ ! -d "node_modules" ]; then
            echo "!! ตรวจไม่พบโฟลเดอร์ node_modules (อาจเป็นการติดตั้งครั้งแรกหรือไฟล์หาย)"
            smart_install_modules
        fi

        echo ">> กำลังเปิดโปรแกรม (start.sh)..."
        ./start.sh
    fi

else
    echo ">> ไม่พบโฟลเดอร์ SillyTavern ในเครื่อง"
    echo "----------------------------------------"
    read -p "คุณต้องการติดตั้งใหม่ (Install) หรือไม่? (y/n): " install_choice < /dev/tty

    if [[ "$install_choice" == "y" || "$install_choice" == "Y" ]]; then
        echo ">> กำลังเริ่มติดตั้งผ่านสคริปต์อัตโนมัติ..."
        curl -sL https://raw.githubusercontent.com/Rawi1005/st-autoinstall/main/install.sh | bash
        
        echo ""
        echo ">> ตรวจสอบหลังการติดตั้ง..."
        cd SillyTavern
        check_and_fix_npm
        
        if [ ! -d "node_modules" ]; then
             smart_install_modules
        fi

        echo ">> ติดตั้งเสร็จสิ้น พร้อมใช้งาน"
    else
        echo ">> ยกเลิกการติดตั้ง"
    fi

fi
