Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8585EC433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 12:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D93C610F8
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 12:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbhJ1MLn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Oct 2021 08:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbhJ1MLn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 08:11:43 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620AEC061570
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Oct 2021 05:09:16 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id f8so2278736edy.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Oct 2021 05:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y0cW1T41hmSx1fhsT025xt2zuivyWD0bEQof68DZI7g=;
        b=TN3x9TsT7fL1HJe6twpKb8e5UD0QPdv78IqRd/nvAsXqQBSgAhdKVbvbpTV89Hpjc0
         iTp3lHV773PF7V6hThEvgyMTRA8y1Js7C8ScY7oZrLq0MXyU66hA0j4GyrxzSsmV0LX5
         nyoFHLPBUa/H+lRMM4lVoPxLGjqajm18YJ3J/gfssmPb6fCdaCnLQNUXqnnDjSLebLFF
         IV+dXtsfoS8HBks0/dZdMLojS7fXH+3p8Yjz1mWzhjmAxwKXBYGCNy55BVVanZ1pKVUA
         WFgkT8tzftTkrPLRpqkA/EJKA7aLcGEF8oovV8jV4zn8dAln/KXJxkPkydnAzWuoZvbX
         9rfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y0cW1T41hmSx1fhsT025xt2zuivyWD0bEQof68DZI7g=;
        b=PIEe7cr2VjGLX0iCMcDXxEb3mVgEzbHNU72D3PtHIUwZBkS1uojIoVxznOsAvEgjEI
         v2xGuwRxS/V8VQWLx2UXJxgOi51/CI8MeB6prH+yOpijgsYB7G/ki+7SUHc4FPk/AW+l
         FGmr6PTkynu0ogGsEwhcPxtfVkgQUbLoke5enRKseulIeofz6MqYAjtfI4jjrLGmp3tm
         zhH5/qaFQhzhZDBHyIkHicNUMnIMzD8jfuzeCQg4vR+bmTDpots0YTXiddDwz6o9dqad
         gm1dVA9KMI0KwTCFJtD2MvVzgEc1+2A8VLg2e1GqFRAoNwvXCKuJm/IYRk0UnPVBOAlT
         tb/Q==
X-Gm-Message-State: AOAM531i/86zhLwgEimrfqVvhqbi4w8CMY0w5oh/Lq4UskLY9+PlFWcf
        tLYR/2cZdRE//iKKF5+666Y=
X-Google-Smtp-Source: ABdhPJxwD8XJeo9pTei7De1BAyy9rcmx808SQx0wusDcRVPKtJIa/s2CFcdEzd2sooBD73uh5PEgvg==
X-Received: by 2002:a05:6402:17c4:: with SMTP id s4mr5604445edy.253.1635422954307;
        Thu, 28 Oct 2021 05:09:14 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v6sm1803003edc.52.2021.10.28.05.09.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 05:09:13 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 04/12] libtracefs: Remove redundant kprobes APIs
Date:   Thu, 28 Oct 2021 15:08:59 +0300
Message-Id: <20211028120907.101847-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211028120907.101847-1-tz.stoyanov@gmail.com>
References: <20211028120907.101847-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The newly introduced API tracefs_kprobe_destroy() can be used to clear a
specific kprobe or all kprobes from the system. These legacy APIs are
removed as redundant:
 tracefs_kprobe_clear_all();
 tracefs_kprobe_clear_probe();

There is one functionality, missing in the new API - clearing all
kprobes from specific system only. If this is needed,
tracefs_kprobe_destroy() can be extended with that use case.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs.h     |  2 --
 src/tracefs-kprobes.c | 62 -------------------------------------------
 2 files changed, 64 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index e7d545c..c7b9179 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -262,8 +262,6 @@ int tracefs_kretprobe_raw(const char *system, const char *event,
 char **tracefs_kprobes_get(enum tracefs_kprobe_type type);
 enum tracefs_kprobe_type tracefs_kprobe_info(const char *group, const char *event,
 					     char **type, char **addr, char **format);
-int tracefs_kprobe_clear_all(bool force);
-int tracefs_kprobe_clear_probe(const char *system, const char *event, bool force);
 
 enum tracefs_hist_key_type {
 	TRACEFS_HIST_KEY_NORMAL = 0,
diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
index 80dc327..1e08b75 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -542,68 +542,6 @@ static int kprobe_clear_probes(const char *group, bool force)
 	return ret;
 }
 
-/**
- * tracefs_kprobe_clear_all - clear kprobe events
- * @force: Will attempt to disable all kprobe events and clear them
- *
- * Will remove all defined kprobe events. If any of them are enabled,
- * and @force is not set, then it will error with -1 and errno to be
- * EBUSY. If @force is set, then it will attempt to disable all the kprobe
- * events in all instances, and try again.
- *
- * Returns zero on success, -1 otherwise.
- */
-int tracefs_kprobe_clear_all(bool force)
-{
-	if (tracefs_instance_file_clear(NULL, KPROBE_EVENTS) == 0)
-		return 0;
-
-	if (!force)
-		return -1;
-
-	/* Attempt to disable all kprobe events */
-	return kprobe_clear_probes(NULL, force);
-}
-
-/**
- * tracefs_kprobe_clear_all - clear kprobe events
- * @system: System to clear (NULL means default)
- * @event: Name of probe to clear in system (NULL for all probes in system)
- * @force: Will attempt to disable all kprobe events and clear them
- *
- * Will remove the kprobes that match the @system and @event. If @system
- * is NULL, then "kprobes" is used and will ignore all other system
- * groups of kprobes. The @event is NULL then all events under the given
- * @system are removed, otherwise only the event that matches.
- *
- * Returns zero on success, -1 otherwise.
- */
-int tracefs_kprobe_clear_probe(const char *system, const char *event, bool force)
-{
-	char **instance_list;
-	int ret;
-
-	if (!system)
-		system = "kprobes";
-
-	if (!event)
-		return kprobe_clear_probes(system, force);
-
-	/*
-	 * Since we know we are disabling a specific event, try
-	 * to disable it first before clearing it.
-	 */
-	if (force) {
-		instance_list = tracefs_instances(NULL);
-		disable_events(system, event, instance_list);
-		tracefs_list_free(instance_list);
-	}
-
-	ret = clear_kprobe(system, event);
-
-	return ret < 0 ? -1 : 0;
-}
-
 /**
  * tracefs_kprobe_destroy - Remove a kprobe or kretprobe from the system
  * @kprobe: A kprobe context, describing the kprobe that will be deleted.
-- 
2.31.1

