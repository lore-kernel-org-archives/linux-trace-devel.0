Return-Path: <SRS0=lDd+=TR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BE2EC04AB4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 May 2019 19:39:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7169B21743
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 May 2019 19:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558121960;
	bh=C/dleWZOcYYMVhcc+Bs5hIwQWI7EK9BeCCvBo9sdBI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=zO4uQ+hJckQWRdYz0OTZCqkA8rfN9agNKxFh52+oOJkABwmR91Vxli694f5GoiJGG
	 Nh84RvFr7yHXW9Ngebb9CT+EsYafhf2U/HEjt6uy9LEApJUSFBlTCPUjiB+ZT9SeDB
	 5MkMNApZg0Fy4nZmfosUqJ5OdKWEtYgXkIMuev0o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729803AbfEQTjT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 May 2019 15:39:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:55500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729809AbfEQTjS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 May 2019 15:39:18 -0400
Received: from quaco.ghostprotocols.net (unknown [190.15.121.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1676821734;
        Fri, 17 May 2019 19:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558121956;
        bh=C/dleWZOcYYMVhcc+Bs5hIwQWI7EK9BeCCvBo9sdBI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k3qmJE2moHy5iiWiqysr0b8NHPR7U+kPhoeF0x+FHhCe752S37ick8t2QSkg9r9tk
         sd2K9nIbwblJXkttHjYdzXSc5pkx6cCd3rDz8k0JXOKib7XluVGflgqvkUIyXHdbWf
         7cEMea8r88TQtoB3mRHnxfb0W++6hkmritwAb+yI=
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
Subject: [PATCH 40/73] tools lib traceevent: Man page for tep_read_number_field()
Date:   Fri, 17 May 2019 16:35:38 -0300
Message-Id: <20190517193611.4974-41-acme@kernel.org>
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

Create man page for libtraceevent API tep_read_number_field().

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lore.kernel.org/linux-trace-devel/20190503091119.23399-21-tstoyanov@vmware.com
Link: http://lkml.kernel.org/r/20190510200109.219394901@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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

