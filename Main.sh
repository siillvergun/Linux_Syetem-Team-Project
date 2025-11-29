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
