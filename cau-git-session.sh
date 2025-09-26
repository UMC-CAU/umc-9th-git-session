#!/bin/bash

# git init
# git status
# git commit -m "Initial commit"
# git switch -c feature/about-page
# git switch main
# git merge feature/about-page

# --- 색상 및 헬퍼 함수 정의 ---
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# 프롬프트 출력 및 명령어 검증 함수
# 사용자가 명령어를 직접 입력하고, 성공 여부를 검증한 뒤 다음 단계로 진행합니다.
prompt_and_validate() { # 함수 정의 시작: 사용자에게 명령을 입력받고 검증하는 함수
    INSTRUCTION=$1      # 첫 번째 인자: 사용자에게 보여줄 미션 설명
    VALIDATION_CMD=$2   # 두 번째 인자: 입력 검증에 사용할 명령어(문자열)
    SUCCESS_MSG=$3      # 세 번째 인자: 성공 시 출력할 메시지

    while true; do      # 무한 루프: 올바른 입력이 들어올 때까지 반복
        echo -e "${YELLOW}>> 미션: ${INSTRUCTION}${NC}" # 미션 설명을 색상과 함께 출력
        read -p "> " user_cmd # 사용자로부터 명령어 입력 받기
        if [[ "$user_cmd" == "exit" ]]; then echo "실습을 종료합니다."; exit 1; fi # 'exit' 입력 시 종료
        
        # 사용자가 입력한 명령어를 실행합니다. 에러 메시지는 숨기지 않아 사용자가 볼 수 있게 합니다.
        eval "$user_cmd" # 사용자가 입력한 명령어 실행
        
        # 검증 로직을 실행하여 성공 여부를 판단합니다.
        if LC_ALL=C eval "$VALIDATION_CMD"; then # 검증 명령어 실행, 성공 시
            echo -e "${GREEN}✔ 성공: ${SUCCESS_MSG}${NC}" # 성공 메시지 출력
            echo "----------------------------------------------------" # 구분선 출력
            sleep 1 # 1초 대기
            break   # 루프 종료(함수 종료)
        else
            echo -e "${RED}✖ 실패: 명령이 올바르지 않거나 조건이 충족되지 않았습니다. 다시 시도하세요.${NC}" # 실패 메시지 출력
        fi
    done
}

# --- 실습 시나리오 시작 ---
clear
echo -e "${CYAN}===== UMC 9th 중앙대학교 Git Sesison에 오신 것을 환영합니다! =====${NC}"
echo "이 실습은 '나만의 웹사이트 만들기' 시나리오로 진행됩니다."
echo "----------------------------------------------------"

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

git config init.defaultBranch main
echo -e "${YELLOW}>> INFO: Git의 기본 브랜치를 'main'으로 설정합니다.${NC}"
echo "----------------------------------------------------"
sleep 1

### --- 1단계: 프로젝트 시작 및 첫 커밋 ---
echo -e "\n${CYAN}### 1단계: 프로젝트 시작 및 첫 커밋 ###${NC}"

prompt_and_validate "현재 폴더에서 Git 프로젝트를 시작하세요. (힌트: git init)" \
                    "[ -d .git ]" \
                    "Git 저장소가 성공적으로 생성되었습니다!"

# --- 3. 원격 저장소 연결 ---
# 현재 폴더가 Git 저장소인지 확인
if [ ! -d .git ]; then
    echo -e "${RED}✖ 오류: 이 폴더는 Git 저장소가 아닙니다. 먼저 'git init'을 실행해주세요.${NC}"
    exit 1
fi

## ----------------------------------------------------------------------

## ----------------------------------------------------------------------


echo -e "${YELLOW}>> INFO: 웹사이트의 메인 페이지 'index.html' 파일을 생성합니다.${NC}"
echo "<h1>My Website</h1>" > index.html
sleep 1

prompt_and_validate "현재 프로젝트의 상태를 확인하세요. (힌트: git status)" \
                    "LC_ALL=C git status | grep -q 'Untracked files'" \
                    "'index.html' 파일이 '추적하지 않는 파일' 목록에 있는 것을 확인했습니다!"

prompt_and_validate "'index.html' 파일을 Staging Area에 추가하세요. (힌트: git add ...)" \
                    "LC_ALL=C git status --porcelain | grep -q 'A  index.html'" \
                    "파일이 Staging Area에 성공적으로 추가되었습니다!"

prompt_and_validate "첫 번째 커밋을 남기세요. 메시지는 'feat: Create main page'로 작성해보세요." \
                    "git rev-list -n 1 HEAD &>/dev/null" \
                    "프로젝트의 첫 번째 커밋이 성공적으로 기록되었습니다!"

### --- 2단계: 커밋 메시지 수정하기 ---
echo -e "\n${CYAN}### 2단계: 방금 작성한 커밋 메시지 수정하기 (amend) ###${NC}"
echo -e "${YELLOW}>> INFO: 이런, 커밋 메시지에 오타가 있었네요! 'Create main page'를 'Initial commit'으로 바꿔봅시다.${NC}"
sleep 1

