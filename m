Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E101C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 10:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357072AbhLBLCz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 06:02:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233830AbhLBLCz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 06:02:55 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9DBC06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 02:59:32 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id r11so114266287edd.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 02:59:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PbQpqxxIHdEIFacRsDS+C6vCgFUH8fVOY6dIYyIkuwo=;
        b=eGQL1V1uebBspwuvp0MrxjtSqAoFr5BrRR2ZtcpwevfUYXhIWcFwnxbSF4hxb2/8ps
         vo9J/lAMVtY+8mBqgUX4+7NQ02/r3nVu8YSX6Jd4saa/CAt/0V4IEQLixIn04ww1OWAP
         oD9X2IyliwFvqsjAgK5Tc9O/Mpxtt6mtzjxrfw9epHE6F3LesEEastOeFPB7qm27ha1w
         ImayZHLMD8fLx1M0SwPbY0bOjbJF9ZrlXBxtNe41Z+YKcegllLs0THNxSZjJC8mgDsuy
         DGLHVFyh3smukGlJS/FpJfU5yUFeWPMn+6cUtGCVUvtGC9XTLpD5E3ogzFKxolCjUg4z
         KJaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PbQpqxxIHdEIFacRsDS+C6vCgFUH8fVOY6dIYyIkuwo=;
        b=BOxbBGims74nWPld5z4KdxYG2kK8LcDwIeW95gnz5li5ZYlW6WJxe9ZRemEBX0OQoN
         EhHpX5Q2tpI1jCKbfNusIQZY2CYjbaQISQQt/aTOa4r8+htT/uzZc0yXFih4axXQs3Ni
         YHirsSDTZt7cf+s9Ab/mcl7P2sarFcpaEfX0/GMC0CsZ7ExfCZlL0rLJmXb/SnvMZTw4
         K3MZbKkhOSsBT4jNzTxv2UI+hsjBkwLjx/IKhD+OB8wVzX93qYvRhP6Q/9knJNOCKeoj
         WIibVULfHNglbDS20cw6acW01KHhq0x6afm9iUG/ghu+ultUajc1obxreULfYqE9qYfL
         wtMw==
X-Gm-Message-State: AOAM532aeVLstGQDOtcic5rnrbgdqd2bfTwFoNUHAcv5FkkoRcY7jPi+
        A/HAHL+OqiRnyMI/ALPtsboYAduE78fh5A==
X-Google-Smtp-Source: ABdhPJx1m2AjZunRQperjg0EXJZBSnJ650ftduJWrI74oSW0zYTJY417sYcnET2w32Zp0LItjIooSg==
X-Received: by 2002:a05:6402:26d4:: with SMTP id x20mr16902897edd.119.1638442771250;
        Thu, 02 Dec 2021 02:59:31 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e19sm1852930edu.47.2021.12.02.02.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 02:59:30 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/4] libtracefs: New API for getting dynamic event
Date:   Thu,  2 Dec 2021 12:59:24 +0200
Message-Id: <20211202105926.32581-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202105926.32581-1-tz.stoyanov@gmail.com>
References: <20211202105926.32581-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new API is proposed, to get tep event describing given dynamic event:

	tracefs_dynevent_get_event()

The API detects any newly created or removed dynamic events.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-dynevents.txt | 13 ++++++++--
 include/tracefs.h                      |  2 ++
 src/tracefs-dynevents.c                | 33 ++++++++++++++++++++++++++
 3 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/Documentation/libtracefs-dynevents.txt b/Documentation/libtracefs-dynevents.txt
index a374651..bec31f1 100644
--- a/Documentation/libtracefs-dynevents.txt
+++ b/Documentation/libtracefs-dynevents.txt
@@ -4,8 +4,8 @@ libtracefs(3)
 NAME
 ----
 tracefs_dynevent_create, tracefs_dynevent_destroy, tracefs_dynevent_destroy_all,
-tracefs_dynevent_free, tracefs_dynevent_list_free, tracefs_dynevent_get_all, tracefs_dynevent_info -
-Create, destroy, free and get dynamic events.
+tracefs_dynevent_free, tracefs_dynevent_list_free, tracefs_dynevent_get_all, tracefs_dynevent_info,
+tracefs_dynevent_get_event - Create, destroy, free and get dynamic events.
 
 SYNOPSIS
 --------
