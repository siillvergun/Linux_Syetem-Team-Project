#!/usr/bin/env bash

DAMAGOCHI_NAME=""
TURN=1 # 현재 턴
MAX_TURN=30 # 최대 턴

FEED=70 # 포만감
HAPPY=70 # 행복

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

clamp_stats() {
    # FEED
    [ "$FEED" -lt 0 ]   && FEED=0
    [ "$FEED" -gt 100 ] && FEED=100

    # HAPPY
    [ "$HAPPY" -lt 0 ]   && HAPPY=0
    [ "$HAPPY" -gt 100 ] && HAPPY=100

    # SOCIAL
    [ "$SOCIAL" -lt 0 ]   && SOCIAL=0
    [ "$SOCIAL" -gt 100 ] && SOCIAL=100

    # VISUAL
    [ "$VISUAL" -lt 0 ]   && VISUAL=0
    [ "$VISUAL" -gt 100 ] && VISUAL=100

    # MORAL
    [ "$MORAL" -lt 0 ]   && MORAL=0
    [ "$MORAL" -gt 100 ] && MORAL=100
}

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
}
EVENT_RES=""

RESET="\033[0m"
BOLD="\033[1m"
CYAN="\033[36m"
YELLOW="\033[33m"

clear_screen() {
    clear 2>/dev/null || printf "\033c"
}

set_name() {
    echo
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
    if [ "$TURN" -gt 1 ]; then
        # 이전 턴( TURN-1 ) 결과 출력
        local prev_turn=$((TURN - 1))
        echo "[${prev_turn}일차 결과]: $EVENT_RES"
        echo "$EVENT_SCRIPT"
    fi
    echo "────────────────────────────────────────────"
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

Load_UserData () {
 if [[ ! -f "user.txt" ]]; then
        cat > "user.txt" <<EOF
    END1=0
    END2=0
    END3=0
    END4=0
    END5=0
    END6=0

    ACH1=0
    ACH2=0
    ACH3=0
EOF
    fi

    # user.txt가 존재하면 불러오기
    source "user.txt"

    # 권한 설정
    chmod 444 "user.txt"
}


draw_Gallely(){
    echo "────────────────────────────────────────────"
    echo "                갤러리 화면"
    echo "────────────────────────────────────────────"
    echo "아직 해금된 엔딩이 없습니다."
    echo "아무 키나 눌러 메뉴로 돌아가세요..."
    echo $END2
    read -n1 -s
    GAME_STATE="INIT"
}

draw_Next_Turn(){
    clear_screen
    echo "────────────────────────────────────────────"
    echo
    echo "  다음 날이 밝았습니다."
    echo "  아무 키나 눌러 오늘의 상황을 확인하세요."
    echo
    echo "────────────────────────────────────────────"
    read -n1 -s   # 키 입력 대기

    # 돌발 이벤트 체크
    Random_Event2  # 여기서 Dice_Roll + DICE_RES 세팅

    # DICE_RES가 1 또는 2일 때만 돌발 이벤트 멘트 출력
    if [ "$DICE_RES" -eq 1 ] || [ "$DICE_RES" -eq 2 ]; then
        Random_Event2_Script
        echo
        echo "$EVENT_SCRIPT2"
        echo
        echo "────────────────────────────────────────────"
        echo "아무 키나 눌러 게임을 계속합니다..."
        read -n1 -s
    fi
}

Random_Event2(){
    Dice_Roll
    case "$DICE_RES" in
    1|2)
        clear_screen
        echo
        echo "** !!돌발 이벤트 발생!! **"
        echo "** !!돌발 이벤트 발생!! **"
        echo "** !!돌발 이벤트 발생!! **"
        ;;
    *)
        ;;
    esac
    echo "────────────────────────────────────────────"
}


