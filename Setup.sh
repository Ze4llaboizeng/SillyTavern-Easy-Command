#!/bin/bash



clear

echo "========================================"
echo "    SillyTavern Launcher & Manager      "
echo "========================================"
echo ""



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
งั้นทำอันนี้สำหรับเช็ค Npm ด้วยว่ามีมั้ยถ้าไม่มีก็ให้ใช้ yarn ช่วย ซึ่งตัวเช็ค NPM อ่ะเราจะต้องเคลียร์ก่อนว่าโอเคลองติดตั้ง Silly แล้วแต่ไม่ได้ค่อยมาเช็ค NPM  ไม่คือในโค้ดลงซิลลี่มันมีโค้ดลง nodejs ไง
