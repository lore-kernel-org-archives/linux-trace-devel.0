Return-Path: <SRS0=Ozv+=ZZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9950C43141
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Dec 2019 10:35:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7717E20684
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Dec 2019 10:35:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZbhRjTI0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbfLCKfp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Dec 2019 05:35:45 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37691 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfLCKfp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Dec 2019 05:35:45 -0500
Received: by mail-lj1-f195.google.com with SMTP id u17so3205441lja.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 03 Dec 2019 02:35:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TzKltY28zxysFwGXwi4Pp9PUBgVROhECvLFXCt3zpQw=;
        b=ZbhRjTI0kupL+RkuyB7ehxPQIRY8aj9s1pcy0xs+0FugABbzho1uOGNp1Ra/Um7TNH
         fuK6awqymr8RUPMMIpfr5C+ZFOnOnqiA7UGioZd5mTkW9tkvtljFH9neYvIgqycsitlY
         ee1dWiO2jO83g5/U3DNb+FXfbfDc/slgYYQGEvPONNeTOtZn37CQYbwBWa1aD4A4P1/I
         hkGydDGpLJRvTMfpyqSxM2b265G6LUTVB/OgMJzo9W5GPsRFjdVp9G58vii30b2EnDFZ
         ucq3hb/yvZBzY45mwsxeW/ll487Bor45TwncnW3QOwFNJj9IlC2GSArfdYz6IuFp+rWp
         WKvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TzKltY28zxysFwGXwi4Pp9PUBgVROhECvLFXCt3zpQw=;
        b=Z8N7Iw+wRUH5oUdJ2g1zLI5yk/PMPp3a8ltGgTeWscxFNjDh5e3sXxehlzZJhKUtaN
         M2I6A63l1ykBFZEhWXAiXeirZ0TMpBaWrr+b8jYiIh4/C54qiPqKVnnnk758FwJzgBk5
         6U/5fkAgNruz1/PKV30kE3bqf1zApFBdx8kIX0u7SU3FHmNnXN0XasH/aJ566rbqcrcQ
         SeWQF74ENUUrIhMIyxRZLo3AtX3VqR1d05Ix4qH3cRyA8K8QguHuRqwk8hs0VLJF5oOC
         7zHE8fOcAeo6F2iMLgx9W7MOoB/8rSyrAA/DED3M4hp8IxLOJEVhr9Nf3gF8EUcaaJdH
         19gA==
X-Gm-Message-State: APjAAAU0Xpq5juC6EbKvMIa5sZNVReKkI6GGd85TrA42SIlaKHKBQ6Id
        uB+i/1Ru+OYqXBINcVt8wPwlwklaQ8A=
X-Google-Smtp-Source: APXvYqyx1pEV+R3IDMEnqODxRVKv9W78SLLbCKt44fs4mbCgA8scqh3qvptLl0DI21zBLj5pFS6w9A==
X-Received: by 2002:a2e:b0db:: with SMTP id g27mr2218985ljl.74.1575369343002;
        Tue, 03 Dec 2019 02:35:43 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t9sm1053023lfl.51.2019.12.03.02.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 02:35:42 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v17 14/18] trace-cmd: Add host trace clock as guest trace argument
Date:   Tue,  3 Dec 2019 12:35:18 +0200
Message-Id: <20191203103522.482684-15-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191203103522.482684-1-tz.stoyanov@gmail.com>
References: <20191203103522.482684-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When tracing host and guest machines, both should use the same
tracing clock for event timestamps. If a clock is specified
as host tracing argument, with option "-C clock_name", the same
is injected as guest tracing argument. If the user wants to use
different tracing clocks, it can specify it using "-C clock_name"
as guest tracing argument. In that case, the one specified by
the user has higher priority.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 49730d6..e7fb1bd 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5405,6 +5405,8 @@ static void parse_record_options(int argc,
 	char *sav;
 	int name_counter = 0;
 	int neg_event = 0;
+	struct buffer_instance *instance;
+	bool guest_config = false;
 
 	init_common_record_context(ctx, curr_cmd);
 
@@ -5562,6 +5564,7 @@ static void parse_record_options(int argc,
 			break;
 		case 'C':
 			ctx->instance->ftrace->clock = optarg;
+			guest_config = true;
 			break;
 		case 'v':
 			neg_event = 1;
@@ -5779,14 +5782,26 @@ static void parse_record_options(int argc,
 
 	/* If --date is specified, prepend it to all guest VM flags */
 	if (ctx->date) {
-		struct buffer_instance *instance;
-
 		for_all_instances(instance) {
 			if (is_guest(instance))
 				add_argv(instance, "--date", true);
 		}
 	}
 
+	if (guest_config) {
+		/* If -C is specified, prepend clock to all guest VM flags */
+		for_all_instances(instance) {
+			if (top_instance.ftrace->clock) {
+				if (is_guest(instance)) {
+					add_argv(instance,
+						 (char *)top_instance.ftrace->clock,
+						 true);
+					add_argv(instance, "-C", true);
+				}
+			}
+		}
+	}
+
 	if (!ctx->filtered && ctx->instance->filter_mod)
 		add_func(&ctx->instance->filter_funcs,
 			 ctx->instance->filter_mod, "*");
-- 
2.23.0

