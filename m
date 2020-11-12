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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 620E2C56201
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 09:11:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02F6321534
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 09:11:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FkD8WtYj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbgKLJLS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Nov 2020 04:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgKLJLP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 04:11:15 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC57C0613D1
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 01:11:15 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id h2so4606986wmm.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 01:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VvdDjjYW11lLHzIdmxutetwT1vPbN7TiEOXdTOtvrdo=;
        b=FkD8WtYjycSpeoBwMgIaEg4Ia6IGCSzOlVm2KlRQzn5ntnuOWF+hlFZ2OL2w01dOTT
         HsK0cLcMoLihiwl+MemFmU+FYtsY0EIxen7eZX2bUOgQx4RVCCbIe2SkPOXBqvIQ9jzb
         h7W1O0a3W3a4X853mfdKTj6/iC3ZdjAVJWzOyZQGHSKVvTqPBK1AKIgw/GEFVhVw4nSw
         Ug8jDkQ4kLxtD9EAFhC2ApMEQv4p38R6lzUniBoFx/YTk43Bl+vMeoq7w9kdcZOgjcg1
         KDH3jsAi4fw/H7Gdx+lWNtfOl0geKYQGFC6f2uPSg7tRNl8EF6ViHS/wTuOwklKmvYA6
         pJlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VvdDjjYW11lLHzIdmxutetwT1vPbN7TiEOXdTOtvrdo=;
        b=EhBzFOXw2pqmQ+AIJ22P3uA5RyQ9IWat99ZpcEvu2o6GNxqK9vWqeSZx4h9xolJS1Q
         2PmSUt/aBylq+iP9rav0Ljjy4eDZkWYXS8qPGK88/pOUaaIauGo/gKohFYOFtTKmwCVU
         cjE9/GNS5aDChxgqiuojB+Cz+51U4768KnMgTHoli8g9m0cvnHrCC21NQUKIaiijjoAF
         cleulMea1S5l5zD4Pb5XB1GFW3+wyrWFPDUqSXOG96I8TNYSPYhjJEjRuYCDZSjZ1ySk
         F5H3PLk0l8LHy1i1aABl0/H2dZ6ZjizqAd7GDDT+vJF9wrZytea5kCkrUZoKhCfqCpEy
         XBiw==
X-Gm-Message-State: AOAM530hJ3qzhLxtB22ybs4iE0mJ9X+BdPf7KPXOgz6qvVR6BesW8/M+
        cDxl/yxXWR871tFE7R7wudYnQ7Nre9FzQdyo
X-Google-Smtp-Source: ABdhPJynsPHoRsmhIExMbiWG3FPpEBrQ1wpEcEV1IGwRsuzARqZlvP2y6GO/lN41shnli0a9vuHBGg==
X-Received: by 2002:a05:600c:2254:: with SMTP id a20mr8564427wmm.117.1605172273768;
        Thu, 12 Nov 2020 01:11:13 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r18sm6705718wrj.50.2020.11.12.01.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 01:11:13 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 2/6] libtracefs: Change get name API to return constant string
Date:   Thu, 12 Nov 2020 11:11:05 +0200
Message-Id: <20201112091109.1239169-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201112091109.1239169-1-tz.stoyanov@gmail.com>
References: <20201112091109.1239169-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The tracefs_instance_get_name() API returns a pointer to internal
string. This string is not meant to be changed by the API callers,
that's why it should be constant.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs/tracefs.h      |  2 +-
 lib/tracefs/tracefs-events.c   | 12 ++----------
 lib/tracefs/tracefs-instance.c |  2 +-
 tracecmd/trace-record.c        |  2 +-
 utest/tracefs-utest.c          |  2 +-
 5 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
index 8ee7ba6e..1cf8de48 100644
--- a/include/tracefs/tracefs.h
+++ b/include/tracefs/tracefs.h
@@ -24,7 +24,7 @@ struct tracefs_instance *tracefs_instance_alloc(const char *name);
 void tracefs_instance_free(struct tracefs_instance *instance);
 int tracefs_instance_create(struct tracefs_instance *instance);
 int tracefs_instance_destroy(struct tracefs_instance *instance);
-char *tracefs_instance_get_name(struct tracefs_instance *instance);
+const char *tracefs_instance_get_name(struct tracefs_instance *instance);
 char *
 tracefs_instance_get_file(struct tracefs_instance *instance, const char *file);
 char *tracefs_instance_get_dir(struct tracefs_instance *instance);
diff --git a/lib/tracefs/tracefs-events.c b/lib/tracefs/tracefs-events.c
index 8e825f50..6b796382 100644
--- a/lib/tracefs/tracefs-events.c
+++ b/lib/tracefs/tracefs-events.c
@@ -481,11 +481,7 @@ next_event:
 			failure = ret;
 	}
 
-	if (events) {
-		for (i = 0; events[i]; i++)
-			free(events[i]);
-		free(events);
-	}
+	tracefs_list_free(events);
 	return failure;
 }
 
@@ -564,11 +560,7 @@ static int fill_local_events_system(const char *tracing_dir,
 	/* always succeed because parsing failures are not critical */
 	ret = 0;
 out:
-	if (systems) {
-		for (i = 0; systems[i]; i++)
-			free(systems[i]);
-		free(systems);
-	}
+	tracefs_list_free(systems);
 	return ret;
 }
 
diff --git a/lib/tracefs/tracefs-instance.c b/lib/tracefs/tracefs-instance.c
index 50e88534..e37d93d1 100644
--- a/lib/tracefs/tracefs-instance.c
+++ b/lib/tracefs/tracefs-instance.c
@@ -169,7 +169,7 @@ char *tracefs_instance_get_dir(struct tracefs_instance *instance)
  * Returns the name of the given @instance.
  * The returned string must *not* be freed.
  */
-char *tracefs_instance_get_name(struct tracefs_instance *instance)
+const char *tracefs_instance_get_name(struct tracefs_instance *instance)
 {
 	if (instance)
 		return instance->name;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 72a5c8c9..8cd44dd0 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3861,7 +3861,7 @@ static void connect_to_agent(struct buffer_instance *instance)
 	unsigned int *ports;
 	int i, *fds = NULL;
 	bool use_fifos = false;
-	char *name;
+	const char *name;
 
 	name = tracefs_instance_get_name(instance->tracefs);
 	if (!no_fifos) {
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 1c146576..b5296963 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -180,7 +180,7 @@ static void test_instance_file(void)
 {
 	struct tracefs_instance *instance = NULL;
 	const char *name = get_rand_str();
-	char *inst_name = NULL;
+	const char *inst_name = NULL;
 	const char *tdir;
 	char *inst_file;
 	char *inst_dir;
-- 
2.28.0

