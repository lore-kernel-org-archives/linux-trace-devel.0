Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FF326F461
	for <linux-trace-devel@vger.kernel.org>; Fri, 30 May 2025 19:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748634289; cv=none; b=l4VAbKax6maz1HwXlai/x/MoQoTd5PsiwXdUj1GCmoNAFcnLheGEm+Y+BnaogKaYzesMdt8KbKCij6UmCPPk6GaBEJYnNpCIfQU93kH5DJfPPKxToBdDIpwaFZKrgT3aPipgfWtS3vq+6fvYn1Qg/mi0twg+KeSUZwuepLJzCis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748634289; c=relaxed/simple;
	bh=JLI0Z1UYXfsO93nA6fsgCyuIeg3er4TCvYgJuYfWChM=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=dALDdgpR3Vljk0ds1RSDy4fyM/1+QNwOM1sKVEZfTasVXURrLIDTAS0oJiJU7avVNgRujOrG+nTb6geC3kqLdw5EiQOgkPTB/x85Xj9XLChvWPd76sQKj9dGBOXPNFUBaicLf+Ad7gx7sh2xJ5cpuDcGA5Vq/PoOqE++QTGWmbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951D9C4CEE9
	for <linux-trace-devel@vger.kernel.org>; Fri, 30 May 2025 19:44:48 +0000 (UTC)
Date: Fri, 30 May 2025 15:45:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd completion: Fix trace-cmd report to show files
Message-ID: <20250530154553.62ed9c1f@gandalf.local.home>
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

