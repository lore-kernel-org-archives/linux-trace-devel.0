Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE9F8C10F14
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8D422084D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfDLNin (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:38:43 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44816 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726965AbfDLNin (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 09:38:43 -0400
Received: by mail-wr1-f67.google.com with SMTP id y7so11973006wrn.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 12 Apr 2019 06:38:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1pyjYGzyAV1I6IQHXAb08su9TODg663ZbIYx4lSofPQ=;
        b=uYk76BvCG33Z7ELLy4WXK27gMxbSIv9ZNdZgFvyIbZnA4OQ1QfuU0B3NjFLgk/mbX2
         qpl1ploLLjlfPWvsKBtN2RDXMiix6xaIS+XlnP9Vxj3EhOLkEIvKy3Lt+A1LMBICzico
         85ct4mijZHOJ70aizAdmeojSDGhbIfBKtxjBn6Aq1yMqk8DSyNX+MqkBcT+9r52Zgfqp
         3Mqy7B5S6uzFaKR6cwDcbJJEeYT1zV+06MP2lf7h9uPY8xvlpy3Bwx0btKSROwJt75mH
         rxqcjefIjiIvTpt5Wos120pBqyopobVqFz9oejBJMgPcGXWQwFzGoB7KEORaiaTk/QZM
         r1iQ==
X-Gm-Message-State: APjAAAXu03hd3QDviROc+MvsQbyovdi12C4/wy8xbOb+J7hLbgOE37/f
        D0N8y9Nmp+7wEabG3Vc3iyHyECEs
X-Google-Smtp-Source: APXvYqxAxFotcYWhu7V3qGgvRR36sUFLslA6FGH9cCkE5l20Uij4O1379N/zPSiiAynpStyfCW/cFQ==
X-Received: by 2002:adf:ee07:: with SMTP id y7mr33622423wrn.219.1555076321020;
        Fri, 12 Apr 2019 06:38:41 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x205sm11594682wmg.9.2019.04.12.06.38.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Apr 2019 06:38:40 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 30/30] tools/lib/traceevent: Man pages for trace sequences APIs
Date:   Fri, 12 Apr 2019 16:38:11 +0300
Message-Id: <20190412133811.15878-31-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190412133811.15878-1-tstoyanov@vmware.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

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

