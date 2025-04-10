Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275381EA7D4
	for <linux-trace-devel@vger.kernel.org>; Thu, 10 Apr 2025 15:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744299979; cv=none; b=FYqnYRwA2LoNaF60DyhZRUHlJJv1IZtJIcMcuSkcYXAgxcJmibQEhiGSfEcpscxAr1GvPjCbKUJEeZo7GU28MA8YlRTak42we/aNCcjSNuGwGpr2eyFFSatuV+W+nvC4JVAf2nk0CMGRWiJ2ZBBOmmZoE7S1G1+lsyDZEPi6k+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744299979; c=relaxed/simple;
	bh=k5Y9QpwbrhDq5ryCJMongaKx5h+kclE8ZR31DczyaF0=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=ACWD9sifi1HvEIR7MR2cEeEjDHkaXpPaxcCcXRtNjDFsPrLwc2yZbIwpomy2KPdDebHoELYoYpFwYk8qEx+ef3p/+TD5t+VTMxzh7Pyk2uwtadqSV96w1qcg7slSTRYeiNIUFb9/MHLZDTzam88UKLkHf8B9tEdzjO6cdrxoHdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54901C4CEDD
	for <linux-trace-devel@vger.kernel.org>; Thu, 10 Apr 2025 15:46:18 +0000 (UTC)
Date: Thu, 10 Apr 2025 11:47:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Add trace_sql.bash for tracefs_sql() bash
 completions
Message-ID: <20250410114740.31b51642@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

trace-cmd and the internal sqlhist programs can take SQL input to be passed
into the tracefs_sql() function. This can be a bit complex, so create a
bash completion script that uses trace-cmd to allow for tab completions on a
bash command line to fill in the next commands.

This should simplify creating bash completions as well as make some
shortcuts known.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Makefile             |   5 +-
 meson.build          |   1 +
 scripts/utils.mk     |   8 +
 src/meson.build      |   4 +
 src/tracefs_sql.bash | 351 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 368 insertions(+), 1 deletion(-)
 create mode 100644 src/tracefs_sql.bash

diff --git a/Makefile b/Makefile
index 6e80226..49a5477 100644
--- a/Makefile
+++ b/Makefile
@@ -300,7 +300,10 @@ install_libs: libs install_pkgconfig
 	$(Q)$(call do_install,$(src)/include/tracefs.h,$(includedir_SQ),644)
 	$(Q)$(call install_ld_config)
 
-install: install_libs
+install_bash_completion: force
+	$(Q)$(call do_install_data,$(src)/src/tracefs_sql.bash,$(BASH_COMPLETE_DIR))
+
+install: install_libs install_bash_completion
 
 install_pkgconfig: $(PKG_CONFIG_FILE)
 	$(Q)$(call , $(PKG_CONFIG_FILE)) \
diff --git a/meson.build b/meson.build
index 2258ca0..04cedb1 100644
--- a/meson.build
+++ b/meson.build
@@ -21,6 +21,7 @@ threads_dep = dependency('threads', required: true)
 cunit_dep = dependency('cunit', required : false)
 
 prefixdir = get_option('prefix')
+datadir = join_paths(prefixdir, get_option('datadir'))
 bindir = join_paths(prefixdir, get_option('bindir'))
 mandir = join_paths(prefixdir, get_option('mandir'))
 htmldir = join_paths(prefixdir, get_option('htmldir'))
diff --git a/scripts/utils.mk b/scripts/utils.mk
index 4d0f8bc..379d47f 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -187,6 +187,14 @@ define do_install
 	$(INSTALL) $(if $3,-m $3,) $1 '$(DESTDIR_SQ)$2'
 endef
 
+define do_install_data
+	$(print_install)				\
+	if [ ! -d '$(DESTDIR_SQ)$2' ]; then		\
+		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$2';	\
+	fi;						\
+	$(INSTALL) -m 644 $1 '$(DESTDIR_SQ)$2'
+endef
+
 define do_install_pkgconfig_file
 	if [ -n "${pkgconfig_dir}" ]; then 					\
 		$(call do_install,$(PKG_CONFIG_FILE),$(pkgconfig_dir),644); 	\
