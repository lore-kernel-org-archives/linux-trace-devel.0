Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728127AbfAGMni (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 7 Jan 2019 07:43:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.20 119/145] tools lib traceevent: Fix processing of dereferenced args in bprintk events
Date: Mon,  7 Jan 2019 13:32:36 +0100
Message-Id: <20190107104452.785874755@linuxfoundation.org>
In-Reply-To: <20190107104437.308206189@linuxfoundation.org>
References: <20190107104437.308206189@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

4.20-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit f024cf085c423bac7512479f45c34ee9a24af7ce upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/lib/traceevent/event-parse.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -4970,6 +4970,7 @@ static void pretty_print(struct trace_se
 
 				if (arg->type == TEP_PRINT_BSTRING) {
 					trace_seq_puts(s, arg->string.string);
+					arg = arg->next;
 					break;
 				}
 
