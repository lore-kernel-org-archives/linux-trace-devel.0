Return-Path: <SRS0=lDd+=TR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CF77C04E87
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 May 2019 19:42:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E9FE2166E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 May 2019 19:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558122122;
	bh=q7WKE/PxVdUiZswmkA8zyS4iEKkoSFu3iphWqBiJvZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=XvYqnEjnXxCtvNTqtBdwcpbya9Pt1vddFjzCNcx+Odu2mviq8ra7hGzzbqq7WuUmC
	 htYNU73/3UtxO4L1LPSE869Cy+0TgVvaVR2TlLCnvWYbnETsiM+C/qUN2GuncOkkiS
	 Ls/ndIwCRl+eDrVoRtDrVmZ2gaJVJ6w30IVFGTnw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbfEQTi5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 May 2019 15:38:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728410AbfEQTi4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 May 2019 15:38:56 -0400
Received: from quaco.ghostprotocols.net (unknown [190.15.121.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC52D2166E;
        Fri, 17 May 2019 19:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558121935;
        bh=q7WKE/PxVdUiZswmkA8zyS4iEKkoSFu3iphWqBiJvZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TxCB621t0HfmhB+KCbW1Leg1tP4ElPlcePBA/iaqzzmSq3gcQZ39MrtCeutnVCtda
         1zSoNii4BYj7YFoWbGMk8RE5rnHGAU2hpK9pIyQcYjAngBfPA2bX13gZcVFIh3OaDz
         c5DqBlQd2IMsxlo/1H8pofsAUkBE8OpPmkuC886Y=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 35/73] tools lib traceevent: Man page for list events APIs
Date:   Fri, 17 May 2019 16:35:33 -0300
Message-Id: <20190517193611.4974-36-acme@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190517193611.4974-1-acme@kernel.org>
References: <20190517193611.4974-1-acme@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

Create man page for libtraceevent APIs:

  tep_list_events()
  tep_list_events_copy()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lore.kernel.org/linux-trace-devel/20190503091119.23399-16-tstoyanov@vmware.com
Link: http://lkml.kernel.org/r/20190510200108.367633707@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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