diff --git a/src/meson.build b/src/meson.build
index 31fd9ed..202df9d 100644
--- a/src/meson.build
+++ b/src/meson.build
@@ -63,3 +63,7 @@ pkg.generate(
 libtracefs_dep = declare_dependency(
     include_directories: ['.'],
     link_with: libtracefs)
+
+install_data(
+    'tracefs_sql.bash',
+    install_dir: datadir + '/bash-completion/completions')
diff --git a/src/tracefs_sql.bash b/src/tracefs_sql.bash
new file mode 100644
index 0000000..fe2e656
--- /dev/null
+++ b/src/tracefs_sql.bash
@@ -0,0 +1,351 @@
+make_small() {
+    local w=$1
+
+    echo $w | tr A-Z a-z
+}
+
+prev_keyword() {
+    local i=$1
+    shift
+    local words=("$@")
+
+    while [ $i -gt 0 ]; do
+	let i=$i-1
+	local w=`make_small ${words[$i]}`
+
+	case $w in
+	    select)
+		      echo "select"
+		      return
+		      ;;
+		  from)
+		      echo "from"
+		      return
+		      ;;
+		  as)
+		      echo "as"
+		      return
+		      ;;
+		  on)
+		      echo "on"
+		      return
+		      ;;
+		  join)
+		      echo "join"
+		      return
+		      ;;
+		  where)
+		      echo "where"
+		      return
+		      ;;
+		  *)
+		      if [ "$w" != "${w%%,}" ]; then
+			  echo ","
+			  return
+		      fi
+		      if [ "$w" != "${w%%=}" ]; then
+			  echo "="
+			  return
+		      fi
+		      if [ "$w" != "${w%%&}" ]; then
+			  echo "&"
+			  return
+		      fi
+		      ;;
+	    esac
+	done
+	    echo ""
+}
+
+prev_command() {
+    local i=$1
+    shift
+    local words=("$@")
+
+    while [ $i -gt 0 ]; do
+	let i=$i-1
+	local w=`make_small ${words[$i]}`
+
+	case $w in
+	    select)
+		      echo "select"
+		      return
+		      ;;
+		  from)
+		      echo "from"
+		      return
+		      ;;
+		  on)
+		      echo "on"
+		      return
+		      ;;
+		  join)
+		      echo "join"
+		      return
+		      ;;
+		  where)
+		      echo "where"
+		      return
+		      ;;
+	    esac
+	done
+	    echo ""
+}
+
+add_vars() {
+    local words=("$@")
+
+    local i=$COMP_CWORD
+
+    local event=""
+
+    let found_from=0
+    let found_as=0
+
+    while [ $i -gt 0 ]; do
+	let i=$i-1
+	local w=`make_small ${words[$i]}`
+
+	case $w in
+	    "from")
+		let found_from=1
+		;;
+	    "as")
+		# Do not add the event itself if it was used by name
+		if [ $found_as -eq 0 ]; then
+		    event=${words[$i-1]};
+		fi
+		let found_as=1
+		;;
+	    *)
+		if [ $found_from -eq 1 ]; then
+		    start=`echo $w | sed -e 's/\.[^\.]*$//'`
+		    if [ "$start" != "$w" -a "$start" == "${start%%\.*}" -a \
+		         "$start" != "$event" ]; then
+			echo -n "$start "
+		    fi
+		fi
+		;;
+	esac
+    done
+}
+
+add_options() {
+    local cur="$1"
+    local list="$2"
+
+    COMPREPLY=( $(compgen -W "${list}" -- "${cur}") )
+}
+
+print_fields() {
+    local event=$1
+    local var=$2
+    local extra=$3
+
+    local list=`trace-cmd list -e "^${event/\./:}\$" -F |  cut -d';' -f1 | sed -ne 's/\t.*:.* \(.*\)/\1/p' |sed -e 's/\[.*\]//'`
+
+    for field in $list $extra; do
+	if [ -z "$var" ]; then
+	    echo "$event.$field"
+	else
+	    echo "$var.$field"
+	fi
+    done
+}
+
+select_options() {
+    local cur=$1
+    local extra=$2
+    local list=`list_events "${cur/\./:}" | sed -e 's/:/./g'`
+    local select_list=" TIMESTAMP_DELTA TIMESTAMP_DELTA_USECS $extra"
+    local select_fields=" TIMESTAMP TIMESTAMP_USECS STACKTRACE COMM"
+    add_options "$cur" "$list $select_list"
+    local cnt=${#COMPREPLY[@]}
+    if [ $cnt -eq 1 ]; then
+	local comp=${COMPREPLY[0]}
+	local w=$(compgen -W "$select_list" -- "$comp" )
+	if [ -z "$w" ]; then
+	    COMPREPLY=("$comp.")
+	    compopt -o nospace
+	fi
+    elif [ $cnt -eq 0 ]; then
+	local w=`echo $cur | sed -e 's/\.[^\.]*$//'`
+	list=`print_fields $w "" "$select_fields"`
+	COMPREPLY=( $(compgen -W "${list}" -- "${cur}") )
+    fi
+}
+
+check_as() {
+    local words=("$@")
+
+    last_key=`prev_keyword $COMP_CWORD ${words[@]}`
+    if [ "$last_key" != "as" ]; then
+	echo -n "AS"
+    fi
+}
+
+on_list() {
+    local type=$1
+    shift
+    local words=("$@")
+
+    local i=$COMP_CWORD
+
+    local var=""
+
+    while [ $i -gt 0 ]; do
+	let i=$i-1
+	local w=`make_small ${words[$i]}`
+	case $w in
+	    "from"|"join")
+		if [ $w == $type ]; then
+		    print_fields ${words[$i+1]} "$var"
+		    return
+		fi
+		var=""
+		;;
+	    as)
+		var=${words[$i+1]}
+		;;
+	esac
+    done
+}
+
+update_completion() {
+    local cur=$1
+    shift
+    local words=("$@")
+
+    if [ ${#COMPREPLY[@]} -gt 0 ]; then
+	return
+    fi
+
+    for w in ${words[@]}; do
+	if [ "$w" != "${w##$cur}" ]; then
+	    COMPREPLY=("$w")
+	    return
+	fi
+    done
+}
+
+sqlhist_completion()
+{
+    local prev=$1
+    local cur=$2
+    shift 2
+    local words=("$@")
+
+    if [ "$cur" != "${cur%%,}" ]; then
+	COMPREPLY=("$cur")
+	return
+    fi
+
+    local p=`make_small $prev`
+
+    if [ "$p" != "${p%%,}" ]; then
+	p=`prev_command $COMP_CWORD ${words[@]}`
+    fi
+
+    case "$p" in
+	"select")
+	    select_options "$cur"
+	    ;;
+	"on")
+	    list=`on_list "from" ${words[@]}`
+	    add_options "$cur" "$list"
+	    ;;
+	"where")
+	    flist=`on_list "from" ${words[@]}`
+	    jlist=`on_list "join" ${words[@]}`
+	    add_options "$cur" "$flist $jlist"
+	    ;;
+	"as")
+	    local last_cmd=`prev_command $COMP_CWORD ${words[@]}`
+	    case $last_cmd in
+		"select")
+		    if [ ! -z "$cur" ]; then
+			COMPREPLY=("$cur" "$cur,")
+		    fi
+		    ;;
+		"from"|"join")
+		    list=`add_vars ${words[@]}`
+		    if [ ! -z "$list" ]; then
+			add_options "$cur" "$list"
+		    fi
+		    ;;
+	    esac
+	    ;;
+	"from"|"join")
+	    local list=$(trace-cmd list -e "${cur/\./:}" | tr : .)
+	    local prefix=${cur/\./}
+	    if [ -z "$cur" -o  "$cur" != "$prefix" ]; then
+		COMPREPLY=( $(compgen -W "${list}" -- "${cur}") )
+	    else
+		local events=$(for e in $list; do echo ${e/*\./}; done | sort -u)
+	        local systems=$(for s in $list; do echo ${s/\.*/.}; done | sort -u)
+
+		COMPREPLY=( $(compgen -W "all ${events} ${systems}" -- "${cur}") )
+	    fi
+	    ;;
+	# TIMESTAMP_DELTA must be labeled
+	"timestamp_delta"|"timestamp_delta_usecs")
+	    COMPREPLY=( $(compgen -W "AS" -- "${cur}") )
+	    update_completion "$cur" "as"
+	    ;;
+	*)
+	    local last_cmd=`prev_command $COMP_CWORD ${words[@]}`
+	    local list=`check_as ${words[@]}`
+	    local alist=""
+	    if [ ! -z "$list" ]; then
+		alist="as"
+	    fi
+	    case $last_cmd in
+		"select")
+		    if [ "$cur" != "${cur%%,}" ]; then
+			select_options "$cur" "$list"
+		    else
+			add_options "$cur" "FROM , $list"
+			update_completion "$cur" from $alist
+		    fi
+		    ;;
+		"from")
+		    add_options "$cur" "JOIN $list"
+		    update_completion "$cur" join $alist
+		    ;;
+		"join")
+		    add_options "$cur" "ON $list"
+		    update_completion "$cur" on $alist
+		    ;;
+		"on")
+		    if [ "$cur" != "${cur%%=}" ]; then
+			COMPREPLY=("")
+		    else
+			last_key=`prev_keyword $COMP_CWORD ${words[@]}`
+			if [ "$last_key" == "=" ]; then
+			    if [ $prev == "=" ]; then
+				list=`on_list "join" ${words[@]}`
+				add_options "$cur" "$list"
+			    else
+				add_options "$cur" "WHERE"
+				update_completion "$cur" where
+			    fi
+			else
+			    add_options "$cur" "="
+			fi
+		    fi
+		    ;;
+		"where")
+		    if [ "$cur" != "${cur%%[=&]}" ]; then
+			COMPREPLY=("")
+		    else
+			add_options "$cur" "== != &"
+		    fi
+		    ;;
+		*)
+		    cmd_options sqlhist "$cur" "SELECT"
+		    update_completion "$cur" select
+		    ;;
+	    esac
+	    ;;
+    esac
+}
-- 
2.47.2

