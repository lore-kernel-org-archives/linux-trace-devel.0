Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1133C1E25F2
	for <linux-trace-devel@vger.kernel.org>; Thu, 10 Apr 2025 02:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744252951; cv=none; b=e1qf6x4k2TKRPEdjPVPj9YhypAwMQVKmwFaX7WLWqYyylZxADarTDuV1DcdTMw0OKHv8HV7Zf4xpah75+y5Z3klAF24vcgLUfp6rc91XAZgsbDFol9a0dF/EbplaKgceAWI6eqrRMG9R02MGk6hu/eMSPPprN1yj0BWpiwJPK7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744252951; c=relaxed/simple;
	bh=JznZUtw8Dj2LMnAsEIuwhlZPHYeWRv5mq5lR0G1yK8E=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=JnfWkoIf/lFSZ4WHdnZAtdA8v8Q5wGx91Ltw4DiHqNphdE6BP+FuwWYvej+ynDHw99z1AV3ivvATFjVvQTwHb59vZQDlKax6GU252aIsAaFwz/ahSUy5lVs2rmUi7eHZRwws6TQSVFOzg1O8b/F0nokcAOknpxtTBpwS3PWVR10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528A7C4CEE2
	for <linux-trace-devel@vger.kernel.org>; Thu, 10 Apr 2025 02:42:30 +0000 (UTC)
Date: Wed, 9 Apr 2025 22:43:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Add sqlhist to bash completion
Message-ID: <20250409224350.7224d8ce@gandalf.local.home>
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

Add the commands for sqlhist to bash completion. This makes writing the SQL
lines for the select statements so much easier. Now the user can use tab
completion to see what the next possible commands are.

This also makes the shortcuts like TIMESTAMP_DELTA_USECS more visible and
less error prone to typos.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-cmd.bash | 375 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 357 insertions(+), 18 deletions(-)

diff --git a/tracecmd/trace-cmd.bash b/tracecmd/trace-cmd.bash
index ee7c79a2..6167bdbc 100644
--- a/tracecmd/trace-cmd.bash
+++ b/tracecmd/trace-cmd.bash
@@ -1,3 +1,9 @@
+make_small() {
+    local w=$1
+
+    echo $w | tr A-Z a-z
+}
+
 show_instances()
 {
    local cur="$1"
@@ -48,9 +54,15 @@ cmd_options()
 {
     local type="$1"
     local cur="$2"
+    local extra="$3"
     local cmds=$(trace-cmd $type -h 2>/dev/null|grep "^ *-" | \
 				 sed -e 's/ *\(-[^ ]*\).*/\1/')
-    COMPREPLY=( $(compgen -W "${cmds}" -- "${cur}") )
+    COMPREPLY=( $(compgen -W "${cmds} ${extra}" -- "${cur}") )
+}
+
+cmd_options_files()
+{
+    cmd_options "$1" "$2" "$3"
     if [ ${#COMPREPLY[@]} -eq 0 ]; then
 	__show_files "${cur}"
     fi
@@ -71,6 +83,21 @@ compression_param()
     COMPREPLY=( $(compgen -W "${opts}") )
 }
 
+list_events() {
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
 __trace_cmd_list_complete()
 {
     local prev=$1
@@ -85,10 +112,8 @@ __trace_cmd_list_complete()
 	    COMPREPLY=( $(compgen -W "${cmds}" -- "${cur}") )
 	    ;;
 	-e)
-	    local list=$(trace-cmd list -e "$cur")
-	    local events=$(for e in $list; do echo ${e/*:/}; done | sort -u)
-	    local systems=$(for s in $list; do echo ${s/:*/:}; done | sort -u)
-	    COMPREPLY=( $(compgen -W "all ${events} ${systems}" -- "${cur}") )
+	    local list=`list_events "$cur"`
+	    COMPREPLY=( $(compgen -W "all $list" -- "${cur}") )
 	    ;;
 	*)
 	    size=${#words[@]}
@@ -154,17 +179,9 @@ __trace_cmd_record_complete()
     local words=("$@")
 
     case "$prev" in
-        -e)
-	    local list=$(trace-cmd list -e "$cur")
-            local prefix=${cur%%:*}
-	    if [ -z "$cur" -o  "$cur" != "$prefix" ]; then
-		COMPREPLY=( $(compgen -W "all ${list}" -- "${cur}") )
-	    else
-		local events=$(for e in $list; do echo ${e/*:/}; done | sort -u)
-	        local systems=$(for s in $list; do echo ${s/:*/:}; done | sort -u)
-
-		COMPREPLY=( $(compgen -W "all ${events} ${systems}" -- "${cur}") )
-	    fi
+	-e)
+	    local list=`list_events $cur`
+	    COMPREPLY=( $(compgen -W "all ${list}" -- "${cur}") )
 
             # This is still to handle the "*:*" special case
             if [[ -n "$prefix" ]]; then
@@ -191,7 +208,7 @@ __trace_cmd_record_complete()
 	    ;;
 	-A)
 	    if ! show_virt "$cur"; then
-		cmd_options record "$cur"
+		cmd_options_files record "$cur"
 	    fi
 	    ;;
 	--compression)
@@ -199,7 +216,7 @@ __trace_cmd_record_complete()
 	    ;;
         *)
 	    # stream start and profile do not show all options
-	    cmd_options record "$cur"
+	    cmd_options_files record "$cur"
 	    ;;
     esac
 }
@@ -288,6 +305,324 @@ __trace_cmd_convert_complete()
     esac
 }
 
+##### SQLHIST COMMANDS #####
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
+    let found_from=0
+
+    while [ $i -gt 0 ]; do
+	let i=$i-1
+	local w=`make_small ${words[$i]}`
+
+	case $w in
+	    "from")
+		let found_from=1
+		;;
+	    *)
+		if [ $found_from ]; then
+		    start=`echo $w | sed -e 's/\.[^\.]*$//'`
+		    if [ "$start" != "$w" -a "$start" == "${start%%\.*}" ]; then
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
+	echo "$event.$field"
+	if [ ! -z "$var" ]; then
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
+    local select_fields=" TIMESTAMP TIMESTAMP_USECS STACKTRACE"
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
+__trace_cmd_sqlhist_complete()
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
+	"sqlhist")
+	    cmd_options sqlhist "$cur" "SELECT"
+	    update_completion "$cur" select
+	    ;;
+	"select")
+	    select_options "$cur"
+	    ;;
+	"on")
+	    list=`on_list "from" ${words[@]}`
+	    add_options "$cur" "$list"
+	    ;;
+	"as")
+	    local last_cmd=`prev_command $COMP_CWORD ${words[@]}`
+	    case $last_cmd in
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
+		    ;;
+		*)
+		    cmd_options sqlhist "$cur" "SELECT"
+		    update_completion "$cur" select
+		    ;;
+	    esac
+	    ;;
+    esac
+}
+
+##### SQLHIST COMMANDS END #####
+
 __show_command_options()
 {
     local command="$1"
@@ -374,6 +709,10 @@ _trace_cmd_complete()
 	    __trace_cmd_convert_complete "${prev}" "${cur}" ${words[@]}
 	    return 0
 	    ;;
+	sqlhist)
+	    __trace_cmd_sqlhist_complete "${prev}" "${cur}" ${words[@]}
+	    return 0
+	    ;;
         *)
 	    __show_command_options "$w" "${prev}" "${cur}"
             ;;
-- 
2.47.2

