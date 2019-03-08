Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D509DC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1E0E2087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbfCHNhY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:24 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43767 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbfCHNhY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:24 -0500
Received: by mail-wr1-f68.google.com with SMTP id d17so21389450wre.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qrts+UVGs5O0G1MTkOgPGdEdfruWa9Z/47yZoFESDBA=;
        b=qJOcDxMb2JSWizFWPx64iON6/DLqrOkCWw5bdy8BhBWzEnVAHB+W9UqsNVxC3Cp51s
         e8LBLr2y6SUBYI/8XJypbES5smnsfkBEcSCWIKb8UgSlOf1w7vwIB6BX5DRZhyvat3JP
         PZDxTcwp46ulTwEYNDkaVVmXda+uotssV/JP7Mv+tTtqgXrEH0qje/Wzy4xYrTuyEpIg
         evnvUchycTpagHG7wfwPjcNYq8/4531BitcuEqFeZMexMUcqhJuRthdL56W2Ry++Ovhc
         jkYaL43CIXyJsHlbpPp8J0XpVNXCVgkcX5OSSrfxTy9I/m99mkGLey/mOayy0arrRW7d
         5Sgg==
X-Gm-Message-State: APjAAAX+yT/wioyfiNrJvxmHWhBEMHBXuIopq1Uol8Kg2+0D7FJjR21B
        PK3x4N+rd6N6zy+K1FZCULI=
X-Google-Smtp-Source: APXvYqxIwhMQRU60OB0OG7Ca8hRATSRjCLU1kaftkNUr9zNH7jxEVY0Y7supFrTLkPv6tNYGdz9NRA==
X-Received: by 2002:adf:e80c:: with SMTP id o12mr10606483wrm.114.1552052242636;
        Fri, 08 Mar 2019 05:37:22 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:22 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 27/46] tools/lib/traceevent: Man pages for tep_filter_alloc(), tep_filter_free() and tep_filter_reset()
Date:   Fri,  8 Mar 2019 15:36:35 +0200
Message-Id: <20190308133654.21264-28-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages tep_filter_alloc(), tep_filter_free() and tep_filter_reset()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../Documentation/libtraceevent-filter.txt    | 85 +++++++++++++++++++
 1 file changed, 85 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-filter.txt b/tools/lib/traceevent/Documentation/libtraceevent-filter.txt
new file mode 100644
index 000000000000..6335bcc10c6c
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-filter.txt
@@ -0,0 +1,85 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_filter_alloc,tep_filter_free,tep_filter_reset - Create / free / reset an event filter.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+struct tep_event_filter pass:[*]*tep_filter_alloc*(struct tep_handle pass:[*]_tep_);
+void *tep_filter_free*(struct tep_event_filter pass:[*]_filter_);
+void *tep_filter_reset*(struct tep_event_filter pass:[*]_filter_);
+--
+
+DESCRIPTION
+-----------
+The _tep_filter_alloc()_ function creates a new event filter. The _tep_ argument
+is the trace event parser context.
+
+The _tep_filter_free()_ function frees an event filter and all resources that it
+had used.
+
+The _tep_filter_reset()_ function removes all rules from an event filter and
+resets it.
+
+RETURN VALUE
+------------
+The _tep_filter_alloc()_ function returns a pointer to the newly created event
+filter, or NULL in case of an error.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+struct tep_event_filter *filter = tep_filter_alloc(tep);
+if (filter == NULL) {
+	/* Failed to create the filter */
+}
+...
+tep_filter_reset(filter);
+...
+tep_filter_free(filter);
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

