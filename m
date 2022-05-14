Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55D55C433FE
	for <linux-trace-devel@archiver.kernel.org>; Sat, 14 May 2022 02:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbiENCzj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 May 2022 22:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbiENCzV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 May 2022 22:55:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5A234A966
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 May 2022 19:48:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EAF9B8325F
        for <linux-trace-devel@vger.kernel.org>; Sat, 14 May 2022 02:48:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6E9C341C0;
        Sat, 14 May 2022 02:47:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nphoz-005XMq-IX;
        Fri, 13 May 2022 22:47:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 14/26] trace-cmd record: Pass cpu_count instead of an instance to stop_mapping_vcpus()
Date:   Fri, 13 May 2022 22:47:44 -0400
Message-Id: <20220514024756.1319681-15-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220514024756.1319681-1-rostedt@goodmis.org>
References: <20220514024756.1319681-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The stop_mapping_vcpus() takes an instance as a parameter just to get to
the cpu_count. There's no reason to not just pass the cpu_count instead.
This will also simplify the code when adding an agent proxy that will use
this code as well.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 8b6b27595c96..f05ad09c9723 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3920,8 +3920,7 @@ static int map_vcpus(struct tep_event *event, struct tep_record *record,
 	return i == tmap->max_cpus;
 }
 
-static void stop_mapping_vcpus(struct buffer_instance *instance,
-			       struct trace_guest *guest)
+static void stop_mapping_vcpus(int cpu_count, struct trace_guest *guest)
 {
 	struct trace_mapping tmap = { };
 	struct tep_handle *tep;
@@ -3932,7 +3931,7 @@ static void stop_mapping_vcpus(struct buffer_instance *instance,
 		return;
 
 	tmap.pids = guest->task_pids;
-	tmap.max_cpus = instance->cpu_count;
+	tmap.max_cpus = cpu_count;
 
 	tmap.map = malloc(sizeof(*tmap.map) * tmap.max_cpus);
 	if (!tmap.map)
@@ -4010,7 +4009,7 @@ static int host_tsync(struct common_record_context *ctx,
 						    instance->cpu_count,
 						    proto, ctx->clock);
 	if (!is_network(instance))
-		stop_mapping_vcpus(instance, guest);
+		stop_mapping_vcpus(instance->cpu_count, guest);
 
 	if (!instance->tsync)
 		return -1;
-- 
2.35.1

