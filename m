Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58A9DC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 11:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 415C6611F2
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 11:10:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbhKDLNd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Nov 2021 07:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbhKDLNc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Nov 2021 07:13:32 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7861AC061714
        for <linux-trace-devel@vger.kernel.org>; Thu,  4 Nov 2021 04:10:54 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id s13so8028573wrb.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 04 Nov 2021 04:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RRxT0VYQErq4JmQ2IIfnMxZCSctXuvVY5wqi05HlylE=;
        b=MUDExuyGOkM5j7Or2MTUTmTaVXFAzecFSvl7z+serxcBcToxh3arECqUeBTw0LthhJ
         s2AlQI/46HcXJ3WcS+g4/0DXFZeaxL6p4ZLJ6gJdjjBaSL0eBl7SCV8x33yPP2YYQ31c
         xjLQ6LpXZXfw1eW3yHIIFI1jePylfDDLO8stfmMgzGXzirM3fqXAfRgDj6m4PtCBrMsx
         bzDovJfIJip6SviiFpBER5HTf0fh0GRnn/ofC7srvlRP3wrArYC93dw1qkM8b1do+CVf
         a+K0R5tr3RA5+iiRe1/C8i1hZguJ2lUMLOYuHhPTTEGAmt8qJlhpeJrx0SBqn1DlYPXN
         +m2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RRxT0VYQErq4JmQ2IIfnMxZCSctXuvVY5wqi05HlylE=;
        b=h5vNarexx45qgl711cqau9p8MrZeS0seTJQb9jY6idfEYxgOc1TKO95kjVHxwhcHaL
         gkBlxP+efslxkFPE/LieWEcFushINMbMy0ObqbfVBpHja7G8uqFx0ZLL/QwKa06oPyVu
         Xf2V211qa8u2HJIZOlh5hQqqlm77dTXxzKy1c0TEj70LHbxTlwV/vP+YgT2rLLXp8Muu
         wLEIZdzprStzOwsAKSfy/SmVrQs6CDpOuYkbUmepd0iIO63e7c2PtS4kgRRIMIGOrcpT
         OUzoAv0eCeMLCF+Jz0NsLif7UwnQ83jcQ+ZJqltcO4mBZS3huEvgz1bHO24E9Hb3mZ92
         cUYg==
X-Gm-Message-State: AOAM531UJDiQI1WmTIt3qiQgU8tddSNuYgGvr5j7ARf5i/9BUPUF6a0Z
        r0jRBD2MVE0KFU0Pq6Thet2gT7xlqEso8w==
X-Google-Smtp-Source: ABdhPJycYATxHu08XhJKYkY5xMqE6F/m3nG8LFyDN/KQzD8NdcZ18n7aOCLju7keiEfkyRy68BQhMQ==
X-Received: by 2002:adf:f9d2:: with SMTP id w18mr31242593wrr.303.1636024253033;
        Thu, 04 Nov 2021 04:10:53 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l18sm5080843wrt.81.2021.11.04.04.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 04:10:52 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 03/10] libtracefs: Remove redundant kprobes APIs
Date:   Thu,  4 Nov 2021 13:10:40 +0200
Message-Id: <20211104111047.302660-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211104111047.302660-1-tz.stoyanov@gmail.com>
References: <20211104111047.302660-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The newly introduced set of APIs tracefs_dynevent_...() can be used to
manage kprobes. These legacy APIs are removed as redundant:
 tracefs_kprobe_clear_all();
 tracefs_kprobe_clear_probe();
 tracefs_get_kprobes()

There is one functionality, missing in the new clear API - clearing all
dynamic events from specific system only. If this is needed,
tracefs_dynevent_destroy() can be extended with that use case.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs.h     |   3 -
 src/tracefs-kprobes.c | 247 ------------------------------------------
 2 files changed, 250 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 3b2fc50..7d9a9af 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -272,11 +272,8 @@ int tracefs_kprobe_raw(const char *system, const char *event,
 		       const char *addr, const char *format);
 int tracefs_kretprobe_raw(const char *system, const char *event,
 			  const char *addr, const char *format);
-char **tracefs_get_kprobes(enum tracefs_kprobe_type type);
 enum tracefs_kprobe_type tracefs_kprobe_info(const char *group, const char *event,
 					     char **type, char **addr, char **format);
