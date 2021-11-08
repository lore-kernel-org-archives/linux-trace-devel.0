Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5431C4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 08:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B76FA61208
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 08:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237450AbhKHIG4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 03:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237433AbhKHIGz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 03:06:55 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64ED2C061570
        for <linux-trace-devel@vger.kernel.org>; Mon,  8 Nov 2021 00:04:11 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id r12so58963877edt.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Nov 2021 00:04:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XJdkg/DlWu5oe4f4IN0Mj44ojw6UTNspDKNrK2yAX6w=;
        b=XBhqH/19TxTw/ZBXKIoNbuS/NPT5V5Wpf44naJ7DhdHdVy39uu60fgcbs7IIsNJ4D9
         EboWN7Dpj58Gs+Vn6e64uSoOjSjzE8bk9br/ZgX4j7o5kSq/ingJAe9N4zDB5VXuDNsZ
         29QiCRygbTk+q4nComhn6vVcH2sSaMnYVWMvrYoJTGfN8PF7L7gZxRjMABpUdc1lS2QU
         8LP9tNeYft3qZNQUJROAp8Ldvg0/bireyUtQjUiES+FyI298dKkp7EAWqbD/3ZxtScQC
         ykDHVBa2joSc9cK1+3jWP/72emhxJyQdfZSYmL7NFxXO6vIwnfTu9yhB4LOcDPAD3U64
         TnSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XJdkg/DlWu5oe4f4IN0Mj44ojw6UTNspDKNrK2yAX6w=;
        b=apc89Td4B6BCQ/C0tL7l0qNjuW6ovZ6zdyntq8SvVthAglDuUaePoCJyRha2zcDfw8
         0lA4O3O4V9aLpVvScNMwgOzp2Zcb8TTi+QEBySPyWpSAeG+UUugC5M3vvRhFpNRt4l5y
         Lc21eVF7kky/srfRiyzF27+knB3gyY4Qr3dP2brmgm3YKORM2IYN2aPpqwjwka4FFFsI
         r5rfz+lJQdPLkgS1ge3+ufrgnDwXv348I45qqy7XvGqIKf9peiCWTNYZeMn418ZBFe3r
         JdTq9wFJSEgGphbkKJ/H8oo7N1Fmz4Sx1H7olIVoYb7p1Gf32QNKB8kjUQqPnO0IZrHs
         gfXg==
X-Gm-Message-State: AOAM532XMnYxf1bqRbLEtLd/waH4LioWM4QQruHH0yVJNkFYmEmUtECa
        5k/+JaFH4dVXUvEyGktBFhQ=
X-Google-Smtp-Source: ABdhPJyOusrwH1OMSJD26ovBBSNKVI12oofMfUsex/7Q/kTmw4fDBsv1zzqcM33ITn7+Vq/MKMxS/w==
X-Received: by 2002:a17:907:6eaa:: with SMTP id sh42mr87645459ejc.556.1636358649929;
        Mon, 08 Nov 2021 00:04:09 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id mp5sm7962309ejc.68.2021.11.08.00.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 00:04:09 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 03/12] libtracefs: Remove redundant kprobes APIs
Date:   Mon,  8 Nov 2021 10:03:55 +0200
Message-Id: <20211108080404.55814-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211108080404.55814-1-tz.stoyanov@gmail.com>
References: <20211108080404.55814-1-tz.stoyanov@gmail.com>
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
 tracefs_kprobe_info()

There is one functionality, missing in the new clear API - clearing all
dynamic events from specific system only. If this is needed,
tracefs_dynevent_destroy() can be extended with that use case.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs.h     |  11 --
 src/tracefs-kprobes.c | 370 ------------------------------------------
 2 files changed, 381 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index dfd9b51..25d9e9a 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -261,12 +261,6 @@ enum tracefs_dynevent_type
 tracefs_dynevent_info(struct tracefs_dynevent *dynevent, char **system,
 		      char **event, char **prefix, char **addr, char **format);
 
-enum tracefs_kprobe_type {
-	TRACEFS_ALL_KPROBES,
-	TRACEFS_KPROBE,
-	TRACEFS_KRETPROBE,
-};
-
 struct tracefs_dynevent *
 tracefs_kprobe_alloc(const char *system, const char *event, const char *addr, const char *format);
 struct tracefs_dynevent *
@@ -276,11 +270,6 @@ int tracefs_kprobe_raw(const char *system, const char *event,
 		       const char *addr, const char *format);
 int tracefs_kretprobe_raw(const char *system, const char *event,
 			  const char *addr, const char *format);
