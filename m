Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E1F9C43219
	for <linux-trace-devel@archiver.kernel.org>; Sat, 12 Mar 2022 23:40:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbiCLXlp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 12 Mar 2022 18:41:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232957AbiCLXlo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 12 Mar 2022 18:41:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C95E26C946
        for <linux-trace-devel@vger.kernel.org>; Sat, 12 Mar 2022 15:40:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83C31B80B06
        for <linux-trace-devel@vger.kernel.org>; Sat, 12 Mar 2022 23:40:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC08C340EB;
        Sat, 12 Mar 2022 23:40:35 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nTBLe-000X7E-1n;
        Sat, 12 Mar 2022 18:40:34 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/2] trace-cmd library: Make cpu_data[] match the cpus
Date:   Sat, 12 Mar 2022 18:40:31 -0500
Message-Id: <20220312234032.127108-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220312234032.127108-1-rostedt@goodmis.org>
References: <20220312234032.127108-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

There's logic that expects cpu_data[cpu] to match the cpu buffer for the
given cpu. But now that the cpu_data array only holds the CPUs that exist
in the trace.dat file, it breaks this logic. Create the array for all cpus
regardless if a cpu exists or not. Just have the data structure be zero.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 46 ++++++++++++++++++++++++++++++-------
 1 file changed, 38 insertions(+), 8 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 6e59a12f7807..da922834de1f 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3196,7 +3196,9 @@ static int handle_buffer_option(struct tracecmd_input *handle,
 				unsigned short id, char *data, int size)
 {
 	struct input_buffer_instance *buff;
+	struct cpu_file_data *cpu_data;
 	unsigned long long tmp;
+	long long max_cpu = -1;
 	int rsize = 0;
 	char *name;
 	int i;
@@ -3247,24 +3249,52 @@ static int handle_buffer_option(struct tracecmd_input *handle,
 		buff->cpus = tmp;
 		if (!buff->cpus)
 			return 0;
-		buff->cpu_data = calloc(buff->cpus, sizeof(struct cpu_file_data));
-		if (!buff->cpu_data)
+		cpu_data = calloc(buff->cpus, sizeof(*cpu_data));
+		if (!cpu_data)
 			return -1;
 		for (i = 0; i < buff->cpus; i++) {
 			if (save_read_number(handle->pevent, data, &size, &rsize, 4, &tmp))
-				return -1;
-			buff->cpu_data[i].cpu = tmp;
+				goto fail;
+			if ((long long)tmp > max_cpu)
+				max_cpu = tmp;
+			cpu_data[i].cpu = tmp;
 			if (save_read_number(handle->pevent, data,
-					     &size, &rsize, 8, &buff->cpu_data[i].offset))
-				return -1;
+					     &size, &rsize, 8, &cpu_data[i].offset))
+				goto fail;
 			if (save_read_number(handle->pevent, data,
-					     &size, &rsize, 8, &buff->cpu_data[i].size))
-				return -1;
+					     &size, &rsize, 8, &cpu_data[i].size))
+				goto fail;
+		}
+		if (buff->cpus == max_cpu + 1) {
+			/* Check to make sure cpus match the index */
+			for (i = 0; i < buff->cpus; i++) {
+				if (cpu_data[i].cpu != i)
+					goto copy_buffer;
+			}
+			buff->cpu_data = cpu_data;
+		} else {
+ copy_buffer:
+			buff->cpu_data = calloc(max_cpu + 1, sizeof(*cpu_data));
+			if (!buff->cpu_data)
+				goto fail;
+			for (i = 0; i < buff->cpus; i++) {
+				if (buff->cpu_data[cpu_data[i].cpu].size) {
+					tracecmd_warning("More than one buffer defined for CPU %d (buffer %d)\n",
+							 cpu_data[i].cpu, i);
+					goto fail;
+				}
+				buff->cpu_data[cpu_data[i].cpu] = cpu_data[i];
+			}
+			buff->cpus = max_cpu + 1;
+			free(cpu_data);
 		}
 	} else {
 		buff->latency = true;
 	}
 	return 0;
+fail:
+	free(cpu_data);
+	return -1;
 }
 
 static int handle_options(struct tracecmd_input *handle)
-- 
2.35.1

