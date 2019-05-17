Return-Path: <SRS0=lDd+=TR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58961C04AB4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 May 2019 19:38:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28A6021744
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 May 2019 19:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558121938;
	bh=S66R7P0cvTF/7gOwPvHAiRLKWeSwRQiD/cJ+RFsXyKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=TkHT4OU/1+vO55o5PIGZ5peTN5vu38PhngA2xb+FuHaTDsfZlBTP943FR80AZdz/Y
	 iDfwoRafEvEP48RW5LkfR0orH0XUiTLbo5VYMoLeIGbBK9qfiZ6vk2iZXp9DjwaJqc
	 UimCiXxinb0Hwmf9yhD1Hl6z6/1S9nDC5d5vc9Qg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729761AbfEQTiw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 May 2019 15:38:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729437AbfEQTiw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 May 2019 15:38:52 -0400
Received: from quaco.ghostprotocols.net (unknown [190.15.121.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F190D2087B;
        Fri, 17 May 2019 19:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558121931;
        bh=S66R7P0cvTF/7gOwPvHAiRLKWeSwRQiD/cJ+RFsXyKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BAT8asWNzOL/xyi5kbZrD3xByHXbjFy5t0nL2FtSs8W8hD277unlZ0iRkNPTZ1p6z
         NA9LbuXHA0rU5yaXtcfVPAP8iS+kXkbB++fnBQ919F0MUbgSPRDD3P9NrP+pSlEcVD
         uKuooEE/15yyVI2CZisNSgVfmZ7c9EZ76C7E5h2Y=
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
Subject: [PATCH 34/73] tools lib traceevent: Man pages for event find APIs
Date:   Fri, 17 May 2019 16:35:32 -0300
Message-Id: <20190517193611.4974-35-acme@kernel.org>
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

  tep_find_event()
  tep_find_event_by_name()
  tep_find_event_by_record()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lore.kernel.org/linux-trace-devel/20190503091119.23399-15-tstoyanov@vmware.com
Link: http://lkml.kernel.org/r/20190510200108.197407057@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../libtraceevent-event_find.txt              | 103 ++++++++++++++++++
 1 file changed, 103 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_find.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-event_find.txt b/tools/lib/traceevent/Documentation/libtraceevent-event_find.txt
new file mode 100644
index 000000000000..7bc062c9f76f
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-event_find.txt
@@ -0,0 +1,103 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_find_event,tep_find_event_by_name,tep_find_event_by_record -
+Find events by given key.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+struct tep_event pass:[*]*tep_find_event*(struct tep_handle pass:[*]_tep_, int _id_);
+struct tep_event pass:[*]*tep_find_event_by_name*(struct tep_handle pass:[*]_tep_, const char pass:[*]_sys_, const char pass:[*]_name_);
+struct tep_event pass:[*]*tep_find_event_by_record*(struct tep_handle pass:[*]_tep_, struct tep_record pass:[*]_record_);
+--
+
+DESCRIPTION
+-----------
+This set of functions can be used to search for an event, based on a given
+criteria. All functions require a pointer to a _tep_, trace event parser
+context.
+
+The _tep_find_event()_ function searches for an event by given event _id_. The
+event ID is assigned dynamically and can be viewed in event's format file,
+"ID" field.
+
+The tep_find_event_by_name()_ function searches for an event by given
+event _name_, under the system _sys_. If the _sys_ is NULL (not specified),
+the first event with _name_ is returned.
+
+The tep_find_event_by_record()_ function searches for an event from a given
+_record_.
+
+RETURN VALUE
+------------
+All these functions return a pointer to the found event, or NULL if there is no
+such event.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+struct tep_event *event;
+
+event = tep_find_event(tep, 1857);
+if (event == NULL) {
+	/* There is no event with ID 1857 */
+}
+
+event = tep_find_event_by_name(tep, "kvm", "kvm_exit");
+if (event == NULL) {
+	/* There is no kvm_exit event, from kvm system */
+}
+
+void event_from_record(struct tep_record *record)
+{
+ struct tep_event *event = tep_find_event_by_record(tep, record);
+	if (event == NULL) {
+		/* There is no event from given record */
+	}
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

