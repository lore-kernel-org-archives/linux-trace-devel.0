Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D141C10F09
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59C342087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfCHNhT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:19 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53930 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbfCHNhT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:19 -0500
Received: by mail-wm1-f67.google.com with SMTP id e74so12566863wmg.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s+Xi4RNnn4n3FGDyajZ40+ZAG9VqVOURtnngeQmvobM=;
        b=aFnpsvbPf/xGVHpb9TBVuE84hmDYFJe7+/gpLELg95ABruhd1BFpJvOb+37QOlkHkY
         q2IAa2tC6HvCGtK7OWLJi9pX+RgKjUf6GtUGPBOOKUQJo1MWTzSfAcnHPyS49ViYJ7o/
         JTO21NT7GyxCirj4tA1EezESmP+xcfrL4CAx4KanJb2xGPTONowT4YDjQycIp/zmB9D1
         oWmvei4x5f9p9ZAXBsrgStXQDRpZdtTQK0bIVAjv4akmw8GlG5N4mANrxaWGr5NeqOuw
         FwR8yLLxBSl822dvvVWd/NlkPLYfBRz0FNSS16gzPG28C+lKNmOU6HAV6n5tI3jtCss2
         5GJQ==
X-Gm-Message-State: APjAAAXtRfquT0ulJfxO3DDGgDL/wmrQazfaDB3XW7k1l5V9507iwQ+v
        3hMo4UR7bx0r0Ews52uUIQc=
X-Google-Smtp-Source: APXvYqzST5shBOimTOnN1p22MKCR2rFK7RlzDbEQN1qEQ6h28p6moWYIZd/5nI3b7EPatSa02TUxvg==
X-Received: by 2002:a1c:2082:: with SMTP id g124mr8815409wmg.59.1552052237281;
        Fri, 08 Mar 2019 05:37:17 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:16 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 21/46] tools/lib/traceevent: Man pages tep_get_first_event() and tep_get_events_count()
Date:   Fri,  8 Mar 2019 15:36:29 +0200
Message-Id: <20190308133654.21264-22-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for tep_get_first_event() and tep_get_events_count()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../Documentation/libtraceevent-events.txt    | 87 +++++++++++++++++++
 1 file changed, 87 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-events.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-events.txt b/tools/lib/traceevent/Documentation/libtraceevent-events.txt
new file mode 100644
index 000000000000..b8f81bb9ece9
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-events.txt
@@ -0,0 +1,87 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_get_first_event,tep_get_events_count - Access events.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+struct tep_event pass:[*]*tep_get_first_event*(struct tep_handle pass:[*]_tep_);
+int *tep_get_events_count*(struct tep_handle pass:[*]_tep_);
+--
+
+DESCRIPTION
+-----------
+The _tep_get_first_event()_ function returns a pointer to the first event.
+As events are stored in an array, this function returns the pointer to the
+beginning of the array. The _tep_ argument is trace event parser context.
+
+The _tep_get_events_count()_ function returns the number of the events
+in the array. The _tep_ argument is trace event parser context.
+
+RETURN VALUE
+------------
+The _tep_get_first_event()_ returns a pointer to the first event. NULL is
+returned in case of error, or in case there are no events.
+
+The _tep_get_events_count()_ returns the number of the events. 0 is
+returned in case of error, or in case there are no events.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+int i,count = tep_get_events_count(tep);
+struct tep_event *event, *events = tep_get_first_event(tep);
+
+if (events == NULL) {
+	/* There are no events */
+} else {
+	for (i=0; i<count; i++) {
+		event = (events+i);
+		/* process events[i] */
+	}
+}
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

