Return-Path: <SRS0=lDd+=TR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA1FC04E84
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 May 2019 19:39:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EB592166E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 May 2019 19:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558121987;
	bh=LhFOXG0WISx3V40lhHAcu5eNTbn4/Io60kUmHo1ThfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=u/g9VKZHCIlwA+euDMCOwCNswrc9n9RaGJaEenXPiBbggXATBN7gvtH9E1vJDnnzp
	 SiRDE16MdO6Fp/88ll7XAvLbesgnzhgu+P2LJNNnJLGnro/D5O38n9w5V0q/CWYeF2
	 9jyOqF9tpztzuLvQIDqLUccdQzk8BGpqU8O/4540=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727467AbfEQTjq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 May 2019 15:39:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729566AbfEQTjp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 May 2019 15:39:45 -0400
Received: from quaco.ghostprotocols.net (unknown [190.15.121.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A39C821734;
        Fri, 17 May 2019 19:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558121984;
        bh=LhFOXG0WISx3V40lhHAcu5eNTbn4/Io60kUmHo1ThfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wdETtJHxgLB6vhxfrHMeK/ZT+29EC1fKB/U09j7NkeSBDEGh092GxZ16R6sW00ckW
         IsZzAl9IABZbRxqog82PAqKHi7s6Mrl/hV7wR4+RdOXcb0DUPZFmw8xZoNSwYZ3sAU
         doZViF0qc9gXe12cj+6Y/ljw7WOpE10foNaTXfyQ=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 46/73] tools lib traceevent: Man pages for trace sequences APIs
Date:   Fri, 17 May 2019 16:35:44 -0300
Message-Id: <20190517193611.4974-47-acme@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190517193611.4974-1-acme@kernel.org>
References: <20190517193611.4974-1-acme@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lore.kernel.org/linux-trace-devel/20190503091119.23399-27-tstoyanov@vmware.com
Link: http://lkml.kernel.org/r/20190510200110.462646052@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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

