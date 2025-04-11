Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39368367
	for <linux-trace-devel@vger.kernel.org>; Fri, 11 Apr 2025 01:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744334034; cv=none; b=AKNRIDSrcdII8eP7yzcuUf5G0wYqx7PBGOGdUdc47P43kjY7iWqLPLdUujel6DoxbfX96zWKSMQ3Y2HcikaDfUROomVpnuVwKHAFHL9W0JCpdl3QZupnoLluayHA6g6l3wJKUm0K21WgNwJ5hBdYFpieQsuHky3MnSpjrhSU7aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744334034; c=relaxed/simple;
	bh=k3gAVowJVnCZfSdL37JFMlfHOTVNXksO9zu/wZUUNjs=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=XTZi6QnT72whYr17blo/GvDcwSXE7wDDTGzdmBvRsgUelffOUIYiSpTeMaA2AT/YfdCBHsdyp9YveiGCMYIUsT5rPCrzI3h7JAQ5XnIQPSbw7Vr6axAzmjFBQTJlIR0VVInsZ93bk2/9jza2+M9w0YFlQKuLLIKSpHtV3aw1+Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA03C4CEDD
	for <linux-trace-devel@vger.kernel.org>; Fri, 11 Apr 2025 01:13:53 +0000 (UTC)
Date: Thu, 10 Apr 2025 21:15:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v5] libtracefs: Add trace_sql.bash for tracefs_sql() bash
 completions
Message-ID: <20250410211516.1188030c@gandalf.local.home>
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

Other completions can include this file and use tracefs_sql_completion()
function.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Changes since v4: https://lore.kernel.org/20250410160020.47ad614d@gandalf.local.home

- Added support for CAST()
  Although it appears that bash completions have a bug when 'prev' ends
  with an open parenthesis :-p

 Makefile             |  12 +-
 meson.build          |   1 +
 scripts/utils.mk     |   8 +
 src/meson.build      |   4 +
 src/tracefs_sql.bash | 430 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 449 insertions(+), 6 deletions(-)
 create mode 100644 src/tracefs_sql.bash

diff --git a/Makefile b/Makefile
index 6e80226..6b829f7 100644
--- a/Makefile
+++ b/Makefile
@@ -55,6 +55,8 @@ libdir_relative ?= $(libdir_relative_temp)
 prefix ?= /usr/local
 man_dir ?= $(prefix)/share/man
 man_dir_SQ = '$(subst ','\'',$(man_dir))'
+completion_dir ?= $(prefix)/share/bash-completion/completions
+completion_dir_SQ = '$(subst ','\'',$(completion_dir))'
 libdir ?= $(prefix)/$(libdir_relative)
 libdir_SQ = '$(subst ','\'',$(libdir))'
 includedir_relative ?= include/tracefs
@@ -86,9 +88,6 @@ else
 PREF_DEFINED := 0
 endif
 
-etcdir ?= /etc
-etcdir_SQ = '$(subst ','\'',$(etcdir))'
-
 export man_dir man_dir_SQ html_install html_install_SQ INSTALL
 export img_install img_install_SQ
 export DESTDIR DESTDIR_SQ
@@ -100,8 +99,6 @@ HELP_DIR = -DHELP_DIR=$(html_install)
 HELP_DIR_SQ = '$(subst ','\'',$(HELP_DIR))'
 #' emacs highlighting gets confused by the above escaped quote.
 
-BASH_COMPLETE_DIR ?= $(etcdir)/bash_completion.d
-
 # copy a bit from Linux kbuild
 
 ifeq ("$(origin V)", "command line")
@@ -300,7 +297,10 @@ install_libs: libs install_pkgconfig
 	$(Q)$(call do_install,$(src)/include/tracefs.h,$(includedir_SQ),644)
 	$(Q)$(call install_ld_config)
 
