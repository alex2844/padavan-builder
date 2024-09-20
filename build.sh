#!/usr/bin/env bash
set -euo pipefail;
trap handle_exit EXIT;
if [[ -z "${COLAB_RELEASE_TAG:-}" ]]; then
	trap handle_interrupt SIGINT SIGTERM;
fi

container='';
select_input='';
select_list=();
select_index=0;

handle_exit() {
	if [[ -n "${container}" ]]; then
		"${container}" container exists "padavan-ng" && "${container}" rm -f "padavan-ng" &>> /dev/null;
	fi
	if [[ "${BUILDER_CLEANUP:-true}" == true ]]; then
		rm -rf "padavan-ng" "podman.AppImage" "podman" "Dockerfile.sh" "toolchain.tzst";
	fi
	set +euo pipefail;
}
handle_interrupt() {
	local req;
	if [[ ${#select_list[@]} -ne 0 ]]; then
		stty echo;
	fi
	read -p "Do you want to quit? [Y/n] " req;
	if [[ ${#select_list[@]} -ne 0 ]]; then
		stty -echo;
	fi
	if ! [[ "${req,,}" =~ ^n(o)?$ ]]; then
		exit 1;
	elif [[ ${#select_list[@]} -ne 0 ]]; then
		list;
	fi
}
config() {
	local file="$1";
	shift;
	local keys=("$@");
	if [[ -f "${file}" ]]; then
		while IFS== read -r line; do
			if [[ "${line}" =~ ^#.* ]] || [[ -z "${line}" ]]; then
				continue;
			fi
			key="${line%%=*}";
			value="";
			if [[ "${line}" != "${key}" ]]; then
				value=$(echo "${line#*=}" | sed "s/^['\"]\(.*\)['\"]$/\1/");
			fi
			if ! [[ -v "${key}" ]]; then
				export "${key}=${value}";
			fi
		done < "${file}";
	fi
	if [[ -n "${keys:-}" ]]; then
		for key in ${keys[@]}; do
			if ! [[ -v "${key}" ]]; then
				while :; do
					read -p "Please enter a value for the required parameter ${key}: " value;
					if [[ -n "${value}" ]]; then
						break;
					else
						echo "Error: ${key} cannot be empty. Please provide a value.";
					fi
				done
				if [[ ! -f "${file}" ]]; then
					touch "${file}";
				fi
				export "${key}=${value}";
				echo "${key}=${value}" >> "${file}";
			fi
		done
	fi
}
edit() {
	local editors=('vim' 'vi' 'nano' 'open');
	local editor="${BUILDER_EDITOR:-${EDITOR:-}}";
	if [[ -z "$editor" ]]; then
		for bin in "${editors[@]}"; do
			if command -v "$bin" > /dev/null; then
				editor=$bin;
				break;
			fi
		done
		if [[ -z "$editor" ]]; then
			desktop_file=$(xdg-mime query default text/plain || echo '');
			if [[ -n "$desktop_file" ]]; then
				editor="gtk-launch $desktop_file";
			else
				read -p 'Enter the command to launch the editor: ' editor;
			fi
		fi
	fi
	if [[ -n "$editor" ]]; then
		timestamp=$(date +%s);
		"$editor" "$1";
		if [[ $(($(date +%s) - timestamp)) -lt 1 ]]; then
			sleep 1;
			read -p "Press Enter to continue..." next;
		fi
	fi
}
list() {
	clear;
	local i=0;
	select_list=();
	if [[ "${select_input}" == *"/"* ]]; then
		templates="padavan-ng/trunk/configs/templates/*/*config";
	else
		templates="padavan-ng/trunk/configs/templates/*/";
	fi
	for config in ${templates[@]}; do
		if [[ -r "${config}" ]]; then
			model="${config#*templates/}";
			model="${model%.*}";
			if [[ ${model} == *"${select_input}"* ]]; then
				select_list+=("${model}");
				if [ ${i} == ${select_index} ]; then
					echo "> ${model}";
				else
					echo "  ${model}";
				fi
				i=$((i+1));
			fi
		fi
	done
}
prompt() {
	list;
	while IFS= read -r -s -n 1 char; do
		if [[ "${char}" == "$(printf '\033')" ]]; then
			read -r -s -t 0.1 -n 1 next_char;
			if [[ -z ${next_char} ]]; then
				continue;
			else
				read -r -s -n 1 arrow_char;
				case "${arrow_char}" in
					'A') # Up
						if [[ "${select_index}" != 0 ]]; then
							select_index=$((select_index-1));
						fi
						;;
					'B') # Down
						if [[ ${#select_list[@]} -ne $((select_index+1)) ]]; then
							select_index=$((select_index+1));
						fi
						;;
					'5') # Page Up
						select_index=0;
						read -r -s -t 0.1 -n 1 next_char;
						;;
					'6') # Page Down
						select_index=$((${#select_list[@]}-1));
						read -r -s -t 0.1 -n 1 next_char;
						;;
				esac
			fi
		else
			case "$char" in
				"$(printf '\n')") # Enter
					if [[ ${#select_list[@]} -ne 0 ]]; then
						select_input="${select_list[${select_index}]}";
						select_list=();
						if [[ "${select_input}" != *"/" ]]; then
							break;
						fi
					fi
					;;
				"$(printf '\t')") # Tab
					if [[ ${#select_list[@]} -ne 0 ]]; then
						select_input="${select_list[${select_index}]}";
						select_list=();
					fi
					;;
				"$(printf '\177')") # Backspace
					select_input="${select_input%?}";
					;;
				*)
					for config in ${select_list[@]}; do
						if [[ ${config} == *"${select_input}${char}"* ]]; then
							select_input+="${char}";
							break;
						fi
					done
					;;
			esac
			select_index=0;
		fi
		list;
	done
	clear;
}
dockerfile() {
	local cursor='';
	echo '#!/usr/bin/env bash';
	while IFS= read -r line; do
		line=$(echo "${line}" | sed 's/^[[:space:]]*//');
		if [[ -z "${cursor}" ]]; then
			cursor=$(echo "${line}" | cut -d' ' -f1);
		fi
		case "${cursor}" in
			FROM)
				echo "# ${line/FROM /}";;
			ENV)
				echo "export ${line/ENV /}" | sed 's/\\$//';;
			WORKDIR)
				echo "mkdir -p ${line/WORKDIR /} && cd ${line/WORKDIR /}";;
			RUN)
				echo "${line/RUN /}";;
			*)
				echo "${line}";;
		esac
		if [[ "${line}" != *\\ ]]; then
			cursor='';
		fi
	done
}
cexec() {
	local work_dir='';
	local args=();
	while [ "$#" -gt 0 ]; do
		if [ "$1" == "-w" ]; then
			shift;
			work_dir=$1;
			shift;
		elif [ "$1" == "-c" ]; then
			args+=("/bin/bash");
		fi
		args+=("$1");
		shift;
	done
	if [[ -n "${container}" ]]; then
		if [[ -n "${work_dir}" ]] && ! [[ "${work_dir}" =~ ^/ ]]; then
			work_dir="/opt/${work_dir}";
		fi
		$container exec -w "$work_dir" "padavan-ng" "${args[@]}";
	else
		root="${PWD}";
		if [[ -n "${work_dir}" ]]; then
			cd "${work_dir}";
		fi
		"${args[@]}";
		cd "$root";
	fi
}

echo "Checking required parameters...";
keys=();
if [[ ! -d "padavan-ng" ]]; then
	keys+=("PADAVAN_REPO");
fi
if [[ ! -f "toolchain.tzst" ]]; then
	keys+=("PADAVAN_TOOLCHAIN_URL");
fi
config "build.conf" "${keys[@]}";

if [[ -n "${CONTAINER_IMAGE:-}" ]]; then
	if [[ -z "${COLAB_RELEASE_TAG:-}" ]] && [[ ! -d "/mnt/chromeos" ]] && [[ ! -f /.dockerenv ]] && [[ ! -f /run/.containerenv ]]; then
		echo "Container initialization...";
		if command -v "podman" 1>/dev/null; then
			container="podman";
		else
			if [[ ! -f "${PWD}/podman" ]] && [[ -n "${CONTAINER_APPIMAGE_URL:-}" ]]; then
				if [[ ! -f "${PWD}/podman.AppImage" ]]; then
					wget "${CONTAINER_APPIMAGE_URL}" -O "${PWD}/podman.AppImage";
					chmod +x "${PWD}/podman.AppImage";
				fi
				ln -s "${PWD}/podman.AppImage" "${PWD}/podman";
				container="${PWD}/podman";
			fi
			if [[ -f "${PWD}/podman" ]]; then
				container="${PWD}/podman";
			fi
		fi
		"${container}" run --rm -dt -v "${PWD}":/opt -w /opt --name "padavan-ng" "${CONTAINER_IMAGE}";
	fi
fi

if [[ -z "${container}" ]] && [[ "${PROJECT:-}" != 'padavan-ng' ]] && [[ "${BUILDER_DEPENDENCIES:-true}" == true ]]; then
	echo "Installing dependencies...";
	if command -v "apt" 1>/dev/null; then
		if [[ -f "padavan-ng/Dockerfile" ]]; then
			cat "padavan-ng/Dockerfile" | dockerfile > Dockerfile.sh;
		else
			wget -qO- "${PADAVAN_REPO/.git/}/-/raw/${PADAVAN_BRANCH:-master}/Dockerfile" | dockerfile > Dockerfile.sh;
		fi
		bash Dockerfile.sh;
	fi
fi

echo "Cloning or updating Padavan repository...";
if [[ ! -d "padavan-ng" ]]; then
	if [[ "${PADAVAN_COMMIT:-HEAD}" == "HEAD" ]]; then
		cexec git clone --depth 1 -b "${PADAVAN_BRANCH:-master}" "${PADAVAN_REPO}";
	else
		cexec git config --global --add safe.directory '*'
		cexec git clone -b "${PADAVAN_BRANCH:-master}" "${PADAVAN_REPO}";
		cexec git -C padavan-ng checkout "${PADAVAN_COMMIT}";
	fi
else
	if [[ "${BUILDER_RESET:-true}" == true ]]; then
		cexec git -C padavan-ng reset --hard;
		cexec git -C padavan-ng clean -dfx;
		cexec git -C padavan-ng pull;
	fi
fi

if [[ ! -d "padavan-ng/toolchain/out" ]]; then
	echo "Downloading and extracting toolchain...";
	if [[ ! -f "toolchain.tzst" ]]; then
		wget "${PADAVAN_TOOLCHAIN_URL}" -O "toolchain.tzst";
	fi
	cexec tar -C padavan-ng --zstd -xf "toolchain.tzst";
fi

if [[ -n ${PADAVAN_THEMES:-} ]] && [[ -n ${PADAVAN_THEMES_REPO:-} ]]; then
	echo "Installing themes...";
	cexec git clone --depth 1 -b "${PADAVAN_THEMES_BRANCH:-main}" "${PADAVAN_THEMES_REPO}" themes;
	cexec cp -r themes/common-theme themes/jquery.js padavan-ng/trunk/user/www/n56u_ribbon_fixed;
	for theme in ${PADAVAN_THEMES[@]}; do
		echo "Installing ${theme} theme";
		cexec cp -r "themes/${theme}-theme" padavan-ng/trunk/user/www/n56u_ribbon_fixed;
	done
fi

echo "Configuring build...";
if [[ "${PADAVAN_CONFIG:-build.config}" != "build.config" ]]; then
	regex="^(https?|ftp|file)://";
	if [[ "$PADAVAN_CONFIG" =~ $regex ]]; then
		wget "$PADAVAN_CONFIG" -qO build.config;
	else
		cp "$PADAVAN_CONFIG" build.config;
	fi
elif [[ ! -s "build.config" ]] || [[ -z $(cat "build.config") ]]; then
	if [[ -n "${CONFIG_VENDOR:-}" ]] && [[ -n "${CONFIG_FIRMWARE_PRODUCT_ID:-}" ]]; then
		cp "padavan-ng/trunk/configs/templates/${CONFIG_VENDOR,,}/${CONFIG_FIRMWARE_PRODUCT_ID,,}.config" build.config;
	else
		prompt;
		cp "padavan-ng/trunk/configs/templates/$select_input.config" build.config;
	fi
	read -p "Do you want to edit the configuration file? [y/N] " edit;
	if [[ "${edit,,}" =~ ^y(es)?$ ]]; then
		edit build.config;
	fi
fi
config "build.config" "CONFIG_VENDOR CONFIG_FIRMWARE_PRODUCT_ID";

if [[ -f "pre_build.sh" ]]; then
	echo "Run custom pre_build script...";
	. pre_build.sh
fi

echo "Building firmware...";
cexec cp "build.config" "padavan-ng/trunk/.config";
cexec -w "padavan-ng/trunk" "./build_firmware.sh";

echo "Moving firmware to the current directory...";
FW_FILE_NAME="$(find padavan-ng/trunk/images -type f -regextype posix-extended -iregex ".*\.(trx|bin)$" -printf "%T@\t%f\n" | sort -V | tail -1 | cut -f2)";
FW_NAME="${FW_FILE_NAME%.*}";
mv "padavan-ng/trunk/images/${FW_FILE_NAME}" ./;

if [[ -f "post_build.sh" ]]; then
	echo "Run custom post_build script...";
	. post_build.sh
fi

echo "Checking firmware size...";
partitions="padavan-ng/trunk/configs/boards/${CONFIG_VENDOR}/${CONFIG_FIRMWARE_PRODUCT_ID}/partitions.config";
max_fw_size="$(cexec awk '/Firmware/ { getline; getline; sub(",", ""); print strtonum($2); }' "$partitions")";
fw_size="$(stat -c %s "${FW_FILE_NAME}")";
if ((fw_size > max_fw_size)); then
	fw_size_fmtd="$(numfmt --grouping "${fw_size}") bytes";
	max_fw_size_fmtd="$(numfmt --grouping "${max_fw_size}") bytes";
	echo "Firmware size (${fw_size_fmtd}) exceeds max size (${max_fw_size_fmtd}) for your target device" >&2;
	exit 1;
fi
echo "Done! Firmware built successfully. 🎉";
