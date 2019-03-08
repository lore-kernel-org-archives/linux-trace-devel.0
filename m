Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CCBFC4360F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48FCE2087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfCHNhl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:41 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:56259 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbfCHNhk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:40 -0500
Received: by mail-wm1-f66.google.com with SMTP id q187so12682625wme.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GEwAHxUPq3/2YFrpcFnPwlBlgq8zhVh31CVdXNYgQYI=;
        b=pxaohCjk54CR9SpbQGMv5essZMttmANUQvzQ2yxypKLt0dxN+aBmWI2dY+TNrfFsrz
         kMV5RXiicoae4CpPx9uwopCwxetXmznpjvnLYpd5neScNNIeu+HbhowZBggsgpxichY1
         XqLKFUXrHq/GERN4Wxh7N9mlvCzMHTCPB887W1jOn3W5AuTVe600SUgsHrhGrS3bL7sg
         tgQraCTz84sTpPmZXq0EU0Ddygsfzrz7g+iIzKMx8NQJTEd1F9tGUkof7dUIrsxf8Zh1
         iNBr4AIHO+nHz/Y1UZOMfgOYOY0CjFR84oYKGYEFnmhVK8BbhZrgZvE4oZNFy+SKDur9
         rixg==
X-Gm-Message-State: APjAAAX1u+89JUaX8mxPItSusScTGKUUbFProk6IChFeY3frKmIdiWm8
        CmwvEG2D38C13R0p+H/WhpmSNb/H
X-Google-Smtp-Source: APXvYqxzil9D/tp2e7o69kdaQB65pKAnIIDr0BT/D4kw0f+EG9Nbal0iC7B+9wDT+GQ74aIO+V8Emg==
X-Received: by 2002:a7b:c777:: with SMTP id x23mr9542920wmk.71.1552052258139;
        Fri, 08 Mar 2019 05:37:38 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:37 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 43/46] tools/lib/traceevent: Man pages for trace_seq_do_fprintf() and trace_seq_do_printf()
Date:   Fri,  8 Mar 2019 15:36:51 +0200
Message-Id: <20190308133654.21264-44-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for trace_seq_do_fprintf() and trace_seq_do_printf()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-tseq_doprint.txt            | 89 +++++++++++++++++++
 1 file changed, 89 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-tseq_doprint.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-tseq_doprint.txt b/tools/lib/traceevent/Documentation/libtraceevent-tseq_doprint.txt
new file mode 100644
index 000000000000..dd46a7e05c4f
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-tseq_doprint.txt
@@ -0,0 +1,89 @@
+libtraceevent(3)
+================
+
+NAME
+----
+trace_seq_do_fprintf,trace_seq_do_printf - Print the trace sequence buffer to a file.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+*#include <trace-seq.h>*
+
+int *trace_seq_do_printf*(struct trace_seq pass:[*]_s_);
+int *trace_seq_do_fprintf*(struct trace_seq pass:[*]_s_, FILE pass:[*]_fp_);
+--
+
+DESCRIPTION
+-----------
+Trace sequences are used to allow a function to call several other functions
+to create a string of data to use.
+
+The _trace_seq_do_printf()_ function prints the buffer of trace sequence _s_ to
+the standard output stdout.
+
+The _trace_seq_do_fprintf()_ function prints the buffer of trace sequence _s_
+to the given file _fp_.
+
+RETURN VALUE
+------------
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
+if (trace_seq_do_printf(&seq) < 0 ) [
+	/* Failed to print the buffer of the trace sequence to the standard output */
+}
+...
+FILE *fp = fopen("trace.txt", "w");
+if (trace_seq_do_fprintf(&seq, fp) < 0 ) [
+	/* Failed to print the buffer of the trace sequence to the trace.txt file */
+}
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

