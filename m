Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FE0AC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E01712087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfCHNhR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:17 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38746 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbfCHNhR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:17 -0500
Received: by mail-wr1-f65.google.com with SMTP id g12so21392424wrm.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tY96rDYVH9xKi+gBJ0gG5dWXJIpRyx68RFvXx3IgsWM=;
        b=ev5gx6mFH4frkcjn+f/Jd6KdUFJUDhQ7ERm0fIRBtpcA6VQbBaPyO6jvyeOtetR6eN
         HCwXR2FuE32KdOcWJaEtruSehVIO4aBJMSh5jUxTAQDCua+Z9b9PtXjt36bTOz7gGU7/
         zeFfKqc788XFUEATNVJHmqjq1hHcHEo2Un8l+qJjE1/GYHcb/sT9+LIVFLNQw2Jwff62
         h8alx82E4PdC6nEGx1LnfSRI++gSec9qbl45zy8nlF6nOTK/nN4TVoK3rfiF6mvAISM4
         x1z6/ZEVdJ4GgeTzN6PDfPtYdwh+gWeNNk1/czNIqz74OGgVGUGkkPsLywgUlwaQrt4N
         mVnQ==
X-Gm-Message-State: APjAAAXJoAcbT4OCOkWz+0IN2RTI382IImsdhDcCpxsPYTgO1q++83Ui
        Dc2Onfl/vEgYB/6iUWzLbkk=
X-Google-Smtp-Source: APXvYqy7lOY5msm0aXyTYraI4IEeRaJV4N62Eoydp3ICklphRMLUOKltvAoruxECRLXUQnY5FOKjlw==
X-Received: by 2002:adf:8273:: with SMTP id 106mr11487693wrb.34.1552052235499;
        Fri, 08 Mar 2019 05:37:15 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:14 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 19/46] tools/lib/traceevent: Man page for tep_list_events()
Date:   Fri,  8 Mar 2019 15:36:27 +0200
Message-Id: <20190308133654.21264-20-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man page for tep_list_events() as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-event_list.txt              | 94 +++++++++++++++++++
 1 file changed, 94 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_list.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-event_list.txt b/tools/lib/traceevent/Documentation/libtraceevent-event_list.txt
new file mode 100644
index 000000000000..97b2e0922900
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-event_list.txt
@@ -0,0 +1,94 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_list_events - Get list of events, sorted by given criteria.
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
+--
+
+DESCRIPTION
+-----------
+The _tep_list_events()_ function returns an array of pointers to the events,
+sorted by the _sort_type_ criteria. The last element of the array is NULL.
+The returned memory must not be freed, it is managed by the library.
+The _tep_ argument is trace event parser context. The _sort_type_ argument is
+the required sort criteria:
+[verse]
+--
+	_TEP_EVENT_SORT_ID_	- sort by the event ID.
+	_TEP_EVENT_SORT_NAME_	- sort by the event (name, system, id) triplet.
+	_TEP_EVENT_SORT_SYSTEM_	- sort by the event (system, name, id) triplet.
+--
+
+RETURN VALUE
+------------
+The _tep_list_events()_ function returns an array of pointers to events.
+In case of an error, NULL is returned.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+int i=0;
+struct tep_event_format **events = tep_list_events(tep, TEP_EVENT_SORT_ID);
+if (events == NULL) {
+	/* Failed to get the events, sorted by ID */
+} else {
+	while(events[i]) {
+		/* walk through the list of the events, sorted by the ID */
+		i++;
+	}
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