-int tracefs_kprobe_clear_all(bool force);
-int tracefs_kprobe_clear_probe(const char *system, const char *event, bool force);
 
 enum tracefs_hist_key_type {
 	TRACEFS_HIST_KEY_NORMAL = 0,
diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
index b2dcb0e..f67a93a 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -266,80 +266,6 @@ static int parse_kprobe(char *content, char **saveptr,
 	return 0;
 }
 
-/**
- * tracefs_get_kprobes - return a list kprobes (by group/event name)
- * @type: The type of kprobes to return.
- *
- * If @type is TRACEFS_ALL_KPROBES all kprobes in the kprobe_events
- * are returned. Otherwise if it is TRACEFS_KPROBE, then only
- * normal kprobes (p:) are returned, or if type is TRACEFS_KRETPROBE
- * then only kretprobes (r:) are returned.
- *
- * Returns a list of strings that contain the kprobes that exist
- * in the kprobe_events files. The strings returned are in the
- * "group/event" format.
- * The list must be freed with tracefs_list_free().
- * If there are no kprobes, a list is still returned, but it contains
- * only a NULL pointer.
- * On error, NULL is returned.
- */
-char **tracefs_get_kprobes(enum tracefs_kprobe_type type)
-{
-	char **list = NULL;
-	char *content;
-	char *saveptr;
-	char *event;
-	char *ktype;
-	int ret;
-
-	errno = 0;
-	content = tracefs_instance_file_read(NULL, KPROBE_EVENTS, NULL);
-	if (!content) {
-		if (errno)
-			return NULL;
-		/* content is NULL on empty file, return an empty list */
-		return trace_list_create_empty();
-	}
-
-	ret = parse_kprobe(content, &saveptr, &ktype, NULL, &event, NULL, NULL);
-
-	while (!ret) {
-		char **tmp;
-
-		if (type != TRACEFS_ALL_KPROBES) {
-			switch (*ktype) {
-			case 'p':
-				if (type != TRACEFS_KPROBE)
-					goto next;
-				break;
-			case 'r':
-				if (type != TRACEFS_KRETPROBE)
-					goto next;
-				break;
-			default:
-				goto next;
-			}
-		}
-
-		tmp = tracefs_list_add(list, event);
-		if (!tmp)
-			goto fail;
-		list = tmp;
- next:
-		ret = parse_kprobe(NULL, &saveptr, &ktype, NULL, &event, NULL, NULL);
-	}
-
-	if (!list)
-		list = trace_list_create_empty();
- out:
-	free(content);
-	return list;
- fail:
-	tracefs_list_free(list);
-	list = NULL;
-	goto out;
-}
-
 /**
  * tracefs_kprobe_info - return the type of kprobe specified.
  * @group: The group the kprobe is in (NULL for the default "kprobes")
@@ -410,176 +336,3 @@ enum tracefs_kprobe_type tracefs_kprobe_info(const char *group, const char *even
 	free(content);
 	return rtype;
 }
-
-static void disable_events(const char *system, const char *event,
-			   char **list)
-{
-	struct tracefs_instance *instance;
-	int i;
-
-	/*
-	 * Note, this will not fail even on error.
-	 * That is because even if something fails, it may still
-	 * work enough to clear the kprobes. If that's the case
-	 * the clearing after the loop will succeed and the function
-	 * is a success, even though other parts had failed. If
-	 * one of the kprobe events is enabled in one of the
-	 * instances that fail, then the clearing will fail too
-	 * and the function will return an error.
-	 */
-
-	tracefs_event_disable(NULL, system, event);
-	/* No need to test results */
-
-	if (!list)
-		return;
-
-	for (i = 0; list[i]; i++) {
-		instance = tracefs_instance_alloc(NULL, list[i]);
-		/* If this fails, try the next one */
-		if (!instance)
-			continue;
-		tracefs_event_disable(instance, system, event);
-		tracefs_instance_free(instance);
-	}
-	return;
-}
-
-static int clear_kprobe(const char *system, const char *event)
-{
-	/* '-' + ':' + '/' + '\n' + '\0' = 5 bytes */
-	int len = strlen(system) + strlen(event) + 5;
-	char content[len];
-
-	sprintf(content, "-:%s/%s", system, event);
-	return tracefs_instance_file_append(NULL, KPROBE_EVENTS, content);
-}
-
-static int kprobe_clear_probes(const char *group, bool force)
-{
-	char **instance_list;
-	char **kprobe_list;
-	char *saveptr;
-	char *system;
-	char *kprobe;
-	char *event;
-	int ret;
-	int i;
-
-	kprobe_list = tracefs_get_kprobes(TRACEFS_ALL_KPROBES);
-	if (!kprobe_list)
-		return -1;
-
-	instance_list = tracefs_instances(NULL);
-	/*
-	 * Even if the above failed and instance_list is NULL,
-	 * keep going, as the enabled event may simply be in the
-	 * top level.
-	 */
-
-	/*
-	 * If a system is defined, the default is to pass unless
-	 * an event fails to be removed. If a system is not defined,
-	 * the default is to fail, unless all are removed.
-	 */
-	ret = group ? 0 : -1;
-
-	for (i = 0; kprobe_list[i]; i++) {
-		kprobe = kprobe_list[i];
-
-		system = strtok_r(kprobe, "/", &saveptr);
-		if (!system)
-			goto out;
-
-		event = strtok_r(NULL," ", &saveptr);
-		if (!event)
-			goto out;
-
-		/* Skip if this does not match a given system */
-		if (group && strcmp(system, group) != 0)
-			continue;
-
-		if (force)
-			disable_events(system, event, instance_list);
-
-		if (group) {
-			ret = clear_kprobe(system, event);
-			if (ret < 0)
-				goto out;
-		} else {
-			ret = tracefs_instance_file_clear(NULL, KPROBE_EVENTS);
-			/* On success stop the loop */
-			if (!ret)
-				goto out;
-		}
-
-		/* Set the default for whether a system is defined or not */
-		ret = group ? 0 : -1;
-	}
- out:
-	tracefs_list_free(instance_list);
-	tracefs_list_free(kprobe_list);
-	return ret;
-}
-
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
-- 
2.31.1

