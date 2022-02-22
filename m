Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 711E6C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Feb 2022 18:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234535AbiBVSSp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 13:18:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234442AbiBVSSo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 13:18:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F0291359
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 10:18:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E28A614F9
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 18:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB7AC340E8
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 18:18:17 +0000 (UTC)
Date:   Tue, 22 Feb 2022 13:18:16 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Add script to find functions not listed in main
 man page
Message-ID: <20220222131816.0bfdb33e@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

This checks all the man pages for any function that is not in the main man
page of libtracefs.txt.

The current run when this script was created produced:

$ ./check-manpages.sh Documentation/

Missing functions from libtracefs.txt that are in libtracefs-dynevents.txt
   tracefs_dynevent_get
   tracefs_dynevent_get_event

Missing functions from libtracefs.txt that are in libtracefs-events-tep.txt
   tracefs_load_cmdlines

Missing functions from libtracefs.txt that are in libtracefs-events.txt
   tracefs_event_enable
   tracefs_event_disable

Missing functions from libtracefs.txt that are in libtracefs-instances-affinity.txt
   tracefs_set_affinity_raw
   tracefs_get_affinity_raw

Missing functions from libtracefs.txt that are in libtracefs-instances-file-manip.txt
   tracefs_instance_file_append
   tracefs_instance_file_clear

Missing functions from libtracefs.txt that are in libtracefs-instances-manage.txt
   tracefs_instance_alloc

Missing functions from libtracefs.txt that are in libtracefs-instances-utils.txt
   tracefs_instance_get_trace_dir

Missing functions from libtracefs.txt that are in libtracefs-options.txt
   tracefs_options

Missing functions from libtracefs.txt that are in libtracefs-stream.txt
   tracefs_trace_pipe_stream
   tracefs_trace_pipe_print
   tracefs_trace_pipe_stop

Missing functions from libtracefs.txt that are in libtracefs-synth-info.txt
   tracefs_synth_get_event

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 check-manpages.sh | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)
 create mode 100755 check-manpages.sh

diff --git a/check-manpages.sh b/check-manpages.sh
new file mode 100755
index 000000000000..a52281198f6e
--- /dev/null
+++ b/check-manpages.sh
@@ -0,0 +1,32 @@
+#!/bin/bash
+# SPDX-License-Identifier: LGPL-2.1
+# Copyright (C) 2022, Google Inc, Steven Rostedt <rostedt@goodmis.org>
+#
+# This checks if any function is listed in a man page that is not listed
+# in the main man page.
+
+if [ $# -lt 1 ]; then
+	echo "usage: check-manpages man-page-path"
+	exit 1
+fi
+
+cd $1
+
+MAIN=libtracefs
+MAIN_FILE=${MAIN}.txt
+
+for man in ${MAIN}-*.txt; do
+
+	sed -ne '/^NAME/,/^SYNOP/{/^[a-z]/{s/, *$//;s/,/\n/g;s/ //g;s/-.*$/-/;/-/{s/-//p;q};p}}' $man | while read a; do
+		if ! grep -q '\*'${a}'\*' $MAIN_FILE; then
+			if [ "$last" == "" ]; then
+				echo
+			fi
+			if [ "$last" != "$man" ]; then
+				echo "Missing functions from $MAIN_FILE that are in $man"
+				last=$man
+			fi
+			echo "   ${a}"
+		fi
+	done
+done
-- 
2.34.1

