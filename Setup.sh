#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' 

echo -e "${CYAN}============================================${NC}"
echo -e "${BOLD}🍺  SillyTavern Launcher & Manager  🍺${NC}"
echo -e "${CYAN}============================================${NC}"
echo ""

# --- ตรวจเช็คว่ามีโฟลเดอร์ SillyTavern หรือยัง ---
if [ -d "SillyTavern" ]; then
    # ================= กรณีติดตั้งแล้ว =================
    echo -e "${GREEN}✅ ตรวจพบการติดตั้ง SillyTavern แล้ว!${NC}"
    echo -e "${YELLOW}💡 คุณรันคำสั่งนี้เพราะต้องการเปิด SillyTavern ใช่ไหม?${NC}"
    echo ""
    
    echo -e "คุณต้องการ ${CYAN}อัปเดต (git pull)${NC} ให้เป็นเวอร์ชันล่าสุดก่อนเปิดไหม?"
    echo -e "กด ${GREEN}[y]${NC} เพื่ออัปเดต หรือกด ${RED}[n]${NC} เพื่อข้ามและเปิดเลย"
    read -p "เลือกคำตอบ (y/n): " update_choice

    cd SillyTavern

    if [[ "$update_choice" == "y" || "$update_choice" == "Y" ]]; then
        echo ""
        echo -e "${CYAN}🔄 กำลังตรวจสอบการอัปเดตจาก GitHub...${NC}"
        git pull
        echo -e "${GREEN}✨ อัปเดตเรียบร้อย (หรือเป็นเวอร์ชันล่าสุดแล้ว)${NC}"
    else
        echo ""
        echo -e "${YELLOW}⏩ ข้ามการอัปเดต...${NC}"
    fi

    echo ""
    echo -e "${BOLD}🚀 กำลังเริ่มระบบ SillyTavern... ขอให้สนุก!${NC}"
    echo -e "${CYAN}--------------------------------------------${NC}"
    ./start.sh

else
    # ================= กรณีพึ่งติดตั้งครั้งแรก =================
    echo -e "${RED}❌ ไม่พบโฟลเดอร์ SillyTavern${NC}"
    echo -e "${YELLOW}📦 ระบบกำลังจะเริ่มดาวน์โหลดและติดตั้งให้คุณเดี๋ยวนี้...${NC}"
    echo ""
    echo -e "${CYAN}⏳ กรุณารอสักครู่ กำลังรันสคริปต์ติดตั้ง...${NC}"
    echo -e "${CYAN}--------------------------------------------${NC}"
    
    curl -sL https://raw.githubusercontent.com/Rawi1005/st-autoinstall/main/install.sh | bash
fi
