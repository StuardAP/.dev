# FUNCTIONS
autoload -Uz reload_zshrc

function reload_zshrc() {
    source $HOME/.zshrc
}

function preview() {
  if [ -n "$1" ]; then
    bat --style="numbers,grid" --color=always --theme="ansi" --decorations=always "$1"
  fi
}

function cheat() {
    local language=$(echo "$1" | cut -d '+' -f1)
    local topic=$(echo "$1" | cut -d '+' -f2-)
    curl -s -L -H "Accept: text/plain" "cheat.sh/$language+$topic?style=bw" | sed 's/\x1B\[[0-9;]\+[A-Za-z]//g' | bat --pager=never --style="numbers,grid" --decorations=always --color=always --theme="ansi" --language="$language"
}



function connect_db() {
    local MariaDB_service="MariaDB"
    local password="alice"
    local action="$1"
    local script_file="$2"

    if [[ "$action" == "start" ]]; then
        if ! sc query "$MariaDB_service" | grep "STATE.*RUNNING" >/dev/null; then
            echo "Iniciando el servicio $MariaDB_service..."
            net start "$MariaDB_service"
        else
            echo "El servicio $MariaDB_service ya está en ejecución."
        fi
    elif [[ "$action" == "stop" ]]; then
        if sc query "$MariaDB_service" | grep "STATE.*RUNNING" >/dev/null; then
            echo "Deteniendo el servicio $MariaDB_service..."
            net stop "$MariaDB_service"
        else
            echo "El servicio $MariaDB_service ya está detenido."
        fi
        return 0
    else
        echo "Acción no válida. Debes especificar 'start' o 'stop' como parámetro."
        return 1
    fi

    if [[ "$action" == "start" ]]; then
      if [[ -n "$script_file" ]]; then

          sleep 0.5
          clear
          mariadb -u root -p"$password" < "$script_file"
      else
          echo "Conectándose a la Base de Datos ..."
          sleep 0.5
          clear
          mariadb -u root -p"$password"
      fi
    fi
}
