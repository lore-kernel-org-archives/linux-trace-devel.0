Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92281E9B14
	for <linux-trace-devel@vger.kernel.org>; Thu, 10 Apr 2025 15:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744300039; cv=none; b=tGWSqg8V3YHAyn0vqHurSgg964ZL4WPL+gGP7uwcbibF6ZaBhQ6f5k3/MUg+tAtDJOCJKmE2eOrKe9LsLfSO1rO3HJQX81y3fMTy5McIdRB7UkDpDlR9Aed+8fA2yKkv7DMbn/ioxSNQ7PIK+CPwdwQ+nwrJNVgQv2GsqqRcYmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744300039; c=relaxed/simple;
	bh=Huk59GmzadMW+LrUGZeXvUZNROGzLVTQgfYxg8CoH/s=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=ri6pkEQCWQE1YnrrbTO4HDiOL8y697KIKQmtn2BOWFdlL5T1laN7WqUOqhP4Vb5Hu9FdI2v+PmuIQ5UJDoWo9hDPbm5QmYZNcVyxXFUK4PEhUr/GdzsoD7z40EuXpz34YcwQ0aV7k4w8dIxquRxSjh/TrKPKaOdyjpFnzolvnzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052E5C4CEDD
	for <linux-trace-devel@vger.kernel.org>; Thu, 10 Apr 2025 15:47:14 +0000 (UTC)
Date: Thu, 10 Apr 2025 11:48:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] sqlhish: Add bash completion for the sqlhist utility
Message-ID: <20250410114837.144cec8e@gandalf.local.home>
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

Add a bash completion script for the sqlhist utility that utilizes the
tracefs_sql.bash completion script to fill out the sql lines.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 samples/sqlhist.bash | 61 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)
 create mode 100644 samples/sqlhist.bash

diff --git a/samples/sqlhist.bash b/samples/sqlhist.bash
new file mode 100644
index 0000000..44f7e9a
--- /dev/null
+++ b/samples/sqlhist.bash
@@ -0,0 +1,61 @@
+# sqlhist completion
+
+# use the library tracefs_sql() completion
+
+thisdir=`dirname $BASH_SOURCE`
+if [ -e $thisdir/tracefs_sql.bash ]; then
+. $thisdir/tracefs_sql.bash
+elif [ -e $thisdir/../src/tracefs_sql.bash ]; then
+. $thisdir/../src/tracefs_sql.bash
+else
+sqlhist_completion()
+{
+    return
+}
+fi
+
+found_select()
+{
+    local words=("$@")
+    local i=$COMP_CWORD
+
+    while [ $i -gt 0 ]; do
+	let i=$i-1
+	local w=$(echo ${words[$i]} | tr A-Z a-z)
+	if [ $w == "select" ]; then
+	    return 0
+	fi
+    done
+    return 1
+}
+
+_sqlhist_complete()
+{
+    local cur=""
+    local prev=""
+    local words=()
+
+    # Not to use COMP_WORDS to avoid buggy behavior of Bash when
+    # handling with words including ":", like:
+    #
+    # prev="${COMP_WORDS[COMP_CWORD-1]}"
+    # cur="${COMP_WORDS[COMP_CWORD]}"
+    #
+    # Instead, we use _get_comp_words_by_ref() magic.
+    _get_comp_words_by_ref -n : cur prev words
+
+    if `found_select ${words[@]}` ; then
+	sqlhist_completion "$prev" "$cur" ${words[@]}
+	return
+    fi
+    local cmds=$(sqlhist -h 2>&1 | \
+                     grep '^ *-' | sed -e 's/^ *\(-[^ ]*\).*/\1/')
+    COMPREPLY=( $(compgen -W "${cmds} SELECT" -- "${cur}") )
+    if [ ${#COMPREPLY[@]} -eq 0 ]; then
+	local w="select"
+	if [ "$w" != "${w##$cur}" ]; then
+	    COMPREPLY=("$w")
+	fi
+    fi
+}
+complete -F _sqlhist_complete sqlhist
-- 
2.47.2

