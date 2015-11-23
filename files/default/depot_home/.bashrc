# .bashrc
echo "loaded ~/.bashrc"

# Source global definitions
if [ -f /etc/bash.bashrc ]; then
	. /etc/bash.bashrc
fi

if [ -d /etc/profile.d ]; then
	for i in /etc/profile.d/*.sh; do
		echo "loading $i"
		if [ -r $i ]; then
			. $i
		fi
	done
	unset i
fi