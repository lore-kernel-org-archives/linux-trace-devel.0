Return-Path: <SRS0=H9Ya=DT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9090C2D0A3
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 14:04:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA33F2074D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 14:04:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FHoplBPl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390937AbgJLOEc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 10:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388608AbgJLNgN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 09:36:13 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A509C0613D0
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 06:36:13 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id i1so13105742wro.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 06:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HlgI//eTg53lPEE454NCseMs22UW33H7XR+I0F9LnBk=;
        b=FHoplBPlL0u5RFLMGfZzidgMerxLkxwfgr8khiEgFLaGFHYaEvGwG1uUFfjvJ2KeeW
         W4UHmM3W5gzWV1gK0sHYgTdpFSqclWCgMEJTpKckXN5os+nwFlhcIUpKmqBLcUSIdwBg
         ZWO/2vhK9wFi86ohBLiEp2ZmhivhBvL1DjmVuAxtGa3PorCHJsRTElcMBGGMN+wLty9I
         aK1fzrV8KcU34533iYlRkO3+iSYWc2Djvlzj3zXkrX2yu+DVul80iTeS2UizI5up1fmx
         moNxH/xfQWm4/cirFFbSu06gmG12ir1D8IVD1gMLl+C7aJK04Q+m7OTJBal8Yx3oqGtM
         06rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HlgI//eTg53lPEE454NCseMs22UW33H7XR+I0F9LnBk=;
        b=JHyEKG5xLUAR3FzdUj/yUTNgpU+VVV5pmFrDlX7W29i+Vha2M/YrGYr3fFikANgROd
         KMwmFukbwoE7jvwlSpwSlrir0ID49cCr0lRQkCIKNmTZtylhI0PaewnC5l+UjHcdErXz
         d+TvnMTtryutpf6+hCtmB95rfRXZNvnjHYZ3NCMM2Y+BEky4W71bMyfdC+GhBRgMl7YC
         CQourEQHEM3L5LUWTWrZPWFbm/Z96vytj1E1GSNi+CRaCddiY7hBiz8+3XqZ5zL0sGqu
         h6WYaQdZNMxz5yU+oHtF3TROk47n3pSQTtHA0p2wm5DiHWbZTRDbDBiopAWWblboH9Hy
         twaQ==
X-Gm-Message-State: AOAM533otPftj5gHqyjuoLeyDLsVt7IhRsOPbcTkv0AjkyOF+3hC9BTi
        n3sXmiZBvatZaO8WsyTimWI=
X-Google-Smtp-Source: ABdhPJzP12CkUEmOKhgMaTmEwoB3k100FFNv+f7e8rxkqmk6jZXsQNrZbhjbjqNbdP3KVwu/Tca2OQ==
X-Received: by 2002:a5d:4f09:: with SMTP id c9mr28817913wru.427.1602509772105;
        Mon, 12 Oct 2020 06:36:12 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.41])
        by smtp.gmail.com with ESMTPSA id k5sm23145388wmb.19.2020.10.12.06.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 06:36:11 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 06/20] kernel-shark: Rename static methods in libkshark
Date:   Mon, 12 Oct 2020 16:35:09 +0300
Message-Id: <20201012133523.469040-7-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012133523.469040-1-y.karadz@gmail.com>
References: <20201012133523.469040-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

"kshark" prefix is needed only for the public methods of the API.
We are changing the names of those static methods because we need to
use those names when integrating the data streams into the API.i

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/src/libkshark.c b/src/libkshark.c
index 92e2450c..6a1258dc 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -1097,8 +1097,8 @@ size_t kshark_load_data_matrix(struct kshark_context *kshark_ctx,
 	return -ENOMEM;
 }
 
-static const char *kshark_get_latency(struct tep_handle *pe,
-				      struct tep_record *record)
+static const char *get_latency(struct tep_handle *pe,
+			       struct tep_record *record)
 {
 	if (!record)
 		return NULL;
@@ -1108,7 +1108,7 @@ static const char *kshark_get_latency(struct tep_handle *pe,
 	return seq.buffer;
 }
 
-static const char *kshark_get_info(struct tep_handle *pe,
+static const char *get_info(struct tep_handle *pe,
 				   struct tep_record *record,
 				   struct tep_event *event)
 {
@@ -1233,7 +1233,7 @@ const char *kshark_get_latency_easy(struct kshark_entry *entry)
 	pthread_mutex_lock(&kshark_ctx->input_mutex);
 
 	data = tracecmd_read_at(kshark_ctx->handle, entry->offset, NULL);
-	lat = kshark_get_latency(kshark_ctx->pevent, data);
+	lat = get_latency(kshark_ctx->pevent, data);
 	free_record(data);
 
 	pthread_mutex_unlock(&kshark_ctx->input_mutex);
@@ -1376,7 +1376,7 @@ const char *kshark_get_info_easy(struct kshark_entry *entry)
 	event_id = tep_data_type(kshark_ctx->pevent, data);
 	event = tep_find_event(kshark_ctx->pevent, event_id);
 	if (event)
-		info = kshark_get_info(kshark_ctx->pevent, data, event);
+		info = get_info(kshark_ctx->pevent, data, event);
 
 	free_record(data);
 
@@ -1471,7 +1471,7 @@ char* kshark_dump_entry(const struct kshark_entry *entry)
 		event = tep_find_event(kshark_ctx->pevent, entry->event_id);
 
 		event_name = event? event->name : "[UNKNOWN EVENT]";
-		lat = kshark_get_latency(kshark_ctx->pevent, data);
+		lat = get_latency(kshark_ctx->pevent, data);
 
 		size = asprintf(&temp_str, "%" PRIu64 "; %s-%i; CPU %i; %s;",
 				entry->ts,
@@ -1480,7 +1480,7 @@ char* kshark_dump_entry(const struct kshark_entry *entry)
 				entry->cpu,
 				lat);
 
-		info = kshark_get_info(kshark_ctx->pevent, data, event);
+		info = get_info(kshark_ctx->pevent, data, event);
 
 		if (size > 0) {
 			size = asprintf(&entry_str, "%s %s; %s; 0x%x",
-- 
2.25.1

