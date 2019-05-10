Return-Path: <SRS0=90v9=TK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 658A1C04A6B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 May 2019 20:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A844217F4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 May 2019 20:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728246AbfEJUCS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 May 2019 16:02:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727885AbfEJUBK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 May 2019 16:01:10 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 802A9218CD;
        Fri, 10 May 2019 20:01:08 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1hPBhb-0006iv-L1; Fri, 10 May 2019 16:01:07 -0400
Message-Id: <20190510200107.536391771@goodmis.org>
User-Agent: quilt/0.65
Date:   Fri, 10 May 2019 15:56:17 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>
Subject: [PATCH 11/27] tools/lib/traceevent: Man pages for event handler APIs
References: <20190510195606.537643615@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

Create man pages for libtraceevent APIs:
  tep_register_event_handler()
  tep_unregister_event_handler()

Link: http://lore.kernel.org/linux-trace-devel/20190503091119.23399-11-tstoyanov@vmware.com

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .../libtraceevent-reg_event_handler.txt       | 156 ++++++++++++++++++
 1 file changed, 156 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-reg_event_handler.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-reg_event_handler.txt b/tools/lib/traceevent/Documentation/libtraceevent-reg_event_handler.txt
new file mode 100644
index 000000000000..53d37d72a1c1
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-reg_event_handler.txt
@@ -0,0 +1,156 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_register_event_handler, tep_unregister_event_handler -  Register /
+unregisters a callback function to parse an event information.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+enum *tep_reg_handler* {
+	_TEP_REGISTER_SUCCESS_,
+	_TEP_REGISTER_SUCCESS_OVERWRITE_,
+};
+
+int *tep_register_event_handler*(struct tep_handle pass:[*]_tep_, int _id_, const char pass:[*]_sys_name_, const char pass:[*]_event_name_, tep_event_handler_func _func_, void pass:[*]_context_);
+int *tep_unregister_event_handler*(struct tep_handle pass:[*]tep, int id, const char pass:[*]sys_name, const char pass:[*]event_name, tep_event_handler_func func, void pass:[*]_context_);
+
+typedef int (*pass:[*]tep_event_handler_func*)(struct trace_seq pass:[*]s, struct tep_record pass:[*]record, struct tep_event pass:[*]event, void pass:[*]context);
+--
+
+DESCRIPTION
+-----------
+The _tep_register_event_handler()_ function registers a handler function,
+which is going to be called to parse the information for a given event.
+The _tep_ argument is the trace event parser context. The _id_ argument is
+the id of the event. The _sys_name_ argument is the name of the system,
+the event belongs to. The _event_name_ argument is the name of the event.
+If _id_ is >= 0, it is used to find the event, otherwise _sys_name_ and
+_event_name_ are used. The _func_ is a pointer to the function, which is going
+to be called to parse the event information. The _context_ argument is a pointer
+to the context data, which will be passed to the _func_. If a handler function
+for the same event is already registered, it will be overridden with the new
+one. This mechanism allows a developer to override the parsing of a given event.
+If for some reason the default print format is not sufficient, the developer
+can register a function for an event to be used to parse the data instead.
+
+The _tep_unregister_event_handler()_ function unregisters the handler function,
+previously registered with _tep_register_event_handler()_. The _tep_ argument
+is the trace event parser context. The _id_, _sys_name_, _event_name_, _func_,
+and _context_ are the same arguments, as when the callback function _func_ was
+registered.
+
+The _tep_event_handler_func_ is the type of the custom event handler
+function. The _s_ argument is the trace sequence, it can be used to create a
+custom string, describing the event. A _record_  to get the event from is passed
+as input parameter and also the _event_ - the handle to the record's event. The
+_context_ is custom context, set when the custom event handler is registered.
+
+RETURN VALUE
+------------
+The _tep_register_event_handler()_ function returns _TEP_REGISTER_SUCCESS_
+if the new handler is registered successfully or
+_TEP_REGISTER_SUCCESS_OVERWRITE_ if an existing handler is overwritten.
+If there is not  enough memory to complete the registration,
+TEP_ERRNO__MEM_ALLOC_FAILED is returned.
+
+The _tep_unregister_event_handler()_ function returns 0 if _func_ was removed
+successful or, -1 if the event was not found.
+
+The _tep_event_handler_func_ should return -1 in case of an error,
+or 0 otherwise.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+#include <trace-seq.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+int timer_expire_handler(struct trace_seq *s, struct tep_record *record,
+			 struct tep_event *event, void *context)
+{
+	trace_seq_printf(s, "hrtimer=");
+
+	if (tep_print_num_field(s, "0x%llx", event, "timer", record, 0) == -1)
+		tep_print_num_field(s, "0x%llx", event, "hrtimer", record, 1);
+
+	trace_seq_printf(s, " now=");
+
+	tep_print_num_field(s, "%llu", event, "now", record, 1);
+
+	tep_print_func_field(s, " function=%s", event, "function", record, 0);
+
+	return 0;
+}
+...
+	int ret;
+
+	ret = tep_register_event_handler(tep, -1, "timer", "hrtimer_expire_entry",
+					 timer_expire_handler, NULL);
+	if (ret < 0) {
+		char buf[32];
+
+		tep_strerror(tep, ret, buf, 32)
+		printf("Failed to register handler for hrtimer_expire_entry: %s\n", buf);
+	} else {
+		switch (ret) {
+		case TEP_REGISTER_SUCCESS:
+			printf ("Registered handler for hrtimer_expire_entry\n");
+			break;
+		case TEP_REGISTER_SUCCESS_OVERWRITE:
+			printf ("Overwrote handler for hrtimer_expire_entry\n");
+			break;
+		}
+	}
+...
+	ret = tep_unregister_event_handler(tep, -1, "timer", "hrtimer_expire_entry",
+					   timer_expire_handler, NULL);
+	if ( ret )
+		printf ("Failed to unregister handler for hrtimer_expire_entry\n");
+
+--
+
+FILES
+-----
+[verse]
+--
+*event-parse.h*
+	Header file to include in order to have access to the library APIs.
+*trace-seq.h*
+	Header file to include in order to have access to trace sequences
+	related APIs. Trace sequences are used to allow a function to call
+	several other functions to create a string of data to use.
+*-ltraceevent*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+_libtraceevent(3)_, _trace-cmd(1)_
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>, author of *libtraceevent*.
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>, author of this man page.
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtraceevent is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
-- 
2.20.1


