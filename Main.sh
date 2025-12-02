#!/usr/bin/env bash

DAMAGOCHI_NAME=""
TURN=1 # 현재 턴
MAX_TURN=30 # 최대 턴

FEED=70 # 포만감
HAPPY=100 # 행복

SOCIAL=50 #사회성
VISUAL=50 #외모
MORAL=50 #도덕성

DICE_RES=0 #주사위 결과 저장용 변수

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

Clear_Vari()
{
    DAMAGOCHI_NAME=""
    TURN=1 # 현재 턴
    MAX_TURN=30 # 최대 턴

    FEED=70 # 포만감
    HAPPY=100 # 행복

    SOCIAL=50 #사회성
    VISUAL=50 #외모
    MORAL=50 #도덕성
}

#주사위 던지기 1~6 사이 숫자가 나옴. 호출만 하면 DICE_RES에 값이 들어가니 그것을 이용하면됨.
Dice_Roll() {
    DICE_RES=$(( RANDOM % 6 + 1))
    echo "$DICE_RES"
}


RESET="\033[0m"
BOLD="\033[1m"
CYAN="\033[36m"
YELLOW="\033[33m"

clear_screen() {
    clear 2>/dev/null || printf "\033c"
}

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
    echo "                 (e) 저장    (q) 게임 종료     "
}

save_game(){

    local slot="$1"
    local file="save${slot}.txt"

    cat > $file <<EOF

    DAMAGOCHI_NAME=$DAMAGOCHI_NAME
    TURN=$TURN
    MAX_TURN=$MAX_TURN
    FEED=$FEED
    HAPPY=$HAPPY
    SOCIAL=$SOCIAL 
    VISUAL=$VISUAL 
    MORAL=$MORAL
EOF

    chmod 444 $file
    echo "게임이 저장되었습니다!"

}

#게임 불러오기
load_game(){

    local slot="$1"
    local file="save${slot}.txt"

    if [[ -f "$file" ]]; then
        source "$file"
        echo "${slot}번 세이브를 불러왔습니다!"
        GAME_STATE="LDAGAME"
    else
        echo "⚠ ${slot}번 세이브는 비어 있습니다! 불러올 수 없습니다."
        GAME_STATE="INIT"
    fi
}

# 저장파일 삭제
delete_game(){
    local slot="$1"
    local file="save${slot}.txt"

    if [[ -f "$file" ]]; then
        rm "$file"
        echo "${slot}번 세이브를 삭제했습니다.!"
    else
        echo "⚠ ${slot}번 세이브는 비어 있습니다! 삭제할 수 없습니다."
    fi

}


draw_Gallely(){
    echo "────────────────────────────────────────────"
    echo "                갤러리 화면"
    echo "────────────────────────────────────────────"
    echo "아직 해금된 엔딩이 없습니다."
    echo "아무 키나 눌러 메뉴로 돌아가세요..."
    read -n1 -s
    GAME_STATE="INIT"
}

InGame() {    
    while [ $TURN -le $MAX_TURN ]; do
        draw_Game
        Control_Behave
        TURN=$((TURN + 1))
    done
    
    Ending
}

Ending(){
    echo "엔딩"
    GAME_STATE="INIT"
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

Control_Behave(){
        echo "다음 행동을 선택해주세요!"

        while true; do
        read -n1 -s key
        case "$key" in
            1)
                clear_screen
                feed
                break
                ;;
            2)
                clear_screen
                book
                break
                ;;
            3)
                clear_screen
                play
                break
                ;;
            4)
                clear_screen
                exercise
                break
                ;;
            e|E)
                clear_screen
                draw_SaveGame
                break
                ;;
            q|Q)
                clear_screen
                echo "게임 종료.."
                exit 0
                break
                ;;
            *)
                # 다른 키면 무시하고 계속 대기
                ;;
        esac
    done
}