prompt_and_validate "가장 최근의 커밋 메시지를 \"Initial commit\"으로 수정하세요. (힌트: git commit --amend)" \
                    "git log -1 --pretty=%B | grep -q 'Initial commit'" \
                    "커밋 메시지가 'Initial commit'으로 성공적으로 수정되었습니다!"

### --- 3단계: 새로운 기능 개발 (branch, switch) ---
echo -e "\n${CYAN}### 3단계: '소개' 페이지를 만들기 위한 브랜치 작업 ###${NC}"

prompt_and_validate "'about' 페이지 개발을 위한 'feature/about-page' 브랜치를 생성하세요. (힌트: git branch ...)" \
                    "git branch --list | grep -q 'feature/about-page'" \
                    "새로운 기능 브랜치가 생성되었습니다!"

prompt_and_validate "생성한 'feature/about-page' 브랜치로 이동하세요. (힌트: git switch ...)" \
                    '[ "$(git branch --show-current)" = "feature/about-page" ]' \
                    "성공적으로 'feature/about-page' 브랜치로 이동했습니다!"

# [수정] 새로운 파일을 만드는 대신, 기존 파일(index.html)을 수정합니다.
echo -e "${YELLOW}>> INFO: 'feature/about-page' 브랜치에서 index.html의 제목을 수정합니다.${NC}"
echo "<h1>About Our Company</h1>" > index.html
git add index.html
git commit -m "feat: Update title for about page"
echo -e "${GREEN}✔ 'feature/about-page' 브랜치 작업이 완료되었습니다!${NC}"
echo "----------------------------------------------------"
sleep 1

### --- 4단계: 충돌 상황 만들기 ---
echo -e "\n${CYAN}### 4단계: 병합 충돌(Merge Conflict) 경험하기 ###${NC}"

prompt_and_validate "원래의 'main' 브랜치로 돌아가세요. (힌트: git switch ...)" \
                    '[[ "$(git branch --show-current)" == "main" ]]' \
                    "'main' 브랜치로 복귀했습니다!"

# [수정] feature 브랜치와 '동일한 파일의 동일한 부분'을 다른 내용으로 수정합니다.
echo -e "${YELLOW}>> INFO: 이런! 'main' 브랜치에서도 급하게 'index.html'의 제목을 수정할 일이 생겼습니다.${NC}"
echo "<h1>My Awesome Website</h1>" > index.html
git commit -am "hotfix: Update website title"
echo -e "${GREEN}✔ 'main' 브랜치에서 긴급 수정이 완료되었습니다!${NC}"
echo "----------------------------------------------------"
sleep 1

### --- 5단계: 충돌 해결하기 ---
echo -e "\n${CYAN}### 5단계: 충돌 해결하기 ###${NC}"
echo -e "${YELLOW}>> INFO: 이제 'feature/about-page'의 작업 내용을 'main'으로 가져와 합쳐봅시다.${NC}"
sleep 1

prompt_and_validate "'feature/about-page' 브랜치를 현재 브랜치('main')로 병합하세요. (힌트: git merge ...)" \
    "git status | grep -q 'Unmerged paths'" \
    "예상대로 병합 충돌(Merge Conflict)이 발생했습니다!"

echo -e "\n${RED}!!! 현재 충돌 상태입니다. 아래 안내에 따라 충돌을 해결해주세요. !!!${NC}"
# [수정] 충돌 해결 안내 파일명을 'index.html'로 변경
echo "1. VS Code나 다른 편집기로 'index.html' 파일을 여세요."
echo "2. 아래와 같이 충돌 표시자(<<<<<, =====, >>>>>)가 보일 겁니다."
echo -e "${CYAN}"
cat index.html
echo -e "${NC}"
echo "3. 충돌 표시를 모두 지우고, 원하는 최종 형태로 수정 후 저장하세요."
echo "   (예: <h1>My Awesome Website</h1>)"
read -p "파일 수정이 완료되었다면 Enter를 누르세요..."

# [수정] 검증 로직의 파일명을 'index.html'로 변경
prompt_and_validate "충돌을 해결한 'index.html' 파일을 Staging Area에 추가하세요." \
                    "! git status --porcelain | grep -q 'UU index.html' && git status --porcelain | grep -q 'M  index.html'" \
                    "충돌 해결 파일이 Staging Area에 추가되었습니다!"

prompt_and_validate "충돌 해결을 마무리하는 커밋을 진행하세요. (메시지 없이 'git commit'만 입력해도 됩니다)" \
                    "git status | grep -q 'nothing to commit, working tree clean'" \
                    "병합 충돌을 성공적으로 해결하고 커밋까지 완료했습니다!"


echo -e "\n${CYAN}===== 모든 실습을 완료했습니다! 축하합니다! =====${NC}"
echo "다음으로 표시될, 최종적으로 정리된 커밋 히스토리를 확인해보세요."
sleep 2
git log --all --decorate --oneline --graph

cd ..