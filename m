Return-Path: <SRS0=uRrw=ID=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B579DC4332D
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Mar 2021 23:00:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9938D650AA
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Mar 2021 23:00:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhCEW7x (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Mar 2021 17:59:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:48080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229899AbhCEW7s (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Mar 2021 17:59:48 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 956766509B
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Mar 2021 22:59:48 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lIJQB-00209V-LZ
        for linux-trace-devel@vger.kernel.org; Fri, 05 Mar 2021 17:59:47 -0500
Message-ID: <20210305225947.541189414@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 05 Mar 2021 17:52:25 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/9 v2] trace-cmd: Move tracecmd_write_cmdlines() out of
 tracecmd_append_cpu_data()
References: <20210305225223.794554327@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When the saved_cmdlines was moved to after the recording, as it makes sense
because they are created during the recording, the saving was just tossed
into tracecmd_append_cpu_data() as that was called at the end of recording.

Unfortunately, the trace-cmd restore (as well as trace-cmd split) used the
tracecmd_append_cpu_data() but expecting it not store the saved_cmdlines.
This broke both of them.

Now that there's an API called tracecmd_write_cmdlines(), have those that
need it call it directly, and remove it out of tracecmd_append_cpu_data().

Note, although this can help the trace-cmd restore code, it appears that the
code for trace-cmd split may still be broken, and needs to be fixed.

Link: https://lore.kernel.org/linux-trace-devel/20210301143857.098048355@goodmis.org

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-output.c | 10 +++-------
 tracecmd/trace-record.c      |  3 +++
 tracecmd/trace-split.c       |  4 ++++
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index a2d4a16e3c3d..b05e0032a92c 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1448,13 +1448,6 @@ int tracecmd_append_cpu_data(struct tracecmd_output *handle,
 {
 	int ret;
 
-	/*
-	 * Save the command lines;
-	 */
-	ret = tracecmd_write_cmdlines(handle);
-	if (ret)
-		return ret;
-
 	ret = tracecmd_write_cpus(handle, cpus);
 	if (ret)
 		return ret;
@@ -1556,6 +1549,9 @@ tracecmd_create_file_glob(const char *output_file,
 	if (!handle)
 		return NULL;
 
+	if (tracecmd_write_cmdlines(handle))
+		return NULL;
+
 	if (tracecmd_append_cpu_data(handle, cpus, cpu_data_files) < 0) {
 		tracecmd_output_close(handle);
 		return NULL;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 4337967e11e5..e7428788b1bb 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4236,6 +4236,9 @@ static void record_data(struct common_record_context *ctx)
 				add_guest_info(handle, instance);
 		}
 
+		if (tracecmd_write_cmdlines(handle))
+			die("Writing cmdlines");
+
 		tracecmd_append_cpu_data(handle, local_cpu_count, temp_files);
 
 		for (i = 0; i < max_cpu_count; i++)
diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index 8366d1286d9e..7c9863d481bc 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -384,6 +384,10 @@ static double parse_file(struct tracecmd_input *handle,
 	for (cpu = 0; cpu < cpus; cpu ++)
 		cpu_list[cpu] = cpu_data[cpu].file;
 
+	/* TODO: Fix me, this is suppose to come from handle */
+	if (tracecmd_write_cmdlines(ohandle))
+		die("Writing cmdlines");
+
 	tracecmd_append_cpu_data(ohandle, cpus, cpu_list);
 
 	current = end;
-- 
2.30.0


