Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90340C433DB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Jan 2021 09:21:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52F5E22E03
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Jan 2021 09:21:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731388AbhALJVN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Jan 2021 04:21:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390337AbhALJVM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Jan 2021 04:21:12 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9327C06179F
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Jan 2021 01:20:31 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id e18so1024245ejt.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Jan 2021 01:20:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tUQ0teJNmXs4LnMIulH/DxSFSPK5bzfPxMGc5g6wftw=;
        b=oOWYc4lI8VRlVrr6MNGCoResg3EP+TRP4oLSmURknbqa6PGRGmCyB9qSkivrKHs+nL
         UN6NcHQ/D6qn02jhdUzECtiNgHoigxyUgWk21yGi9NMvvGthTjv7KUZ+g8g+/dhm3XD2
         28jhTtINABKtc9spATrWwrqGKiLnH/Z2G9JxGK1JRo0jjy6wCpitRC2SeegE/5HvFPDE
         2eIbBjkaBK4kWG5u49XkpkDF/4VYvJ5ZN/1+94lA6ktOLSFCRYBp9DUM+vXBLASbiwrA
         tR3BRU87sXtBtnhE6PkfEGVWtK/nYa8NVTBSOhD31B7omb0fTwsXSq0JTSW/VH6V3Ni8
         vrJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tUQ0teJNmXs4LnMIulH/DxSFSPK5bzfPxMGc5g6wftw=;
        b=XQ94pLNrWb/gcxhnNxRzp3YE9yVJED5knQ78+8pw97+yRcwRYpYcqZKv1VvYa3YcbC
         0rE9ZLw7R/M1bV9D/XiXBK6lUuNS3z9/MPS7eH6PSlOJvrJD+n1MBWmBKlUye46H8yxI
         LKJyq3bl5Gj+7CzCJy0KwODA8KrpQfb9mKRVvrdceKQZYBli6oyrZQS47bGufGjRCrUM
         e9p4b5s4t5Y0zsly+wn12uj8Sfwl6rSLmD4gxBE2L99sLfUyfq5hUujMgMehWVoZl6Ep
         eZNtrh2bd626KLNYV1ojCYUFL+AAFwNB5BPI9R32Cb4avfFpBQsmJrHg/nVkBn/P7hwm
         uPsA==
X-Gm-Message-State: AOAM533a5Yiq82vIopSqXsTW51LLEG2i046pOUgFehlGdOs98IzeG5AK
        lqBlYo0reLY8uHbsiyZbM94YEymDMfJt0D94
X-Google-Smtp-Source: ABdhPJwLomWrkcKCj2AE4bZoNNgDgD0Toepr3oXMKrvYmpyLL466zCN7cAe6QKAJNIjLgkRjUja2YQ==
X-Received: by 2002:a17:906:2257:: with SMTP id 23mr2602160ejr.497.1610443230465;
        Tue, 12 Jan 2021 01:20:30 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id rl7sm929187ejb.107.2021.01.12.01.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 01:20:29 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 3/7] libtracefs: New APIs for enable / disable tracing
Date:   Tue, 12 Jan 2021 11:20:20 +0200
Message-Id: <20210112092024.605705-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210112092024.605705-1-tz.stoyanov@gmail.com>
References: <20210112092024.605705-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

These new APIs can be used to enable / disable tracing in given ftrace
instance:
  tracefs_trace_is_on();
  tracefs_trace_on();
  tracefs_trace_off();
  tracefs_trace_on_get_fd();
  tracefs_trace_on_fd();
  tracefs_trace_off_fd();

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs.h   |  18 ++++++++
 src/Makefile        |   1 +
 src/tracefs-tools.c | 109 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 128 insertions(+)
 create mode 100644 src/tracefs-tools.c

diff --git a/include/tracefs.h b/include/tracefs.h
index bec8369..85a776e 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -40,6 +40,24 @@ bool tracefs_instance_exists(const char *name);
 bool tracefs_file_exists(struct tracefs_instance *instance, char *name);
 bool tracefs_dir_exists(struct tracefs_instance *instance, char *name);
 