draw_SaveGame()
{
          clear

    save1_status="비어 있음"
    save2_status="비어 있음"
    save3_status="비어 있음"

    # 세이브 1
    if [[ -f save1.txt ]]; then
        time=$(date -r save1.txt '+%Y-%m-%d %H:%M:%S 저장됨')
        name=$(grep -E '^[[:space:]]*DAMAGOCHI_NAME=' save1.txt \
           | sed 's/.*=//' \
           | tr -d '"\r')
        save1_status="$time / 이름: $name"
    fi

    # 세이브 2
    if [[ -f save2.txt ]]; then
        time=$(date -r save2.txt '+%Y-%m-%d %H:%M:%S 저장됨')
        name=$(grep -E '^[[:space:]]*DAMAGOCHI_NAME=' save2.txt \
       | sed 's/.*=//' \
       | tr -d '"\r')
        save2_status="$time / 이름: $name"
    fi

    # 세이브 3
    if [[ -f save3.txt ]]; then
        time=$(date -r save3.txt '+%Y-%m-%d %H:%M:%S 저장됨')
        name=$(grep -E '^[[:space:]]*DAMAGOCHI_NAME=' save3.txt \
       | sed 's/.*=//' \
       | tr -d '"\r')
        save3_status="$time / 이름: $name"
    fi

    cat <<EOF
                📁 저장 기록

  [1] 세이브 1 : $save1_status
  [2] 세이브 2 : $save2_status
  [3] 세이브 3 : $save3_status

                  📂 저장
    ----------------------------------------------
    1) 1번 세이브 저장
    2) 2번 세이브 저장
    3) 3번 세이브 저장
EOF
        while true; do
        read -n1 -s key
        case "$key" in
            1)
                clear
                save_game 1
                break
                ;;
            2)
               clear
               save_game 2
                break
                ;;
            3) 
               clear
               save_game 3
                break
                ;;
            *)
                # 다른 키면 무시하고 계속 대기
                ;;
        esac
    done

    draw_Game
    Control_Behave
}

#메인화면 불러오기 인터페이스
draw_LoadGame() 
{

    clear

    save1_status="비어 있음"
    save2_status="비어 있음"
    save3_status="비어 있음"

    # 세이브 1
    if [[ -f save1.txt ]]; then
        time=$(date -r save1.txt '+%Y-%m-%d %H:%M:%S 저장됨')
        name=$(grep -E '^[[:space:]]*DAMAGOCHI_NAME=' save1.txt \
           | sed 's/.*=//' \
           | tr -d '"\r')
        save1_status="$time / 이름: $name"
    fi

    # 세이브 2
    if [[ -f save2.txt ]]; then
        time=$(date -r save2.txt '+%Y-%m-%d %H:%M:%S 저장됨')
        name=$(grep -E '^[[:space:]]*DAMAGOCHI_NAME=' save2.txt \
        | sed 's/.*=//' \
        | tr -d '"\r')
        save2_status="$time / 이름: $name"
    fi

    # 세이브 3
    if [[ -f save3.txt ]]; then
        time=$(date -r save3.txt '+%Y-%m-%d %H:%M:%S 저장됨')
        name=$(grep -E '^[[:space:]]*DAMAGOCHI_NAME=' save3.txt \
        | sed 's/.*=//' \
        | tr -d '"\r')
        save3_status="$time / 이름: $name"
    fi

        cat <<EOF
            📁 저장 기록

    [1] 세이브 1 : $save1_status
    [2] 세이브 2 : $save2_status
    [3] 세이브 3 : $save3_status

                  📂 불러오기
    ----------------------------------------------
    1) 1번 세이브 불러오기  4) 1번 세이브 삭제
    2) 2번 세이브 불러오기  5) 2번 세이브 삭제
    3) 3번 세이브 불러오기  6) 3번 세이브 삭제
    ----------------------------------------------
    아무 키나 입력하면 메인으로 돌아갑니다.
EOF

        while true; do
        read -n1 -s key
        case "$key" in
            1)
                clear
                load_game 1
                break
                ;;
            2)
               clear
               load_game 2
                break
                ;;
            3) 
               clear
               load_game 3
                break
                ;;
            4) 
                clear
               delete_game 1
               GAME_STATE="INIT"
               break;
                ;;
            5) 
                clear
               delete_game 2
               GAME_STATE="INIT"
                break
                ;;
            6) 
                clear
               delete_game 3
               GAME_STATE="INIT"
                break
                ;;    
            *)
                clear
                GAME_STATE="INIT"
                break;
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
                break
                ;;
            2)
                clear_screen
                GAME_STATE="LOAD"
                break
                ;;
                
            3) 
                clear_screen
                GAME_STATE="GALLAY"
                break
                ;;
            4)
                clear_screen
                GAME_STATE="EXIT"

                echo "게임 종료..."
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
                Clear_Vari
                set_name
                InGame # 게임 진행 및 사용자 행동 제어 시작
                ;;
            "LDAGAME")
                InGame
                ;;
            "GALLAY")
                draw_Gallely
                ;;
            
            "LOAD")
                draw_LoadGame
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
