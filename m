Return-Path: <SRS0=lLmH=O3=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:36388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727675AbeLRWId (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 Dec 2018 17:08:33 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Clark Williams <williams@redhat.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-trace-devel@vger.kernel.org, stable@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/63] tools lib traceevent: Fix processing of dereferenced args in bprintk events
Date: Tue, 18 Dec 2018 19:06:35 -0300
Message-Id: <20181218220733.15839-6-acme@kernel.org>
In-Reply-To: <20181218220733.15839-1-acme@kernel.org>
References: <20181218220733.15839-1-acme@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

In the case that a bprintk event has a dereferenced pointer that is
stored as a string, and there's more values to process (more args), the
arg was not updated to point to the next arg after processing the
dereferenced pointer, and it screwed up what was to be displayed.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: linux-trace-devel@vger.kernel.org
Cc: stable@vger.kernel.org
Fixes: 37db96bb49629 ("tools lib traceevent: Handle new pointer processing of bprint strings")
Link: http://lkml.kernel.org/r/20181210134522.3f71e2ca@gandalf.local.home
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index a5ed291b8a9f..69a96e39f0ab 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -4973,6 +4973,7 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
 
 				if (arg->type == TEP_PRINT_BSTRING) {
 					trace_seq_puts(s, arg->string.string);
+					arg = arg->next;
 					break;
 				}
 
-- 
2.19.2
