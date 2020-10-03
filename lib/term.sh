
# Available styles/colors
T_BOLD=""
T_UNDERLINE=""
T_STANDOUT=""
T_NORMAL=""
T_BLACK=""
T_RED=""
T_GREEN=""
T_YELLOW=""
T_BLUE=""
T_MAGENTA=""
T_CYAN=""
T_WHITE=""

# Only define values if colors are supported
if test -t 1; then

    # see if it supports colors...
    ncolors=$(tput colors)

    if test -n "$ncolors" && test $ncolors -ge 8; then
        T_BOLD="$(tput bold)"
        T_UNDERLINE="$(tput smul)"
        T_STANDOUT="$(tput smso)"
        T_NORMAL="$(tput sgr0)"
        T_BLACK="$(tput setaf 0)"
        T_RED="$(tput setaf 1)"
        T_GREEN="$(tput setaf 2)"
        T_YELLOW="$(tput setaf 3)"
        T_BLUE="$(tput setaf 4)"
        T_MAGENTA="$(tput setaf 5)"
        T_CYAN="$(tput setaf 6)"
        T_WHITE="$(tput setaf 7)"
    fi
fi

print_info() {
  echo -e "${T_BOLD}${T_BLUE} INFO » ${T_NORMAL} $@" 1>&2
}
print_warning() {
  echo -e "${T_BOLD}${T_YELLOW}[WARNING]${T_NORMAL}${T_BOLD} $@" 1>&2
}
print_error() {
  echo -e "${T_BOLD}${T_RED}[ERROR]${T_NORMAL}${T_BOLD} $@" 1>&2
}
