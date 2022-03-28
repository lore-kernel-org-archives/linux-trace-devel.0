Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04D5FC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 28 Mar 2022 09:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239631AbiC1JFg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 28 Mar 2022 05:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239028AbiC1JFe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 28 Mar 2022 05:05:34 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC4F76348
        for <linux-trace-devel@vger.kernel.org>; Mon, 28 Mar 2022 02:03:52 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id bi12so27270384ejb.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 28 Mar 2022 02:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kBhj0/NEgUimxIMkQ24jodTD6TZd71mZRuPIpmP3CmE=;
        b=mkuzrO1PUSmQKulmFByfKpqCFKlRbwX1rQRDw71N5SPjGcuNbdJwXK28cLMCjEMUuh
         6PFrl03X0OKb056vdbHZbrvpS1N6NlE9yJkDrfKNnMkTmosYEw9m99TbAgzzNZO/Xa8G
         W1JV0pBZ+cMThz9moY8++DtzCGKHZAOqSEgXXgqgjzkgtUP0o1XGq99n9JiWJtKKeANS
         dm7swNc3DDgNf3WTtAjivrtJLsitwaxAh3+svVnj56JcAbJJxCEhFPoiFKuGB7gKQMu3
         RgXBA4c5rUoboQjv6D/xLFhHDvKSUOOXctMOY1ny/2LXLROXT6va19YjBRFnihxkskaL
         Z4Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kBhj0/NEgUimxIMkQ24jodTD6TZd71mZRuPIpmP3CmE=;
        b=NgcYGzeaMdtOAY+dH4YQAz2RWlWgmGiUQWaSvG/CX2z3onA1u2r/JTeixrm18wHBOX
         Ir9808cT3Y+6KJ0j+Aegj7GXQDb3YpWk08IIFivcHFyshN2BsAHfBi6pK4bpdX7ecwoS
         7OYedeIWDcyuJBCvAZe99nS+70UtYGZLxHoVXeFshY6jIwKyXmbTv/QzdzCnn/+OyBf1
         NufgvGIvVfn4gfDCqT3QOuMZ9OhL1y4wUSFjlI7jJB9a/up4DbZk2c6znYFYcpXQaRBv
         vsw3pdbboetIWYibilf7h1LH5C5YGHRVT7NT6cJheaSV/gFmJk5CV5Y/RodVFGjCrzHs
         Gn2Q==
X-Gm-Message-State: AOAM530L84zlmYdKjorCr+e2MALaPiuey+OECDjWqM2Mr+yFmMHh2Onr
        R2R229ClHFFMbFCGThWKBUixSO7WE5E=
X-Google-Smtp-Source: ABdhPJyOPdeaWH48XnZKRpjFIFRbceNWjXp9UmqPeQF8sPT3wqf6cMWHy2Uy83VdVs4WIKhrXnDBew==
X-Received: by 2002:a17:906:9c8e:b0:6df:f6bf:7902 with SMTP id fj14-20020a1709069c8e00b006dff6bf7902mr26317365ejc.191.1648458231357;
        Mon, 28 Mar 2022 02:03:51 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id dm11-20020a170907948b00b006cf488e72e3sm5647973ejc.25.2022.03.28.02.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 02:03:50 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/3] libtracefs: New APIs for ftrace uprobes
Date:   Mon, 28 Mar 2022 12:03:45 +0300
Message-Id: <20220328090347.107849-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220328090347.107849-1-tz.stoyanov@gmail.com>
References: <20220328090347.107849-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The tracefs library has APIs for allocating almost all types of ftrace
dynamic events. Uprobe is the only dynamic event that has no
corresponding tracefs API. These two APIs are proposed:
 tracefs_uprobe_alloc()
 tracefs_uretprobe_alloc()
They allocate context for new uprobe/uretprobe, without creating events
in the system. The regular dynamic events APIs can be used to work with
newly created uprobes.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs.h     |  6 +++
 src/Makefile          |  1 +
 src/tracefs-uprobes.c | 90 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 97 insertions(+)
 create mode 100644 src/tracefs-uprobes.c

