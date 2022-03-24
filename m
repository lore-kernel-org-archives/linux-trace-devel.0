Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2614AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Mar 2022 00:09:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238611AbiCXAK3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Mar 2022 20:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346690AbiCXAKD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Mar 2022 20:10:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99C01A38C
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Mar 2022 17:08:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51199B821C2
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Mar 2022 00:08:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F89C340F8;
        Thu, 24 Mar 2022 00:08:07 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nXB1K-0071ST-TT;
        Wed, 23 Mar 2022 20:08:06 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/2] trace-cmd library: Use cpu_data variable to shorten commands
Date:   Wed, 23 Mar 2022 20:08:04 -0400
Message-Id: <20220324000805.1666464-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220324000805.1666464-1-rostedt@goodmis.org>
References: <20220324000805.1666464-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Instead of using handle->cpu_data[cpu] for all the references in
tracecmd_close(), just assign it to a variable cpu_data and use that. It
makes the code much more readable.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 31fde182a55e..358b47935602 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4446,6 +4446,7 @@ void tracecmd_close(struct tracecmd_input *handle)
 {
 	struct zchunk_cache *cache;
 	struct file_section *del_sec;
+	struct cpu_data *cpu_data;
 	int cpu;
 	int i;
 
@@ -4465,30 +4466,31 @@ void tracecmd_close(struct tracecmd_input *handle)
 		free_next(handle, cpu);
 		free_page(handle, cpu);
 		if (handle->cpu_data) {
-			if (handle->cpu_data[cpu].kbuf) {
-				kbuffer_free(handle->cpu_data[cpu].kbuf);
-				if (handle->cpu_data[cpu].page_map)
-					free_page_map(handle->cpu_data[cpu].page_map);
+			cpu_data = &handle->cpu_data[cpu];
+			if (cpu_data->kbuf) {
+				kbuffer_free(cpu_data->kbuf);
+				if (cpu_data->page_map)
+					free_page_map(cpu_data->page_map);
 
-				if (handle->cpu_data[cpu].page_cnt)
+				if (cpu_data->page_cnt)
 					tracecmd_warning("%d pages still allocated on cpu %d%s",
-							 handle->cpu_data[cpu].page_cnt, cpu,
-							 show_records(handle->cpu_data[cpu].pages,
-								      handle->cpu_data[cpu].nr_pages));
-				free(handle->cpu_data[cpu].pages);
+							 cpu_data->page_cnt, cpu,
+							 show_records(cpu_data->pages,
+								      cpu_data->nr_pages));
+				free(cpu_data->pages);
 			}
-			if (handle->cpu_data[cpu].compress.fd >= 0) {
-				close(handle->cpu_data[cpu].compress.fd);
-				unlink(handle->cpu_data[cpu].compress.file);
+			if (cpu_data->compress.fd >= 0) {
+				close(cpu_data->compress.fd);
+				unlink(cpu_data->compress.file);
 			}
-			while (!list_empty(&handle->cpu_data[cpu].compress.cache)) {
-				cache = container_of(handle->cpu_data[cpu].compress.cache.next,
+			while (!list_empty(&cpu_data->compress.cache)) {
+				cache = container_of(cpu_data->compress.cache.next,
 						     struct zchunk_cache, list);
 				list_del(&cache->list);
 				free(cache->map);
 				free(cache);
 			}
-			free(handle->cpu_data[cpu].compress.chunks);
+			free(cpu_data->compress.chunks);
 		}
 	}
 
-- 
2.35.1

