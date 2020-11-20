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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DC72C5519F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:43:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B11EC22227
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:43:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OQROfheq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgKTJnb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 04:43:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726122AbgKTJn3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 04:43:29 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EAEDC0613CF
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Nov 2020 01:43:29 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id y4so8848164edy.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Nov 2020 01:43:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Abs1Q4oLMte7gYT/AzauP/BoKt49DCtdWJqWH25Dm2g=;
        b=OQROfheqTKStpMYd5BNAIdAsENZBFJSzzrelBvTJnEk2LZ7FhfM73PL6Iq6p7gfYMd
         sReEQyGkEnjWJpu088a9HZm5KsYDYrzrkGPNYLGywwmZBV1NMfjI5IrH8qa6o2qJkHZq
         BDrBxXM7S4qLnrCSAajVyYEL827iwMFMjcPMfS4/F1ldRkZgioCyYMwrYt2TQeMe910x
         yHIODZQlIDLEBvDyJEneDfRn/oa5osbsu8T/G4BmLADTgDcqxXOiBJGwx+geqAwgJ8o7
         7plK4OzyJpefOSnEdTiIXY2ZmJ+RzJAG67PjiRCvcSHL9AzIswDPw8gE8L31YKRf7U46
         C4Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Abs1Q4oLMte7gYT/AzauP/BoKt49DCtdWJqWH25Dm2g=;
        b=CxnCpOZonVvx7hLJkFCDXExGxUDqtMpLwNW2+DRYsTWcjlzocWT0WEmoCAr8jUeSc9
         d6DYgrkcuYGbJtJm+MFRi6tk/7Nt21QOXQz30G9GwCxhAcykipkXbJnAwDsMsJgrphwO
         HzHjhQLnEmZpQJFCzksU4kRayPXO9FL2QOZL+SS0eW1Uz9a4uVJVRDtAKkqzmAfcUGCr
         MIHG6SBfAoQRdfFCJP4H92HDLR0/guRsxgw4BEWEFnHatEbYCRIIGMZ6ijN/JGh0ZSxG
         QRXTq3PZWR7Xhewt0KUgEE7Ycf+mJFnJ5ueVhD3KiYcSmhYwtshG2aS+7JA5zXhkqKBd
         BzrA==
X-Gm-Message-State: AOAM530AyHl6ibuPT/+/xyWyC9KZmgK0jmBHle3Potu5V4Cx/EBaa9qv
        gssLLXESzfv+17xYNd9dKiA=
X-Google-Smtp-Source: ABdhPJyNiqFvEjfAVGMpZQVcxTE3v9yEIONamaydNfGfpYp8UcQNSJXyitdjuCOBJsjisVxeblHenw==
X-Received: by 2002:a05:6402:2363:: with SMTP id a3mr9346619eda.388.1605865407969;
        Fri, 20 Nov 2020 01:43:27 -0800 (PST)
Received: from localhost.localdomain ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id h2sm897006ejx.55.2020.11.20.01.43.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 01:43:27 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v5 05/20] kernel-shark: Rename static methods in libkshark
Date:   Fri, 20 Nov 2020 11:42:49 +0200
Message-Id: <20201120094304.271502-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201120094304.271502-1-y.karadz@gmail.com>
References: <20201120094304.271502-1-y.karadz@gmail.com>
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

