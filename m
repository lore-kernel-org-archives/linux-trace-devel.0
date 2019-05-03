Return-Path: <SRS0=scwk=TD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9013CC43219
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 09:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69423206C3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 09:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbfECJLm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 May 2019 05:11:42 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:32869 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbfECJLm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 May 2019 05:11:42 -0400
Received: by mail-wm1-f67.google.com with SMTP id b188so5269970wmb.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 May 2019 02:11:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bZ+I1EqMaelYorRhjejZI8WmMDXy0IyI9PEtYxf9P+I=;
        b=CwfDaD23h7uAvJcU9mUWzCloRcopEOJqxMKyfcSOSPFKKIfTXn3/A9scGNa4s5mWIm
         nyPHfffqZNx4Wtf7seKZIYEEZFBZYPsgoFO6CRwHLievuJw99CjslltEnV+TK8hUvNDt
         rZrZmZWyo5UEnDoNGS2ravOwm7S0tlH8BcxE0HDYmDlR8tJEqgNiKG6syxsVk6I+K9NV
         m5lldBzOCLF0CaS0wII57iOMciB8EYbYx7zBSEdQvd+GcxrXGxzjB2FNvon5rewnbWjQ
         DXdXgMUAGc9v2s85iAPA/AaWMnQW0pK2VSiArwVp9mdhi0PTeoMzwONsAukBnUbcLtaC
         pOeQ==
X-Gm-Message-State: APjAAAXPMImy52GC0AtmXa01tBFPtPnwyWKt6VeD5nQBxdYo0TcmYnGU
        3Yo9D63iv5jTBcr1C7ks5tU=
X-Google-Smtp-Source: APXvYqxs1q58UBzbvdnt3hzTxTf13oJ5YRFPztW4PMcPp3oywkKCeIzrAIl/NNe4ukBykTkLkzibIQ==
X-Received: by 2002:a1c:a753:: with SMTP id q80mr5490067wme.120.1556874700078;
        Fri, 03 May 2019 02:11:40 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id b11sm2398596wmh.29.2019.05.03.02.11.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 02:11:39 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 23/26] tools/lib/traceevent: Man pages for parse event APIs
Date:   Fri,  3 May 2019 12:11:16 +0300
Message-Id: <20190503091119.23399-24-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503091119.23399-1-tstoyanov@vmware.com>
References: <20190503091119.23399-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for libtraceevent APIs:
  tep_parse_event(),
  tep_parse_format()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-parse_event.txt             | 90 +++++++++++++++++++
 1 file changed, 90 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-parse_event.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-parse_event.txt b/tools/lib/traceevent/Documentation/libtraceevent-parse_event.txt
new file mode 100644
index 000000000000..f248114ca1ff
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-parse_event.txt
@@ -0,0 +1,90 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_parse_event, tep_parse_format - Parse the event format information
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+enum tep_errno *tep_parse_event*(struct tep_handle pass:[*]_tep_, const char pass:[*]_buf_, unsigned long _size_, const char pass:[*]_sys_);
+enum tep_errno *tep_parse_format*(struct tep_handle pass:[*]_tep_, struct tep_event pass:[*]pass:[*]_eventp_, const char pass:[*]_buf_, unsigned long _size_, const char pass:[*]_sys_);
+--
+
+DESCRIPTION
+-----------
+The _tep_parse_event()_ function parses the event format and creates an event
+structure to quickly parse raw data for a given event. The _tep_ argument is
+the trace event parser context. The created event structure is stored in the
+_tep_ context. The _buf_ argument is a buffer with _size_, where the event
+format data is. The event format data can be taken from
+tracefs/events/.../.../format files. The _sys_ argument is the system of
+the event.
+
+The _tep_parse_format()_ function does the same as _tep_parse_event()_. The only
+difference is in the extra _eventp_ argument, where the newly created event
+structure is returned.
+
+RETURN VALUE
+------------
+Both _tep_parse_event()_ and _tep_parse_format()_ functions return 0 on success,
+or TEP_ERRNO__... in case of an error.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+char *buf;
+int size;
+struct tep_event *event = NULL;
+buf = read_file("/sys/kernel/tracing/events/ftrace/print/format", &size);
+if (tep_parse_event(tep, buf, size, "ftrace") != 0) {
+	/* Failed to parse the ftrace print format */
+}
+
+if (tep_parse_format(tep, &event, buf, size, "ftrace") != 0) {
+	/* Failed to parse the ftrace print format */
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

