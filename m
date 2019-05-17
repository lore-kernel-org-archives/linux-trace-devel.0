Return-Path: <SRS0=lDd+=TR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ED32C04E84
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 May 2019 19:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A8D02166E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 May 2019 19:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558122125;
	bh=UX50jR1VytJVQQxer7LjamI6OiE4kGXkWTXxYQGWl2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=MzP65bmSU6Pf5AEF7ks4CwZ2+1mdkonNld4Jaxp5F/xe44NTUgBFFzrOhZKnbDMvl
	 V3zV/3xjytfWq7O/YLxo5BDpI7Qng9Xb8YKJEPyJI6zNMRimP69pt7TsR3pq098xFA
	 3lpNOEpSBgVPusmbOm19HkiSAk/wtj/bbUMWjfXc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbfEQTiK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 May 2019 15:38:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727771AbfEQTiJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 May 2019 15:38:09 -0400
Received: from quaco.ghostprotocols.net (unknown [190.15.121.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9019C21726;
        Fri, 17 May 2019 19:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558121887;
        bh=UX50jR1VytJVQQxer7LjamI6OiE4kGXkWTXxYQGWl2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dJF+t5BaR9x8HOQ2vT8BA3y9KEJSGJKuzc1WrXsj+f06kKaA5Ci9sXLJajKn7vHkQ
         DxzgGv9qnW70syLJaiOxwIauwaDgkc08BnsD+EG8HbNmprqHb+KMtUSRKx83p5O+ke
         WYnUighbJN3ehk1rS1/O3hixJDW7F+KAp5PDFN4U=
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
Subject: [PATCH 24/73] tools lib traceevent: Man page for header_page APIs
Date:   Fri, 17 May 2019 16:35:22 -0300
Message-Id: <20190517193611.4974-25-acme@kernel.org>
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

Create a man page for libtraceevent APIs:

  tep_get_header_page_size(),
  tep_get_header_timestamp_size(),
  tep_is_old_format()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lore.kernel.org/linux-trace-devel/20190503091119.23399-5-tstoyanov@vmware.com
Link: http://lkml.kernel.org/r/20190510200106.583928896@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../libtraceevent-header_page.txt             | 102 ++++++++++++++++++
 1 file changed, 102 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-header_page.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-header_page.txt b/tools/lib/traceevent/Documentation/libtraceevent-header_page.txt
new file mode 100644
index 000000000000..615d117dc39f
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-header_page.txt
@@ -0,0 +1,102 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_get_header_page_size, tep_get_header_timestamp_size, tep_is_old_format -
+Get the data stored in the header page, in kernel context.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_get_header_page_size*(struct tep_handle pass:[*]_tep_);
+int *tep_get_header_timestamp_size*(struct tep_handle pass:[*]_tep_);
+bool *tep_is_old_format*(struct tep_handle pass:[*]_tep_);
+--
+DESCRIPTION
+-----------
+These functions retrieve information from kernel context, stored in tracefs
+events/header_page. Old kernels do not have header page info, so default values
+from user space context are used.
+
+The _tep_get_header_page_size()_ function returns the size of a long integer,
+in kernel context. The _tep_ argument is trace event parser context.
+This information is retrieved from tracefs events/header_page, "commit" field.
+
+The _tep_get_header_timestamp_size()_ function returns the size of timestamps,
+in kernel context. The _tep_ argument is trace event parser context. This
+information is retrieved from tracefs events/header_page, "timestamp" field.
+
+The _tep_is_old_format()_ function returns true if the kernel predates
+the addition of events/header_page, otherwise it returns false.
+
+RETURN VALUE
+------------
+The _tep_get_header_page_size()_ function returns the size of a long integer,
+in bytes.
+
+The _tep_get_header_timestamp_size()_ function returns the size of timestamps,
+in bytes.
+
+The _tep_is_old_format()_ function returns true, if an old kernel is used to
+generate the tracing data, which has no event/header_page. If the kernel is new,
+or _tep_ is NULL, false is returned.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+	int longsize;
+	int timesize;
+	bool old;
+
+	longsize = tep_get_header_page_size(tep);
+	timesize = tep_get_header_timestamp_size(tep);
+	old = tep_is_old_format(tep);
+
+	printf ("%s kernel is used to generate the tracing data.\n",
+		old?"Old":"New");
+	printf("The size of a long integer is %d bytes.\n", longsize);
+	printf("The timestamps size is %d bytes.\n", timesize);
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