InGame() {
    while [ "$TURN" -le "$MAX_TURN" ]; do

        if [ "$TURN" -ge 2 ]; then
            draw_Next_Turn
        fi
        
        clear_screen
        draw_Game
        Control_Behave

        clamp_stats
        
        if [ "$GAME_STATE" = "INIT" ]; then
            break
        fi

        TURN=$((TURN + 1))
    done
    
    if [ "$TURN" -gt "$MAX_TURN" ]; then
        Ending
    fi
}

Ending(){
    echo "🎉 30일이 경과하여 다마고치 엔딩을 맞이합니다!"
    # 엔딩 결과에 따라 메세지 출력 로직 추가 예정
    echo "아무 키나 눌러 초기화면으로 돌아가세요..."
    read -n1 -s
    GAME_STATE="INIT"
}

EVENT_SCRIPT=""
Random_Event_Script_Feed(){
    # 밥 먹기 전용 랜덤 멘트
    case "$DICE_RES" in
        1)  # 대실패
            local r=$(( RANDOM % 3 ))
            case "$r" in
                0) EVENT_SCRIPT="$DAMAGOCHI_NAME가 밥그릇을 통째로 엎어버렸다..." 
                FEED=$((FEED - 15)) HAPPY=$((HAPPY - 15));;
                1) EVENT_SCRIPT="밥을 태워버려서 결국 굶게 되었다..." 
                FEED=$((FEED - 15)) HAPPY=$((HAPPY - 15));;
                2) EVENT_SCRIPT="밥 대신 숟가락만 만지작거리다가 식사가 끝났다." 
                FEED=$((FEED - 15)) HAPPY=$((HAPPY - 15));;
            esac
            ;;
        2|3)  # 실패
            local r=$(( RANDOM % 3 ))
            case "$r" in
                0) EVENT_SCRIPT="편식을 해서 반쯤만 먹고 말았다." 
                FEED=$((FEED - 10)) HAPPY=$((HAPPY - 5));;
                1) EVENT_SCRIPT="밥보다 장난감이 더 좋은지 몇 입 먹고 일어났다." 
                FEED=$((FEED - 10)) HAPPY=$((HAPPY - 5));;
                2) EVENT_SCRIPT="밥을 조금 먹더니 금방 흥미를 잃어버렸다." 
                FEED=$((FEED - 10)) HAPPY=$((HAPPY - 5));;
            esac
            ;;
        4)  # 아무 일도
            local r=$(( RANDOM % 3 ))
            case "$r" in
                0) EVENT_SCRIPT="아무 일도 없었다. 아주 평범한 식사 시간이었다." ;;
                1) EVENT_SCRIPT="$DAMAGOCHI_NAME는 조용히 밥을 먹고 물 한 모금 마셨다." ;;
                2) EVENT_SCRIPT="특별한 일은 없었지만, 무난하게 끼니를 해결했다." ;;
            esac
            ;;
        5)  # 성공
            local r=$(( RANDOM % 3 ))
            case "$r" in
                0) EVENT_SCRIPT="밥을 맛있게 먹고 배를 두드리며 만족해한다." 
                FEED=$((FEED + 10)) HAPPY=$((HAPPY + 10));;
                1) EVENT_SCRIPT="골고루 잘 먹어서 포만감이 올라간 것 같다." 
                FEED=$((FEED + 10)) HAPPY=$((HAPPY + 10));;
                2) EVENT_SCRIPT="남기지 않고 깔끔하게 그릇을 비웠다." 
                FEED=$((FEED + 10)) HAPPY=$((HAPPY + 10));;
            esac
            ;;
        6)  # 대성공
            local r=$(( RANDOM % 3 ))
            case "$r" in
                0) EVENT_SCRIPT="$DAMAGOCHI_NAME가 폭풍흡입을 하고 행복하게 트림을 했다." 
                FEED=$((FEED + 15)) HAPPY=$((HAPPY + 15));;
                1) EVENT_SCRIPT="추가로 한 그릇 더 먹고 기운이 불끈 솟아났다." 
                FEED=$((FEED + 15)) HAPPY=$((HAPPY + 15));;
                2) EVENT_SCRIPT="식사 시간이 소소한 축제처럼 느껴졌다." 
                FEED=$((FEED + 15)) HAPPY=$((HAPPY + 15));;
            esac
            ;;
    esac
}

