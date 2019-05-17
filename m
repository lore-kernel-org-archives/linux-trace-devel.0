Return-Path: <SRS0=lDd+=TR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BD0CC04E87
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 May 2019 19:39:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0D7D217D4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 May 2019 19:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558121942;
	bh=3pDmHX7Z34TVj7oDYyhqMU6ctsjLh5WNmo03zUjl9Ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=SS63ew6HxHnV6UakY5dj+34KjaZC+P0nQ6bCyzVhq1zalPRHNfk4xlOD4LX5LlIfa
	 Ga4jB8HU1n5O/aOBvwO6TfSmdQ3TQDvYkNSRpz86BnER/pbFrwGQ/hRgkFnziF+0nH
	 8wCGY8FNhrf31rA17myBUo3tqnhypn9JI4IM66wk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbfEQTjB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 May 2019 15:39:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728410AbfEQTjA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 May 2019 15:39:00 -0400
Received: from quaco.ghostprotocols.net (unknown [190.15.121.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43210216FD;
        Fri, 17 May 2019 19:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558121939;
        bh=3pDmHX7Z34TVj7oDYyhqMU6ctsjLh5WNmo03zUjl9Ds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RkhILx/TnEmkGMrzQ2YhFhacfTAqF8Kao8Zrfg9nxZuKK4A1D3weQ41siZuXnDaVZ
         M5ImLJRNCKPzPX0caLvORxdQXLkUjGgbyvt5+ap1TOCVZptBGEq5mHkgzn2irr+Gb/
         iGqJOPCuLVp45414rdGX/AKOi2/CXsZRl/UzZyM0=
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
Subject: [PATCH 36/73] tools lib traceevent: Man pages for libtraceevent event get APIs
Date:   Fri, 17 May 2019 16:35:34 -0300
Message-Id: <20190517193611.4974-37-acme@kernel.org>
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

Create man pages for libtraceevent APIs:

  tep_get_event(),
  tep_get_first_event(),
  tep_get_events_count()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lore.kernel.org/linux-trace-devel/20190503091119.23399-17-tstoyanov@vmware.com
Link: http://lkml.kernel.org/r/20190510200108.561088129@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../Documentation/libtraceevent-event_get.txt | 99 +++++++++++++++++++
 1 file changed, 99 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_get.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-event_get.txt b/tools/lib/traceevent/Documentation/libtraceevent-event_get.txt
new file mode 100644
index 000000000000..6525092fc417
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-event_get.txt
@@ -0,0 +1,99 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_get_event, tep_get_first_event, tep_get_events_count - Access events.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+struct tep_event pass:[*]*tep_get_event*(struct tep_handle pass:[*]_tep_, int _index_);
+struct tep_event pass:[*]*tep_get_first_event*(struct tep_handle pass:[*]_tep_);
+int *tep_get_events_count*(struct tep_handle pass:[*]_tep_);
+--
+
+DESCRIPTION
+-----------
+The _tep_get_event()_ function returns a pointer to event at the given _index_.
+The _tep_ argument is trace event parser context, the _index_ is the index of
+the requested event.
+
+The _tep_get_first_event()_ function returns a pointer to the first event.
+As events are stored in an array, this function returns the pointer to the
+beginning of the array. The _tep_ argument is trace event parser context.
+
+The _tep_get_events_count()_ function returns the number of the events
+in the array. The _tep_ argument is trace event parser context.
+
+RETURN VALUE
+------------
+The _tep_get_event()_ returns a pointer to the event located at _index_.
+NULL is returned in case of error, in case there are no events or _index_ is
+out of range.
+
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
+	for (i = 0; i < count; i++) {
+		event = (events+i);
+		/* process events[i] */
+	}
+
+	/* Get the last event */
+	event = tep_get_event(tep, count-1);
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