-install: install_libs
+install_bash_completion: force
+	$(Q)$(call do_install_data,$(src)/src/tracefs_sql.bash,$(completion_dir))
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
index 0000000..2ec5d91
--- /dev/null
+++ b/src/tracefs_sql.bash
@@ -0,0 +1,430 @@
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
+	local w=$(make_small ${words[$i]})
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
+		  cast)
+		      echo "cast"
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
+	local w=$(make_small ${words[$i]})
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
+		  cast)
+		      echo "cast"
+		      return
+		      ;;
+		  *)
+		      # treat commas as a "select"
+		      if [ "$w" != "${w%%,}" ]; then
+			  echo "select"
+			  return
+		      fi
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
+	local w=$(make_small ${words[$i]})
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
+		    start=$(echo $w | sed -e 's/\.[^\.]*$//')
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
+    local list=$(trace-cmd list -e "^${event/\./:}\$" -F |  cut -d';' -f1 | sed -ne 's/\t.*:.* \(.*\)/\1/p' |sed -e 's/\[.*\]//')
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
+__list_events() {
+    local cur=$1
+
+    local list=$(trace-cmd list -e "$cur")
+    local prefix=${cur%%:*}
+    if [ -z "$cur" -o  "$cur" != "$prefix" ]; then
+	echo "${list}"
+    else
+	local events=$(for e in $list; do echo ${e/*:/}; done | sort -u)
+	local systems=$(for s in $list; do echo ${s/:*/:}; done | sort -u)
+
+	echo "${events} ${systems}"
+    fi
+}
+
+select_options() {
+    local cur=$1
+    local extra=$2
+    local select_list="$extra"
+    local select_fields=" TIMESTAMP TIMESTAMP_USECS STACKTRACE COMM"
+    local list;
+    # Do not show events if nothing was typed yet
+    if [ ! -z "$cur" ]; then
+	list=$(__list_events "${cur/\./:}" | sed -e 's/:/./g')
+	if [ "cast" != "${cast%%$cur}" ]; then
+	    list+=" cast"
+	fi
+    fi
+    add_options "$cur" "$list $select_list"
+    local cnt=${#COMPREPLY[@]}
+    if [ $cnt -eq 1 ]; then
+	local comp=${COMPREPLY[0]}
+	local w=$(compgen -W "$select_list" -- "$comp" )
+	if [ -z "$w" -a $(make_small "$comp") != "cast" ]; then
+	    COMPREPLY=("$comp.")
+	    compopt -o nospace
+	fi
+    elif [ $cnt -eq 0 ]; then
+	local w=$(echo $cur | sed -e 's/\.[^\.]*$//')
+	list=$(print_fields $w "" "$select_fields")
+	COMPREPLY=( $(compgen -W "${list}" -- "${cur}") )
+    fi
+}
+
+check_as() {
+    local words=("$@")
+
+    last_key=$(prev_keyword $COMP_CWORD ${words[@]})
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
+	local w=$(make_small ${words[$i]})
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
+# return 0 if it was handled, otherwise return 1
+tracefs_sql_completion()
+{
+    local prev=$1
+    local cur=$2
+    shift 2
+    local words=("$@")
+
+    if [ "$cur" != "${cur%%,}" ]; then
+	COMPREPLY=("$cur")
+	return 0
+    fi
+
+    local p=$(make_small $prev)
+
+    if [ "$p" != "${p%%,}" ]; then
+	p=$(prev_command $COMP_CWORD ${words[@]})
+    fi
+
+    case "$p" in
+	"select")
+	    select_options "$cur" "CAST TIMESTAMP_DELTA TIMESTAMP_DELTA_USECS"
+	    ;;
+	"on")
+	    list=$(on_list "from" ${words[@]})
+	    add_options "$cur" "$list"
+	    ;;
+	"where")
+	    flist=$(on_list "from" ${words[@]})
+	    jlist=$(on_list "join" ${words[@]})
+	    add_options "$cur" "$flist $jlist"
+	    ;;
+	"cast")
+	    COMPREPLY=("'('")
+	    ;;
+	"as")
+	    local last_cmd=$(prev_command $COMP_CWORD ${words[@]})
+	    case $last_cmd in
+		"select")
+		    if [ ! -z "$cur" ]; then
+			COMPREPLY=("$cur" "$cur,")
+		    fi
+		    ;;
+		"from"|"join")
+		    list=$(add_vars ${words[@]})
+		    if [ ! -z "$list" ]; then
+			add_options "$cur" "$list"
+		    fi
+		    ;;
+		"cast")
+		    local list="hex sym sym-offset log log2 buckets stacktrace"
+		    local w;
+		    if [ -z "$cur" ]; then
+			w=${words[$COMP_CWORD-1]}
+		    else
+			w=${words[$COMP_CWORD-2]}
+		    fi
+		    if [ "$w" != "${w%%.common_pid}" ]; then
+			list+=" execname"
+		    fi
+		    add_options "$cur" "$list"
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
+	"'('")
+	    if [ ! -z "$cur" ]; then
+		select_options "$cur"
+	    fi
+	    ;;
+	"')'")
+	    add_options "$cur" "FROM , $list"
+	    update_completion "$cur" from $alist
+	    ;;
+	*)
+	    local last_cmd=$(prev_command $COMP_CWORD ${words[@]})
+	    local list=$(check_as ${words[@]})
+	    local alist=""
+	    if [ ! -z "$list" ]; then
+		alist="as"
+	    fi
+	    case $last_cmd in
+		"select")
+		    if [ "$cur" != "${cur%%,}" ]; then
+			select_options "$cur" "CAST TIMESTAMP_DELTA TIMESTAMP_DELTA_USECS  $list"
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
+			last_key=$(prev_keyword $COMP_CWORD ${words[@]})
+			if [ "$last_key" == "=" ]; then
+			    if [ $prev == "=" ]; then
+				list=$(on_list "join" ${words[@]})
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
+		"cast")
+		    local last_key=$(prev_keyword $COMP_CWORD ${words[@]})
+		    if [ "$prev" == "\"(\"" -a ! -z "$cur" ]; then
+			select_options "$cur"
+		    elif [ "$prev" == "buckets" ]; then
+			COMPREPLY=("=")
+		    elif [ "$last_key" == "=" ]; then
+			if [ "$prev" != "=" ]; then
+			    COMPREPLY=("')'")
+			fi
+		    elif [ "$last_key" != "as" ]; then
+			COMPREPLY=("AS")
+			update_completion "$cur" as
+		    else
+			    COMPREPLY=("')'")
+		    fi
+		    ;;
+		*)
+		    return 1
+	    esac
+	    ;;
+    esac
+    return 0
+}
-- 
2.47.2

