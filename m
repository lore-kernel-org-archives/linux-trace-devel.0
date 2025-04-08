Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282961A3AB8
	for <linux-trace-devel@vger.kernel.org>; Tue,  8 Apr 2025 15:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744126548; cv=none; b=JzAGKHDZe8laAr9qYEbDqBesCD+aeD+qys7LzYkY0bwdw5vRbdmkdmaUwkFZgRGioWe+ODP5oJd2VYs2oJCGeQcnnRd+dZ+FkCDaW+SGlItTaAAlZdV13Fm7VVefr01TcQecFgauxzHcfmPV69Ci1/0N4W0geU4stVeB9hXtH4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744126548; c=relaxed/simple;
	bh=+/ZHK2JVX5w+wkYC+9tmSpTz8pujUenKDcSTrHN6VkY=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=PjBsSkP4s1FueQrP3i3YI0yDhvo0i/ZZlmSvtFgKkCCGVuigyPBOwEOsTM3ACn1MGqijaWce+qok23PsHtj/hFeYTibpI44+phkUuIPbtwSxKp3lhzozN9Rhl0vqNoL0M6nDfoNeO+srE7d0TWL6NDBOqsmRa1ejSFydYxofYWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FE8C4CEE5
	for <linux-trace-devel@vger.kernel.org>; Tue,  8 Apr 2025 15:35:47 +0000 (UTC)
Date: Tue, 8 Apr 2025 11:37:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd list: Show events in bash completion
Message-ID: <20250408113704.42fb24c8@gandalf.local.home>
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

Even though trace-cmd list -e shows the events, there's several times where
it is useful to see a format of an event that is known, and having tab
completion for those events would be useful.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-cmd.bash | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tracecmd/trace-cmd.bash b/tracecmd/trace-cmd.bash
index d7816bcf..ee7c79a2 100644
--- a/tracecmd/trace-cmd.bash
+++ b/tracecmd/trace-cmd.bash
@@ -84,6 +84,12 @@ __trace_cmd_list_complete()
 				 sed -e 's/.*\(-.\).*/\1/')
 	    COMPREPLY=( $(compgen -W "${cmds}" -- "${cur}") )
 	    ;;
+	-e)
+	    local list=$(trace-cmd list -e "$cur")
+	    local events=$(for e in $list; do echo ${e/*:/}; done | sort -u)
+	    local systems=$(for s in $list; do echo ${s/:*/:}; done | sort -u)
+	    COMPREPLY=( $(compgen -W "all ${events} ${systems}" -- "${cur}") )
+	    ;;
 	*)
 	    size=${#words[@]}
 	    if [ $size -gt 3 ]; then
-- 
2.47.2

