#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/sxyazi/yazi"
TOOL_NAME="yazi"
TOOL_TEST="yazi --version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	list_github_tags
}

download_release() {
	local version filename url download_suffix
	version="$1"
	filename="$2"

	download_suffix=$(get_download_suffix)
	url="$GH_REPO/releases/download/v${version}/yazi-$download_suffix.zip"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		local download_suffix
		download_suffix=$(get_download_suffix)
		cp -r "$ASDF_DOWNLOAD_PATH"/yazi-"$download_suffix"/* "$install_path"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}

get_arch() {
	local arch=""

	case "$(uname -m)" in
	x86_64 | amd64) arch='x86_64' ;;
	aarch64 | arm64) arch="aarch64" ;;
	*)
		fail "Arch '$(uname -m)' not supported!"
		;;
	esac

	echo -n $arch
}

get_suffix() {
	local os=""

	case "$(uname -o)" in
	'GNU/Linux') os='unknown-linux-gnu' ;;
	'Darwin') os="apple-darwin" ;;
	*)
		fail "os '$(uname -m)' not supported!"
		;;
	esac

	echo -n $os
}

get_download_suffix() {
	if [ "$(uname -o)" = "Darwin" ]; then
		echo -n $(get_suffix)
	else
		echo -n "$(get_arch)-$(get_suffix)"
	fi
}
