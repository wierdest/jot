#!/bin/bash

# jot is a minimal command-line logging tool.
# jot was made by wierdest - Andre Luiz Pinheiro Torres dos Santos 
# andrlzpt@protonmail.com
# as a way of learning the basics of bash
# it was made in oct 12 2024
# code provided as-is with no warranty whatsoever - comments in Portuguese, 'tis a learning project afterall


# Arquivo do log
# centralização em um arquivo na pasta pessoal do usuário
LOG_FILE="$HOME/jot.txt"

# verde para o timestamp
BLACK="\e[30m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m" 
CYAN="\e[36m"
WHITE="\e[37m"

# cor padrão para o
RESET="\e[0m"
# formato do nosso timestamp
TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"

# Adiciona um log
add_log() {
    echo "${TIMESTAMP} | ${CURRENT_TOPIC} | $1" >> "$LOG_FILE"
    echo -e "${CYAN}Log added:${RESET} ${GREEN}$1${RESET}"
}

# Extrai o tópico do último log
extract_topic() {
    if [[ -s $LOG_FILE ]]; then
        last_log=$(tail -n 1 "$LOG_FILE")
        # usa o pipe para jogar a ultima linha para o awk, que joga para xargs fazer trim
        last_topic=$(echo "$last_log" | awk -F'|' '{print $2}' | xargs)
        echo "$last_topic"
    else
        echo ""
    fi
}

# Imprime o log de acordo com o esquema de cor geral: MAGENTA para velhas, BLUE para hj e YELLOW para a ultima hora
print_general_log_line() {
    # pega a data de hoje para imprimir as jots de hj em amarelo
    today=$(date '+%Y-%m-%d')
    # até uma hora atrás imprime em amarelo
    current_hour=$(date '+%H')
    # extrai o time stamp e a mensagem da linha
    # awk é usado para extrair os dois primeiros itens (a data e a hora)
    # poderia ser cut -d ' ' -f1-2
    log_date=$(echo "$1" | awk '{print $1}')
    log_time=$(echo "$1" | awk '{print $2}')
    # extrai a hora do time
    log_hour=$(echo "$log_time" | cut -d':' -f1)
    # cut, com o -delimitador ' ' e com o range -f3-, cortando tudo do terceiro campo em diante
    # a gente precisa do -d do cut para marcar que o delimitador será o espaco, 
    # que delimita a data, a hora e o - separador.
    message=$(echo "$1" | cut -d' ' -f3-)
    topic=$(echo "$message" | awk -F'|' '{print $2}' | xargs)
    content=$(echo "$message" | awk -F'|' '{print $3}' | xargs)
    if [[ "$log_date" == "$today" ]]; then
        # se for hoje faz o print em BLUE
        # a não ser que seja na última hora, ocasião que faz o print em YELLOW
        if [[ "$log_hour" == "$current_hour" ]]; then
            echo -e "${YELLOW}${log_date} ${log_time}"
            echo -e "${WHITE}| ${topic} |${RESET}"
            echo -e "${content}"
        else
            echo -e "${BLUE}${log_date} ${log_time}${RESET}"
            echo -e "${WHITE}| ${topic} |${RESET}"
            echo -e "${content}"
        fi
    else
        # se for ontem ou anterior
        echo -e "${MAGENTA}${log_date} ${log_time}${RESET}"
        echo -e "${WHITE}| ${topic} |${RESET}"
        echo -e "${content}"
    fi
}

# Imprime o log de acordo com o esquema de cor para intervalo recente: MAGENTA para velhas BLUE para as de até 3 horas e YELLOW para a ultima hora
print_recent_log_line() {
    # Pega a hora atual
    current_hour=$(date '+%H')
    # Define o limite de 3 horas atrás
    three_hours_ago=$(date --date='-3 hour' '+%H')

    # extrai o time stamp e a mensagem da linha
    log_date=$(echo "$1" | awk '{print $1}')
    log_time=$(echo "$1" | awk '{print $2}')
    log_hour=$(echo "$log_time" | cut -d':' -f1)
    message=$(echo "$1" | cut -d' ' -f3-)
    topic=$(echo "$message" | awk -F'|' '{print $2}' | xargs)
    content=$(echo "$message" | awk -F'|' '{print $3}' | xargs)

    # Verifica se a hora do log é da última hora
    if [[ "$log_hour" == "$current_hour" ]]; then
        echo -e "${YELLOW}${log_date} ${log_time}"
        echo -e "${WHITE}| ${topic} |${RESET}"
        echo -e "${content}"
    # Verifica se é dentro das últimas 3 horas
    elif [[ "$log_hour" -ge "$three_hours_ago" && "$log_hour" -lt "$current_hour" ]]; then
        echo -e "${BLUE}${log_date} ${log_time}${RESET}"
        echo -e "${WHITE}| ${topic} |${RESET}"
        echo -e "${content}"
    # Logs mais antigos que 3 horas
    else
        echo -e "${MAGENTA}${log_date} ${log_time}${RESET}"
        echo -e "${WHITE}| ${topic} |${RESET}"
        echo -e "${content}"
    fi
}

# Imprime uma mensagem que diz Log file is empty
print_empty() {
    # -e permite a leitura de newline \n, tab \t ou codigos de cor
    echo -e "${RED}Log file is empty.${RESET}"
}

# Imprime uma mensagem que dis jot log message (Press Enter twice to finish):
print_header() {
    echo -e "${CYAN}jot log message (Press Enter twice to finish):${RESET}"
}

# Lê todos os logs
view_all() {
    if [[ -s $LOG_FILE ]]; then
        while IFS= read -r line; do
            print_general_log_line "$line"
        done < "$LOG_FILE"
    else
        print_empty
    fi
}

