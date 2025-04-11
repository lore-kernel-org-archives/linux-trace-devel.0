Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444DFFC08
	for <linux-trace-devel@vger.kernel.org>; Fri, 11 Apr 2025 13:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744377150; cv=none; b=aGpaQa5bi8vkEqibpXtjKIB53ORXROaYeE/dU9/XY6imFVab9lgKVirvDSCtwojBcowKOyWDZKmptkm24MhQnjUdYD0Vm1B7CLPJ+SicGdSR5MOqp2nJ2IBu1ORvalpYaQ0p37K8oFAgNFPes6bmL6tdfogrQvXlNJjiQ3gNN30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744377150; c=relaxed/simple;
	bh=PjZmxbngztiv4a7fYgN5585lXKjiPdnsaQsXIIUIFEc=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=Cupey9OFmaiNcx1fJY5sC6Jbhf9tBtlXzdoAkBmGA+nlciZno4/LvJMMaZMNZx81ZvArEY62p2E7AcmPm/dETiNEvC2hxIAnXAZnAvAMnwmoJE/Gg4LVLDxNRGCNX7qYC7d6PlhgmrKA99WDqjmWKmE3hDQxMvICj3e+bOJc824=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8119CC4CEE2
	for <linux-trace-devel@vger.kernel.org>; Fri, 11 Apr 2025 13:12:29 +0000 (UTC)
Date: Fri, 11 Apr 2025 09:13:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd show: Update help message for --hist and
 --trigger options
Message-ID: <20250411091353.13f2a48a@gandalf.local.home>
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

The trace-cmd show help message was missing the --hist and --trigger
options. These are quite useful options and should be visible to the user
and not hidden as Easter eggs!

Also update the bash completion script to help out with the event list.

Fixes: 3e930655b ("trace-cmd show: Add --hist and --trigger options")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-cmd.bash | 4 ++++
 tracecmd/trace-usage.c  | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/tracecmd/trace-cmd.bash b/tracecmd/trace-cmd.bash
index 1bf4bc1b..c500ef0d 100644
--- a/tracecmd/trace-cmd.bash
+++ b/tracecmd/trace-cmd.bash
@@ -139,6 +139,10 @@ __trace_cmd_show_complete()
 	-B)
 	    show_instances "$cur"
 	    ;;
+	--hist|--trigger)
+	    local list=`list_events $cur`
+	    COMPREPLY=( $(compgen -W "all ${list}" -- "${cur}") )
+	    ;;
 	*)
 	    cmd_options show "$cur"
 	    ;;
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 9884631d..3fd975c0 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -177,6 +177,8 @@ static struct usage_help usage_help[] = {
 		"          -f display the file path that is being dumped\n"
 		"          The following options shows the corresponding file name\n"
 		"           and then exits.\n"
+		"          --hist event (show the hist file of an event)\n"
+		"          --trigger event (show the trigger file of an event)\n"
 		"          --tracing_on\n"
 		"          --current_tracer\n"
 		"          --buffer_size (for buffer_size_kb)\n"
-- 
2.47.2

