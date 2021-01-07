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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1322C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 08:33:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 640C120738
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 08:33:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbhAGIdh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Jan 2021 03:33:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbhAGIdg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Jan 2021 03:33:36 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386ECC0612F8
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Jan 2021 00:32:56 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id g185so4777492wmf.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Jan 2021 00:32:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TWpP65YDCc1mQUdLFjkYo9gs89cZKkr/iPV7lbXlSyE=;
        b=ZjJ8+wE7ADzPRYor1BkGq1Wq/ELn+SU88CG4Bt1DvasW0pdCs8P6VlS1MyAlGEyr7k
         L9daOfOdG9HqHTzD2zgeRf9QlhPRhyMtzkO8XxsrmGC+PBuD9zmSpk+KEpfttIlO5IRg
         IrJauSmSnorUCgZxnV1ePs0hfWJkvhbGYQqMHQhYoQFM3AsyP7U+2JRmRrxHcC/FjO1t
         R4c06sO8nKBHE7ONsiGjDJynkJ8gsTN85y2cQAQDRFRu51uqCwGsLU7qokynhwfaqP0P
         /ORLAn4/VKBNbI0b7Y62ardAIfDdCmAKKhnicOcEykV4tbqkDK0v2fL21N5xTc5t1Fjh
         8mIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TWpP65YDCc1mQUdLFjkYo9gs89cZKkr/iPV7lbXlSyE=;
        b=m8FVL0yHVuD1839uv5NcsT05Yzn1VGn7EijZ2tc1QXOnhNsUN/pOHDfMHMd22yN82f
         CHRFx08Xhbp60jYa1L9pVG4vZ1rnF074QxEC2gKGGRBYu5uqVYo2IiNO3egkqgU3eMtv
         FBko12in+oMjs0iP8T5100MC959LDH7V9W8mNSTAIMEM/XGJTUROZg21Dsxh2kWVo4W/
         cnMSjHy1EB2Qn6F9g6UNygjx+d5iM+g8FSH1hi6UMMQkk2rJxWOn0vSW2qV1JcdNvXUS
         e/DGFKlLuv/SqiX0eeZ9qf73+BQwLmOM8O1Y3nwBlBNEO8MQ0BiXuHCgLf6cxMHmz+eV
         SkSA==
X-Gm-Message-State: AOAM533jqkfauGKCBZz9R9Rg3XC2Ba1aAsuINww5RcrZrWkq/xpl2jX2
        Ayu9v9cvO/047+Cmpva16Mv1NoZEOkHw96rK
X-Google-Smtp-Source: ABdhPJzZ+VK3dXb5+9fu612ksIlbXVz9azaxgbLHKzgoyF9341g6Xp4y/ku8Coz2Z2adsCaCg8iKfg==
X-Received: by 2002:a1c:e142:: with SMTP id y63mr7228593wmg.28.1610008375023;
        Thu, 07 Jan 2021 00:32:55 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v20sm7293867wra.19.2021.01.07.00.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 00:32:54 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/6] libtracefs: New APIs for enable / disable tracing
Date:   Thu,  7 Jan 2021 10:32:46 +0200
Message-Id: <20210107083250.16295-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107083250.16295-1-tz.stoyanov@gmail.com>
References: <20210107083250.16295-1-tz.stoyanov@gmail.com>
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
  tracefs_trace_on_fd();
  tracefs_trace_off_fd();

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs.h   |   6 +++
 src/Makefile        |   1 +
 src/tracefs-tools.c | 123 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 130 insertions(+)
 create mode 100644 src/tracefs-tools.c

diff --git a/include/tracefs.h b/include/tracefs.h
index 460fa4c..bc799c7 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -40,6 +40,12 @@ bool tracefs_instance_exists(const char *name);
 bool tracefs_file_exists(struct tracefs_instance *instance, char *name);
 bool tracefs_dir_exists(struct tracefs_instance *instance, char *name);
 
+int tracefs_trace_is_on(struct tracefs_instance *instance);
+int tracefs_trace_on(struct tracefs_instance *instance);
+int tracefs_trace_off(struct tracefs_instance *instance);
+int tracefs_trace_on_fd(int fd);
+int tracefs_trace_off_fd(int fd);
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
index 0000000..89e2d6d
--- /dev/null
+++ b/src/tracefs-tools.c
@@ -0,0 +1,123 @@
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
+	int ret;
+
+	if (on)
+		ret = write(fd, "1", 1);
+	else
+		ret = write(fd, "0", 1);
+
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
+	char buf[10];
+	int ret;
+	int fd;
+
+	fd = tracefs_instance_file_open(instance, TRACE_CTRL, O_RDONLY);
+	if (fd < 0)
+		return -1;
+	ret = read(fd, buf, 10);
+	if (ret > 0) {
+		buf[9] = 0;
+		ret = atoi(buf);
+	} else {
+		ret = -1;
+	}
+	close(fd);
+
+	return ret;
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
+ * @fd: File descriptor to ftrace tracing_on file, previously opened for reading
+ *	with tracefs_instance_file_open()
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
+ * @fd: File descriptor to ftrace tracing_on file, previously opened for reading
+ *	with tracefs_instance_file_open()
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

