Return-Path: <SRS0=a4MR=OP=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:59262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727695AbeLFDiM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 Dec 2018 22:38:12 -0500
Date: Wed, 5 Dec 2018 22:38:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Cc: Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Slavomir Kaslev <kaslevs@vmware.com>,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH] trace-cmd: Fix left open file descriptor in recording of
 date
Message-ID: <20181205223809.036f3950@vmware.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When running the --date option of trace-cmd record it loops through
writing to the trace_marker and reading the timestamp from
trace_pipe_raw. But it never closes the file descriptor it used to open
trace_pipe_raw with. This prevents other parts of trace-cmd from working
like writing "function" into current_tracer, because the trace_pipe_raw will
hold a ref count and not let different tracers be set if that file is open.

Fixes: e09a5db1a ("trace-cmd: Add trace-cmd record --date option")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 038b2313..24580a40 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3421,6 +3421,7 @@ static unsigned long long find_time_stamp(struct tep_handle *pevent)
 			if (ts)
 				break;
 		} while (r > 0);
+		close(fd);
 		if (ts)
 			break;
 	}
-- 
2.19.2
