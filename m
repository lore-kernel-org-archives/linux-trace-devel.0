Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC6E7C43381
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADCF420700
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbhADRtD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:49:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbhADRtD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 12:49:03 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC51C0617A5
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Jan 2021 09:47:50 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id x16so37918859ejj.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Jan 2021 09:47:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ULB2jnd1vmjrM+/QI8t6ZBRrmLCk7MNWpicnjlzF32o=;
        b=FrJRIZNK/ksqfvgQjh7I4VeM4DVK4aFh/lO7XO+9UcU38Zjul2vtNsA500CBgtkqqv
         ZBt5Kstsl9kZwiz6JvkELse9slvh9wuNaMK6EhttMc61oJCXVlQQ8i+h3U9C3Vq2mgBp
         NkLbE2XpOLByFsiWnhK9+1OKhliEH+r8vILVmljSZK0U808HWSd7dtZEvSich8Lhtcdn
         Yg88EnS2UrwnWLcFBkLlkCpS5DIvMxxjTjZUXqMwCeO4ZM0M+CAgLJlPxu9DeWzg8RRO
         fSOBpNc72UAH6Jm36si6/h2+PPOWWQQLxNR/TAJp4+p66etBK389JKaoIELcTaM0XdP5
         uqhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ULB2jnd1vmjrM+/QI8t6ZBRrmLCk7MNWpicnjlzF32o=;
        b=KQnZH6PJNp+FRcMIyNeGTAriOIVuoUtRE2zBymLukU9a8vWmkL4ulnwsvWSJ1PRdys
         0ZYV0uXdmZ/hjRaeCa0FgBImFC3uK0zCerCUHIthqiQVDGegjRnBUg9wAA3t7sJzwv9s
         ah/5CFcKCfywuMiYTWHuuh0HnIToerOM1g3BtGjANFeCFNP/EmukYyXcwFkzjkxS8ZAg
         lIIX+N+JA0eExRJskUTRenB1ZfvWXGDw6jVzUlCBpXj8J/4PB5e5XQRboRpSLjucaOTA
         ssMBLHcHLWnGdujoF29wF/DbAjuAzx0aaC8yAr2noGlQOViVP9hFWna7r6asJgZUWwNX
         VHOQ==
X-Gm-Message-State: AOAM533HNJTu9VJZ4lJUlQOgfCsBPYk361omtBnGO0QYF4eL+ErEhrzJ
        Xe5dY21NUUC9S2srH69r2b0=
X-Google-Smtp-Source: ABdhPJynOrAhwH0m4qxsMx5I7OHFBAdD/Nt9992QLE7lrrcqbhxaMZhgApZ5hn0veVz9eo9To8gu0w==
X-Received: by 2002:a17:906:9588:: with SMTP id r8mr66199013ejx.148.1609782469078;
        Mon, 04 Jan 2021 09:47:49 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id l14sm44107750edq.35.2021.01.04.09.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 09:47:48 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v8 13/44] kernel-shark: Rename static methods in libkshark
Date:   Mon,  4 Jan 2021 19:46:53 +0200
Message-Id: <20210104174724.70404-14-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210104174724.70404-1-y.karadz@gmail.com>
References: <20210104174724.70404-1-y.karadz@gmail.com>
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
index a540da2..654a262 100644
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
 	tracecmd_free_record(data);
 
 	pthread_mutex_unlock(&kshark_ctx->input_mutex);
@@ -1376,7 +1376,7 @@ const char *kshark_get_info_easy(struct kshark_entry *entry)
 	event_id = tep_data_type(kshark_ctx->pevent, data);
 	event = tep_find_event(kshark_ctx->pevent, event_id);
 	if (event)
-		info = kshark_get_info(kshark_ctx->pevent, data, event);
+		info = get_info(kshark_ctx->pevent, data, event);
 
 	tracecmd_free_record(data);
 
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

