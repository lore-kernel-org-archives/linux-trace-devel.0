Return-Path: <SRS0=90v9=TK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA886C04AB2
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 May 2019 20:03:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95F72217F4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 May 2019 20:03:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbfEJUBJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 May 2019 16:01:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727656AbfEJUBI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 May 2019 16:01:08 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BED10217D6;
        Fri, 10 May 2019 20:01:07 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1hPBha-0006gO-RU; Fri, 10 May 2019 16:01:06 -0400
Message-Id: <20190510200106.742948683@goodmis.org>
User-Agent: quilt/0.65
Date:   Fri, 10 May 2019 15:56:12 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>
Subject: [PATCH 06/27] tools/lib/traceevent: Man page for get/set cpus APIs
References: <20190510195606.537643615@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

Create man pages for libtraceevent APIs:
 tep_get_cpus(),
 tep_set_cpus()

Link: http://lore.kernel.org/linux-trace-devel/20190503091119.23399-6-tstoyanov@vmware.com

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .../Documentation/libtraceevent-cpus.txt      | 77 +++++++++++++++++++
 1 file changed, 77 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-cpus.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-cpus.txt b/tools/lib/traceevent/Documentation/libtraceevent-cpus.txt
new file mode 100644
index 000000000000..5ad70e43b752
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-cpus.txt
@@ -0,0 +1,77 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_get_cpus, tep_set_cpus - Get / set the number of CPUs, which have a tracing
+buffer representing it. Note, the buffer may be empty.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_get_cpus*(struct tep_handle pass:[*]_tep_);
+void *tep_set_cpus*(struct tep_handle pass:[*]_tep_, int _cpus_);
+--
+
+DESCRIPTION
+-----------
+The _tep_get_cpus()_ function gets the number of CPUs, which have a tracing
+buffer representing it. The _tep_ argument is trace event parser context.
+
+The _tep_set_cpus()_ function sets the number of CPUs, which have a tracing
+buffer representing it. The _tep_ argument is trace event parser context.
+The _cpu_ argument is the number of CPUs with tracing data.
+
+RETURN VALUE
+------------
+The _tep_get_cpus()_ functions returns the number of CPUs, which have tracing
+data recorded.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+	tep_set_cpus(tep, 5);
+...
+	printf("We have tracing data for %d CPUs", tep_get_cpus(tep));
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


