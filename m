Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D9E20B810
	for <linux-trace-devel@vger.kernel.org>; Fri, 11 Apr 2025 02:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744336997; cv=none; b=o+5xwqD1VG3wvCAE/SU5CpsHneT8zJjCv3ECX8wnw2v5enmmqWl1wojDeSw4X8E+rKjFQbw4o4dUVI7RXhtHwz7TZ0RZa4upo3Sis+hFqd1f3NHFDgRUHEeTe6WgmHto+JTk0oI3QAA33XTEzyYwB3lc9SY/8L5pHJKbru3CBrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744336997; c=relaxed/simple;
	bh=54WUhHQKfSetxY9qbhcJDFrc/dPAwoHG/ltJEDc8Y3E=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=J5T/GMKT66BBQ7yId2p0SaMP8el5DelL/sa2kbQUpPcb3KzEegf7e7KIDGRTUJZdsUVCjzV95VtEJjWl98E9EBeVOqW3FlEkJoSPe0ZqzBjhSQFhlD+8/4RM7FUCCCpWZTgKNCDufHno5N8KpgFq0R3JQIgNAuei4KrjubAu90I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC589C4CEE3
	for <linux-trace-devel@vger.kernel.org>; Fri, 11 Apr 2025 02:03:16 +0000 (UTC)
Date: Thu, 10 Apr 2025 22:04:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] tracefs: Handle synthetic events with dynamic strings as
 fields
Message-ID: <20250410220439.14b81af3@gandalf.local.home>
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

Dynamic strings may contain "__data_loc" in their types within the format
files, but "__data_loc" is not an acceptable type for the dynamic_events
file.

For example tracing the latency of interrupts and having the name of the
interrupt be reported:

  # sqlhist -e -n irq_lat select irq_handler_entry.name, TIMESTAMP_DELTA_USECS as delta from irq_handler_entry as start join irq_handler_exit as end ON start.irq = end.irq
  echo 's:irq_lat __data_loc char name[]; u64 delta;' >> /sys/kernel/tracing/dynamic_events
  echo 'hist:keys=irq:__arg_1193_2=name,__arg_1193_3=common_timestamp.usecs' >> /sys/kernel/tracing/events/irq/irq_handler_entry/trigger
  echo 'hist:keys=irq:__name_1193_1=$__arg_1193_2,__delta_1193_4=common_timestamp.usecs-$__arg_1193_3:onmatch(irq.irq_handler_entry).trace(irq_lat,$__name_1193_1,$__delta_1193_4)' >> /sys/kernel/tracing/events/irq/irq_handler_exit/trigger

The above writes echo 's:irq_lat __data_loc char name[]; u64 delta;' into
dynamic_events, and the "__data_loc" will cause it to fail. To show this,
adding the '-e' option will execute the command first:

  # sqlhist -e -n irq_lat select irq_handler_entry.name, TIMESTAMP_DELTA_USECS as delta from irq_handler_entry as start join irq_handler_exit as end ON start.irq = end.irq
  [23109.878734] synthetic_events: error: Invalid type
  Command: s:synthetic/irq_lat  __data_loc char name[]; u64 delta;
                                ^

The __data_loc caused the write to fail.

Strip the __data_loc off of fields so that it will produce:

  # sqlhist -e -n irq_lat select irq_handler_entry.name, TIMESTAMP_DELTA_USECS as delta from irq_handler_entry as start join irq_handler_exit as end ON start.irq = end.irq
  echo 's:irq_lat char name[]; u64 delta;' >> /sys/kernel/tracing/dynamic_events
  echo 'hist:keys=irq:__arg_1193_2=name,__arg_1193_3=common_timestamp.usecs' >> /sys/kernel/tracing/events/irq/irq_handler_entry/trigger
  echo 'hist:keys=irq:__name_1193_1=$__arg_1193_2,__delta_1193_4=common_timestamp.usecs-$__arg_1193_3:onmatch(irq.irq_handler_entry).trace(irq_lat,$__name_1193_1,$__delta_1193_4)' >> /sys/kernel/tracing/events/irq/irq_handler_exit/trigger

And not fail to execute.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-hist.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index bfbcd65..d67f8eb 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -1068,6 +1068,9 @@ static int alloc_synthetic_event(struct tracefs_synth *synth)
 
 	for (i = 0; synth->synthetic_fields && synth->synthetic_fields[i]; i++) {
 		field = synth->synthetic_fields[i];
+		/* Strip off __data_loc */
+		if (!strncmp(field, "__data_loc ", sizeof("__data_loc ") - 1))
+			field += sizeof("__data_loc ") - 1;
 		format = tfs_append_string(format, i ? " " : NULL, field);
 	}
 
-- 
2.47.2