diff --git a/include/tracefs.h b/include/tracefs.h
index 05f3352..27954a4 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -280,6 +280,12 @@ tracefs_dynevent_get_event(struct tep_handle *tep, struct tracefs_dynevent *dyne
 struct tracefs_dynevent *
 tracefs_eprobe_alloc(const char *system, const char *event,
 		     const char *target_system, const char *target_event, const char *fetchargs);
+struct tracefs_dynevent *
+tracefs_uprobe_alloc(const char *system, const char *event,
+		     const char *file, unsigned long long offset, const char *fetchargs);
+struct tracefs_dynevent *
+tracefs_uretprobe_alloc(const char *system, const char *event,
+			const char *file, unsigned long long offset, const char *fetchargs);
 
 struct tracefs_dynevent *
 tracefs_kprobe_alloc(const char *system, const char *event, const char *addr, const char *format);
diff --git a/src/Makefile b/src/Makefile
index e8afab5..645d518 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -13,6 +13,7 @@ OBJS += tracefs-hist.o
 OBJS += tracefs-filter.o
 OBJS += tracefs-dynevents.o
 OBJS += tracefs-eprobes.o
+OBJS += tracefs-uprobes.o
 
 # Order matters for the the three below
 OBJS += sqlhist-lex.o
diff --git a/src/tracefs-uprobes.c b/src/tracefs-uprobes.c
new file mode 100644
index 0000000..aa39b75
--- /dev/null
+++ b/src/tracefs-uprobes.c
@@ -0,0 +1,90 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2022, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ *
+ */
+#include <stdlib.h>
+#include <errno.h>
+
+#include "tracefs.h"
+#include "tracefs-local.h"
+
+#define UPROBE_DEFAULT_GROUP "uprobes"
+
+static struct tracefs_dynevent *
+uprobe_alloc(enum tracefs_dynevent_type type, const char *system, const char *event,
+	     const char *file, unsigned long long offset, const char *fetchargs)
+{
+	struct tracefs_dynevent *kp;
+	char *target;
+
+	if (!event || !file) {
+		errno = EINVAL;
+		return NULL;
+	}
+
+	if (!system)
+		system = UPROBE_DEFAULT_GROUP;
+
+	if (asprintf(&target, "%s:0x%0*llx", file, (int)(sizeof(void *) * 2), offset) < 0)
+		return NULL;
+
+	kp = dynevent_alloc(type, system, event, target, fetchargs);
+	free(target);
+
+	return kp;
+}
+
+/**
+ * tracefs_uprobe_alloc - Allocate new user probe (uprobe)
+ * @system: The system name (NULL for the default uprobes)
+ * @event: The name of the event to create
+ * @file: The full path to the binary file, where the uprobe will be set
+ * @offset: Offset within the @file
+ * @fetchargs: String with arguments, that will be fetched with the uprobe
+ *
+ * Allocate new uprobe context that will be in the @system group
+ * (or uprobes if @system is NULL) and with @event name. The new uprobe will be
+ * attached to @offset within the @file. The arguments described in @fetchargs
+ * will fetched with the uprobe. See linux/Documentation/trace/uprobetracer.rst
+ * for more details.
+ *
+ * The uprobe is not created in the system.
+ *
+ * Return a pointer to a uprobe context on success, or NULL on error.
+ * The returned pointer must be freed with tracefs_dynevent_free()
+ *
+ */
+struct tracefs_dynevent *
+tracefs_uprobe_alloc(const char *system, const char *event,
+		     const char *file, unsigned long long offset, const char *fetchargs)
+{
+	return uprobe_alloc(TRACEFS_DYNEVENT_UPROBE, system, event, file, offset, fetchargs);
+}
+
+/**
+ * tracefs_uretprobe_alloc - Allocate new user return probe (uretprobe)
+ * @system: The system name (NULL for the default uprobes)
+ * @event: The name of the event to create
+ * @file: The full path to the binary file, where the uretprobe will be set
+ * @offset: Offset within the @file
+ * @fetchargs: String with arguments, that will be fetched with the uretprobe
+ *
+ * Allocate mew uretprobe context that will be in the @system group
+ * (or uprobes if @system is NULL) and with @event name. The new uretprobe will
+ * be attached to @offset within the @file. The arguments described in @fetchargs
+ * will fetched with the uprobe. See linux/Documentation/trace/uprobetracer.rst
+ * for more details.
+ *
+ * The uretprobe is not created in the system.
+ *
+ * Return a pointer to a uretprobe context on success, or NULL on error.
+ * The returned pointer must be freed with tracefs_dynevent_free()
+ *
+ */
+struct tracefs_dynevent *
+tracefs_uretprobe_alloc(const char *system, const char *event,
+			const char *file, unsigned long long offset, const char *fetchargs)
+{
+	return uprobe_alloc(TRACEFS_DYNEVENT_URETPROBE, system, event, file, offset, fetchargs);
+}
-- 
2.35.1