Random_Event_Script_Read(){
    # 책 읽기 전용 랜덤 멘트
    case "$DICE_RES" in
        1)  # 대실패
            local r=$(( RANDOM % 3 ))
            case "$r" in
                0) EVENT_SCRIPT="책을 펼치자마자 잠이 쏟아져 그대로 자버렸다." 
                FEED=$((FEED - 5)) HAPPY=$((HAPPY + 15)) MORAL=$((MORAL-15));;
                1) EVENT_SCRIPT="책을 거꾸로 들고 한참을 보고 있었다..." 
                FEED=$((FEED - 5)) MORAL=$((MORAL-15));;
                2) EVENT_SCRIPT="첫 페이지를 넘기기도 전에 집중력을 완전히 잃었다." 
                FEED=$((FEED - 5)) MORAL=$((MORAL-15));;
            esac
            ;;
        2|3)  # 실패
            local r=$(( RANDOM % 3 ))
            case "$r" in
                0) EVENT_SCRIPT="몇 줄 읽다가 핸드폰 생각이 나서 책을 덮어버렸다." 
                FEED=$((FEED - 5)) HAPPY=$((HAPPY + 5)) MORAL=$((MORAL-10));;
                1) EVENT_SCRIPT="같은 줄만 계속 읽다가 포기해버렸다." 
                FEED=$((FEED - 5)) HAPPY=$((HAPPY - 5)) MORAL=$((MORAL-10));;
                2) EVENT_SCRIPT="내용이 너무 어려워서 머리 위로 물음표만 떠다녔다." 
                FEED=$((FEED - 5)) HAPPY=$((HAPPY - 5)) MORAL=$((MORAL-10));;
            esac
            ;;
        4)  # 아무 일도
            local r=$(( RANDOM % 3 ))
            case "$r" in
                0) EVENT_SCRIPT="특별한 감흥 없이, 그럭저럭 책 한 챕터를 읽었다." ;;
                1) EVENT_SCRIPT="$DAMAGOCHI_NAME는 조용히 책장을 넘기며 시간을 보냈다." ;;
                2) EVENT_SCRIPT="아무 일도 없었지만, 약간은 지식이 늘어난 느낌이다." ;;
            esac
            ;;
        5)  # 성공
            local r=$(( RANDOM % 3 ))
            case "$r" in
                0) EVENT_SCRIPT="흥미로운 부분을 발견하고 눈을 반짝였다." 
                FEED=$((FEED - 5)) HAPPY=$((HAPPY + 15)) MORAL=$((MORAL+10));;
                1) EVENT_SCRIPT="새로운 단어와 표현을 몇 개나 배웠다." 
                FEED=$((FEED - 5)) HAPPY=$((HAPPY + 15)) MORAL=$((MORAL+10));;
                2) EVENT_SCRIPT="책 속 이야기에 빠져서 시간 가는 줄 몰랐다." 
                FEED=$((FEED - 5)) HAPPY=$((HAPPY + 15)) MORAL=$((MORAL+10));;
            esac
            ;;
        6)  # 대성공
            local r=$(( RANDOM % 3 ))
            case "$r" in
                0) EVENT_SCRIPT="인생 문장을 발견하고 깊은 감동을 받았다." 
                FEED=$((FEED - 10)) HAPPY=$((HAPPY + 15)) MORAL=$((MORAL+15));;
                1) EVENT_SCRIPT="책의 내용을 자기 삶에 적용해보겠다고 다짐했다." 
                FEED=$((FEED - 10)) HAPPY=$((HAPPY + 15)) MORAL=$((MORAL+15));;
                2) EVENT_SCRIPT="독서 후 $DAMAGOCHI_NAME의 눈빛이 한층 똑똑해졌다." 
                FEED=$((FEED - 10)) HAPPY=$((HAPPY + 15)) MORAL=$((MORAL+15));;
            esac
            ;;
    esac
}

