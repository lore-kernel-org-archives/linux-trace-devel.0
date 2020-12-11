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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39B28C4361B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:54:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE7C923B31
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392737AbgLKPKT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 10:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392736AbgLKPJg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 10:09:36 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85365C061285
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:23 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id g185so8897067wmf.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6llSx7hgEf2smLRrpCsAO3FdE7ck0dMBR2Ily4Dh5nc=;
        b=s0I15DezZzi+V7CPcjqbSbS+8b9zVaWjih8f+wtmdihQhvRxvC5u7zS0thTLpT9Aqk
         4Q7bo37OHJ1yK4HRy23ekAw/7cejokMUCD18tBY+eoGopVvfnUqIlrdr0Ui5jbJyvcmv
         4Q1GiF/vCy7IYw/dfNL34q3qF96LWV5qIVPFY0Vr0FkJBE4ENHaSSDAUG0tz7wVlClPN
         Iz8WqB0oklLF3CozPj5SgR8+bchiWX4R2BZM3af51+ePH5WBIR/mP5Rxo6gPE9tnSnb1
         13LlAkBAFFfII0cz4dYcpWtfj9Drlqe/383D4VhgTp/CUBd3l1vYmCSD7i9cd8n2qatY
         IWhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6llSx7hgEf2smLRrpCsAO3FdE7ck0dMBR2Ily4Dh5nc=;
        b=emo5qe0xIuBdMG2oEmK4obXsz30P4/lLslvmt8OyAvVoQOifPKBFoHN7Gz+bjp5r8h
         Znb7lXwqsB0/rl9jpPw0K900r3VXe6RLFQBJRpwWVyQppcgZicWVEg8CpDDiWzxjff0y
         EsHcYU0TekRuMUoT1GYSeEUE9Frd7xfNm/XT5cZUhxBNfq7SmCj/UvjjWPHX9/TaRUmV
         y11/9KvP9ZIVAAvTg7NmR0n4ET2QSvFxDBO7oNHj2Pyx6XLhud/JK+mHXlB75uWjKvOl
         Bm/y89+RhjjhThw8yjRuA+8bCD+lZOdMKoXd0Vh0nzYqypSyQJ5kPvxN7cKieLYlms4f
         T8Lg==
X-Gm-Message-State: AOAM532S0klvCNtjLPuwui96+7mgP/zku79j6RZY2F0iKewSN4ZqTFDZ
        Z60DR98jdkmIY+UuGYfpEqQ=
X-Google-Smtp-Source: ABdhPJyjF8yA7G8MUyiHvAZxpyOZ0zCa4GoKi/M7akyJHc/iwpUFL9YLvzB+ORagh8J1zjjfx8FJJA==
X-Received: by 2002:a1c:454:: with SMTP id 81mr14053537wme.178.1607699302355;
        Fri, 11 Dec 2020 07:08:22 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id w17sm15620948wru.82.2020.12.11.07.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 07:08:21 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v7 10/32] kernel-shark: Rename static methods in libkshark
Date:   Fri, 11 Dec 2020 17:07:34 +0200
Message-Id: <20201211150756.577366-11-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211150756.577366-1-y.karadz@gmail.com>
References: <20201211150756.577366-1-y.karadz@gmail.com>
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

