#!/usr/bin/env bash

# =============================
# 텍스트 다마고치 - 초기 화면 전용
# =============================


TURN=1 # 현재 턴
MAX_TURN=30 # 최대 턴

FEED=100 # 포만감
HAPPY=100 # 행복

SOCIAL=50 #사회성
VISUAL=50 #외모
MORAL=50 #도덕성

#엔딩 해금 확인용 BOOL 변수
END1=0
END2=0
END3=0
END4=0
END5=0
END6=0

#업적 해금 확인용 BOOL 변수
ACH1=0
ACH2=0
ACH3=0




RESET="\033[0m"
BOLD="\033[1m"
CYAN="\033[36m"
YELLOW="\033[33m"

clear_screen() {
    clear 2>/dev/null || printf "\033c"
}

DAMAGOCHI_NAME=""
set_name() {
    local name_input # 사용자의 입력값을 저장할 지역 변수

    # set_name이 성공할 때까지 반복
    while true; do
        read -p "다마고치의 이름을 입력해주세요 (7글자 이하): " name_input
        
        local name_length=${#name_input}
        local success=0 # 성공 여부 플래그 (0: 성공, 1: 실패)

        # 1. 이름 공백 검사
        if [[ -z "$name_input" ]]; then
            echo "⚠️ 오류: 이름을 입력해주세요."
            success=1

        # 2. 이름 길이 (7글자 이하) 검사
        elif (( name_length > 7 )); then
            echo "❌ 오류: 이름은 7글자를 초과할 수 없습니다. (현재 ${name_length}글자)"
            success=1
        
        # 3. 이름 설정 성공
        else
            DAMAGOCHI_NAME="$name_input"
            echo "✅ 다마고치 이름이 **${DAMAGOCHI_NAME}**(으)로 설정되었습니다."
            success=0 # 성공
        fi

        # 성공(success=0)하면 루프를 종료하고, 실패(success=1)하면 다시 시도 메시지 출력 후 반복
        if [ $success -eq 0 ]; then
            break
        else
            echo "다시 시도해주세요."
            echo "---"
        fi
    done
}

damagochi(){
    echo "  .------."
    echo " /        \\         이름: $DAMAGOCHI_NAME"
    echo "|  [ o  o ] |"
    echo "|   .----.   |"
    echo "|  /      \\  |"
    echo "|  |      |  |"
    echo "|  '------'  |"
    echo " \\          /"
    echo "  '--------'"
}

draw_title() {
    echo -e "${CYAN}${BOLD}"
    echo "────────────────────────────────────────────"
    echo "            텍스트 다마고치"
    echo "────────────────────────────────────────────"
    echo -e "${RESET}"
}

draw_initial_menu() {
    draw_title
    echo -e "${YELLOW}${BOLD}메뉴${RESET}"
    echo
    echo "새 게임(1)"
    echo "불러오기(2)"
    echo "갤러리(3)"
    echo "종료하기(4)"
}

draw_Game(){
    echo "────────────────────────────────────────────"
    damagochi
    echo "────────────────────────────────────────────"
    echo "1일차 결과"
    echo "포만감 95 | 행복 20"
    echo "지능 10 | 외모 5 | 도덕 75"
    echo "────────────────────────────────────────────"
    echo "  (a) 식사하기     (b) 책 읽기"
    echo "  (c) 놀아주기     (d) 운동하기"
    echo "  (e) 저장        (f) 게임 종료"
    echo "────────────────────────────────────────────"
}

draw_NewGame(){
    echo "                                      2일차  "
    echo "────────────────────────────────────────────"
    damagochi
    echo "────────────────────────────────────────────"
    echo "[1일차 결과]"
    echo " 포만감 95 | 행복 20"
    echo " 지능 10 | 외모 5 | 도덕 75"
    echo "────────────────────────────────────────────"
    echo "  (a) 식사하기     (b) 책 읽기"
    echo "  (c) 놀아주기     (d) 운동하기"
    echo "────────────────────────────────────────────"
    echo "                      (e) 저장    (f) 게임 종료"

}

# draw_Gallely(){

# }

#  draw_SaveAndLoad(){

# }

# Control_Behave(){

# }

wait_for_num() {
    while true; do
        read -n1 -s key
        case "$key" in
            1)
                clear_screen
                set_name
                draw_NewGame
                break
                ;;
            2)
                clear_screen
                draw_Gallely
                break
                ;;
            3)
                clear_screen
                draw_SaveAndLoad    
                break
                ;;
            4)
                clear_screen
                echo "게임 종료..."
                break
                ;;
            *)
                # 다른 키면 무시하고 계속 대기
                ;;
        esac
    done
}



# 메인
main() {
    clear_screen
    draw_initial_menu
    wait_for_num
}

main
