Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77619C5519F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 14:24:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21BFA22248
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 14:24:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NrFfgR6Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbgKLOYV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Nov 2020 09:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728032AbgKLOYV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 09:24:21 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0552FC0613D1
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 06:24:21 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id j7so6205592wrp.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 06:24:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Abs1Q4oLMte7gYT/AzauP/BoKt49DCtdWJqWH25Dm2g=;
        b=NrFfgR6Z7FhM/wKK49lalcy+D50z88jWwLBvDOkJG9M5l6KpaQN0spdjOp8PhJCKl7
         K0O8iUxtCKr/1LKUJykOwohAr0VsOYSHOAv9q6P85ZfPWzrZZ9KGXBiJEb7R+GG5zGyo
         JUz3nrEq0pY6qNASDogfPX7oO6cF2Go3jPrBVo9aClIZTTXsyMmiXDmxNGShAB0IBZ2h
         NKb047PilyVHn6MKyNI7zqMY7zNZrzlZp+luORs1B0bryUSn6K5OQPQDHoRZigOwx37j
         7W4oqzfMjA0aiJk0E3CUYaUns49gWCa+0kjUiDswwkMMmx+68L89GBRSyVWD07kiFULe
         OkoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Abs1Q4oLMte7gYT/AzauP/BoKt49DCtdWJqWH25Dm2g=;
        b=dcezE2ER0IfDEypiIIFudfi3NJpSlk8cptEp0farHFZ7I+koXba8UXBup5fCbbv0/Y
         27Zu+45L0s1Ycv69wivbLoX8VY4yFiI3zlLkng0CXOxcItGlMgcHGPY0gCg/YZFHKk0V
         05rrcdhLEwtA1fHJefM9Z8f1Q1LnvX3sGwx8e9XqQcolZYed2CgWvAAMoBJUAp5xKu0y
         0E46D7Ox1sha/fLPzxBnvXrfduzokvk6uFr+21HEbv0oGq/xXDKAM9X6hOlyUlQvxAGY
         q1PThU/LppHKAody+tbRm6McX5mg9bn5jXUNEK+zsUk/i/S9HAKatQmShjch96uBbVYs
         hdrw==
X-Gm-Message-State: AOAM532mklECT+kLKClT698cIbYNxQyYlCQHBhOhkf4XtJ2pQg3yxhAB
        W/jHcEDmouKXcj+WaQq5yJApP6lrkco=
X-Google-Smtp-Source: ABdhPJxobnMZZ+7y9alYzk/+fWHl+NVRt/B0s5A5GlZsCZ+ik64g5WfRe6IYrbeVY48vHvf3W6bkZA==
X-Received: by 2002:a5d:4c8c:: with SMTP id z12mr8882580wrs.248.1605191059807;
        Thu, 12 Nov 2020 06:24:19 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.214])
        by smtp.gmail.com with ESMTPSA id h15sm6950685wrw.15.2020.11.12.06.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 06:24:19 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 05/20] kernel-shark: Rename static methods in libkshark
Date:   Thu, 12 Nov 2020 16:23:43 +0200
Message-Id: <20201112142358.36821-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201112142358.36821-1-y.karadz@gmail.com>
References: <20201112142358.36821-1-y.karadz@gmail.com>
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
index 52aacd30..f3323ae3 100644
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

