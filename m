Return-Path: <SRS0=lDd+=TR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1E26C04E87
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 May 2019 19:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C11B82087B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 May 2019 19:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558122124;
	bh=ZoEXBcVdmFsdz/V/Ql5U8fQ3EuR+/gKC/IbjsOaJxj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=yYGS73bBoISuePX3JcVRAx1h6nBWf3aYSI+TyOfri3AinO1MuA42Vn/oyLvVnktbX
	 W+zBzBJv+D4Ef0WkqXggHqY4gL7w3ZJoEDJ2QryjYpqZ8kDUJgf87qYdpQrL6Vp4gH
	 TRzZwvacx6QGOuFI2zLgN4xEzFNdGmtPV0JLHac4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729688AbfEQTi1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 May 2019 15:38:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729686AbfEQTi0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 May 2019 15:38:26 -0400
Received: from quaco.ghostprotocols.net (unknown [190.15.121.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D791A21744;
        Fri, 17 May 2019 19:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558121905;
        bh=ZoEXBcVdmFsdz/V/Ql5U8fQ3EuR+/gKC/IbjsOaJxj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PktAaB1UhlxLhF7pbYXEURsJ0QfhCZED2/gUCusEXaJWhzTQBIrcEC6K/bfPZLTBQ
         bopOYz4dicCYktkXv0gA1B1HDxWKvDZcrmgarb5zLxff6ABgbfbII3LzU6eGGX4Cv6
         kZU2fmtHYXgNG7DOl26tWt9OMZnIJi0WTYzXzAlo=
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
Subject: [PATCH 28/73] tools lib traceevent: Man page for page size APIs
Date:   Fri, 17 May 2019 16:35:26 -0300
Message-Id: <20190517193611.4974-29-acme@kernel.org>
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

  tep_get_page_size()
  tep_set_page_size()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lore.kernel.org/linux-trace-devel/20190503091119.23399-9-tstoyanov@vmware.com
Link: http://lkml.kernel.org/r/20190510200107.218173559@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../Documentation/libtraceevent-page_size.txt | 82 +++++++++++++++++++
 1 file changed, 82 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-page_size.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-page_size.txt b/tools/lib/traceevent/Documentation/libtraceevent-page_size.txt
new file mode 100644
index 000000000000..452c0cfa1822
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-page_size.txt
@@ -0,0 +1,82 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_get_page_size, tep_set_page_size - Get / set the size of a memory page on
+the machine, where the trace is generated
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_get_page_size*(struct tep_handle pass:[*]_tep_);
+void *tep_set_page_size*(struct tep_handle pass:[*]_tep_, int _page_size_);
+--
+
+DESCRIPTION
+-----------
+The _tep_get_page_size()_ function returns the size of a memory page on
+the machine, where the trace is generated. The _tep_ argument is trace
+event parser context.
+
+The _tep_set_page_size()_ function stores in the _tep_ context the size of a
+memory page on the machine, where the trace is generated.
+The _tep_ argument is trace event parser context.
+The _page_size_ argument is the size of a memory page, in bytes.
+
+RETURN VALUE
+------------
+The _tep_get_page_size()_ function returns size of the memory page, in bytes.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <unistd.h>
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+	int page_size = getpagesize();
+
+	tep_set_page_size(tep, page_size);
+
+	printf("The page size for this machine is %d\n", tep_get_page_size(tep));
+
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

