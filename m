Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C53D9C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F0E72171F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfDLNiY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:38:24 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37902 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbfDLNiY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 09:38:24 -0400
Received: by mail-wm1-f66.google.com with SMTP id w15so11075703wmc.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 12 Apr 2019 06:38:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bUDFP96y6t0zBr12uIbr8NfufuZQqY5ZLq9u27ZVetg=;
        b=StDSyfHw3t0cO/lJ7phY+BiGvaF6o3hEOg1aY5AdGQRmG3pTFFjMqXM4DCtQAmLMWJ
         ujOLE3oEffv523wKNpyiR+46nE/jp6tb3g5RJb4ccoPyTPGHOFSKejRLcqsvYl2MXV/+
         fYEOOCzK79fLaEfMbYb0nSDfnfT+bGpX1w7eW8FibXJb0yaGNQ6ee2lAqeulbBhAsSXc
         yAwRCWqNijpc6gu4eiu4Lte9xVpLYT7+a/lgwrmshVxCEGaoK+NDpiqfXUAbp9OSXTTx
         toe/mSxHV3etCDbDStmSi6YOXDI+tTZG76yHG7G6p1RkLB3q/JyXTg8syFfGhQAHOFAb
         UQlQ==
X-Gm-Message-State: APjAAAU3I9HXDZZYyypzsfdCAz2qLiPDaw8oKN6dsWEUtvaGDAxF6sJy
        /TeHn9Tw9Iw3B6W013fsXlU=
X-Google-Smtp-Source: APXvYqwwjOhLpWt7bI1GjK3ryZOJyVRIvNDlBVJp2rydLhNIjfzQY+DCsTnvBrS7BYmaoZWcchnKDg==
X-Received: by 2002:a1c:9c03:: with SMTP id f3mr11591006wme.67.1555076301928;
        Fri, 12 Apr 2019 06:38:21 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x205sm11594682wmg.9.2019.04.12.06.38.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Apr 2019 06:38:21 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 10/30] tools/lib/traceevent: Man page for tep_register_trace_clock()
Date:   Fri, 12 Apr 2019 16:37:51 +0300
Message-Id: <20190412133811.15878-11-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190412133811.15878-1-tstoyanov@vmware.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man page for tep_register_trace_clock() libtraceevent API.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../Documentation/libtraceevent-reg_clock.txt | 77 +++++++++++++++++++
 1 file changed, 77 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-reg_clock.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-reg_clock.txt b/tools/lib/traceevent/Documentation/libtraceevent-reg_clock.txt
new file mode 100644
index 000000000000..8bf6c5348fcf
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-reg_clock.txt
@@ -0,0 +1,77 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_register_trace_clock - Registers the clock, used for the timestamp of
+the events.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_register_trace_clock*(struct tep_handle pass:[*]_tep_, const char pass:[*]_trace_clock_);
+--
+
+DESCRIPTION
+-----------
+The _tep_register_trace_clock()_ function registers the clock, used for
+the timestamps of the events. When an event is recorded, a timestamp is attached
+to it. This timestamp comes from a specified clock. Supported clocks can be seen
+in tracefs/trace_clock, the selected one is in square brackets.
+The _tep_ argument is the trace event parser context. The _trace_clock_ argument
+is the name of the clock, the string is copied internally.
+
+RETURN VALUE
+------------
+The _tep_register_trace_clock()_ function returns 0 in case of success.
+If there is not enough memory to copy the _trace_clock_ string -1 is returned
+and errno is set to ENOMEM.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+	if(tep_register_trace_clock(tep, "local") != 0) {
+		/* Failed to register the clock */
+	}
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

