Return-Path: <SRS0=lDd+=TR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7A91C04AB4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 May 2019 19:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 941BB216FD
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 May 2019 19:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558122124;
	bh=9n38qUIdozudC6yheFv2zMGuMxdA6cPiLPZg/nVW5Bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=VoITfNDN7ta/T7rvI67araUTkN1NS0vLUvTkBwNtruL0fEcIiSvbnrdiNyUBU40ib
	 swsYmdYE3fkypJLy2DHjj4r+m+gXzSTUUmfzZymN/GCTsvYl+tqngQ5tuuiPge5Wgj
	 blYYBPbye8FKzf3fw9fmMcw9iPsAYRD1SsQmQnQQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729702AbfEQTib (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 May 2019 15:38:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729686AbfEQTia (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 May 2019 15:38:30 -0400
Received: from quaco.ghostprotocols.net (unknown [190.15.121.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2005D21783;
        Fri, 17 May 2019 19:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558121909;
        bh=9n38qUIdozudC6yheFv2zMGuMxdA6cPiLPZg/nVW5Bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q1+aGJS8GJ40hFjdutzVTPfikxmXVDdiGpOXrSLeVU4mlU6puwoU8NDSA22gzthQS
         Evq59L/Fgg2f5SFTMJOsFoSkwZEIHSPS8j3tDFPhfa7bnGx+hiXLZzXPspviBExqxB
         pD7EGQ1qBJclOXC+xoy1XoHka/VQy6hPWDWSZ2f8=
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
Subject: [PATCH 29/73] tools lib traceevent: Man page for tep_strerror()
Date:   Fri, 17 May 2019 16:35:27 -0300
Message-Id: <20190517193611.4974-30-acme@kernel.org>
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

Create man page for tep_strerror() libtraceevent API.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lore.kernel.org/linux-trace-devel/20190503091119.23399-10-tstoyanov@vmware.com
Link: http://lkml.kernel.org/r/20190510200107.371692630@goodmis.org
[ Added "always" to state it doesn't matter if it is POSIX or GNU ]
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../Documentation/libtraceevent-strerror.txt  | 85 +++++++++++++++++++
 1 file changed, 85 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-strerror.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-strerror.txt b/tools/lib/traceevent/Documentation/libtraceevent-strerror.txt
new file mode 100644
index 000000000000..ee4062a00c9f
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-strerror.txt
@@ -0,0 +1,85 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_strerror - Returns a string describing regular errno and tep error number.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_strerror*(struct tep_handle pass:[*]_tep_, enum tep_errno _errnum_, char pass:[*]_buf_, size_t _buflen_);
+
+--
+DESCRIPTION
+-----------
+The _tep_strerror()_ function converts tep error number into a human
+readable string.
+The _tep_ argument is trace event parser context. The _errnum_ is a regular
+errno, defined in errno.h, or a tep error number. The string, describing this
+error number is copied in the _buf_ argument. The _buflen_ argument is
+the size of the _buf_.
+
+It as a thread safe wrapper around strerror_r(). The library function has two
+different behaviors - POSIX and GNU specific. The _tep_strerror()_ API always
+behaves as the POSIX version - the error string is copied in the user supplied
+buffer.
+
+RETURN VALUE
+------------
+The _tep_strerror()_ function returns 0, if a valid _errnum_ is passed and the
+string is copied into _buf_. If _errnum_ is not a valid error number,
+-1 is returned and _buf_ is not modified.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+char buf[32];
+char *pool = calloc(1, 128);
+if (tep == NULL) {
+	tep_strerror(tep, TEP_ERRNO__MEM_ALLOC_FAILED, buf, 32);
+	printf ("The pool is not initialized, %s", buf);
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

