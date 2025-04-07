Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D13D1CB337
	for <linux-trace-devel@vger.kernel.org>; Mon,  7 Apr 2025 21:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744060739; cv=none; b=dQuwSDCItDBlsJJYHQsK75wzFR5ChqslVyeO0tlW/s0mdOLYvqXK3J21lhjis5vq4ID10/xAUiEo34etrl4gzXXj8Ro95+GXYcRpNfIjWPRf9ZOFHiq9nmt/Sno/4yngCUxnq78rOpfUr1plERNp4uQ85qUfd4hPH3EK80Gptpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744060739; c=relaxed/simple;
	bh=g4m+fpkcBpASOBdNGOXeXmVNRSiC6fnVY1BgGcWn6TU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=AfqejaJGeC4VNtq/C4WseSXZyi0SF/O+lulJpkoYSXiFWAVmCxrWxO8UQmbhtoVOvxy3jtJjIc9mTFSWShAVhHKA9vs6k6dWkoWrBH5Xf1RlxUAc/BbUpvosLC9zN1PMGTWLZF1zQNC8nieZN0COdOFhrAqaisrhQZRPF5g2ps4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9D8C4CEDD;
	Mon,  7 Apr 2025 21:18:58 +0000 (UTC)
Date: Mon, 7 Apr 2025 17:20:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Metin Kaya <metin.kaya@arm.com>
Subject: [PATCH] libtracefs: Fix mistaken update to TRACEFS_STACKTRACE macro
Message-ID: <20250407172013.6aa58191@gandalf.local.home>
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

The change that converted generic names to variables to start with "tfs_"
was a bit too aggressive and ended up changing the string name of
"common_stacktrace" which broke trace_sql():

When running sqlhist, it would get the following error:

  # ./bin/sqlhist -n wake_lat 'select start.pid, start.common_stacktrace, TIMESTAMP_DELTA_USECS as delta from sched_waking as start join sched_switch as end on start.pid = end.next_pid'
  Failed creating synthetic event!: Success
  select start.pid, start.common_stacktrace, TIMESTAMP_DELTA_USECS as delta from sched_waking as start join sched_switch as end on start.pid = end.next_pid
                    ^
  ERROR: 'start.common_stacktrace'
  Field 'common_stacktrace' not part of event sched_waking

When it should have produced:

  # ./bin/sqlhist -n wake_lat 'select start.pid, start.common_stacktrace, TIMESTAMP_DELTA_USECS as delta from sched_waking as start join sched_switch as end on start.pid = end.next_pid'
  echo 's:wake_lat pid_t pid; unsigned long common_stacktrace[]; u64 delta;' >> /sys/kernel/tracing/dynamic_events
  echo 'hist:keys=pid:__arg_15169_2=pid,__arg_15169_4=common_stacktrace,__arg_15169_5=common_timestamp.usecs' >> /sys/kernel/tracing/events/sched/sched_waking/trigger
  echo 'hist:keys=next_pid:__pid_15169_1=$__arg_15169_2,__common_stacktrace_15169_3=$__arg_15169_4,__delta_15169_6=common_timestamp.usecs-$__arg_15169_5:onmatch(sched.sched_waking).trace(wake_lat,$__pid_15169_1,$__common_stacktrace_15169_3,$__delta_15169_6)' >> /sys/kernel/tracing/events/sched/sched_switch/trigger

Fixes: a2bfb49f ("libtracefs: utest: Rename private functions to fix static building")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/tracefs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index b4e2e30..b6e0f6b 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -593,7 +593,7 @@ int tracefs_event_verify_filter(struct tep_event *event, const char *filter,
 #define TRACEFS_TIMESTAMP "common_timestamp"
 #define TRACEFS_TIMESTAMP_USECS "common_timestamp.usecs"
 
-#define TRACEFS_STACKTRACE "tfs_common_stacktrace"
+#define TRACEFS_STACKTRACE "common_stacktrace"
 
 enum tracefs_synth_handler {
 	TRACEFS_SYNTH_HANDLE_NONE	= 0,
-- 
2.47.2

