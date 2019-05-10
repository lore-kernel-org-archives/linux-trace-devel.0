Return-Path: <SRS0=90v9=TK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76352C04AB5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 May 2019 20:02:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5176F217F9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 May 2019 20:02:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbfEJUCH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 May 2019 16:02:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727952AbfEJUBK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 May 2019 16:01:10 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 378CC21852;
        Fri, 10 May 2019 20:01:10 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1hPBhd-0006nl-B0; Fri, 10 May 2019 16:01:09 -0400
Message-Id: <20190510200109.219394901@goodmis.org>
User-Agent: quilt/0.65
Date:   Fri, 10 May 2019 15:56:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>
Subject: [PATCH 21/27] tools/lib/traceevent: Man page for tep_read_number_field()
References: <20190510195606.537643615@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

Create man page for libtraceevent API tep_read_number_field().

Link: http://lore.kernel.org/linux-trace-devel/20190503091119.23399-21-tstoyanov@vmware.com

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .../libtraceevent-field_read.txt              | 81 +++++++++++++++++++
 1 file changed, 81 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_read.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-field_read.txt b/tools/lib/traceevent/Documentation/libtraceevent-field_read.txt
new file mode 100644
index 000000000000..64e9e25d3fd9
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-field_read.txt
@@ -0,0 +1,81 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_read_number_field - Reads a number from raw data.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_read_number_field*(struct tep_format_field pass:[*]_field_, const void pass:[*]_data_, unsigned long long pass:[*]_value_);
+--
+
+DESCRIPTION
+-----------
+The _tep_read_number_field()_ function reads the value of the _field_ from the
+raw _data_ and stores it in the _value_. The function sets the _value_ according
+to the endianness of the raw data and the current machine and stores it in
+_value_.
+
+RETURN VALUE
+------------
+The _tep_read_number_field()_ function retunrs 0 in case of success, or -1 in
+case of an error.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+struct tep_event *event = tep_find_event_by_name(tep, "timer", "hrtimer_start");
+...
+void process_record(struct tep_record *record)
+{
+	unsigned long long pid;
+	struct tep_format_field *field_pid = tep_find_common_field(event, "common_pid");
+
+	if (tep_read_number_field(field_pid, record->data, &pid) != 0) {
+		/* Failed to get "common_pid" value */
+	}
+}
+...
+--
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


