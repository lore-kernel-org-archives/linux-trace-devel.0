Return-Path: <SRS0=scwk=TD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24CC7C004C9
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 09:11:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3FB9206C3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 09:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbfECJLf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 May 2019 05:11:35 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42821 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbfECJLf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 May 2019 05:11:35 -0400
Received: by mail-wr1-f66.google.com with SMTP id l2so6873065wrb.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 May 2019 02:11:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QQNQCWdAZPE4o870Y5Mw5VQl+CHZWta3q4pQPTGYQSU=;
        b=nJNRZSt9BBNXtjm9DvA9w2cVUAVbdj9jZjuec9PNTu1JfdfVgusm/qN7HTOVCWGjyQ
         1ZN61G29iI0XKF16k9bE2QO8PxMuRMoiI19jDzPeY/B54RpNvTwj3/m6fWQr1eG0P/bz
         DQf7bOhz7yd8Nnz83uKV8yqTcvOhSDqKt5LyyGzXoxTWj2ZpOEWpIbFSAWvFcgofHPHD
         7mFa+D0mv2RTsxRvUfqCr/4f5buGY4gQzhfIbq4rdeUe0O/CuaUAExSPm79w3iBGs1rS
         ITROzNw0Ko2cTxIwLsGnipZUx1ExsDACuJQ9gcQ5jh2KhU3GrCPBRqSzIcPvars/+F9Y
         zX5w==
X-Gm-Message-State: APjAAAUnU38C4oQXWax8Zj0QnOASZTMbkvOEUa0dadu3rd6DfJDe8L7g
        joI0yTL1GNxM1UWe8oGXRMk=
X-Google-Smtp-Source: APXvYqyLT/yIZhUzaFmfhKBQLktG4vvp5+v02iqoT1bwmGvd1ds4uNSxNZcVt6nAH7LhyL85MHUTTg==
X-Received: by 2002:adf:f88c:: with SMTP id u12mr4145159wrp.26.1556874693899;
        Fri, 03 May 2019 02:11:33 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id b11sm2398596wmh.29.2019.05.03.02.11.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 02:11:33 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 15/26] tools/lib/traceevent: Man page for list events APIs
Date:   Fri,  3 May 2019 12:11:08 +0300
Message-Id: <20190503091119.23399-16-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503091119.23399-1-tstoyanov@vmware.com>
References: <20190503091119.23399-1-tstoyanov@vmware.com>
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
 .../libtraceevent-event_list.txt              | 122 ++++++++++++++++++
 1 file changed, 122 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_list.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-event_list.txt b/tools/lib/traceevent/Documentation/libtraceevent-event_list.txt
new file mode 100644
index 000000000000..fba350e5a4cb
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-event_list.txt
@@ -0,0 +1,122 @@
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
+must be freed by the caller. Note that the content of the array must not be
+freed (see the EXAMPLE below).
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

