Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D734A1E
	for <linux-trace-devel@vger.kernel.org>; Thu, 17 Apr 2025 00:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744848673; cv=none; b=dpF5WUC48AE4xI4U1WMrhwK3HSnGD6yktOMmY9b4weWBfS8SVt8gefv0BCGJgsQdVMTaPbTRpH++5fXT1/kN9Vx3aSxqHTr/uq0YoizchYO5PLn0WuK9icARDk1DXRaQvqQbZPhWv3OzrBVkJFSEzPyyeN6JGH4IPWglwFPcHks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744848673; c=relaxed/simple;
	bh=JLI0Z1UYXfsO93nA6fsgCyuIeg3er4TCvYgJuYfWChM=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=nx1rb722SwC0ZlluxkO5G1XnMHhAdUYEBUJWhqsQLKl016+UwWlU2lKHG0jlwz8YvYGJ4opudTqS6z9LBR00TxnED7KiBUAmJhkZjYje1LCyesMOp5Z7ZwPPlWlYMF3ql6qhA1SmtkKiF5fjogG1nmAsC62y4UazDcoT9UyeqUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7152CC4CEE2
	for <linux-trace-devel@vger.kernel.org>; Thu, 17 Apr 2025 00:11:12 +0000 (UTC)
Date: Wed, 16 Apr 2025 20:12:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd completion: Fix trace-cmd report to show files
Message-ID: <20250416201249.195f3e86@gandalf.local.home>
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

The addition of the trace-cmd sqlhist had to separate out where commands
are printed and where files are printed, and it split cmd_options into one
that showed the commands and cmd_options_files that also will show the
files if no command was found to be completed.

Some trace-cmd commands should show files and some should not.

trace-cmd report is one that should show files if nothing else is
completed, but it was given cmd_options when it should have used
cmd_options_files.

Fixes: 2149da9cdc48b ("trace-cmd: Add sqlhist to bash completion")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-cmd.bash | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-cmd.bash b/tracecmd/trace-cmd.bash
index 82a3b91dfd02..a7e81e0ded4a 100644
--- a/tracecmd/trace-cmd.bash
+++ b/tracecmd/trace-cmd.bash
@@ -237,7 +237,7 @@ __trace_cmd_report_complete()
 	    plugin_options "$cur"
 	    ;;
         *)
-	    cmd_options report "$cur"
+	    cmd_options_files report "$cur"
 	    ;;
     esac
 }
-- 
2.47.2

