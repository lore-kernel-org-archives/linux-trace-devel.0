Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE59C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F97A2087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbfCHNhn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:43 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51454 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbfCHNhm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:42 -0500
Received: by mail-wm1-f65.google.com with SMTP id n19so12557177wmi.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hfr/XW9nWfq0j12kU6DOCXZlcGOGdP2lqwFZ2x5Sn8s=;
        b=RUUUfDwxZdcDmFqkQVL5c4SbrwWgfNBpkwFCvdR83i1xhdlq6mlCHPEEt3Oz6tZ0cd
         ApOg2LKglayICXBcItm1PFhMJgJ8JH5r/lBqC9woPs/fMroC7ef/Dt6SjyaaaDzzgM5P
         EvV6GDBr8ET0u5KBkTK/IWa19yY+W0/U1OGldjmdUShmgDCYZIe32b5Nowm1RrXFyJW0
         6NqETTHTPVfxj4d+QcwewHAbI1fdXWAAolJhj9Ct3GEoPgiAGyWQOKCqIpfbMz+8FCJd
         fysbNIWHtF/sm6ii+Lb9U55IDqfhDYT6sbB5t+Do1A0jwO8eQf/78zRI1wu/BlusswbM
         yP+g==
X-Gm-Message-State: APjAAAVx4fwQNvtfy2/XwiH7LmAuE6gnHBJ2nU58ksL7CZc6Y/8eLaF1
        EQEEAiWbm5dn5IPbM/I/k/Y=
X-Google-Smtp-Source: APXvYqy/kA6Uyfu/rFRxlWkv29m6sWT6b48dOhV+daYoLPSTWpvjOXHEOhUrlMy0XIfkLJrvPwwgZg==
X-Received: by 2002:a1c:1fca:: with SMTP id f193mr8753409wmf.65.1552052260252;
        Fri, 08 Mar 2019 05:37:40 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:39 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 45/46] tools/lib/traceevent: Man pages for trace_seq_putc() and trace_seq_puts()
Date:   Fri,  8 Mar 2019 15:36:53 +0200
Message-Id: <20190308133654.21264-46-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for trace_seq_putc() and trace_seq_puts()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../Documentation/libtraceevent-tseq_put.txt  | 89 +++++++++++++++++++
 1 file changed, 89 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-tseq_put.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-tseq_put.txt b/tools/lib/traceevent/Documentation/libtraceevent-tseq_put.txt
new file mode 100644
index 000000000000..d14d7791d0ef
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-tseq_put.txt
@@ -0,0 +1,89 @@
+libtraceevent(3)
+================
+
+NAME
+----
+trace_seq_putc,trace_seq_puts - Put string / character in  a trace sequence.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+*#include <trace-seq.h>*
+
+int *trace_seq_putc*(struct trace_seq pass:[*]_s_, unsigned char _c_);
+int *trace_seq_puts*(struct trace_seq pass:[*]_s_, const char pass:[*]_str_);
+--
+
+DESCRIPTION
+-----------
+Trace sequences are used to allow a function to call several other functions
+to create a string of data to use.
+
+The _trace_seq_putc()_ function puts a single character _c_ in the trace
+sequence _s_.
+
+The _trace_seq_puts()_ function puts a NULL terminated string _str_ in the
+trace sequence _s_.
+
+RETURN VALUE
+------------
+Both _trace_seq_putc()_ and _trace_seq_puts()_ functions return the number of
+characters put in the trace sequence, or 0 in case of an error.
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
+if (trace_seq_putc(&seq, ';') != 1) {
+	/* Failed to put ';' in the trace sequence */
+}
+...
+char *str = " foo ";
+if (trace_seq_puts(&seq, str) != strlen(str)) {
+	/* Failed to put " foo " in the trace sequence */
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