+int tracefs_trace_is_on(struct tracefs_instance *instance);
+int tracefs_trace_on(struct tracefs_instance *instance);
+int tracefs_trace_off(struct tracefs_instance *instance);
+int tracefs_trace_on_fd(int fd);
+int tracefs_trace_off_fd(int fd);
+
+/**
+ * tracefs_trace_on_get_fd - Get a file descriptor of "tracing_on" in given instance
+ * @instance: ftrace instance, can be NULL for the top instance
+ *
+ * Returns -1 in case of an error, or a valid file descriptor to "tracing_on"
+ * file for reading and writing.The returned FD must be closed with close().
+ */
+static inline int tracefs_trace_on_get_fd(struct tracefs_instance *instance)
+{
+	return tracefs_instance_file_open(instance, "tracing_on", O_RDWR);
+}
+
 /* events */
 void tracefs_list_free(char **list);
 char **tracefs_event_systems(const char *tracing_dir);
diff --git a/src/Makefile b/src/Makefile
index 3f64905..dabdbb4 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -6,6 +6,7 @@ OBJS =
 OBJS += tracefs-utils.o
 OBJS += tracefs-instance.o
 OBJS += tracefs-events.o
+OBJS += tracefs-tools.o
 
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
 DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
new file mode 100644
index 0000000..101f389
--- /dev/null
+++ b/src/tracefs-tools.c
@@ -0,0 +1,109 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2008, 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ *
+ * Updates:
+ * Copyright (C) 2021, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ *
+ */
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+
+#include "tracefs.h"
+#include "tracefs-local.h"
+
+#define TRACE_CTRL	"tracing_on"
+
+static int trace_on_off(int fd, bool on)
+{
+	const char *val = on ? "1" : "0";
+	int ret;
+
+	ret = write(fd, val, 1);
+	if (ret == 1)
+		return 0;
+
+	return -1;
+}
+
+static int trace_on_off_file(struct tracefs_instance *instance, bool on)
+{
+	int ret;
+	int fd;
+
+	fd = tracefs_instance_file_open(instance, TRACE_CTRL, O_WRONLY);
+	if (fd < 0)
+		return -1;
+	ret = trace_on_off(fd, on);
+	close(fd);
+
+	return ret;
+}
+
+/**
+ * tracefs_trace_is_on - Check if writing traces to the ring buffer is enabled
+ * @instance: ftrace instance, can be NULL for the top instance
+ *
+ * Returns -1 in case of an error, 0 if tracing is disable or 1 if tracing
+ * is enabled.
+ */
+int tracefs_trace_is_on(struct tracefs_instance *instance)
+{
+	long long res;
+
+	if (tracefs_instance_file_read_number(instance, TRACE_CTRL, &res) == 0)
+		return (int)res;
+
+	return -1;
+}
+
+/**
+ * tracefs_trace_on - Enable writing traces to the ring buffer of the given instance
+ * @instance: ftrace instance, can be NULL for the top instance
+ *
+ * Returns -1 in case of an error or 0 otherwise
+ */
+int tracefs_trace_on(struct tracefs_instance *instance)
+{
+	return trace_on_off_file(instance, true);
+}
+
+/**
+ * tracefs_trace_off - Disable writing traces to the ring buffer of the given instance
+ * @instance: ftrace instance, can be NULL for the top instance
+ *
+ * Returns -1 in case of an error or 0 otherwise
+ */
+int tracefs_trace_off(struct tracefs_instance *instance)
+{
+	return trace_on_off_file(instance, false);
+}
+
+/**
+ * tracefs_trace_on_fd - Enable writing traces to the ring buffer
+ * @fd: File descriptor to ftrace tracing_on file, previously opened
+ *	with tracefs_trace_on_get_fd()
+ *
+ * Returns -1 in case of an error or 0 otherwise
+ */
+int tracefs_trace_on_fd(int fd)
+{
+	if (fd < 0)
+		return -1;
+	return trace_on_off(fd, true);
+}
+
+/**
+ * tracefs_trace_off_fd - Disable writing traces to the ring buffer
+ * @fd: File descriptor to ftrace tracing_on file, previously opened
+ *	with tracefs_trace_on_get_fd()
+ *
+ * Returns -1 in case of an error or 0 otherwise
+ */
+int tracefs_trace_off_fd(int fd)
+{
+	if (fd < 0)
+		return -1;
+	return trace_on_off(fd, false);
+}
-- 
2.29.2

