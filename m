Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A24A1C10F14
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C0322084D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbfDLNi3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:38:29 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41398 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbfDLNi3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 09:38:29 -0400
Received: by mail-wr1-f68.google.com with SMTP id r4so11965617wrq.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 12 Apr 2019 06:38:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oaPIgFhnw3nZP94vy4cUagZ1XhQY6w1o32hV3EJD3ig=;
        b=sW52J0oBQ0LZvqj/B58w783Qcq/WTiMcGTENBfiDtQVN7OZXnGldy6BnjDwrkVnIq5
         YEB4Cj0ZD8GexqxxfMx8U2ueYf1xgxyyFV7z0Op+0ZH7XV8iJbCGRiPc0oXPV14we2iK
         Rl+l3tHjPqJ25d0+/oDHUSoa30u/dsztBcrkZPpDkba8eW5x6FgD5sHyM+MlmVEMEfBH
         7Hm/OLhJRvKQXAHIqb2f+uqr6yYLgtLApp3S7o4k4acu1lMLKjCzuEhfl2kpD9U255os
         mw5SywJ7yrXLH2GTEdZ4y03zm5fHG02JPNIwXMBM+rjCmyB5FdgBNIkS/0LbY14X0KwT
         Nepw==
X-Gm-Message-State: APjAAAXk+fmOOrOMP6iw9ImhmoFBM0ws29sTCkvuKxhxAoJLIYuS9qln
        jM4tSPz7SqkWQqksGaWMBZUNFqwX
X-Google-Smtp-Source: APXvYqxfUdC0l9DK95Sn650MLfJSi3U8D7mWdQhHqlradM7lCzUG1BdTm4HITFLJ70tDnWH42qEShg==
X-Received: by 2002:adf:e288:: with SMTP id v8mr29978662wri.7.1555076307371;
        Fri, 12 Apr 2019 06:38:27 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x205sm11594682wmg.9.2019.04.12.06.38.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Apr 2019 06:38:26 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 16/30] tools/lib/traceevent: Man page for list events APIs
Date:   Fri, 12 Apr 2019 16:37:57 +0300
Message-Id: <20190412133811.15878-17-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190412133811.15878-1-tstoyanov@vmware.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man page for libtraceevent APIs:
  tep_list_events()
  tep_list_events_copy()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-event_list.txt              | 121 ++++++++++++++++++
 1 file changed, 121 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_list.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-event_list.txt b/tools/lib/traceevent/Documentation/libtraceevent-event_list.txt
new file mode 100644
index 000000000000..3776e84bba8b
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-event_list.txt
@@ -0,0 +1,121 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_list_events, tep_list_events_copy -
+Get list of events, sorted by given criteria.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+enum *tep_event_sort_type* {
+	_TEP_EVENT_SORT_ID_,
+	_TEP_EVENT_SORT_NAME_,
+	_TEP_EVENT_SORT_SYSTEM_,
+};
+
+struct tep_event pass:[*]pass:[*]*tep_list_events*(struct tep_handle pass:[*]_tep_, enum tep_event_sort_type _sort_type_);
+struct tep_event pass:[*]pass:[*]*tep_list_events_copy*(struct tep_handle pass:[*]_tep_, enum tep_event_sort_type _sort_type_);
+--
+
+DESCRIPTION
+-----------
+The _tep_list_events()_ function returns an array of pointers to the events,
+sorted by the _sort_type_ criteria. The last element of the array is NULL.
+The returned memory must not be freed, it is managed by the library.
+The function is not thread safe. The _tep_ argument is trace event parser
+context. The _sort_type_ argument is the required sort criteria:
+[verse]
+--
+	_TEP_EVENT_SORT_ID_	- sort by the event ID.
+	_TEP_EVENT_SORT_NAME_	- sort by the event (name, system, id) triplet.
+	_TEP_EVENT_SORT_SYSTEM_	- sort by the event (system, name, id) triplet.
+--
+
+The _tep_list_events_copy()_ is a thread safe version of _tep_list_events()_.
+It has the same behavior, but the returned array is allocated internally and
+must be freed by the caller.
+
+RETURN VALUE
+------------
+The _tep_list_events()_ function returns an array of pointers to events.
+In case of an error, NULL is returned. The returned array must not be freed,
+it is managed by the library.
+
+The _tep_list_events_copy()_ function returns an array of pointers to events.
+In case of an error, NULL is returned. The returned array must be freed by
+the caller.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+int i;
+struct tep_event_format **events;
+
+i=0;
+events = tep_list_events(tep, TEP_EVENT_SORT_ID);
+if (events == NULL) {
+	/* Failed to get the events, sorted by ID */
+} else {
+	while(events[i]) {
+		/* walk through the list of the events, sorted by ID */
+		i++;
+	}
+}
+
+i=0;
+events = tep_list_events_copy(tep, TEP_EVENT_SORT_NAME);
+if (events == NULL) {
+	/* Failed to get the events, sorted by name */
+} else {
+	while(events[i]) {
+		/* walk through the list of the events, sorted by name */
+		i++;
+	}
+	free(events);
+}
+
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