Random_Event_Script_Play(){
    # 놀아주기 전용 랜덤 멘트
    case "$DICE_RES" in
        1)  # 대실패
            local r=$(( RANDOM % 3 ))
            case "$r" in
                0) EVENT_SCRIPT="뛰어놀다가 넘어져서 울음을 터뜨렸다." 
                FEED=$((FEED - 10)) HAPPY=$((HAPPY - 15)) VISUAL=$((VISUAL-10));;
                1) EVENT_SCRIPT="장난감이 부서져버려서 분위기가 싸해졌다." 
                FEED=$((FEED - 10)) HAPPY=$((HAPPY - 15));;
                2) EVENT_SCRIPT="서로 오해가 생겨서 놀이가 싸움이 되어버렸다." 
                FEED=$((FEED - 10)) HAPPY=$((HAPPY - 15)) SOCIAL=$((SOCIAL-15));;
            esac
            ;;
        2|3)  # 실패
            local r=$(( RANDOM % 3 ))
            case "$r" in
                0) EVENT_SCRIPT="놀다가 금방 흥미를 잃고 시무룩해졌다."
                FEED=$((FEED - 5)) HAPPY=$((HAPPY - 10));;
                1) EVENT_SCRIPT="게임 룰을 잘 몰라서 어수선하게 끝났다."
                FEED=$((FEED - 5)) HAPPY=$((HAPPY - 5)) SOCIAL=$((SOCIAL-10));;
                2) EVENT_SCRIPT="기대만큼 재미있진 않았던 시간." 
                FEED=$((FEED - 5)) HAPPY=$((HAPPY - 5)) SOCIAL=$((SOCIAL-5));;
            esac
            ;;
        4)  # 아무 일도
            local r=$(( RANDOM % 3 ))
            case "$r" in
                0) EVENT_SCRIPT="적당히 즐겁게 놀고, 무난하게 시간이 흘렀다." ;;
                1) EVENT_SCRIPT="$DAMAGOCHI_NAME는 조용히 혼자 블록을 쌓으며 놀았다." ;;
                2) EVENT_SCRIPT="크게 웃지도, 그렇다고 지루하지도 않은 평범한 놀이 시간." ;;
            esac
            ;;
        5)  # 성공
            local r=$(( RANDOM % 3 ))
            case "$r" in
                0) EVENT_SCRIPT="깔깔 웃으면서 신나게 놀았다." 
                FEED=$((FEED - 5)) HAPPY=$((HAPPY + 15)) SOCIAL=$((SOCIAL+10));;
                1) EVENT_SCRIPT="새로운 게임을 만들어서 둘만의 유행놀이가 생겼다." 
                FEED=$((FEED - 5)) HAPPY=$((HAPPY + 15)) SOCIAL=$((SOCIAL+10));;
                2) EVENT_SCRIPT="놀이가 끝나고도 여운이 남는 즐거운 시간이었다." 
                FEED=$((FEED - 5)) HAPPY=$((HAPPY + 15)) SOCIAL=$((SOCIAL+10));;
            esac
            ;;
        6)  # 대성공
            local r=$(( RANDOM % 3 ))
            case "$r" in
                0) EVENT_SCRIPT="웃다가 배가 아플 정도로 즐거운 시간을 보냈다." 
                FEED=$((FEED - 10)) HAPPY=$((HAPPY + 20)) SOCIAL=$((SOCIAL+15)) MORAL=$((MORAL+5));;
                1) EVENT_SCRIPT="$DAMAGOCHI_NAME가 '또 놀자!'를 연발했다." 
                FEED=$((FEED - 10)) HAPPY=$((HAPPY + 20)) SOCIAL=$((SOCIAL+15)) MORAL=$((MORAL+5));;
                2) EVENT_SCRIPT="오늘 놀았던 일은 오래 기억에 남을 것 같다." 
                FEED=$((FEED - 10)) HAPPY=$((HAPPY + 20)) SOCIAL=$((SOCIAL+15)) MORAL=$((MORAL+5));;
            esac
            ;;
    esac
}