# Lê a última entrada
view_last() {
   if [[ -s $LOG_FILE ]]; then 
	last_log=$(tail -n 1 "$LOG_FILE")
    print_general_log_line "$last_log"
   else
	print_empty
   fi
}

# Lê os logs escritos hoje
view_today() {
   if [[ -s $LOG_FILE ]]; then
        today=$(date '+%Y-%m-%d')
        today_logs=$(grep "^$today" "$LOG_FILE")

        if [[ -n $today_logs ]]; then
            while IFS= read -r line; do
                print_recent_log_line "$line"
            done <<< "$today_logs"
        else
            echo -e "${RED}No log entries for today.${RESET}"
        fi
   else
	print_empty
   fi
}

# Lê os logs escritos ontem
view_yesterday() {
   if [[ -s $LOG_FILE ]]; then
	yesterday=$(date -d "yesterday" '+%Y-%m-%d')
	grep "^$yesterday" "$LOG_FILE" || echo -e "${RED}No log entries for yesterday.${RESET}"
   else
	print_empty
   fi 

}

# Lê os logs escritos recentemente
view_recent() {
    if [[ -s $LOG_FILE ]]; then
        if [[ $1 =~ ^[0-9]+$ && $1 -gt 0 ]]; then
	        recent_logs=$(tail -n "$1" "$LOG_FILE")
            # Lê a linha a linha do texto guardado na variável!
            while IFS= read -r line; do
                print_recent_log_line "$line"
            # O operador <<< "here string" redireciona uma string diretamente no standard input, 
            # enquanto que o < redireciona um arquivo
            done <<< "$recent_logs" 
        else
            echo "Please provide a valid positive number corresponding to the number of entries you would like to view."
        fi
    else
	echo "Log file is empty."
    fi
}

# Pesquisa os logs
search_logs() {
    grep -i "$1" "$LOG_FILE"
    # testa se o resultado do grep não retornou 0 (0 == sucesso)
    # note o uso de single brackets 
    if [ $? -ne 0 ]; then 
        echo "No matching log entries found for '$1'."
    fi
}

# Limpa o último log
clear_last() {
   if [[ -s $LOG_FILE ]]; then
	# Remove a ultima linha do arquivo de log
	sed -i '$d' "$LOG_FILE"
	echo -e "${GREEN}Last log entry deleted!${RESET}"
   else
	echo -e "${RED}Log file is empty! Nothing to delete!${RESET}"
   fi
}

# Limpa todos os logs
clear_logs() {
    # usa noop operator como o linter sugeriu
    : > "$LOG_FILE"
    echo -e -e "${GREEN}Log entries cleared!${RESET}" 
}

# Mostra ajuda de utilização
show_help() {
    echo -e "${CYAN}Usage: jot [options]"
    echo -e "Options:"
    echo -e "${YELLOW} -a-'press enter'-${BLUE} Jot log message prompt"
    echo -e "${YELLOW} -s-'keyword'-----${BLUE} Search log entries for keyword"
    echo -e "${YELLOW} -r-'n'-----------${BLUE} View a number n of recent entries" 
    echo -e "${YELLOW} -l---------------${BLUE} View last entry"
    echo -e "${YELLOW} -h---------------${BLUE} View today's entries"
    echo -e "${YELLOW} -y---------------${BLUE} View yesterday's entries"
    echo -e "${YELLOW} -v---------------${BLUE} View all log entries"
    echo -e "${YELLOW} -d---------------${BLUE} Clear last log entry" 
    echo -e "${YELLOW} -c---------------${BLUE} Clear all log entries with no warning ${RED}BEWARE!${RESET}"
}


# Usa getopts para parse das opções
while getopts "altyvr:s:dch" option; do
    case $option in
        a)
            # confere se há um tópico e oferece para mudar ou não
            CURRENT_TOPIC=$(extract_topic)
            if [[ -n $CURRENT_TOPIC ]]; then
                echo -e "${CYAN}Topic: '${GREEN}${CURRENT_TOPIC}${CYAN}'. Add new?${BLACK} Leave it blank to use current...${RESET}"
                read -r new_topic
                if [[ -n "$new_topic" ]]; then
                    echo -e "${CYAN}Topic set to: '${GREEN}${new_topic}${CYAN}'."
                    CURRENT_TOPIC="$new_topic"
                fi
            else
                while [[ -z "$CURRENT_TOPIC" ]]; do
                    echo -e "${RED}No topic found. Please enter a new topic:${RESET}"
                    read -r CURRENT_TOPIC
                    if [[ -z "$CURRENT_TOPIC" ]]; then
                        echo -e "${RED}Topic cannot be empty. Please provide a valid topic.${RESET}"
                    fi
                done
            fi
            print_header
            log_message=""
            while IFS= read -r line; do
                # se a linha é vazia, sai do loop
                [[ -z "$line" ]] && break
                log_message+="$line "
            done
            # limpa espaços vazios, usando o que o linter sugeriu
            log_message=${log_message%"${log_message##*[![:space:]]}"}
            if [[ -n "$log_message" ]]; then
                add_log "$log_message"
            else
                echo -e "${RED}No log message entered. Please provide a message.${RESET}"
            fi
            ;;
        l)
	        view_last
	        ;;
	    t)
	        view_today
	        ;;
	    y)
	        view_yesterday
	        ;;
        v)
            view_all
            ;;
        r)
            view_recent "$OPTARG"
            ;;
        s)
            search_logs "$OPTARG"
            ;;
	    d)
	        clear_last
	        ;;
        c)
            clear_logs
            ;;
        h)
            show_help
            ;;
        *)
            show_help
            ;;
    esac
done

# Se nenhuma opção for inserida
if [ $OPTIND -eq 1 ]; then
    show_help
fi
