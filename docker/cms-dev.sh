#!/usr/bin/env bash
set -x

GIT_BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD | tr A-Z a-z)
PROJECT_NAME="cms-$GIT_BRANCH_NAME"
COMPOSE_FILE="docker/docker-compose.dev.yml"

# 1. Start Containers ในโหมด Detached (--build: build image ถ้าจำเป็น)
#    คำสั่งนี้จะสร้าง/เริ่มต้น Container ทั้ง devdb และ devcms และปล่อยให้รันอยู่เบื้องหลัง
echo "Starting containers in detached mode: $PROJECT_NAME"
docker compose -p "$PROJECT_NAME" -f "$COMPOSE_FILE" up -d --build

# 2. รอให้ Database พร้อม (เพิ่มความมั่นใจในการเชื่อมต่อ)
#    ใช้ wait-for-it หรือเพียงแค่ sleep สั้นๆ
#    (เนื่องจาก 'wait-for-it' ในไฟล์ compose ของคุณถูกรันใน command ของ devcms
#     ดังนั้นเราจะข้ามไปใช้ exec เลย แต่ต้องแน่ใจว่า devdb มีเวลา start)
sleep 5 

# 3. เข้าสู่ Container devcms เพื่อทำงาน (ใช้ exec แทน run --rm)
#    exec จะทำให้คุณเข้าสู่ Container ที่รันอยู่แล้ว ข้อมูลจึงยังคงอยู่
echo "Attaching to devcms container..."
docker compose -p "$PROJECT_NAME" -f "$COMPOSE_FILE" exec devcms bash
