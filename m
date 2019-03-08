Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B53B3C4360F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 923032087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfCHNh1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:27 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43768 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbfCHNh1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:27 -0500
Received: by mail-wr1-f65.google.com with SMTP id d17so21389585wre.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V8CBUyIiZxvhAQGN49U1N68+lFZo6BYMAtwLWK1iDjA=;
        b=EykA4vO3U6cjLrEj/DY0SrqfffTdG9cQghhYi0L95gIEoFsZQ2wigrS9uC75FfvDKy
         8cAL6I9Oym8xzdek16BfQNooGieNsm+aVN3VviNqkhvdnk8JVVA6J7BDAZJ1MRxV6Kfu
         2/jF0UBNKtuVN+QGQFoCpwyGa5e79GxqvcpuRIcPtWZM6jjgFNuMvmKcGGHL/gz4qo/g
         bZlkwf+BdidO1ile/CXPShCZs7uVadbhREtby/UAL0RCEeBLE2py+LihAB7XeG/FcjXW
         Jj0pBLX3GLyYrkM8c8NKqrBpNvUV1h3csxlTDxQB0ZUF0ilGACwG8MY8Nt8EaOfcgkWi
         KPtg==
X-Gm-Message-State: APjAAAWWhL4xfuv84uotW8DNnRHLrDx7s38Hei0sbpriEMT2OwGl930K
        UTzWr4udZbOO8DeruGWQghSQTMGN
X-Google-Smtp-Source: APXvYqwbRcfayFLR0nOQqux3MDUXIGI2daiNG1HnI/jKrp64tHCHGjugeLFoPDKTrZ2pc/4QBQTWEQ==
X-Received: by 2002:adf:9f54:: with SMTP id f20mr11290291wrg.88.1552052245437;
        Fri, 08 Mar 2019 05:37:25 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:25 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 30/46] tools/lib/traceevent: Man pages for tep_event_filtered() and tep_filter_remove_event()
Date:   Fri,  8 Mar 2019 15:36:38 +0200
Message-Id: <20190308133654.21264-31-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for tep_event_filtered() and tep_filter_remove_event()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-filter_event.txt            | 84 +++++++++++++++++++
 1 file changed, 84 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter_event.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-filter_event.txt b/tools/lib/traceevent/Documentation/libtraceevent-filter_event.txt
new file mode 100644
index 000000000000..9d73e6ec8511
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-filter_event.txt
@@ -0,0 +1,84 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_event_filtered,tep_filter_remove_event - Checks / removes a filter on an event.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_event_filtered*(struct tep_event_filter pass:[*]_filter_, int _event_id_);
+int *tep_filter_remove_event*(struct tep_event_filter pass:[*]_filter_, int _event_id_);
+--
+
+DESCRIPTION
+-----------
+The _tep_event_filtered()_ function checks if the event with _event_id_ has
+_filter_.
+
+The _tep_filter_remove_event()_ function removes a _filter_ for an event with
+_event_id_.
+
+RETURN VALUE
+------------
+The _tep_event_filtered()_ function returns 1 if the filter is found for given
+event, or 0 otherwise.
+
+The _tep_filter_remove_event()_ function returns 1 if the vent was removed, or
+0 if the event was not found.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+struct tep_event_filter *filter = tep_filter_alloc(tep);
+...
+if (tep_event_filtered(filter, 1857) == 1) {
+	/* Event 1857 has filter */
+}
+
+if (tep_filter_remove_event(filter, 1857) == 1) {
+	/* Event 1857 was removed from the filter */
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

