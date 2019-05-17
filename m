Return-Path: <SRS0=lDd+=TR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1BFCC04E87
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 May 2019 19:38:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B384C21744
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 May 2019 19:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558121898;
	bh=cVr3Pz9ro6AUNWN07ga7liLJ8gHYTb+xjZNb1YnqfhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=xcXGes8ZSZZtMTjgYYPoz8mh3TI17RGRh2trDGjqO25LISxyZFK1jLAIy+Oc5TIzS
	 6HBqGJHHhupnBWU+zMzu/vuRiPJEjgXyFgaBz3hPcKbsiYoh5kmdx4EWcJD7l0PFw/
	 aOTcNoIeU0Zt2BVf+DLckbDlm8Esmp+wigxariSo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729665AbfEQTiS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 May 2019 15:38:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727771AbfEQTiS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 May 2019 15:38:18 -0400
Received: from quaco.ghostprotocols.net (unknown [190.15.121.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 865B8216FD;
        Fri, 17 May 2019 19:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558121896;
        bh=cVr3Pz9ro6AUNWN07ga7liLJ8gHYTb+xjZNb1YnqfhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mh6a/0JghaiFfUIZhPy6TbElJTYvw8i2PWslh9mvt9a1kCMoKfjg5F2HXkJht+6bz
         1a2OlmaLu6bsPqggSVCsbhT+KmwPLKjw6CZohDviXmq3HppsBH6eedLyHuCWiELmyX
         hyvQi2GykXbhmY6N2wrkuuQ1+eNJccqFsnYu8cYA=
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
Subject: [PATCH 26/73] tools lib traceevent: Man page for file endian APIs
Date:   Fri, 17 May 2019 16:35:24 -0300
Message-Id: <20190517193611.4974-27-acme@kernel.org>
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

  tep_is_file_bigendian(),
  tep_set_file_bigendian()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lore.kernel.org/linux-trace-devel/20190503091119.23399-7-tstoyanov@vmware.com
Link: http://lkml.kernel.org/r/20190510200106.895177252@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../libtraceevent-file_endian.txt             | 91 +++++++++++++++++++
 1 file changed, 91 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-file_endian.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-file_endian.txt b/tools/lib/traceevent/Documentation/libtraceevent-file_endian.txt
new file mode 100644
index 000000000000..f401ad311047
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-file_endian.txt
@@ -0,0 +1,91 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_is_file_bigendian, tep_set_file_bigendian - Get / set the endianness of the
+raw data being accessed by the tep handler.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+enum *tep_endian* {
+	TEP_LITTLE_ENDIAN = 0,
+	TEP_BIG_ENDIAN
+};
+
+bool *tep_is_file_bigendian*(struct tep_handle pass:[*]_tep_);
+void *tep_set_file_bigendian*(struct tep_handle pass:[*]_tep_, enum tep_endian _endian_);
+
+--
+DESCRIPTION
+-----------
+The _tep_is_file_bigendian()_ function gets the endianness of the raw data,
+being accessed by the tep handler. The _tep_ argument is trace event parser
+context.
+
+The _tep_set_file_bigendian()_ function sets the endianness of raw data being
+accessed by the tep handler. The _tep_ argument is trace event parser context.
+[verse]
+--
+The _endian_ argument is the endianness:
+	_TEP_LITTLE_ENDIAN_ - the raw data is in little endian format,
+	_TEP_BIG_ENDIAN_ - the raw data is in big endian format.
+--
+RETURN VALUE
+------------
+The _tep_is_file_bigendian()_ function returns true if the data is in bigendian
+format, false otherwise.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+	tep_set_file_bigendian(tep, TEP_LITTLE_ENDIAN);
+...
+	if (tep_is_file_bigendian(tep)) {
+		/* The raw data is in big endian */
+	} else {
+		/* The raw data is in little endian */
+	}
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

