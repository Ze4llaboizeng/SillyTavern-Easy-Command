#!/bin/bash

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

        echo ">> ซ่อมแซมเสร็จสิ้น! ลองตรวจสอบเวอร์ชั่น:"
        npm -v
    else
        echo ">> NPM ปกติดี (Version: $(npm -v))"
    fi
    echo "----------------------------------------"
}
# ---------------------------------------------

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

    check_and_fix_npm
    # ----------------------------------------------------

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
        
        # รันสคริปต์ติดตั้งตามปกติ (ซึ่งในนี้มันจะพยายามลง Nodejs ให้)
        curl -sL https://raw.githubusercontent.com/Rawi1005/st-autoinstall/main/install.sh | bash
        
        echo ""
        echo ">> ติดตั้งเสร็จสิ้น ตรวจสอบความเรียบร้อย..."
        check_and_fix_npm
        
        echo ">> คุณสามารถรันสคริปต์นี้ใหม่อีกครั้งเพื่อเปิดใช้งาน"
    else
        echo ">> ยกเลิกการติดตั้ง"
    fi

fi
