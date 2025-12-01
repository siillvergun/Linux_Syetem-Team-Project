#!/usr/bin/env bash

# =============================
# 텍스트 다마고치 - 초기 화면 전용
# =============================

RESET="\033[0m"
BOLD="\033[1m"
CYAN="\033[36m"
YELLOW="\033[33m"

clear_screen() {
    clear 2>/dev/null || printf "\033c"
}

damagochi(){
    echo "  .------."
    echo " /        \\         이름: "
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
    echo "초기 화면입니다."
    echo "다음 화면으로 넘어가려면 [y] 키를 누르세요."
}

wait_for_y() {
    while true; do
        # -n1 : 1글자만 읽기, -s : 입력 표시하지 않기
        read -n1 -s key
        case "$key" in
            y|Y)
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
    wait_for_y

    # y를 눌러 넘어왔을 때 화면 전환
    clear_screen
    draw_title
    echo
    echo "다음 화면입니다. (여기서부터 '시작하기/갤러리/종료하기' 실제 로직 구현 예정)"
    echo
}

main
#!/usr/bin/env bash

# =============================
# 텍스트 다마고치 - 초기 화면 전용
# =============================

RESET="\033[0m"
BOLD="\033[1m"
CYAN="\033[36m"
YELLOW="\033[33m"

clear_screen() {
    clear 2>/dev/null || printf "\033c"
}

damagochi(){
    echo "  .------."
    echo " /        \\         이름: "
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
    echo "  (a) 식사하기  (b) 책 읽기"
    echo "  (c) 놀아주기  (d) 운동하기"
    echo "────────────────────────────────────────────"
    echo "                      (e) 저장    (f) 종료"

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
