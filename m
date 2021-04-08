Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2D4BC433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 08:08:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B90B461158
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 08:08:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbhDHIIf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 04:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhDHIIf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 04:08:35 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727D2C061760
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Apr 2021 01:08:24 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id r9so1509454ejj.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 08 Apr 2021 01:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z0Zw0OBuy4ujnpRsbgfJSZ6rZQNoTkdKuPMYKSgA2iw=;
        b=IoWsbR6ruBwwXiopONPPdTw9WRS/bNDVNXVWMSWlTOHGeHVm0ki/vZvb/32on238FA
         JlQEVmvJ7RkI9ntHTKuD/XwGsyvuoX0Few86Wzw4aZNtnNm8usbMmn8f760gur463KzN
         JeXELA4/f+4r9kMyRjEHb5wR5S5y/AySuEqZHtKSDK4bm3zICE7G6Km7H2N6pGmh8yUj
         9h2alqymdE2M0OxGiU2CbSb5LR4HDqQZhwqqc0kJGeiAuodGjadgCuOj/8PLt4JONkln
         +9CCLwKZnnF/Z7/QSUFLRTVDm0NLGANylR3y6LpLp0SdOMGeFnThcHoRXvy0As7Llnkr
         Z+YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z0Zw0OBuy4ujnpRsbgfJSZ6rZQNoTkdKuPMYKSgA2iw=;
        b=FZ5UKBf3NXgVKhXga1jkFQcBVNM6kRHMXfLIotADCZ8watjdBWbfJ/bdzBOtk2/E6r
         Hue544P7f20LKvgXmh6oL67kMEVO6GOVwWW/6MuEBctOXHSKfq7W9LmwcVp2HfogEgvN
         AvS9GJAFoapMMsq2+QjVL7QM6ibSgPLT/snBH6MQVqrQ50n8UwtAcIyWTqCyIIroi8M7
         OyQhNUgRGpc+5Kl2KpKobliZfTY35Vi645ouvJrKSEE31UcvJPPikauw9djKO+lRYXsO
         GQiP++dZ1ScuHGe8g/wHEYdxibKQcDxGxjfUdXTYQPTo/EGgDe9dfYXXrUAQ8mgcAQ6j
         BvYg==
X-Gm-Message-State: AOAM5338EI00znRoJXd2gPIXKePli70aPcFelmC5TXcIFQe+9EPQ8ywE
        4pTBdud6ef/9YxvlREX8HXpwMqAaD5M2GQ==
X-Google-Smtp-Source: ABdhPJwSNlIqm+CuEwuDfV5yGTU+XJuOjCGoGdVYQL1frPpX2IPs0vA/WHXSpnRwjfWgFqbMPnFWzQ==
X-Received: by 2002:a17:907:11c2:: with SMTP id va2mr4995369ejb.86.1617869303224;
        Thu, 08 Apr 2021 01:08:23 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gb4sm13804741ejc.122.2021.04.08.01.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 01:08:22 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] libtracefs: Add new API for open trace marker file
Date:   Thu,  8 Apr 2021 11:08:21 +0300
Message-Id: <20210408080821.3129896-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added new APIs for opening trace_marker file of given instance:
   tracefs_marker_init()
   tracefs_marker_write()
   tracefs_marker_vprint()
   tracefs_marker_print()
   tracefs_marker_close()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
Apply on top of "libtracefs: Update filtering functions"
https://lore.kernel.org/linux-trace-devel/20210407202126.1870994-1-rostedt@goodmis.org/

v2 changes:
 - Added set of new APIs, instead of the previously proposed API for just
   opening the file.

 include/tracefs-local.h |   1 +
 include/tracefs.h       |   9 +++
 src/Makefile            |   1 +
 src/tracefs-instance.c  |   3 +
 src/tracefs-marker.c    | 129 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 143 insertions(+)
 create mode 100644 src/tracefs-marker.c

diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index 6865611..6657b6f 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -21,6 +21,7 @@ struct tracefs_instance {
 	int			flags;
 	int			ftrace_filter_fd;
 	int			ftrace_notrace_fd;
+	int			ftrace_marker_fd;
 };
 
 extern pthread_mutex_t toplevel_lock;
diff --git a/include/tracefs.h b/include/tracefs.h
index 70b7ebe..9adcf07 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -63,6 +63,15 @@ static inline int tracefs_trace_on_get_fd(struct tracefs_instance *instance)
 	return tracefs_instance_file_open(instance, "tracing_on", O_RDWR);
 }
 
+/* trace marker */
+int tracefs_marker_init(struct tracefs_instance *instance);
+int tracefs_marker_print(struct tracefs_instance *instance,
+			 const char *fmt, ...);
+int tracefs_marker_vprint(struct tracefs_instance *instance,
+			   const char *fmt, va_list ap);
+int tracefs_marker_write(struct tracefs_instance *instance, void *data, int len);
+void tracefs_marker_close(struct tracefs_instance *instance);
+
 /* events */
 void tracefs_list_free(char **list);
 char **tracefs_event_systems(const char *tracing_dir);
diff --git a/src/Makefile b/src/Makefile
index dabdbb4..b4cff07 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -7,6 +7,7 @@ OBJS += tracefs-utils.o
 OBJS += tracefs-instance.o
 OBJS += tracefs-events.o
 OBJS += tracefs-tools.o
