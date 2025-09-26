#!/bin/bash

# --- 색상 및 헬퍼 함수 정의 ---
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 프롬프트 출력 및 명령어 검증 함수
prompt_and_validate() {
    INSTRUCTION=$1
    VALIDATION_CMD=$2
    SUCCESS_MSG=$3

    while true; do
        echo -e "${YELLOW}>> 미션: ${INSTRUCTION}${NC}"
        read -p "> " user_cmd
        # 사용자가 exit를 입력하면 스크립트 종료
        if [[ "$user_cmd" == "exit" ]]; then exit 1; fi
        eval "$user_cmd" 2>/dev/null # 명령어 실행 (에러 메시지는 숨김)

        if eval "$VALIDATION_CMD"; then
            echo -e "${GREEN}✔ 성공: ${SUCCESS_MSG}${NC}"
            echo "----------------------------------------------------"
            sleep 1
            break
        else
            echo -e "${RED}✖ 실패: 명령이 올바르지 않거나 조건이 충족되지 않았습니다. 다시 시도하세요.${NC}"
        fi
    done
}

# --- 실습 시작 ---
clear
echo "===== Part 1: 로컬 저장소 생성 (대화형 실습) 시작 ====="
echo ""

# 실습 폴더 생성
echo -e "${YELLOW}>> INFO: 기존에 'caumc-git-session' 폴더가 있으면 삭제하고, 새로 생성합니다.${NC}"
echo ""

rm -rf caumc-git-session
mkdir caumc-git-session

echo -e "${YELLOW}>> INFO: 'caumc-git-session' 폴더로 이동합니다.\n${NC}이동 전 Working Directory : ${GREEN}$(pwd)${NC}"
echo ""

cd caumc-git-session

echo -e "Terminal Working Directory를 새로 생성된 실습 폴더 'caumc-git-session'로 이동했습니다.\npwd: ${GREEN}$(pwd)${NC}"

# 1. git init
prompt_and_validate "현재 폴더를 Git 저장소로 초기화하세요. (힌트: git init)" \
                    "[ -d .git ]" \
                    ".git 폴더가 생성되어 저장소 초기화에 성공했습니다!"

# 2. 파일 생성 (이 단계는 스크립트가 자동으로 처리)
echo -e "${YELLOW}>> INFO: 실습을 위해 README.md 파일을 생성합니다.${NC}"
echo "# My First Repository" > README.md
cat README.md
echo "----------------------------------------------------"
sleep 1

# 3. git status (상태 확인)
prompt_and_validate "파일이 생성된 후의 Git 상태를 확인하세요. (힌트: git status)" \
                    "git status | grep -q 'README.md'" \
                    "'README.md가 git의 tracked file에 확인했습니다!"

# 4. git add
prompt_and_validate "README.md 파일을 Staging Area에 추가하세요. (힌트: git add <파일명>)" \
                    "git status --porcelain | grep -q 'A  README.md'" \
                    "파일이 Staging Area에 성공적으로 추가되었습니다!"

# 5. git commit
COMMIT_COUNT_BEFORE=$(git rev-list --count HEAD 2>/dev/null)
COMMIT_COUNT_BEFORE=${COMMIT_COUNT_BEFORE:-0}
prompt_and_validate "Staging Area의 변경사항을 커밋하세요. (힌트: git commit -m \"커밋 메시지\")" \
                    "[ $(git rev-list --count HEAD) -gt $COMMIT_COUNT_BEFORE ]" \
                    "첫 번째 커밋이 성공적으로 기록되었습니다!"

# 6. 파일 수정 (자동 처리)
echo -e "${YELLOW}>> INFO: 실습을 위해 README.md 파일을 수정합니다.${NC}"
echo "Git and GitHub session practice." >> README.md
cat README.md
echo "----------------------------------------------------"
sleep 1

# 7. git commit -am
COMMIT_COUNT_BEFORE=$(git rev-list --count HEAD)
prompt_and_validate "수정된 파일을 add와 commit을 동시에 처리하세요. (힌트: git commit -am \"...\" )" \
                    "[ $(git rev-list --count HEAD) -gt $COMMIT_COUNT_BEFORE ]" \
                    "두 번째 커밋(수정사항)이 성공적으로 기록되었습니다!"

git log --oneline
echo ""
echo "===== Part 1 (대화형 실습) 완료! ====="
cd ..