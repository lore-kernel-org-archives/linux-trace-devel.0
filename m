Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09131C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Nov 2021 15:44:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E167D61076
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Nov 2021 15:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhKCPrC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Nov 2021 11:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbhKCPrC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Nov 2021 11:47:02 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDF3C061714
        for <linux-trace-devel@vger.kernel.org>; Wed,  3 Nov 2021 08:44:25 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id s13so4274239wrb.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 03 Nov 2021 08:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lnVE59onQOLIl9fFs9ZtirZV6E+WBa281mt3cuvQw8g=;
        b=LbcmLIwBMOoQ3okcnP4YSjQ8ov92N7WHrzsgNe+TzwxARm9gO/ygx+XcCP/tQRphEC
         brURkc7LykDB/bn7SZrBXhSHpbMpi8UFzu2koMM/nhEPpKt+++tjKNufvz7nb7Zyet1U
         U30GN5ukt67wIBPqZGETtQSTJiBaxlQx7vQIxPBK//kOkPafcvCgi4v4o6pQT5ZNIRbw
         6Bdl9+XbFOWt7cBbRkSKqjqdUZzr7s7chLbTJjBk7OW/EAASWD3syAfizweBc238kGyW
         4ZKAHLwBr/toNTwOruo3uA+Zm5orrwVuU+hq4VrfLlzfslW8MM1Q0sATInLZThB86xSG
         GNxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lnVE59onQOLIl9fFs9ZtirZV6E+WBa281mt3cuvQw8g=;
        b=e/1Bv+QRnYM0e+Mr1vh0ibRfE0uoa5J0G5+1rQvSl0ehbNh0w+AmiDkM1SB3eK4Q7j
         Gye46My89Txk1luWR1WlFqocQY8eP5/CyfRjK1Snx8xqv8sML0QoFKDSnEkaF5O+kMRD
         xWEmPvm+0LkvOfQf3eHfZrOoQ8bu8IggjfBNLe9RmDh/rCnOZIY+W7hCJ8YCb7J5Az7w
         YVWEuV6FnNxKWJEMQqKwgtloUWtqzieOa1BqU+NrZ6+cGYeMaY4WHhF+ZVEGPeiyf00P
         FwrV0K3AESn9jktIl8XNDHKNrq5KyKPU26LoJzQfPQKI9AExK072kAecjtE+KhTgpnBW
         gPxQ==
X-Gm-Message-State: AOAM532DuFj4T4cDATpV3uuY2PQyM2n/Fouh03U0djYXAEhnF4VAeGVS
        opNtlmBjozx8M3ZPYRmgW2k=
X-Google-Smtp-Source: ABdhPJz39L5DF1moKRIusu0b4yNcV8Y5P8axLsmWrBfRh77li1GYDyL5Smf29+u3O6eECj6iojsaZQ==
X-Received: by 2002:a5d:4582:: with SMTP id p2mr28356862wrq.364.1635954263973;
        Wed, 03 Nov 2021 08:44:23 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p12sm2767866wrr.10.2021.11.03.08.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 08:44:23 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 04/11] libtracefs: Remove redundant kprobes APIs
Date:   Wed,  3 Nov 2021 17:44:10 +0200
Message-Id: <20211103154417.246999-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103154417.246999-1-tz.stoyanov@gmail.com>
References: <20211103154417.246999-1-tz.stoyanov@gmail.com>
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
index b8f7c09..6bf45c3 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -276,11 +276,8 @@ int tracefs_kprobe_raw(const char *system, const char *event,
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
index d1279ff..72a4a35 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -262,80 +262,6 @@ static int parse_kprobe(char *content, char **saveptr,
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
@@ -406,176 +332,3 @@ enum tracefs_kprobe_type tracefs_kprobe_info(const char *group, const char *even
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