+OBJS += tracefs-marker.o
 
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
 DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index 599c3a7..90e35b4 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -49,6 +49,7 @@ static struct tracefs_instance *instance_alloc(const char *trace_dir, const char
 
 	instance->ftrace_filter_fd = -1;
 	instance->ftrace_notrace_fd = -1;
+	instance->ftrace_marker_fd = -1;
 
 	return instance;
 
@@ -74,6 +75,8 @@ void tracefs_instance_free(struct tracefs_instance *instance)
 	free(instance->trace_dir);
 	free(instance->name);
 	pthread_mutex_destroy(&instance->lock);
+	if (instance->ftrace_marker_fd >= 0)
+		close(instance->ftrace_marker_fd);
 	free(instance);
 }
 
diff --git a/src/tracefs-marker.c b/src/tracefs-marker.c
new file mode 100644
index 0000000..92d55f8
--- /dev/null
+++ b/src/tracefs-marker.c
@@ -0,0 +1,129 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2021, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ *
+ */
+
+#include <stdlib.h>
+#include <unistd.h>
+#include <stdio.h>
+
+#include "tracefs.h"
+#include "tracefs-local.h"
+
+/* File descriptor for Top level trace_marker */
+static int ftrace_marker_fd = -1;
+
+/**
+ * tracefs_marker_init - Open trace_marker file of selected instance for writing
+ * @instance: ftrace instance, can be NULL for top tracing instance.
+ *
+ * Returns 0 if the trace_marker is opened successfully, or -1 in case of an error
+ */
+int tracefs_marker_init(struct tracefs_instance *instance)
+{
+	int *fd = instance ? &instance->ftrace_marker_fd : &ftrace_marker_fd;
+
+	if (*fd >= 0)
+		return 0;
+	*fd = tracefs_instance_file_open(instance, "trace_marker", O_WRONLY);
+
+	return *fd < 0 ? -1 : 0;
+}
+
+/**
+ * tracefs_marker_write - Write binary data in the trace marker
+ * @instance: ftrace instance, can be NULL for top tracing instance.
+ * @data: binary data, that is going to be written in the trace marker
+ * @len: length of the @data
+ *
+ * If the trace marker file of the desired instance is not open already,
+ * this API will open it for writing. The file will stay open until
+ * tracefs_marker_close() is called.
+ *
+ * Returns 0 if the data is written correctly, or -1 in case of an error
+ */
+int tracefs_marker_write(struct tracefs_instance *instance, void *data, int len)
+{
+	int *fd = instance ? &instance->ftrace_marker_fd : &ftrace_marker_fd;
+	int ret;
+
+	if (!data || len < 1)
+		return -1;
+	if (*fd < 0) {
+		ret = tracefs_marker_init(instance);
+		if (ret < 0)
+			return ret;
+	}
+
+	ret = write(*fd, data, len);
+
+	return ret == len ? 0 : -1;
+}
+
+/**
+ * tracefs_marker_vprint - Write a formatted string in the trace marker
+ * @instance: ftrace instance, can be NULL for top tracing instance.
+ * @fmt: pritnf formatted string
+ * @ap: list of arguments for the formatted string
+ *
+ * If the trace marker file of the desired instance is not open already,
+ * this API will open it for writing. The file will stay open until
+ * tracefs_marker_close() is called.
+ *
+ * Returns 0 if the string is written correctly, or -1 in case of an error
+ */
+int tracefs_marker_vprint(struct tracefs_instance *instance,
+			   const char *fmt, va_list ap)
+{
+	char *str = NULL;
+	int ret;
+
+	ret = vasprintf(&str, fmt, ap);
+	if (ret < 0)
+		return ret;
+	ret = tracefs_marker_write(instance, str, strlen(str) + 1);
+	free(str);
+
+	return ret;
+}
+
+/**
+ * tracefs_marker_print - Write a formatted string in the trace marker
+ * @instance: ftrace instance, can be NULL for top tracing instance.
+ * @fmt: pritnf formatted string with variable arguments ...
+ *
+ * If the trace marker file of the desired instance is not open already,
+ * this API will open it for writing. The file will stay open until
+ * tracefs_marker_close() is called.
+ *
+ * Returns 0 if the string is written correctly, or -1 in case of an error
+ */
+int tracefs_marker_print(struct tracefs_instance *instance,
+			 const char *fmt, ...)
+{
+	va_list ap;
+	int ret;
+
+	va_start(ap, fmt);
+	ret = tracefs_marker_vprint(instance, fmt, ap);
+	va_end(ap);
+
+	return ret;
+}
+
+/**
+ * tracefs_marker_close - Close trace_marker file of selected instance
+ * @instance: ftrace instance, can be NULL for top tracing instance.
+ *
+ * Closes the file, previously opened with any of the other tracefs_marker_ APIs
+ */
+void tracefs_marker_close(struct tracefs_instance *instance)
+{
+	int *fd = instance ? &instance->ftrace_marker_fd : &ftrace_marker_fd;
+
+	if (*fd < 0)
+		return;
+	close(*fd);
+	*fd = -1;
+}
-- 
2.30.2

