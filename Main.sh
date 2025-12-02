#!/usr/bin/env bash

TURN=1 # 현재 턴
MAX_TURN=30 # 최대 턴

FEED=70 # 포만감
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
    echo "                                  ${TURN}일차"
    echo "────────────────────────────────────────────"
    damagochi
    echo "────────────────────────────────────────────"
    echo "[1일차 결과]"
    echo " 포만감 $FEED | 행복 $HAPPY"
    echo " 사회성 $SOCIAL | 외모 $VISUAL | 도덕 $MORAL"
    echo "────────────────────────────────────────────"
    echo "  (1) 식사하기     (2) 책 읽기"
    echo "  (3) 놀아주기     (4) 운동하기"
    echo "────────────────────────────────────────────"
    echo "                 (e) 저장    (f) 게임 종료     "
}


draw_Gallely(){
    echo "────────────────────────────────────────────"
    echo "                갤러리 화면"
    echo "────────────────────────────────────────────"
    echo "아직 해금된 엔딩이 없습니다."
    echo "아무 키나 눌러 메뉴로 돌아가세요..."
    read -n1 -s
    GAME_STATE="MENU"
}

draw_SaveAndLoad(){
    echo "────────────────────────────────────────────"
    echo "              저장 & 로드 화면"
    echo "────────────────────────────────────────────"
    echo "현재 저장/불러오기 기능은 미구현 상태입니다."
    echo "아무 키나 눌러 메뉴로 돌아가세요..."
    read -n1 -s
    GAME_STATE="MENU"
}

feed(){
    echo "밥 먹자 (+포만감, +행복)"
}
book(){
    echo "책 읽자 (+도덕성, +사회성)"
}
play(){
    echo "놀자 (+행복, +사회성)"
}
exercise(){
    echo "운동하자 (+외모, -포만감)"
}
save(){
    echo "저장되었습니다 (기능 미구현)"
}
quit(){
    echo "저장되지 않았습니다... 초기화면으로 돌아갑니다."
    GAME_STATE="INIT" # 🌟🌟🌟 [수정]: 초기화면 복귀를 위한 상태 변경 🌟🌟🌟
}

InGame() {
    set_name

    while [ $TURN -le $MAX_TURN ]; do
        clear_screen
        draw_Game
        Control_Behave
        TURN=$((TURN + 1))
    done
    
    Ending
}

Ending(){
    GAME_STATE="INIT"
}

Control_Behave(){
        echo "다음 행동을 선택해주세요!"

        while true; do
        read -n1 -s key
        case "$key" in
            1)
                feed
                break
                ;;
            2)
                book
                break
                ;;
            3)
                play
                break
                ;;
            4)
                exercise
                break
                ;;
            s)
                save
                break
                ;;
            q)
                quit
                break
                ;;
            *)
                # 다른 키면 무시하고 계속 대기
                ;;
        esac
    done
}


wait_for_menu() {
    while true; do
        read -n1 -s key
        case "$key" in
            1)
                clear_screen
                GAME_STATE="INGAME"
                echo "1"
                break
                ;;
            2)
                clear_screen
                GAME_STATE="GALLAY"
                break
                ;;
            3)
                clear_screen
                GAME_STATE="SAVE&LOAD"
                break
                ;;
            4)
                clear_screen
                GAME_STATE="EXIT"
                break
                ;;
            *)
                # 다른 키면 무시하고 계속 대기
                ;;
        esac
    done
}


GAME_STATE="INIT"
# 메인
main() {
    while [ "$GAME_STATE" != "EXIT" ]; do
    
        # 현재 게임 상태에 따라 적절한 함수를 호출
        case "$GAME_STATE" in
            "INIT")
                # 요청: 맨 처음 게임을 실행하면 draw_initial_menu를 호출
                draw_initial_menu
                wait_for_menu
                ;;
                
            "INGAME")
                InGame # 게임 진행 및 사용자 행동 제어 시작
                ;;

            "GALLAY")
                draw_Gallely
                ;;
            
            "SAVE&LOAD")
                draw_SaveAndLoad
                ;;

            *)
                echo "🚨 알 수 없는 게임 상태입니다. (상태: $GAME_STATE) 게임을 종료합니다."
                GAME_STATE="EXIT"
                ;;
        esac
    done
    
    echo "게임 종료."

}

main
