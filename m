Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91138C10F09
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B607208E4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfCHNhm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:42 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33290 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbfCHNhl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:41 -0500
Received: by mail-wr1-f66.google.com with SMTP id i12so21395112wrw.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6Z8ZEoOfvX8++ORC0VJqtjDGKMYkB80TdZwRJpGJqOQ=;
        b=BKRUyOHsr5E9GUadeoWqh1lBUfpGzSszUfXaGvLxXIYdvWCee43MYuEfDdaZk8kSLs
         csnHt+q+AN8b4CGIWMYoDTR25/kKttamK7nKfCCex2mT1mSfWtahAuHRqopsTyVxEWq8
         B6drPZn1sj6RRx1Kh/ATcKYUsOI2GOc3OXnxqJEkjNbNamG+G4ssr0LL2ZIZxd++sqzy
         Cey9Pq7N3GnCygN9JdCNY+fzRx2jcNZPhDK9xbGvLLcA1bia6wGKxqeco6RPT7VLEfzZ
         rz1gjfJy7AdbI5i7trdRsYXTgx3h2xyZ3IcfrZC8JobijunrDr6ehprpCSQMjq/sNihp
         8hZg==
X-Gm-Message-State: APjAAAXhOWnjE8NcnoCRqTKPvRpWWeVdSbrYWfK4ngVb6bNW0NMqs8Zh
        +UNZEY5A8QaLTsuwql5jLSc=
X-Google-Smtp-Source: APXvYqzikZXGKYKs8Oukqf3YNf6QvZGMIVTEWk+Yssp2m7kLxp5wBC0hj8dPkAOThz88RDAa5SSDow==
X-Received: by 2002:a5d:4b05:: with SMTP id v5mr1930067wrq.323.1552052259165;
        Fri, 08 Mar 2019 05:37:39 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:38 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 44/46] tools/lib/traceevent: Man pages for trace_seq_printf() and trace_seq_vprintf()
Date:   Fri,  8 Mar 2019 15:36:52 +0200
Message-Id: <20190308133654.21264-45-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for trace_seq_printf() and trace_seq_vprintf()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-tseq_print.txt              | 96 +++++++++++++++++++
 1 file changed, 96 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-tseq_print.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-tseq_print.txt b/tools/lib/traceevent/Documentation/libtraceevent-tseq_print.txt
new file mode 100644
index 000000000000..f0919bcf1fe3
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-tseq_print.txt
@@ -0,0 +1,96 @@
+libtraceevent(3)
+================
+
+NAME
+----
+trace_seq_printf,trace_seq_vprintf - Print formated string with arguments in a trace sequence.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+*#include <trace-seq.h>*
+
+int *trace_seq_printf*(struct trace_seq pass:[*]_s_, const char pass:[*]_fmt_, _..._);
+int *trace_seq_vprintf*(struct trace_seq pass:[*]_s_, const char pass:[*]_fmt_, va_list _args_);
+--
+
+DESCRIPTION
+-----------
+Trace sequences are used to allow a function to call several other functions
+to create a string of data to use.
+
+The _trace_seq_printf()_ function puts a formated string _fmt _with
+variable arguments _..._ in the trace sequence _s_.
+
+The _trace_seq_vprintf()_ function puts a formated string _fmt _with
+list of arguments _args_ in the trace sequence _s_.
+
+RETURN VALUE
+------------
+
+Both _trace_seq_printf()_ and _trace_seq_vprintf()_ functions return 0 if the
+trace oversizes the buffer's free space, the number of characters printed, or
+a negative value in case of an error.
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
+if (trace_seq_printf(&seq, "example print %d", 10) <= 0) {
+	/* Failed to print in the trace sequence */
+}
+...
+void my_print(char *format, ...)
+{
+	va_list ap;
+	va_start(ap, format);
+	if (trace_seq_printf(&seq, format, ap) <= 0) {
+		/* Failed to print in the trace sequence */
+	}
+	va_end(ap);
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

