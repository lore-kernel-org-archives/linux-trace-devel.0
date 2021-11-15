Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E55C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Nov 2021 10:46:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0FC663218
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Nov 2021 10:46:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbhKOKtq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Nov 2021 05:49:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237490AbhKOKtM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Nov 2021 05:49:12 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 304D8C061746
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Nov 2021 02:46:16 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id z10so43324128edc.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Nov 2021 02:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h78QeBEEovORBF/16T7O3ZByWmCzMq5HwgKLnG/R2k4=;
        b=OSmSNSXtjnhARUcroPhjqt3uynSVpU3V132WntnN1qFxjFVpKmpOYsW1fPPAnRuxZh
         amnLZwKGhM2R3dbIVsLs+qecVj6cH4Zum9bQblWGNinArjw8pJC7d4tKmOMkROZXiNfY
         WHnzzJt9xtET0O/YVqkJlgqjB4kBqGQAiw6B4LZtDsUoS63sHyO1ikjCc3/LLM1xjxyX
         6+jhXl9OqiKiklaZwcPnKdxJnqqMeLeIiCmwIqUbz7CjYj5CQ/wsugK88vCKL3sClKCw
         85EcR5PwBZxbBq5PyB8PhX5bfORotIV6K2LgrWpl0L54VnuSyg0XMH6osMXoU3bNJDpA
         5aMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h78QeBEEovORBF/16T7O3ZByWmCzMq5HwgKLnG/R2k4=;
        b=kuFK2tmHhdCPk5oaZlR/+gJDGW03Cwk864C5qRaRLDEG1wcPYCxIIrOr4GS0mVz4Id
         rC8UKzM85l67M/RG1cT8zKYDJwz5Xbh79C6HzqXuzzhRgyss7vwVQjqIJDotf3dseyH6
         IgekqtUw1yx5fgZGUdfBWQGNmA8hhL333SW8mPQT3yGTDx8JV4B8aX6ZkPcXipu+S0/K
         Q220zIXGvJsdI69OkTX15egGCB7j0BskPvNKunB4p22DHIWIHw+Hh/E1RoqoVsBmM16A
         eJcBh0gBniXGWIZIouPZMrbQa42f2UxXsySlXcquL/3eLaIF4O15rZJLx+MpTrw1NCC1
         MpVw==
X-Gm-Message-State: AOAM532iYLk7iqi6nK+/Vn5hG9cZldStEDQYe+M+BHU1GWG4RmoahSso
        BT2WpDl1a0vyUPKHQhWJjXs=
X-Google-Smtp-Source: ABdhPJwAvmR9nkKj9GQJrj+NIrSte+1ouCvX9DrCzkhnEHqcdoBQ2xHYZKSM269HwJG4v2Dbo4ZHlw==
X-Received: by 2002:a17:906:478e:: with SMTP id cw14mr47272266ejc.46.1636973174771;
        Mon, 15 Nov 2021 02:46:14 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e12sm6315509ejs.86.2021.11.15.02.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 02:46:14 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 13/15] libtracefs: Introduce eprobe API
Date:   Mon, 15 Nov 2021 12:45:54 +0200
Message-Id: <20211115104556.121359-14-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115104556.121359-1-tz.stoyanov@gmail.com>
References: <20211115104556.121359-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Recently a new type of dynamic trace events was added in the Linux
kernel - event probes. Tracefs library should have APIs to work with
that event. As this is a dynamic event, all tracefs_dynevent_* APIs can
be used to control event probes. Only one new API is proposed:
 tracefs_eprobe_alloc()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs.h     |  4 ++++
 src/Makefile          |  1 +
 src/tracefs-eprobes.c | 56 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+)
 create mode 100644 src/tracefs-eprobes.c

diff --git a/include/tracefs.h b/include/tracefs.h
index 7b3f92b..4431ec7 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -261,6 +261,10 @@ enum tracefs_dynevent_type
 tracefs_dynevent_info(struct tracefs_dynevent *dynevent, char **system,
 		      char **event, char **prefix, char **addr, char **format);
 
+struct tracefs_dynevent *
+tracefs_eprobe_alloc(const char *system, const char *event,
+		     const char *target_system, const char *target_event, const char *fetchargs);
+
 struct tracefs_dynevent *
 tracefs_kprobe_alloc(const char *system, const char *event, const char *addr, const char *format);
 struct tracefs_dynevent *
diff --git a/src/Makefile b/src/Makefile
index 99cd7da..cda0a0c 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -12,6 +12,7 @@ OBJS += tracefs-kprobes.o
 OBJS += tracefs-hist.o
 OBJS += tracefs-filter.o
 OBJS += tracefs-dynevents.o
+OBJS += tracefs-eprobes.o
 
 # Order matters for the the three below
 OBJS += sqlhist-lex.o
diff --git a/src/tracefs-eprobes.c b/src/tracefs-eprobes.c
new file mode 100644
index 0000000..cc25f8e
--- /dev/null
+++ b/src/tracefs-eprobes.c
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2021, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ *
+ */
+#include <stdlib.h>
+#include <errno.h>
+
+#include "tracefs.h"
+#include "tracefs-local.h"
+
+#define EPROBE_DEFAULT_GROUP "eprobes"
+
+/**
+ * tracefs_eprobe_alloc - Allocate new eprobe
+ * @system: The system name (NULL for the default eprobes)
+ * @event: The name of the event to create
+ * @target_system: The system of the target event
+ * @target_event: The name of the target event
+ * @fetchargs: String with arguments, that will be fetched from @target_event
+ *
+ * Allocate an eprobe context that will be in the @system group (or eprobes if
+ * @system is NULL). Have the name of @event. The new eprobe will be attached to
+ * given @target_event which is in the given @target_system. The arguments
+ * described in @fetchargs will fetched from the @target_event.
+ *
+ * The eprobe is not created in the system.
+ *
+ * Return a pointer to a eprobe context on success, or NULL on error.
+ * The returned pointer must be freed with tracefs_dynevent_free()
+ *
+ */
+struct tracefs_dynevent *
+tracefs_eprobe_alloc(const char *system, const char *event,
+		     const char *target_system, const char *target_event, const char *fetchargs)
+{
+	struct tracefs_dynevent *kp;
+	char *target;
+
+	if (!event || !target_system || !target_event) {
+		errno = EINVAL;
+		return NULL;
+	}
+
+	if (!system)
+		system = EPROBE_DEFAULT_GROUP;
+
+	if (asprintf(&target, "%s.%s", target_system, target_event) < 0)
+		return NULL;
+
+	kp = dynevent_alloc(TRACEFS_DYNEVENT_EPROBE, system, event, target, fetchargs);
+	free(target);
+
+	return kp;
+}
+
-- 
2.33.1

