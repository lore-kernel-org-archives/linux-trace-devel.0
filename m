Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,
	DATE_IN_FUTURE_12_24,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AE37C433E0
	for <linux-trace-devel@archiver.kernel.org>; Sun, 21 Feb 2021 12:24:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DFD864DED
	for <linux-trace-devel@archiver.kernel.org>; Sun, 21 Feb 2021 12:24:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhBUMYX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 21 Feb 2021 07:24:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbhBUMYX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 21 Feb 2021 07:24:23 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D3EC061574
        for <linux-trace-devel@vger.kernel.org>; Sun, 21 Feb 2021 04:23:42 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id z5so1666042pfe.3
        for <linux-trace-devel@vger.kernel.org>; Sun, 21 Feb 2021 04:23:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=L4JmDPZDiU3AGd5KAVCbQRm7ADa/hO5/sTceebwwqUE=;
        b=WuXFxgVFH9d639Qm8vQ+meYrT8RdMV0DFW/U7O3Ftu5LZFG/GSx6IYYUxlH+vAeT8x
         yIdfSSMWFx/FRtZRMHuKi1qHl3CE7tEulu8doxEQvfkdSppfLKjCHaj3sy6bQ4QUta56
         tW5MP2fG/D4IvIki0tkwDqqCjUsD/kmIpBIH7k7hpJt5moA4ZuX/qjgctlcOSWZ68HmT
         kROlLBJCwSeAdUVzmVUcMHKnzDpZ90pbBA/fVaLFul6HWwBtS+T/KjCumsQrYCphO3u4
         fK/hnO0ukaqnb6cRrH/iZ4kkn2RskG4/G5Izj6OaUiYCJiQzss6HkRLuFS/pkQOwt3jz
         MxqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=L4JmDPZDiU3AGd5KAVCbQRm7ADa/hO5/sTceebwwqUE=;
        b=SvFcs+1dOd5qSc05zGCDrKQgOdDTcsiarUGCFCP+eiNS1k/aZ+O7RWL7kW9dW5h51c
         wDS7RyCItZdP++IY6d7nddWfupfPdQhhx7nh34FOp1u1Vf7QGSdcnuqgPaBEF2eQQkbB
         vC1iHR0JLLNemE5HjV/K4O4KOuuO9oUPOzJk2yFKSy3mUU7iKykgS8Y7qNa9cLnLl/22
         E7eV2tuUNcta7+Vu39nbek+JO1YTsvkcokZ6tT42DploMM6e8CQuGRYmf5SoYbYL9jCB
         YhXuBL3e2PuiMbLL1aEavP2UF6rtuD9myPv41LtHjKm4So1aXur8Exdj7bHzKttRbRTG
         xe7A==
X-Gm-Message-State: AOAM533Gb5M4K78J8oQLEoCYxU8U4m/dc2bUm/u6bvJOL/nWxGywiOhq
        +Av3p+/vk3Gelu7WFbAN99NjCYz9aLUtIw==
X-Google-Smtp-Source: ABdhPJyy7hGqm/fNNgq83TXl79650cp4j3klVy4bpWcnLVbQz1XbpPShnI79Uxs7oB93k5UGXxsQLw==
X-Received: by 2002:a63:1d26:: with SMTP id d38mr16263816pgd.385.1613910222276;
        Sun, 21 Feb 2021 04:23:42 -0800 (PST)
Received: from localhost.localdomain ([116.74.248.119])
        by smtp.gmail.com with ESMTPSA id o1sm14383081pgq.1.2021.02.21.04.23.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Feb 2021 04:23:41 -0800 (PST)
From:   Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: [PATCH] libtracefs: New API to trace only specific functions by instance
Date:   Mon, 22 Feb 2021 17:54:21 +0530
Message-Id: <1613996661-6525-1-git-send-email-sameeruddin.shaik8@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <[PATCH][WIP]libtracefs:New API to enable the filtering of functions>
References: <[PATCH][WIP]libtracefs:New API to enable the filtering of functions>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This new API can be used to set the specific functions to be traced.

tracefs_function_filter

Signed-off-by: Sameeruddin shaik <sameeruddin.shaik8@gmail.com>

diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index 187870e..e8ad1f9 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -20,6 +20,7 @@ void warning(const char *fmt, ...);
 int str_read_file(const char *file, char **buffer);
 char *trace_append_file(const char *dir, const char *name);
 char *trace_find_tracing_dir(void);
+int controlled_write(const char *path, const char* const *filter, bool reset);
 
 #ifndef ACCESSPERMS
 #define ACCESSPERMS (S_IRWXU|S_IRWXG|S_IRWXO) /* 0777 */
diff --git a/include/tracefs.h b/include/tracefs.h
index f3eec62..37eab87 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -50,6 +50,7 @@ int tracefs_trace_on(struct tracefs_instance *instance);
 int tracefs_trace_off(struct tracefs_instance *instance);
 int tracefs_trace_on_fd(int fd);
 int tracefs_trace_off_fd(int fd);
+int tracefs_function_filter(struct tracefs_instance *instance, const char* const *filter, bool reset);
 
 /**
  * tracefs_trace_on_get_fd - Get a file descriptor of "tracing_on" in given instance
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index e2dfc7b..709f1e7 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -18,6 +18,7 @@
 #include "tracefs-local.h"
 
 #define TRACE_CTRL	"tracing_on"
+#define TRACE_FILTER      "set_ftrace_filter"
 
 static const char * const options_map[] = {
 	"unknown",
@@ -387,3 +388,28 @@ void tracefs_option_clear(struct tracefs_options_mask *options, enum tracefs_opt
 	if (options && id > TRACEFS_OPTION_INVALID)
 		options->mask &= ~(1ULL << (id - 1));
 }
+
+/**
+ * tracefs_function_filter - write to set_ftrace_filter file to trace particular functions
+ * @instance: ftrace instance, can be NULL for top tracing instnace
+ * @filter: const pointer to an array of const function names
+ * @reset: Boolean value to reset the file
+ */
+int tracefs_function_filter(struct tracefs_instance *instance, const char * const *filters, bool reset)
+{
+	char *ftrace_filter_path;
+	int ret;
+
+	if (!filters)
+		return -1;
+	ftrace_filter_path = tracefs_instance_get_file(instance, TRACE_FILTER);
+
+	if (!ftrace_filter_path)
+		goto gracefully_free;
+
+	ret = controlled_write(ftrace_filter_path, filters, reset);
+
+ gracefully_free:
+	tracefs_put_tracing_file(ftrace_filter_path);
+	return ret;
+}
diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
index 0e96f8e..1cd98a2 100644
--- a/src/tracefs-utils.c
+++ b/src/tracefs-utils.c
@@ -228,3 +228,23 @@ __hidden int str_read_file(const char *file, char **buffer)
 
 	return size;
 }
+
+__hidden int controlled_write(const char *filter_path, const char * const *filters, bool reset)
+{
+	int size = 0;
+	int fd;
+	int i;
+
+	if (!filters)
+		return -1;
+	if (reset)
+		fd = open(filter_path, O_WRONLY | O_APPEND | O_TRUNC);
+	else
+		fd = open(filter_path, O_WRONLY | O_APPEND);
+	if (fd < 0)
+		return -1;
+	for (i = 0; filters[i] != NULL ; i++)
+		size += write(fd, *(filters + i), strlen(*(filters + i)));
+	close(fd);
+	return size;
+}
-- 
2.7.4

