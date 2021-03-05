Return-Path: <SRS0=uRrw=ID=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FDFEC433DB
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Mar 2021 22:48:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F22466509E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Mar 2021 22:48:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhCEWsM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Mar 2021 17:48:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:46702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229493AbhCEWrv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Mar 2021 17:47:51 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CA8C6508B
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Mar 2021 22:47:51 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lIJEc-001zyK-F0
        for linux-trace-devel@vger.kernel.org; Fri, 05 Mar 2021 17:47:50 -0500
Message-ID: <20210305224750.351786306@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 05 Mar 2021 17:47:21 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] trace-cmd report: Add last_timestamp array for instances
References: <20210305224719.784797597@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The logic to add a last_timestamp array to the reading of trace data for
multiple files failed to include the array for instances within a given
file. This caused the instance handles not to have a way to save the last
timestamp, and caused the output to quit due to reading a record on a CPU
past the last CPU in the last_timestamp array.

Fixes: db36a61d2 ("trace-cmd: Fix last_timestamp logic to handle multiple files")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-read.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index ce07b6bdb143..56fc0626d486 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1205,6 +1205,12 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 	list_for_each_entry(handles, handle_list, list) {
 		int cpus;
 
+		cpus = tracecmd_cpus(handles->handle);
+		handles->cpus = cpus;
+		handles->last_timestamp = calloc(cpus, sizeof(*handles->last_timestamp));
+		if (!handles->last_timestamp)
+			die("allocating timestamps");
+
 		/* Don't process instances that we added here */
 		if (tracecmd_is_buffer_instance(handles->handle))
 			continue;
@@ -1213,15 +1219,9 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 		if (ret < 0)
 			die("failed to init data");
 
-		cpus = tracecmd_cpus(handles->handle);
-		handles->cpus = cpus;
 		print_handle_file(handles);
 		printf("cpus=%d\n", cpus);
 
-		handles->last_timestamp = calloc(cpus, sizeof(*handles->last_timestamp));
-		if (!handles->last_timestamp)
-			die("allocating timestamps");
-
 		/* Latency trace is just all ASCII */
 		if (ret > 0) {
 			if (multi_inputs)
-- 
2.30.0


