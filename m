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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27BD3C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:43:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D622623AC4
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:43:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732528AbgLINni (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 08:43:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732159AbgLINni (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 08:43:38 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02BAC0617A6
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 05:42:21 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id c198so1524050wmd.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Dec 2020 05:42:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F8xFGjb80gpezw/Rno+NLhDKi/QOhDhHSRY8gJ9e++o=;
        b=Sz4cksk0ybH0ux7eErVqFE3rmv/DwUup2XUVUd7dyJzBWQpp8XN8FjSNtxrxL0Cg92
         UJBGXASy+KUzf/rJzQnErMR3bRiVdtuNCGxf6jmJAl16KeQkuq5SSev/7Yw47XPr5hOv
         ORBMpxgXHUIu/H+xFifFz2ltS2hJC1yGDWSak13szg3sVlsPFVBDN4uD/7oTSjU6Pbhi
         snoy/kdO3rvXnCrWm6W/zqUeAcbekMUIwUfUbIVc3VR9ww82Ocp2EiNIguflmlc/U2j+
         du8VjmK8x/5tOMdJLJrjr9eMdHAJxsa5rKX0VnUf+w8LIe6NtwWZfSTCE4v/fRzFAaZ2
         xgSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F8xFGjb80gpezw/Rno+NLhDKi/QOhDhHSRY8gJ9e++o=;
        b=rXWqdvO0TAjY+yH4/nBKkjeHWowAEcVWqLZvbzKY5TZcfSV8ej6hsjh+asuQmWjD6z
         m2e/QcRJ5S0ZPEwyz4uacX8X54iSE1ZEoJXx94Mpfp22lCT9IjPpuYXnynbgYjIGt7ek
         6fXLXY3kUHj9FA6ihlJE4Ap8UeVl7heYQhIstBJBVYGHak9/OnLY6KI1Duc+Ly8WbplH
         EYQTlroa0JqNTYJVkePqUm/rAUaiD076oRgY/ut3F9Buo4IxS33WAtBpN8PW/XV9ElKV
         WOagEJcFirEg8NgkzYayg7Wh13hhTM1OIFAoILPAZKbxI9tDbslYEVkiAhqdmBoXoRyS
         EwdQ==
X-Gm-Message-State: AOAM533+Pm89F3U9Bv42VssMgbWaXozZdCocAOD32eachLiTjDkoPpA5
        tLL/uQfc/FPkBCnE4cQU6lg=
X-Google-Smtp-Source: ABdhPJwZfPgwQm5ea8i5AcU+iCx3lgbrZMI+KRi5ZFFmOArtCNajjriwCCxx+NDp+t9tBPsTVurzrg==
X-Received: by 2002:a05:600c:2255:: with SMTP id a21mr2939773wmm.122.1607521340789;
        Wed, 09 Dec 2020 05:42:20 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id q143sm3871071wme.28.2020.12.09.05.42.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 05:42:20 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v6 05/27] kernel-shark: Rename static methods in libkshark
Date:   Wed,  9 Dec 2020 15:41:41 +0200
Message-Id: <20201209134203.428068-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201209134203.428068-1-y.karadz@gmail.com>
References: <20201209134203.428068-1-y.karadz@gmail.com>
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
index 52aacd3..f3323ae 100644
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

