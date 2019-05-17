Return-Path: <SRS0=lDd+=TR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65EB0C04AB4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 May 2019 19:39:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3775E217D9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 May 2019 19:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558121981;
	bh=AOPLlfTF5bFrJs/B1xmT1jKuM+zLXIf7IqkNNlNJg5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=xTbKi4FWStqE+G2Xxc4ta2i3nBt5BdKLQpTG1EdcRpvrhYz4YS8YwXMxOuMLSydrY
	 73LpKYYmZZD6l/5ntn/gahHykuHwsj88GtkYlMHE+8nIxfP0BfVpenB3qZ6Ad/UHt3
	 iQL+HYy6pM+fm47gaNz+I8UOhG3hMTNGip1idOpk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729848AbfEQTjg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 May 2019 15:39:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729566AbfEQTjg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 May 2019 15:39:36 -0400
Received: from quaco.ghostprotocols.net (unknown [190.15.121.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47C6221744;
        Fri, 17 May 2019 19:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558121975;
        bh=AOPLlfTF5bFrJs/B1xmT1jKuM+zLXIf7IqkNNlNJg5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AQVpjBZqPaO866hvWATS3r4bVLbi46l3P5oX9QplJosTPjcCqkCrAmhnepORvcbMs
         reMyAW8lni/4L3cDkird7kOGtwOfVLISwufdGYIq+iHwBDWT+w2NTQE+V2/EbOJ0G9
         6qljHZ2fFgBnsi4sB1ewUwylDXNdTCpX/xyjKXBA=
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
Subject: [PATCH 44/73] tools lib traceevent: Man page for tep_parse_header_page()
Date:   Fri, 17 May 2019 16:35:42 -0300
Message-Id: <20190517193611.4974-45-acme@kernel.org>
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

Create man page for tep_parse_header_page() libtraceevent API.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lore.kernel.org/linux-trace-devel/20190503091119.23399-25-tstoyanov@vmware.com
Link: http://lkml.kernel.org/r/20190510200110.093108279@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../libtraceevent-parse_head.txt              | 82 +++++++++++++++++++
 1 file changed, 82 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-parse_head.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-parse_head.txt b/tools/lib/traceevent/Documentation/libtraceevent-parse_head.txt
new file mode 100644
index 000000000000..c90f16c7d8e6
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-parse_head.txt
@@ -0,0 +1,82 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_parse_header_page - Parses the data stored in the header page.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_parse_header_page*(struct tep_handle pass:[*]_tep_, char pass:[*]_buf_, unsigned long _size_, int _long_size_);
+--
+
+DESCRIPTION
+-----------
+The _tep_parse_header_page()_ function parses the header page data from _buf_,
+and initializes the _tep_, trace event parser context, with it. The buffer
+_buf_ is with _size_, and is supposed to be copied from
+tracefs/events/header_page.
+
+Some old kernels do not have header page info, in this case the
+_tep_parse_header_page()_ function  can be called with _size_ equal to 0. The
+_tep_ context is initialized with default values. The _long_size_ can be used in
+this use case, to set the size of a long integer to be used.
+
+RETURN VALUE
+------------
+The _tep_parse_header_page()_ function returns 0 in case of success, or -1
+in case of an error.
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
+buf = read_file("/sys/kernel/tracing/events/header_page", &size);
+if (tep_parse_header_page(tep, buf, size, sizeof(unsigned long)) != 0) {
+	/* Failed to parse the header page */
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