@@ -23,6 +23,7 @@ void *tracefs_dynevent_list_free*(struct tracefs_dynevent pass:[*]pass:[*]_event
 struct tracefs_dynevent pass:[*]*tracefs_dynevent_get*(enum tracefs_dynevent_type _type_, const char pass:[*]_system_, const char pass:[*]_event_);
 struct tracefs_dynevent pass:[*]pass:[*]*tracefs_dynevent_get_all*(unsigned int _types_, const char pass:[*]_system_);
 enum tracefs_dynevent_type *tracefs_dynevent_info*(struct tracefs_dynevent pass:[*]_dynevent_, char pass:[*]pass:[*]_system_, char pass:[*]pass:[*]_event_, char pass:[*]pass:[*]_prefix_, char pass:[*]pass:[*]_addr_, char pass:[*]pass:[*]_format_);
+struct tep_event pass:[*]*tracefs_dynevent_get_event*(struct tep_handle pass:[*]_tep_, struct tracefs_dynevent pass:[*]_dynevent_);
 --
 
 DESCRIPTION
@@ -68,6 +69,10 @@ if relevant for this event type. If _format_ is non NULL, it will hold the forma
 dynamic event. Note, that the content in _group_, _event_, _prefix_, _addr_, and _format_ must be
 freed with free(3) if they are set.
 
+The *tracefs_dynevent_get_event*() function returns a tep event, describing the given dynamic event.
+The API detects any newly created or removed dynamic events. The returned pointer to tep event is
+controlled by @tep and must not be freed.
+
 RETURN VALUE
 ------------
 
@@ -88,6 +93,10 @@ in case of an error or in case there are no events in the system. That array mus
 on error. If _system_, _event_, _prefix_, _addr_, or _format_ are non NULL, they will contain
 allocated strings that must be freed by free(3).
 
+The *tracefs_dynevent_get_event*() function returns a pointer to a tep event or NULL in case of an
+error or if the requested dynamic event is missing. The returned pointer to tep event is controlled
+by @tep and must not be freed.
+
 ERRORS
 ------
 The following errors are for all the above calls:
diff --git a/include/tracefs.h b/include/tracefs.h
index c9ebaa6..383974b 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -262,6 +262,8 @@ tracefs_dynevent_get(enum tracefs_dynevent_type type, const char *system, const
 enum tracefs_dynevent_type
 tracefs_dynevent_info(struct tracefs_dynevent *dynevent, char **system,
 		      char **event, char **prefix, char **addr, char **format);
+struct tep_event *
+tracefs_dynevent_get_event(struct tep_handle *tep, struct tracefs_dynevent *dynevent);
 
 struct tracefs_dynevent *
 tracefs_eprobe_alloc(const char *system, const char *event,
diff --git a/src/tracefs-dynevents.c b/src/tracefs-dynevents.c
index ea07d13..d089d02 100644
--- a/src/tracefs-dynevents.c
+++ b/src/tracefs-dynevents.c
@@ -752,3 +752,36 @@ error:
 
 	return TRACEFS_DYNEVENT_UNKNOWN;
 }
+
+/**
+ * tracefs_dynevent_get_event - return tep event representing the given dynamic event
+ * @tep: a handle to the trace event parser context that holds the events
+ * @dynevent: a dynamic event context, describing given dynamic event.
+ *
+ * Returns a pointer to a tep event describing the given dynamic event. The pointer
+ * is managed by the @tep handle and must not be freed. In case of an error, or in case
+ * the requested dynamic event is missing in the @tep handler - NULL is returned.
+ */
+struct tep_event *
+tracefs_dynevent_get_event(struct tep_handle *tep, struct tracefs_dynevent *dynevent)
+{
+	struct tep_event *event;
+
+	if (!tep || !dynevent || !dynevent->event)
+		return NULL;
+
+	/* Check if event exists in the system */
+	if (!tracefs_event_file_exists(NULL, dynevent->system, dynevent->event, "format"))
+		return NULL;
+
+	/* If the dynamic event is already loaded in the tep, return it */
+	event = tep_find_event_by_name(tep, dynevent->system, dynevent->event);
+	if (event)
+		return event;
+
+	/* Try to load any new events from the given system */
+	if (trace_rescan_events(tep, NULL, dynevent->system))
+		return NULL;
+
+	return tep_find_event_by_name(tep, dynevent->system, dynevent->event);
+}
-- 
2.33.1

