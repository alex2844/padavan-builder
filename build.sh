#!/usr/bin/env bash
set -euo pipefail

: "${PADAVAN_REPO:=https://gitlab.com/hadzhioglu/padavan-ng.git}"
: "${PADAVAN_BRANCH:=master}"
: "${PADAVAN_COMMIT:=HEAD}"
: "${PADAVAN_TOOLCHAIN_URL:=https://gitlab.com/api/v4/projects/hadzhioglu%2Fpadavan-ng/packages/generic/toolchain/latest/toolchain.tzst}"
: "${PADAVAN_CONFIG:=build.config}"
: "${PADAVAN_THEMES_REPO:=https://gitlab.com/hadzhioglu/padavan-themes.git}"
: "${PADAVAN_THEMES_BRANCH:=main}"
: "${PADAVAN_THEMES:=()}"
: "${CONTAINER_IMAGE:=registry.gitlab.com/hadzhioglu/padavan-ng}"
: "${CONTAINER_APPIMAGE_URL:=https://github.com/popsUlfr/podman-appimage/releases/download/v4.2.1-r1/podman-4.2.1-r1-x86_64.AppImage}"
: "${CLEANUP:=true}"
: "${EDITOR:=}"

select_input=''
select_list=()
select_index=0
container=''

handle_exit() {
	set +euo pipefail
	$container container exists "padavan-ng" && $container rm -f "padavan-ng" &>> /dev/null
	if [[ "$CLEANUP" == true ]]; then
		rm -rf "padavan-ng" "$PWD/podman.AppImage" "$PWD/podman"
	fi
}
handle_interrupt() {
	local req;
	stty echo
	read -p "Do you want to quit? [Y/n] " req
	stty -echo
	if [ -z "$req" ] || [ "$req" == "y" ] || [ "$req" == "Y" ]; then
		exit 1
	elif [[ ${#select_list[@]} -ne 0 ]]; then
		list
	fi
}
trap handle_interrupt SIGINT SIGTERM
trap handle_exit EXIT

cexec() {
	local work_dir=
	local args=()
	while [ "$#" -gt 0 ]; do
		if [ "$1" == "-w" ]; then
			shift
			work_dir=$1
			shift
		elif [ "$1" == "-c" ]; then
			args+=("/bin/bash")
		fi
		args+=("$1")
		shift
	done
	$container exec -w "$work_dir" "padavan-ng" "${args[@]}"
}

list() {
	clear
	i=0
	if [[ "$select_input" == *"/"* ]]; then
		templates="padavan-ng/trunk/configs/templates/*/*config"
	else
		templates="padavan-ng/trunk/configs/templates/*/"
	fi
	# shopt -s nocasematch
	for config in ${templates[@]}; do
		if [ -r "$config" ]; then
			model="${config#*templates/}"
			model=${model%.*}
			if [[ $model == *"$select_input"* ]]; then
				select_list+=("$model")
				if [ $i == $select_index ]; then
					echo "> $model"
				else
					echo "  $model"
				fi
				i=$((i+1))
			fi
		fi
	done
	# shopt -u nocasematch
	# echo -n "Введите модель роутера: $select_input"
}

prompt() {
	list
	while IFS= read -r -s -n 1 char; do
		if [[ "$char" == "$(printf '\033')" ]]; then
            read -r -s -t 0.1 -n 1 next_char
            if [[ -z $next_char ]]; then
                continue
			else
				read -r -s -n 1 arrow_char
				if [[ "$arrow_char" == "$(printf 'A')" ]]; then
					if [ "$select_index" != 0 ]; then
						select_index=$((select_index-1))
					fi
				elif [[ "$arrow_char" == "$(printf 'B')" ]]; then
					if [[ ${#select_list[@]} -ne $((select_index+1)) ]]; then
						select_index=$((select_index+1))
					fi
				fi
            fi
		else
			if [[ "$char" == "$(printf '\n')" ]]; then
				if [[ ${#select_list[@]} -ne 0 ]]; then
					select_input="${select_list[$select_index]}"
					select_list=()
					if [[ "$select_input" != *"/" ]]; then
						break
					fi
				fi
			elif [[ "$char" == "$(printf '\t')" ]]; then
				if [[ ${#select_list[@]} -ne 0 ]]; then
					select_input="${select_list[$select_index]}"
					select_list=()
				fi
			elif [[ "$char" == "$(printf '\177')" ]]; then
				select_input="${select_input%?}"
			#else
				#select_input+="$char"
			fi
			select_index=0
		fi
		list
	done
	clear
}

edit() {
	local editors=('vim' 'vi' 'nano' 'open')
	if [ -z "$EDITOR" ]; then
		for editor in "${editors[@]}"; do
			if command -v "$editor" > /dev/null; then
				EDITOR=$editor
				break
			fi
		done
		if [ -z "$EDITOR" ]; then
			desktop_file=$(xdg-mime query default text/plain || echo '')
			if [ -n "$desktop_file" ]; then
				EDITOR="gtk-launch $desktop_file"
			else
				read -p 'Enter the command to launch the editor: ' EDITOR
			fi
		fi
	fi
	if [ -n "$EDITOR" ]; then
		timestamp=$(date +%s)
		$EDITOR "$1"
		if [[ $(($(date +%s) - timestamp)) -lt 1 ]]; then
			sleep 1
			read -p "Press Enter to continue..." next
		fi
	fi
}

if command -v "podman" 1>/dev/null; then
	container="podman"
else
	if [ ! -f "$PWD/podman.AppImage" ]; then
		wget "$CONTAINER_APPIMAGE_URL" -O "$PWD/podman.AppImage"
		chmod +x "$PWD/podman.AppImage"
	fi
	if [ ! -f "$PWD/podman" ]; then
		ln -s "$PWD/podman.AppImage" "$PWD/podman"
	fi
	container="$PWD/podman"
fi

$container run --rm -dt -v "$PWD":/opt --name "padavan-ng" "$CONTAINER_IMAGE"

if [ ! -d "padavan-ng" ]; then
	cexec git config --global --add safe.directory '*'
	if [[ -n "$PADAVAN_COMMIT" ]] && [ "$PADAVAN_COMMIT" != "HEAD" ]; then
		cexec git clone -b "$PADAVAN_BRANCH" "$PADAVAN_REPO"
		cexec git -C padavan-ng checkout "$PADAVAN_COMMIT"
	else
		cexec git clone --depth 1 -b "$PADAVAN_BRANCH" "$PADAVAN_REPO"
	fi
else
	cexec git -C padavan-ng reset --hard
	cexec git -C padavan-ng clean -dfx
	cexec git -C padavan-ng pull
fi

if [[ -n $PADAVAN_THEMES ]]; then
	IFS=' ' read -r -a PADAVAN_THEMES <<< "${PADAVAN_THEMES:1:-1}"
	if [[ ${#PADAVAN_THEMES[@]} -ne 0 ]]; then
		cexec git clone --depth 1 -b "$PADAVAN_THEMES_BRANCH" "$PADAVAN_THEMES_REPO" themes
		cexec cp -r themes/common-theme themes/jquery.js padavan-ng/trunk/user/www/n56u_ribbon_fixed
		for theme in ${PADAVAN_THEMES[@]}; do
			echo "Installing $theme theme"
			cexec cp -r "themes/$theme-theme" padavan-ng/trunk/user/www/n56u_ribbon_fixed
		done
	fi
fi
cexec -c "wget -qO- '$PADAVAN_TOOLCHAIN_URL' | tar -C padavan-ng --zstd -xf -"

if [[ -n "$PADAVAN_CONFIG" ]] && [ "$PADAVAN_CONFIG" != "build.config" ]; then
	regex="^(https?|ftp|file)://"
	if [[ "$PADAVAN_CONFIG" =~ $regex ]]; then
		wget "$PADAVAN_CONFIG" -qO build.config
	else
		cp "$PADAVAN_CONFIG" build.config
	fi
elif [ ! -s "build.config" ]; then
	prompt
	cp "padavan-ng/trunk/configs/templates/$select_input.config" build.config
	read -p "Do you want to edit the configuration file? [y/N] " edit
	if [ "$edit" == "y" ] || [ "$edit" == "Y" ]; then
		edit build.config
	fi
fi
source build.config

cexec cp build.config padavan-ng/trunk/.config
cexec -w /opt/padavan-ng/trunk ./build_firmware.sh

FW_FILE_NAME="$(find padavan-ng/trunk/images -type f -regextype posix-extended -iregex ".*\.(trx|bin)$" -printf "%T@\t%f\n" | sort -V | tail -1 | cut -f2)"
FW_NAME=${FW_FILE_NAME%.*}
mv "padavan-ng/trunk/images/$FW_FILE_NAME" .

partitions=padavan-ng/trunk/configs/boards/$CONFIG_VENDOR/$CONFIG_FIRMWARE_PRODUCT_ID/partitions.config
max_fw_size="$(cexec awk '/Firmware/ { getline; getline; sub(",", ""); print strtonum($2); }' "$partitions")"
fw_size="$(stat -c %s "$FW_FILE_NAME")"
if ((fw_size > max_fw_size)); then
	fw_size_fmtd="$(numfmt --grouping "$fw_size") bytes"
	max_fw_size_fmtd="$(numfmt --grouping "$max_fw_size") bytes"
	echo "Firmware size ($fw_size_fmtd) exceeds max size ($max_fw_size_fmtd) for your target device"
	exit 1
fi
