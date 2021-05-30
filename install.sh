#!/bin/sh
# By Rafael Madriz

# colors
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

# Messages
error() {
    printf "${BOLD}${RED}[✘] %s${NORMAL}\n" "$@" >&2
}

info() {
    printf "${BOLD}${BLUE}[➭] %s${NORMAL}\n" "$@" >&2
}

warn() {
    printf "${BOLD}${YELLOW}[⚠] %s${NORMAL}\n" "$@" >&2
}

success() {
    printf "${BOLD}${GREEN}[✔] %s${NORMAL}\n" "$@" >&2
}

print_with_color() {
    printf '%b\n' "$1$2$NORMAL"
}

need_cmd() {
    if ! hash "$1" >/dev/null; then
        error "Need '$1' (command not found)"
        exit 1
    fi
}

install_packer() {
    info "Install packer.nvim"
    git clone https://github.com/wbthomason/packer.nvim \
        ~/.local/share/nvim/site/pack/packer/start/packer.nvim >/dev/null 2>&1
    success "packer.nvim installation done"
}

backup_nvim() {
    if [ -d "$HOME/.config/nvim" ]; then
        info "Backing up nvim config"
        mv "$HOME/.config/nvim" "$HOME/.config/nvim_bak"
    fi
}

fetch_repo() {
    backup_nvim
    info "Cloning NeonVim configuration"
    if git clone https://github.com/rafamadriz/NeonVim.git "$HOME/.config/nvim" >/dev/null 2>&1; then
        success "Successfully clone"
        info "Installing plugins"
        nvim --headless +PackerSyncc +qall
        success "Plugins installed"
    else
        error "Failed to clone"
        exit 0
    fi
}

uninstall() {
    if [ -d "$HOME/.config/nvim_back" ]; then
        rm -rf "$HOME/.config/nvim" >/dev/null
        mv "$HOME/.config/nvim_back" "$HOME/.config/nvim"
        success "Uninstall NeonVim"
    else
        warn "Backup directory for old nvim configuration doesn't exist"
        while true; do
            # (1) prompt user, and read command line argument
            print_with_color "Do you want to remove NeonVim configuration ?[y/n] ${NORMAL}" "${YELLOW}"
            read -r answer

            # (2) handle the input we were given
            case $answer in
            [yY]*)
                rm -rf "$HOME/.config/nvim" >/dev/null
                success "Uninstall NeonVim"
                break
                ;;
            [nN]*) exit 0 ;;
            *) error "Dude, just enter Y or N, please." ;;
            esac
        done
    fi
}

check_requirements() {
    info "Checking requirements"
    if hash "nvim" >/dev/null; then
        info "Neovim version needs to be v0.5.0 or above"
        print_with_color "$YELLOW" "Your Neovim version is: $(nvim --version | sed '1q' | awk '{print $2}')\n"
    else
        error "Check requirements: nvim"
        exit 0
    fi
    if hash "node" >/dev/null; then
        success "Check requirements : node"
    else
        warn "Check requirements : node (optional, required to use LSP)"
    fi
    if hash "npm" >/dev/null; then
        success "Check requirements : npm"
    else
        warn "Check requirements : npm (optional, required to use LSP)"
    fi
    if hash "pip3" >/dev/null; then
        success "Check requirements : pip3"
    else
        warn "Check requirements : pip3 (optional)"
    fi
}

main() {
    if [ $# -gt 0 ]; then
        case $1 in
        --uninstall | -u)
            uninstall
            exit 0
            ;;
        --checkRequirements | -c)
            check_requirements
            exit 0
            ;;
        --install | -i)
            need_cmd 'git'
            install_packer
            fetch_repo
            exit 0
            ;;
        esac
    else
        need_cmd 'git'
        install_packer
        fetch_repo
    fi
}

main "$@"
