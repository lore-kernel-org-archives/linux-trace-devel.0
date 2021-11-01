Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EF52C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Nov 2021 09:09:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52030610A2
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Nov 2021 09:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhKAJLq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Nov 2021 05:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbhKAJLp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Nov 2021 05:11:45 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B191C061714
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Nov 2021 02:09:12 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id h7so62697847ede.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Nov 2021 02:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f90pOY/2qZ7VK7u3Vo+L1Kzd6YCTYH+S7wU1QuIlZos=;
        b=OhoG/Kad2OHapWq9/QFTtL0SZWm4qB6DB7jHDGQPepLAYRA54EUnB83ZUHldxBg76J
         JEvZBGp7isSFnH8kQZQ/1QxuSkpB3hE521MzeU3l8RT4C1Ijx0pzbCXqJB9c3oRyuwpd
         yXpy8GC0Z+O9j74Dk62n3KeGn1WBHsJx1UD+dsrzuWYb4RzuimodKDLXw012h6jXcd6t
         RhcuVtooR+c1OUSjuDEQF6o332vaFlxVcuAzFVQ9pQ+S7BFFU9ZD76xzpUT69jFJkGWx
         3UJh6jKnQDV6j54uR7LQEvUOHpN85NP9u5VUPWja16se0NOWbTPl6mNsJnrZb9gJTi8N
         pqSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f90pOY/2qZ7VK7u3Vo+L1Kzd6YCTYH+S7wU1QuIlZos=;
        b=lP5ko4Wt3S1TJo1KWaUSjnn7HfPJrc0jMwkylfshMe+GM34uFaDhQn7OQcGyg1leG3
         XZVcfL6kf5LWQeWlmLWLtwsRqQ7y7rrbbXWQcHa64iSzGye/vLrqaaBvNP9/Q/15Fly7
         3WmSGNwOXekRfhzXYu6C7qvrHt5uqcQtnkxjmJjX7eMnHbRbnu7HAoNkdlHySNReioBi
         HTJe/onR5oovgkEy2gvWzvQA8//NPDM6P09CDPMI+KahmHoxsgXvV4bpcL8pIZ0KJMNx
         M1DDkNzgk22n7/upjxfcRc7kofxM7Ht1mWmhd5GrK7UyAejOH/KdDosrUVfE+J0xhgH5
         Xj+w==
X-Gm-Message-State: AOAM5336dObzcwOa2Nx8kV8W5QUMqs/QAglxfsflxLHICoMA3ODRjd3u
        cGkBbLiZOVm4KIDmP6lGTvpXhXvgqo0n5g==
X-Google-Smtp-Source: ABdhPJyCXWmIJMaCdspuzmJEvc+fn5Py4fr0h9KgthpMf/6u+ChLH9djRZFMPAnKFHRCekrUXsdKuQ==
X-Received: by 2002:a17:907:60c9:: with SMTP id hv9mr15376675ejc.334.1635757750984;
        Mon, 01 Nov 2021 02:09:10 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i8sm9873222edc.10.2021.11.01.02.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 02:09:10 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 04/12] libtracefs: Remove redundant kprobes APIs
Date:   Mon,  1 Nov 2021 11:08:56 +0200
Message-Id: <20211101090904.81454-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211101090904.81454-1-tz.stoyanov@gmail.com>
References: <20211101090904.81454-1-tz.stoyanov@gmail.com>
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
index 85185ce..d72582b 100644
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
index 906f914..0596f34 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -541,68 +541,6 @@ static int kprobe_clear_probes(const char *group, bool force)
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