Random_Event_Script_Exercise(){
    # 운동하기 전용 랜덤 멘트
    case "$DICE_RES" in
        1)  # 대실패
            local r=$(( RANDOM % 3 ))
            case "$r" in
                0) EVENT_SCRIPT="준비운동도 안 하고 뛰었다가 다리에 쥐가 났다." 
                HAPPY=$((HAPPY - 10)) VISUAL=$((VISUAL-10));; 
                1) EVENT_SCRIPT="비에 젖어 감기에 걸릴 것 같은 불길한 예감이 든다." 
                HAPPY=$((HAPPY - 10)) VISUAL=$((VISUAL-10));; 
                2) EVENT_SCRIPT="운동장에 나가자마자 비가 쏟아져 그냥 돌아왔다." 
                HAPPY=$((HAPPY - 10)) VISUAL=$((VISUAL-10));; 
            esac
            ;;
        2|3)  # 실패
            local r=$(( RANDOM % 3 ))
            case "$r" in
                0) EVENT_SCRIPT="조금만 뛰었는데 숨이 차서 바로 포기했다." 
                FEED=$((FEED - 5)) HAPPY=$((HAPPY - 5)) VISUAL=$((VISUAL-  5));;
                1) EVENT_SCRIPT="체력이 부족해 중간에 벤치에 주저앉아버렸다."
                FEED=$((FEED - 5)) HAPPY=$((HAPPY - 5)) VISUAL=$((VISUAL - 5));;
                2) EVENT_SCRIPT="동작이 잘 안 되어서 의욕이 떨어졌다." 
                FEED=$((FEED - 5)) HAPPY=$((HAPPY - 5)) VISUAL=$((VISUAL - 5));;
            esac
            ;;
        4)  # 아무 일도
            local r=$(( RANDOM % 3 ))
            case "$r" in
                0) EVENT_SCRIPT="무난하게 스트레칭과 가벼운 운동을 마쳤다." ;;
                1) EVENT_SCRIPT="$DAMAGOCHI_NAME는 땀을 조금 흘리고 상쾌해진 기분이다." ;;
                2) EVENT_SCRIPT="특별한 성과는 없지만, 몸을 조금은 풀어준 느낌이다." ;;
            esac
            ;;
        5)  # 성공
            local r=$(( RANDOM % 3 ))
            case "$r" in
                0) EVENT_SCRIPT="땀이 송글송글 맺힐 정도로 열심히 운동했다." 
                FEED=$((FEED - 5)) HAPPY=$((HAPPY + 10)) SOCIAL=$((SOCIAL+5)) VISUAL=$((VISUAL+5));;
                1) EVENT_SCRIPT="운동 후 물 한 잔과 함께 개운함을 느꼈다." 
                FEED=$((FEED - 5)) HAPPY=$((HAPPY + 10)) SOCIAL=$((SOCIAL+5)) VISUAL=$((VISUAL+5));;
                2) EVENT_SCRIPT="체력이 조금은 늘어난 것 같은 자신감이 생겼다." 
                FEED=$((FEED - 5)) HAPPY=$((HAPPY + 10)) SOCIAL=$((SOCIAL+5)) VISUAL=$((VISUAL+5));;
            esac
            ;;
        6)  # 대성공
            local r=$(( RANDOM % 3 ))
            case "$r" in
                0) EVENT_SCRIPT="완벽한 운동 루틴을 소화하고 뿌듯해한다." 
                FEED=$((FEED - 10)) HAPPY=$((HAPPY + 15)) SOCIAL=$((SOCIAL+10)) VISUAL=$((VISUAL+10));;
                1) EVENT_SCRIPT="$DAMAGOCHI_NAME의 몸이 한층 건강해진 느낌이다." 
                FEED=$((FEED - 10)) HAPPY=$((HAPPY + 15)) SOCIAL=$((SOCIAL+10)) VISUAL=$((VISUAL+10));;
                2) EVENT_SCRIPT="운동 후 상쾌함과 함께 기분도 최고가 되었다." 
                FEED=$((FEED - 10)) HAPPY=$((HAPPY + 15)) SOCIAL=$((SOCIAL+10)) VISUAL=$((VISUAL+10));;
            esac
            ;;
    esac
}

