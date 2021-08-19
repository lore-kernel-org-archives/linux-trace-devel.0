Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2310DC19F34
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 04:18:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08E82610E6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 04:18:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbhHSETW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 00:19:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229759AbhHSETT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 00:19:19 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05B91610FE;
        Thu, 19 Aug 2021 04:18:44 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1mGZVr-004e0X-1c; Thu, 19 Aug 2021 00:18:43 -0400
Message-ID: <20210819041842.884828019@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 19 Aug 2021 00:13:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Tzvetomir Stoyanov" <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>
Subject: [PATCH v7 10/10] selftests/ftrace: Add selftest for testing eprobe events
References: <20210819041321.105110033@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add a test to test event probes, by creating a synthetic event across
sys_enter_openat and sys_exit_openat that passes the filename pointer from
the enter of the system call to the exit, and then add an event probe to
the synthetic event to make sure that the file name is seen.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .../test.d/dynevent/add_remove_eprobe.tc      | 53 +++++++++++++++++++
 1 file changed, 53 insertions(+)
 create mode 100644 tools/testing/selftests/ftrace/test.d/dynevent/add_remove_eprobe.tc

diff --git a/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_eprobe.tc b/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_eprobe.tc
new file mode 100644
index 000000000000..7b242f29b916
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_eprobe.tc
@@ -0,0 +1,53 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# description: Generic dynamic event - add/remove eprobe events
+# requires: dynamic_events "e[:[<group>/]<event>] <attached-group>.<attached-event> [<args>]":README
+
+echo 0 > events/enable
+
+clear_dynamic_events
+
+SYSTEM="syscalls"
+START="sys_enter_openat"
+END="sys_exit_openat"
+FIELD="filename"
+SYNTH="synth_open"
+EPROBE="eprobe_open"
+
+echo "$SYNTH u64 filename; s64 ret;" > synthetic_events
+echo "hist:keys=common_pid:__arg__1=$FIELD" > events/$SYSTEM/$START/trigger
+echo "hist:keys=common_pid:filename=\$__arg__1,ret=ret:onmatch($SYSTEM.$START).trace($SYNTH,\$filename,\$ret)" > events/$SYSTEM/$END/trigger
+
+echo "e:$EPROBE synthetic/$SYNTH file=+0(\$filename):ustring ret=\$ret:s64" >> dynamic_events
+
+grep -q "$SYNTH" dynamic_events
+grep -q "$EPROBE" dynamic_events
+test -d events/synthetic/$SYNTH
+test -d events/eprobes/$EPROBE
+
+echo 1 > events/eprobes/$EPROBE/enable
+ls
+echo 0 > events/eprobes/$EPROBE/enable
+
+content=`grep '^ *ls-' trace | grep 'file='`
+nocontent=`grep '^ *ls-' trace | grep 'file=' | grep -v -e '"/' -e '"."'` || true
+
+if [ -z "$content" ]; then
+	exit_fail
+fi
+
+if [ ! -z "$nocontent" ]; then
+	exit_fail
+fi
+
+echo "-:$EPROBE" >> dynamic_events
+echo '!'"hist:keys=common_pid:filename=\$__arg__1,ret=ret:onmatch($SYSTEM.$START).trace($SYNTH,\$filename,\$ret)" > events/$SYSTEM/$END/trigger
+echo '!'"hist:keys=common_pid:__arg__1=$FIELD" > events/$SYSTEM/$START/trigger
+echo '!'"$SYNTH u64 filename; s64 ret;" >> synthetic_events
+
+! grep -q "$SYNTH" dynamic_events
+! grep -q "$EPROBE" dynamic_events
+! test -d events/synthetic/$SYNTH
+! test -d events/eprobes/$EPROBE
+
+clear_trace
-- 
2.30.2
