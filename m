Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2E52C5519F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Nov 2020 14:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51905246AA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Nov 2020 14:50:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LO3jgr2O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbgKROud (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 18 Nov 2020 09:50:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727174AbgKROub (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 18 Nov 2020 09:50:31 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA32C0613D6
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2020 06:50:31 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id a186so491469wme.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2020 06:50:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Abs1Q4oLMte7gYT/AzauP/BoKt49DCtdWJqWH25Dm2g=;
        b=LO3jgr2OcTdz5GKs41i9de7R7xHXnFsRmhqVCV+OYiuYMAlQBs5TlI5Oxi75NM4Z6q
         Tec1e+Zq0q/nD4nLmcpPrEaG9WAMKXACVtoh2ayZVPTbQf1CereH9YjbLMchTE2n+ykl
         rVMSIj/zCKdi7yuTYapr4y4A3wfEKVjUKbt9xXJv5G0tGXbdQBb+gqPXZCl/3yqiW3b9
         IJDUAcw4jxtEZY/C7b1VcoXO6J5VRTUkzscjwTjc8fqzvuiS68sGtAIBVY20w8sjltxP
         FdD5LrKNPB7r6YOIPFekRQcy2I39V+reyfoYl9mcEv86fKlkKeAmGPDGPP1WWI30VNcY
         27+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Abs1Q4oLMte7gYT/AzauP/BoKt49DCtdWJqWH25Dm2g=;
        b=bEuCDPlpWBnwMfd33IQSjdR3jz2/x2sU0X9kdUsmvC2eMF2fwvMwFL2jfjmr0oZr7m
         s2RO12VqwQ1r/IlbRkbxK7/igFnhtpB8Iavg6EgdgypuujzEwTOzgfVR4t0m6OeTl34e
         Il3ftDvDTAhcl2ti5HIkqAP98kh7XTeL68bgsLuod/G311esF5T6whFc9tOM6griDjTA
         6V8r4sHejaIwW4EionfVzbrC/a+g0H8jbsm9KTqp/vrNdhf9Dl+9GLe2vOZnqFViI9S5
         inIPb+sQKtv8O7TV9Pdb7MZLZKq62t8NaatO7jHnbnrknBdCv5WBf/8aMSFUaWUvzvw9
         xOPw==
X-Gm-Message-State: AOAM531tA2a6UdoidB+fIaYZYhOwXkKBoRBbZbQoeMNfjFHH84lmQ50S
        IFNzILPThqNlcTaPsvopDhU=
X-Google-Smtp-Source: ABdhPJwonU42k9diQTLQRPNGwPhLXKA/wRkhvo7gugjVyBQc0oazVsOXs+A5fx5fiYXKLyQwIZezjw==
X-Received: by 2002:a7b:ce0e:: with SMTP id m14mr421292wmc.17.1605711030195;
        Wed, 18 Nov 2020 06:50:30 -0800 (PST)
Received: from localhost.localdomain ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id s202sm3926190wme.39.2020.11.18.06.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 06:50:29 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 05/20] kernel-shark: Rename static methods in libkshark
Date:   Wed, 18 Nov 2020 16:49:48 +0200
Message-Id: <20201118145003.156542-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201118145003.156542-1-y.karadz@gmail.com>
References: <20201118145003.156542-1-y.karadz@gmail.com>
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