EVENT_SCRIPT2=""
Random_Event2_Script(){
    local r=$(( RANDOM % 10 ))
    case $r in
        # 0~4 : 나쁜 이벤트
        0)
            EVENT_SCRIPT2="갑자기 의욕이 바닥을 쳤다... 오늘은 아무것도 하기 싫다."
            ;;
        1)
            EVENT_SCRIPT2="밤새 잠을 설쳐서 피곤이 몰려온다. 집중이 잘 되지 않는다."
            ;;
        2)
            EVENT_SCRIPT2="교통사고를 당했다... 몸이 너무 아프다."
            ;;
        3)
            EVENT_SCRIPT2="밖에서 시끄러운 소리가 계속 들려서 마음이 불편해졌다."
            ;;
        4)
            EVENT_SCRIPT2="$DAMAGOCHI_NAME가 멍하니 창밖만 바라본다. 공허한 하루가 될지도 모른다."
            ;;

        # 5~9 : 좋은 이벤트
        5)
            EVENT_SCRIPT2="갑자기 공부 욕구가 불타올랐다! 오늘은 뭔가 해낼 수 있을 것 같다."
            ;;
        6)
            EVENT_SCRIPT2="오늘 컨디션이 너무 좋다! 운동을 해볼까?"
            ;;
        7)
            EVENT_SCRIPT2="우연히 들은 노래가 너무 좋아서 하루 종일 기분이 상쾌해졌다."
            ;;
        8)
            EVENT_SCRIPT2="작은 성취를 떠올리며 미소를 지었다. 오늘은 더 잘해보고 싶은 마음이 든다."
            ;;
        9)
            EVENT_SCRIPT2="$DAMAGOCHI_NAME가 스스로 다짐한다. '오늘은 어제보다 조금 더 나아지자.'"
            ;;
    esac
}



Random_Event(){
    echo "🎲 주사위를 굴리는 중..."
    Dice_Roll
    echo "..."
    sleep 0.9
    echo "..."
    sleep 0.9
    echo "..."
    sleep 0.9
    
    case "$DICE_RES" in
        1)
            EVENT_RES="--- 대실패!! ---"
            ;;
        2|3)
            EVENT_RES="--- 실 패! ---"
            ;;
        4)
            EVENT_RES="--- 아무일도 일어나지 않았습니다... ---"
            ;;
        5)
            EVENT_RES="--- 성 공! ---"
            ;;
        6)
            EVENT_RES="--- 대성공!! ---"
            ;;
        *)
            echo "주사위 결과 오류"
            ;;
    esac
    echo "────────────────────────────────────────────"
}

feed(){
    echo "밥 먹자~"
    Random_Event
    Random_Event_Script_Feed
}
book(){
    echo "독서하자~"
    Random_Event
    Random_Event_Script_Read
}
play(){
    echo "놀자~"
    Random_Event
    Random_Event_Script_Play
}
exercise(){
    echo "운동하자~"
    Random_Event
    Random_Event_Script_Exercise
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
                echo "초기 메뉴로 돌아갑니다."
                GAME_STATE="INIT" 
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
    Load_UserData

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
}

main
