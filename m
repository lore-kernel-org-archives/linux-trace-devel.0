Return-Path: <SRS0=lDd+=TR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09A8CC04AB4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 May 2019 19:38:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF91C21734
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 May 2019 19:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558121932;
	bh=JikuNMDqS+AleAu4QG6At9PQPEqNSpm12Qg6rFgDxlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=diGuPjqyoVT3VQXscyX2vZTDCyr/gdKeuua+1Qwe8QrpddZFs+70ZbrFRy755/iEH
	 v1OPV0CAVoIgncJH9QEqDZFc2tcUUvtsD1pe0WiJ9prg/C0OiILzACLpSUCUZwSXZh
	 mMkRgBPYpF9jaji3jgHsF0DDtGJx+DjrnNJPURvM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727245AbfEQTis (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 May 2019 15:38:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729437AbfEQTis (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 May 2019 15:38:48 -0400
Received: from quaco.ghostprotocols.net (unknown [190.15.121.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 213E821882;
        Fri, 17 May 2019 19:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558121927;
        bh=JikuNMDqS+AleAu4QG6At9PQPEqNSpm12Qg6rFgDxlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dT8mUpXTsopKkfRW2Qdd3hZsCJkrOkkgxmh/WYYeGVAChpl4zEiSRkGTvisHhsCYC
         eJHutUt9r+W3OD5lfnEN8C0HIpQey/8NqIW80na9ct9snAOBsXfabaYX3cDxiiT3Fo
         /kBz2Bv3md/0wuwwrtL9vMwqEkjKtg4QhZkeYiXc=
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
Subject: [PATCH 33/73] tools lib traceevent: Man page for tep_read_number()
Date:   Fri, 17 May 2019 16:35:31 -0300
Message-Id: <20190517193611.4974-34-acme@kernel.org>
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

Create man page for tep_read_number() libtraceevent API.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lore.kernel.org/linux-trace-devel/20190503091119.23399-14-tstoyanov@vmware.com
Link: http://lkml.kernel.org/r/20190510200108.042164597@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../libtraceevent-endian_read.txt             | 78 +++++++++++++++++++
 1 file changed, 78 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-endian_read.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-endian_read.txt b/tools/lib/traceevent/Documentation/libtraceevent-endian_read.txt
new file mode 100644
index 000000000000..e64851b6e189
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-endian_read.txt
@@ -0,0 +1,78 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_read_number - Reads a number from raw data.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+unsigned long long *tep_read_number*(struct tep_handle pass:[*]_tep_, const void pass:[*]_ptr_, int _size_);
+--
+
+DESCRIPTION
+-----------
+The _tep_read_number()_ function reads an integer from raw data, taking into
+account the endianness of the raw data and the current host. The _tep_ argument
+is the trace event parser context. The _ptr_ is a pointer to the raw data, where
+the integer is, and the _size_ is the size of the integer.
+
+RETURN VALUE
+------------
+The _tep_read_number()_ function returns the integer in the byte order of
+the current host. In case of an error, 0 is returned.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+void process_record(struct tep_record *record)
+{
+	int offset = 24;
+	int data = tep_read_number(tep, record->data + offset, 4);
+
+	/* Read the 4 bytes at the offset 24 of data as an integer */
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

