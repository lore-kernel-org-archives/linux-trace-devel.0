Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F475C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Nov 2021 05:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhK3FEV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 00:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbhK3FEV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 00:04:21 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C278C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 Nov 2021 21:01:03 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id y13so81404156edd.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 Nov 2021 21:01:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bx4tcflhExfL16WHTEn4OHU9RTeMCZlVkV76CM5i5g4=;
        b=CSzT3FLw6zbkbzFt9kD7HiA3Lcuv8XUS3YtyZ4Ehs5hOfgSQHqbxqZVKqW0orN3Wy2
         9SceEkGoVDuiSL4qfCD17rJFRtfjTHKsSA2MOdBPURNTZyyq0AaVJnFWsZ/aZVp/4l/B
         Y2ikj48hfQXtszO4RpAFwGXeNNCA9gqMTASNyx7rKfSpjpJaUJQnVREY1/52rCXhpOWE
         /AS7OX33dslZC2OWpqhiG3cUz9BlGdgzTzOr/plniwEVwAbqvOF2vCpmIeXrzFc72xpT
         wOYbFKn4lRToz1EGYTAgRPo9mrr9AS5wMOWyFP1BB9pKXRMcXZYqOAOVC6TiKY6olusP
         zD/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bx4tcflhExfL16WHTEn4OHU9RTeMCZlVkV76CM5i5g4=;
        b=ZbBlk6zuvVfUKR5gLhROWcxX2516NF52y6YHD4TkGv7jL/hjHZTwqXN/5sm5Lhi5xp
         utR+7qtorN5hoVvV9o/W05LziGaJHvvKnO1OdaHZhxMUCRQBoAUQ93UlSIAPC7zStyTO
         geGzRd7wZAWM/USrNJE+OMZSzL7WRWTvy4sb7WpKkvsTQ/PqaEF7m0wLGPJVIuu/TxR2
         pOGIwguIeDB0i/mTOU2cCrkCEqoRZMBMIp1UIKXuriE31Wo7zm9huORpdY68h12ryygo
         iguArhci36Fxz/B6ysspQgOY+WRf6/bGNS3bCgKuoSGFeGFVBcSWpb/clg/8YGis+s3C
         Dg8g==
X-Gm-Message-State: AOAM530ERxmwk+60wA5eIzIT47UWmAcvzpsrHuoyiF13o05A5sH0hqHI
        xRiO+yCAywo+19eXoACJ3FVel098gJmrsg==
X-Google-Smtp-Source: ABdhPJxWn6F/s2lTkFvWxKxmYg1R+zZsEulK1ySGNBeVpwR6ePPnQ9iyfCD8V3dDOT9TjSjHocappQ==
X-Received: by 2002:a17:906:229b:: with SMTP id p27mr65211778eja.264.1638248461656;
        Mon, 29 Nov 2021 21:01:01 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w18sm10385849edx.55.2021.11.29.21.01.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 21:01:00 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/4] libtracefs: Reuse logic for loading events inside the library
Date:   Tue, 30 Nov 2021 07:00:54 +0200
Message-Id: <20211130050057.336228-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211130050057.336228-1-tz.stoyanov@gmail.com>
References: <20211130050057.336228-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The logic for parsing and loading new tep events could be reused in
tracefs library. The function load_events() is exposed as internal API.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs-local.h |  3 +++
 src/tracefs-events.c    | 11 +++++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index a59e806..0540956 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -112,4 +112,7 @@ dynevent_alloc(enum tracefs_dynevent_type type, const char *system,
 	       const char *event, const char *address, const char *format);
 int dynevent_get_count(unsigned int types, const char *system);
 
+int trace_load_events(struct tep_handle *tep,
+		      const char *tracing_dir, const char *system);
+
 #endif /* _TRACE_FS_LOCAL_H */
diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 4679926..e3962e5 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -688,8 +688,8 @@ char **tracefs_tracers(const char *tracing_dir)
 	return plugins;
 }
 
-static int load_events(struct tep_handle *tep,
-		       const char *tracing_dir, const char *system)
+__hidden int trace_load_events(struct tep_handle *tep,
+			       const char *tracing_dir, const char *system)
 {
 	int ret = 0, failure = 0;
 	char **events = NULL;
@@ -697,6 +697,9 @@ static int load_events(struct tep_handle *tep,
 	int len = 0;
 	int i;
 
+	if (!tracing_dir)
+		tracing_dir = tracefs_tracing_dir();
+
 	events = tracefs_system_events(tracing_dir, system);
 	if (!events)
 		return -ENOENT;
@@ -886,14 +889,14 @@ static int fill_local_events_system(const char *tracing_dir,
 	for (i = 0; systems[i]; i++) {
 		if (sys_names && !contains(systems[i], sys_names))
 			continue;
-		ret = load_events(tep, tracing_dir, systems[i]);
+		ret = trace_load_events(tep, tracing_dir, systems[i]);
 		if (ret && parsing_failures)
 			(*parsing_failures)++;
 	}
 
 	/* Include ftrace, as it is excluded for not having "enable" file */
 	if (!sys_names || contains("ftrace", sys_names))
-		load_events(tep, tracing_dir, "ftrace");
+		trace_load_events(tep, tracing_dir, "ftrace");
 
 	load_mappings(tracing_dir, tep);
 
-- 
2.33.1

