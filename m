Return-Path: <SRS0=lDd+=TR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 534F3C04AB4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 May 2019 19:38:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2474121744
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 May 2019 19:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558121898;
	bh=7EU1QC26H5QDnA4OIcciCq2xOcCl97RvrvQ/K2KJyZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=SyH9q3Mlp75FmiBBvjR5p34OZSlmgLjEpJ0gE7VhFC7o+hdU/mJh0JG0kTmTdmgz7
	 HK0vY0VYj7CUQxhYdqBa6tLjeZfX0uwlNY3qmz1mocro4aoRsomBc8ig2w8hGrtgJV
	 BYExpbXqJEjIEqT31QfQ2F+p/L+MWALcNvHG/ORE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729430AbfEQTiO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 May 2019 15:38:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727771AbfEQTiN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 May 2019 15:38:13 -0400
Received: from quaco.ghostprotocols.net (unknown [190.15.121.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EA8D2173C;
        Fri, 17 May 2019 19:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558121892;
        bh=7EU1QC26H5QDnA4OIcciCq2xOcCl97RvrvQ/K2KJyZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HgMVZipsxE8Vf5j3sq18Sp0b20gFEEVHEWqexrb2aI5iZjonD1Am9EkUDC/0a2YWp
         QHsR70ArbCt/5n8fTh72I47i54/ngDTVxkKMr000fIxRw/QyADG1r+OIkuzUUCfTg0
         KGmo76cgOzDKupRTdYGDR+mxLzAApPKlRCTGzd6w=
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
Subject: [PATCH 25/73] tools lib traceevent: Man page for get/set cpus APIs
Date:   Fri, 17 May 2019 16:35:23 -0300
Message-Id: <20190517193611.4974-26-acme@kernel.org>
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

 tep_get_cpus(),
 tep_set_cpus()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lore.kernel.org/linux-trace-devel/20190503091119.23399-6-tstoyanov@vmware.com
Link: http://lkml.kernel.org/r/20190510200106.742948683@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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

