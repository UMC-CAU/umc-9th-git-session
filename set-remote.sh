echo "실행되는 Directory를 반드시 확인하세요."
echo "Current Working Directory: $(pwd)"

echo -e "\n${YELLOW}>> 원격 저장소(remote)를 연결합니다.${NC}"
read -p "연결할 원격 저장소의 URL을 입력하세요: " remote_url

# 'origin'이라는 이름의 원격 저장소가 이미 있는지 확인
if git remote | grep -q "origin"; then
    echo -e "\n${YELLOW}>> INFO: 'origin' 원격 저장소가 이미 존재합니다.${NC}"
    read -p "기존 URL을 방금 입력한 주소로 변경하시겠습니까? (y/n): " -n 1 -r
    echo # 줄바꿈
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git remote set-url origin "$remote_url"
        echo -e "\n${GREEN}✔ 'origin'의 URL을 성공적으로 변경했습니다!${NC}"
    else
        echo "작업을 취소했습니다."
    fi
else
    git remote add origin "$remote_url"
    echo -e "\n${GREEN}✔ 'origin' 원격 저장소를 성공적으로 추가했습니다!${NC}"
fi