-char **tracefs_get_kprobes(enum tracefs_kprobe_type type);
-enum tracefs_kprobe_type tracefs_kprobe_info(const char *group, const char *event,
-					     char **type, char **addr, char **format);
-int tracefs_kprobe_clear_all(bool force);
-int tracefs_kprobe_clear_probe(const char *system, const char *event, bool force);
 
 enum tracefs_hist_key_type {
 	TRACEFS_HIST_KEY_NORMAL = 0,
diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
index b9aeb9d..3f46b8d 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -213,373 +213,3 @@ int tracefs_kretprobe_raw(const char *system, const char *event,
 {
 	return insert_kprobe("r", system, event, addr, format);
 }
-
-/*
- * Helper function to parse kprobes.
- * @content: The content of kprobe_events on the first iteration.
- *           NULL on next iterations.
- * @saveptr: Same as saveptr for strtok_r
- * @type: Where to store the type (before ':')
- * @system: Store the system of the kprobe (NULL to have event contain
- *          both system and event, as in "kprobes/myprobe").
- * @event: Where to store the event.
- * @addr: Where to store the addr (may be NULL to ignore)
- * @format: Where to store the format (may be NULL to ignore)
- */
-static int parse_kprobe(char *content, char **saveptr,
-			char **type, char **system, char **event,
-			char **addr, char **format)
-{
-	char *p;
-
-	p = strtok_r(content, ":", saveptr);
-	if (!p)
-		return 1; /* eof */
-	*type = p;
-
-	if (system) {
-		p = strtok_r(NULL, "/", saveptr);
-		if (!p)
-			return -1;
-		*system = p;
-	}
-
-	p = strtok_r(NULL, " ", saveptr);
-	if (!p)
-		return -1;
-	*event = p;
-
-	if (addr || format) {
-		p = strtok_r(NULL, " ", saveptr);
-		if (!p)
-			return -1;
-		if (addr)
-			*addr = p;
-	}
-
-	p = strtok_r(NULL, "\n", saveptr);
-	if (!p)
-		return -1;
-	if (format)
-		*format = p;
-
-	return 0;
-}
-
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
-/**
- * tracefs_kprobe_info - return the type of kprobe specified.
- * @group: The group the kprobe is in (NULL for the default "kprobes")
- * @event: The name of the kprobe to find.
- * @type: String to return kprobe type (before ':') NULL to ignore.
- * @addr: String to return address kprobe is attached to. NULL to ignore.
- * @format: String to return kprobe format. NULL to ignore.
- *
- * If @type, @addr, or @format is non NULL, then the returned string
- * must be freed with free(). They will also be set to NULL, and
- * even on error, they may contain strings to be freed. If they are
- * not NULL, then they still need to be freed.
- *
- * Returns TRACEFS_ALL_KPROBES if an error occurs or the kprobe is not found,
- *            or the probe is of an unknown type.
- * TRACEFS_KPROBE if the type of kprobe found is a normal kprobe.
- * TRACEFS_KRETPROBE if the type of kprobe found is a kretprobe.
- */
-enum tracefs_kprobe_type tracefs_kprobe_info(const char *group, const char *event,
-					     char **type, char **addr, char **format)
-{
-	enum tracefs_kprobe_type rtype = TRACEFS_ALL_KPROBES;
-	char *saveptr;
-	char *content;
-	char *system;
-	char *probe;
-	char *ktype;
-	char *kaddr;
-	char *kfmt;
-	int ret;
-
-	if (!group)
-		group = KPROBE_DEFAULT_GROUP;
-
-	if (type)
-		*type = NULL;
-	if (addr)
-		*addr = NULL;
-	if (format)
-		*format = NULL;
-
-	content = tracefs_instance_file_read(NULL, KPROBE_EVENTS, NULL);
-	if (!content)
-		return rtype;
-
-	ret = parse_kprobe(content, &saveptr, &ktype, &system, &probe,
-			   &kaddr, &kfmt);
-
-	while (!ret) {
-
-		if (!strcmp(system, group) && !strcmp(probe, event)) {
-			if (type)
-				*type = strdup(ktype);
-			if (addr)
-				*addr = strdup(kaddr);
-			if (format)
-				*format = strdup(kfmt);
-
-			switch (*ktype) {
-			case 'p': rtype = TRACEFS_KPROBE; break;
-			case 'r': rtype = TRACEFS_KRETPROBE; break;
-			}
-			break;
-		}
-		ret = parse_kprobe(NULL, &saveptr, &ktype, &system, &probe,
-				   &kaddr, &kfmt);
-	}
-	free(content);
-	return rtype;
-}
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

