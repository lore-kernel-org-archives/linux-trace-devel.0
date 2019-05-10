Return-Path: <SRS0=90v9=TK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D480C04A6B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 May 2019 20:01:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07B27217F4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 May 2019 20:01:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbfEJUBY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 May 2019 16:01:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728030AbfEJUBM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 May 2019 16:01:12 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 658182184B;
        Fri, 10 May 2019 20:01:11 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1hPBhe-0006qg-IG; Fri, 10 May 2019 16:01:10 -0400
Message-Id: <20190510200110.462646052@goodmis.org>
User-Agent: quilt/0.65
Date:   Fri, 10 May 2019 15:56:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>
Subject: [PATCH 27/27] tools/lib/traceevent: Man pages for trace sequences APIs
References: <20190510195606.537643615@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

Create man pages for trace sequences libtraceevent APIs:
  trace_seq_init(),
  trace_seq_destroy(),
  trace_seq_reset(),
  trace_seq_terminate(),
  trace_seq_putc(),
  trace_seq_puts(),
  trace_seq_printf(),
  trace_seq_vprintf(),
  trace_seq_do_fprintf(),
  trace_seq_do_printf()

Link: http://lore.kernel.org/linux-trace-devel/20190503091119.23399-27-tstoyanov@vmware.com

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .../Documentation/libtraceevent-tseq.txt      | 158 ++++++++++++++++++
 1 file changed, 158 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-tseq.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-tseq.txt b/tools/lib/traceevent/Documentation/libtraceevent-tseq.txt
new file mode 100644
index 000000000000..8ac6aa174e12
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-tseq.txt
@@ -0,0 +1,158 @@
+libtraceevent(3)
+================
+
+NAME
+----
+trace_seq_init, trace_seq_destroy, trace_seq_reset, trace_seq_terminate,
+trace_seq_putc, trace_seq_puts, trace_seq_printf, trace_seq_vprintf,
+trace_seq_do_fprintf, trace_seq_do_printf -
+Initialize / destroy a trace sequence.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+*#include <trace-seq.h>*
+
+void *trace_seq_init*(struct trace_seq pass:[*]_s_);
+void *trace_seq_destroy*(struct trace_seq pass:[*]_s_);
+void *trace_seq_reset*(struct trace_seq pass:[*]_s_);
+void *trace_seq_terminate*(struct trace_seq pass:[*]_s_);
+int *trace_seq_putc*(struct trace_seq pass:[*]_s_, unsigned char _c_);
+int *trace_seq_puts*(struct trace_seq pass:[*]_s_, const char pass:[*]_str_);
+int *trace_seq_printf*(struct trace_seq pass:[*]_s_, const char pass:[*]_fmt_, _..._);
+int *trace_seq_vprintf*(struct trace_seq pass:[*]_s_, const char pass:[*]_fmt_, va_list _args_);
+int *trace_seq_do_printf*(struct trace_seq pass:[*]_s_);
+int *trace_seq_do_fprintf*(struct trace_seq pass:[*]_s_, FILE pass:[*]_fp_);
+--
+
+DESCRIPTION
+-----------
+Trace sequences are used to allow a function to call several other functions
+to create a string of data to use.
+
+The _trace_seq_init()_ function initializes the trace sequence _s_.
+
+The _trace_seq_destroy()_ function destroys the trace sequence _s_ and frees
+all its resources that it had used.
+
+The _trace_seq_reset()_ function re-initializes the trace sequence _s_. All
+characters already written in _s_ will be deleted.
+
+The _trace_seq_terminate()_ function terminates the trace sequence _s_. It puts
+the null character pass:['\0'] at the end of the buffer.
+
+The _trace_seq_putc()_ function puts a single character _c_ in the trace
+sequence _s_.
+
+The _trace_seq_puts()_ function puts a NULL terminated string _str_ in the
+trace sequence _s_.
+
+The _trace_seq_printf()_ function puts a formated string _fmt _with
+variable arguments _..._ in the trace sequence _s_.
+
+The _trace_seq_vprintf()_ function puts a formated string _fmt _with
+list of arguments _args_ in the trace sequence _s_.
+
+The _trace_seq_do_printf()_ function prints the buffer of trace sequence _s_ to
+the standard output stdout.
+
+The _trace_seq_do_fprintf()_ function prints the buffer of trace sequence _s_
+to the given file _fp_.
+
+RETURN VALUE
+------------
+Both _trace_seq_putc()_ and _trace_seq_puts()_ functions return the number of
+characters put in the trace sequence, or 0 in case of an error
+
+Both _trace_seq_printf()_ and _trace_seq_vprintf()_ functions return 0 if the
+trace oversizes the buffer's free space, the number of characters printed, or
+a negative value in case of an error.
+
+Both _trace_seq_do_printf()_ and _trace_seq_do_fprintf()_ functions return the
+number of printed characters, or -1 in case of an error.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+#include <trace-seq.h>
+...
+struct trace_seq seq;
+trace_seq_init(&seq);
+...
+void foo_seq_print(struct trace_seq *tseq, char *format, ...)
+{
+	va_list ap;
+	va_start(ap, format);
+	if (trace_seq_vprintf(tseq, format, ap) <= 0) {
+		/* Failed to print in the trace sequence */
+	}
+	va_end(ap);
+}
+
+trace_seq_reset(&seq);
+
+char *str = " MAN page example";
+if (trace_seq_puts(&seq, str) != strlen(str)) {
+	/* Failed to put str in the trace sequence */
+}
+if (trace_seq_putc(&seq, ':') != 1) {
+	/* Failed to put ':' in the trace sequence */
+}
+if (trace_seq_printf(&seq, " trace sequence: %d", 1) <= 0) {
+	/* Failed to print in the trace sequence */
+}
+foo_seq_print( &seq, "  %d\n", 2);
+
+trace_seq_terminate(&seq);
+...
+
+if (trace_seq_do_printf(&seq) < 0 ) {
+	/* Failed to print the sequence buffer to the standard output */
+}
+FILE *fp = fopen("trace.txt", "w");
+if (trace_seq_do_fprintf(&seq, fp) < 0 ) [
+	/* Failed to print the sequence buffer to the trace.txt file */
+}
+
+trace_seq_destroy(&seq);
+...
+--
+
+FILES
+-----
+[verse]
+--
+*event-parse.h*
+	Header file to include in order to have access to the library APIs.
+*trace-seq.h*
+	Header file to include in order to have access to trace sequences related APIs.
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


