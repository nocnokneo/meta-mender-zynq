SYSTEMD_AUTO_ENABLE = "disable"

do_compile_prepend () {
	export GOCACHE="${B}/.cache"
}
