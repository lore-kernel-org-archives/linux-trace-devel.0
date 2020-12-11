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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F68FC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:15:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CC0B22C9C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:15:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406376AbgLKOrQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 09:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406382AbgLKOqY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 09:46:24 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B882AC061248
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 06:45:33 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id y23so8839396wmi.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 06:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6llSx7hgEf2smLRrpCsAO3FdE7ck0dMBR2Ily4Dh5nc=;
        b=GRT7oHbFsgnLgeXlgD+bERvmMEoMhPlAn2OPE2WUKugrk35ihh2ZlWGvXkHuMUksFw
         WFCAfxuZDIb0r0aO+mtzViIPyaVdBzlNjgbBpfIDpDE/xdFsJ3qGWtlvzUsBEEnKNhmv
         PBWG7Meh9lC/sZBRp9LadYR921KOS4bx03+oKk4q3tHk8N3WWKILrXH2HUsSTW74/L9j
         JtZn8lMSOFXtTtNsN9DSr1hx0FnDmU2/gi2qZcGhwkOmhJnqVxEtqZMcvoN4OpeasiNm
         GfLdI60BM2oTYvMgSZ+pLIZE3McJeJqn8MZ7tlN4CbOvdWBPHAE++T/vr7w8TyJKy2OQ
         CsjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6llSx7hgEf2smLRrpCsAO3FdE7ck0dMBR2Ily4Dh5nc=;
        b=DIRswEASSBhs/S6h9i1NGlvMG16FRYCX6CfI/IpNfarD3tFa/qY/9BpxSmvO5ePvhU
         gpuptJbYos1fs0TMNh7wAO2l/9gK7qaL1mr8agMqc4LHYDxyEk73RNt06l020UDPUMq6
         OMEiU8Iczf/fsQxOHxIOPtn5TsS+/IEJeqTgfVfnxh/T72vG0wnQTykg22WN42TFGOfq
         ITMVVqdW8ENHAMztRoDPDQGcOuJleGrNasgjO8eRcYpaOOB4XJDN7CXWmQzhGDJPBzOf
         xrcshaGht2a8H2hGIr8urwbPGboXYkGzfeXDpfH8G2ejcs6H4MfTzCIuQsL08XVtkYYw
         2j4A==
X-Gm-Message-State: AOAM532m5V2qgrvspk7ZtTuPBQ2zGcLG2u/i3pJpg2qB5zsWA23MnwfF
        CoPgVa1wkoyz5Mhw/guSBKpgjl1RHtA=
X-Google-Smtp-Source: ABdhPJxrSRt6ztVL/nYTRVyZGEN9PTxmgo/lWi6xkDykamlukYFQuFKgu0p+PPhSEsyUvTTq49lN8Q==
X-Received: by 2002:a1c:24c4:: with SMTP id k187mr14222366wmk.14.1607697932523;
        Fri, 11 Dec 2020 06:45:32 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id y2sm14471471wma.6.2020.12.11.06.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 06:45:31 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v7 10/32] kernel-shark: Rename static methods in libkshark
Date:   Fri, 11 Dec 2020 16:44:49 +0200
Message-Id: <20201211144511.575346-11-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211144511.575346-1-y.karadz@gmail.com>
References: <20201211144511.575346-1-y.karadz@gmail.com>
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
index a14d3c5..0acce90 100644
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

