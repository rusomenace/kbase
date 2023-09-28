#!/bin/bash

function get_project_type {
    echo -e "
    Comment

    1 - Build: Cambios que afectan el sistema de compilacion o las dependencias externas
    2 - CI: Cambios en nuestros archivos y scripts de configuracion de CI
    3 - Docs: Solo cambios en la documentacion
    4 - Feat: Una nueva caracteristica
    5 - Fix: Una correccion de errores
    6 - Perf: Un cambio de codigo que mejora el rendimiento
    7 - Refactor: Un cambio de codigo que no corrige un error ni agrega una caracteristica
    8 - Style: Cambios que no afectan el significado del codigo
    9 - Test: Adicion de pruebas faltantes o correccion de pruebas existentes

    Choose option"
    
    read -r type
    case $type in
        1) choice="Build:" ;;
        2) choice="CI:" ;;
        3) choice="Docs:" ;;
        4) choice="Feat:" ;;
        5) choice="Fix:" ;;
        6) choice="Perf:" ;;
        7) choice="Refactor:" ;;
        8) choice="Style:" ;;
        9) choice="Test:" ;;
        *) echo "Invalid option. Exiting." && exit 1 ;;
    esac
    echo "$choice"
}

comment_type=$(get_project_type)
git pull
default_message="Just another commit"
echo -e "\e[36mInput Message or leave default\e[0m"
read -r commit_message
commit_message=${commit_message:-$default_message}
push_message="$comment_type $commit_message"
git add .
git commit -m "$push_message"
git push
