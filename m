Return-Path: <SRS0=lDd+=TR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08810C04AB4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 May 2019 19:39:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB0592166E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 May 2019 19:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558121986;
	bh=GsBZGNpyNUtVNUIFeCF3uYkjQpjW58WSPKW4JHAwf1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Ga3st+Bp4XfiSSvNdodrVnkc2vTpsaM7sn0ZYgyMb9JnbQ+15duxRHYwG9QXJynBO
	 YFgDMRs0y0dUeAMsqdWDc8twWTZSeYuIfNKz7WgdJ+IfmNx7RbcSuQAeW6WF7a1K5/
	 /DFVHTbATqVNLuH6f7D6cxBHxXUSeVvq33h7FEeY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729539AbfEQTjd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 May 2019 15:39:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729499AbfEQTjc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 May 2019 15:39:32 -0400
Received: from quaco.ghostprotocols.net (unknown [190.15.121.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 138DD2166E;
        Fri, 17 May 2019 19:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558121970;
        bh=GsBZGNpyNUtVNUIFeCF3uYkjQpjW58WSPKW4JHAwf1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xFZvZdYg8yWvFmPI7PatSmfuZ6CmoohC+8kKf98NKcD7+U9rTup5mgqmSmPNPoWdk
         uDEhOfWSB3F9h4eHQiDANweCB5tDvANnPX7dGovwuKXfmb8+ZCtOTtuBQbUduKSy5u
         9dwQeeh4s35dgJmS0FtDfTnevHovkuzCMihBFE7E=
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
Subject: [PATCH 43/73] tools lib traceevent: Man pages for parse event APIs
Date:   Fri, 17 May 2019 16:35:41 -0300
Message-Id: <20190517193611.4974-44-acme@kernel.org>
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

  tep_parse_event(),
  tep_parse_format()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lore.kernel.org/linux-trace-devel/20190503091119.23399-24-tstoyanov@vmware.com
Link: http://lkml.kernel.org/r/20190510200109.847820380@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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

