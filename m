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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B246DC433E6
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 17:49:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7681A64F17
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 17:49:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbhCORtH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Mar 2021 13:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231772AbhCORsi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Mar 2021 13:48:38 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78FEEC061763
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Mar 2021 10:44:38 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id c17so3464561pfv.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Mar 2021 10:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6QJ9q0lWdnLrnZVSUMxkwNevGOg1byhyVEsHehM3yaA=;
        b=icn3Eb4jxVGLaGW4bdG8nmLPRCRjR9k0HxUBOtF9e0oePAQlZUuKLpcmsGr6uHab12
         UKQlgmY8OY1GeooNDSRouM4qJIfApbSrvPDqE8eIiQyyF3PFPfWLHFm3WnJ1HSHWzx9X
         y/NoGDn7X1hE78xtzR7d/QC2yylOmEDxvlW3msvvf8jmlihIWTXLWSdNKVFFUI30v6cV
         WGRFvfYNT5T/G0YiE5weHPhWHuJpip7OwIf3ryIQv1pzKzzjNL7oUT5XfZIHSlyrtcVu
         bjA44Ml385aBa82JV1d6xFijc5ZkMqJB+8wMyKuVn/iMH1Fv9eUOlQW0QVN1W/toFdrK
         4jxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6QJ9q0lWdnLrnZVSUMxkwNevGOg1byhyVEsHehM3yaA=;
        b=aEQs8tNtTvsu3gGdeZ5O2PA7L8Ei1mRip1aKaTI5gTsEez6zDHET/nIdrGi0mumuhU
         nQ8apb+tDhuj6EumCgjRSi+HByIIT3qy99b7/uJFUQD6Rdi0jU/EsEzjTObu9UIoWG66
         trebPh8zKmpn6FOti5za/hYgGoYIlmwKJckEAlgEcyb2q3FGCNG6B5BtgMprGzLrmx9Y
         6GpkWJzT2zD+CjTe7toJUAX6UuHrxhOO2bAXG4PfwrD6Lv/tZSh96Ugjtav2Kpr6Ixsh
         jKXms7xFM+7fVReWbbeTxkzDEwAvynzReBlDCgQYByEnVbPxyCkggQZLzK0xjHmAw+nc
         iDJg==
X-Gm-Message-State: AOAM5301scA8O3v2Mz+KKEglvHu/YXBlQnhApA7EdRWgwXNBJj2tJQSo
        emP8HJq0ncQhS7laWE7w0XLvtNofZHy0nA==
X-Google-Smtp-Source: ABdhPJxSHiNsguDpYwzUrPMrBu8B7OX9p4iTotTVmoHk4osks5jy6GL9JL2VEhFzOFkwkP4V84EEcw==
X-Received: by 2002:a63:318b:: with SMTP id x133mr225098pgx.233.1615830277985;
        Mon, 15 Mar 2021 10:44:37 -0700 (PDT)
Received: from localhost.localdomain ([60.243.215.59])
        by smtp.gmail.com with ESMTPSA id x7sm14519677pfp.23.2021.03.15.10.44.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Mar 2021 10:44:37 -0700 (PDT)
From:   Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: [PATCH v1] libtracefs: An API to set the filtering of functions
Date:   Tue, 16 Mar 2021 23:14:53 +0530
Message-Id: <1615916693-15528-1-git-send-email-sameeruddin.shaik8@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This new API will write the function filters into the
set_ftrace_filter file.

tracefs_function_filter()

https://bugzilla.kernel.org/show_bug.cgi?id=210643

Signed-off-by: Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
---
changed snprintf to asprintf for string formation
handled the lines over 80 characters

diff --git a/include/tracefs.h b/include/tracefs.h
index f3eec62..c1f07b0 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -145,5 +145,6 @@ bool tracefs_option_is_enabled(struct tracefs_instance *instance, enum tracefs_o
 int tracefs_option_enable(struct tracefs_instance *instance, enum tracefs_option_id id);
 int tracefs_option_diasble(struct tracefs_instance *instance, enum tracefs_option_id id);
 const char *tracefs_option_name(enum tracefs_option_id id);
-
+int tracefs_function_filter(struct tracefs_instance *instance, const char **filters,
+			    const char *module, bool reset, const char ***errs);
 #endif /* _TRACE_FS_H */
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index e2dfc7b..6b33321 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -18,6 +18,7 @@
 #include "tracefs-local.h"
 
 #define TRACE_CTRL	"tracing_on"
+#define TRACE_FILTER	"set_ftrace_filter"
 
 static const char * const options_map[] = {
 	"unknown",
@@ -387,3 +388,93 @@ void tracefs_option_clear(struct tracefs_options_mask *options, enum tracefs_opt
 	if (options && id > TRACEFS_OPTION_INVALID)
 		options->mask &= ~(1ULL << (id - 1));
 }
+
+static int controlled_write(const char *filter_path, const char **filters,
+			    const char *module, bool reset, const char ***errs)
+{
+	int flags = reset ? O_TRUNC : O_APPEND;
+	const char **e = NULL;
+	char *each_str = NULL;
+	int write_size = 0;
+	int size = 0;
+	int fd = -1;
+	int ret = 0;
+	int j = 0;
+	int i;
+
+	fd = open(filter_path, O_WRONLY | flags);
+	if (fd < 0)
+		return 1;
+
+	for (i = 0; filters[i]; i++) {
+		if (module)
+			write_size = asprintf(&each_str, "%s:mod:%s ", filters[i], module);
+		else
+			write_size = asprintf(&each_str, "%s ", filters[i]);
+		if (write_size < 0)
+			continue;
+		size = write(fd, each_str, write_size);
+		/* compare written bytes*/
+		if (size < write_size) {
+			if (errs) {
+				e = realloc(e, (j + 1) * (sizeof(char *)));
+				e[j++] = filters[i];
+				ret -= 1;
+			}
+		}
+		free(each_str);
+	}
+	if (errs) {
+		e = realloc(e, (j + 1) * (sizeof(char *)));
+		e[j] = NULL;
+		*errs = e;
+	}
+	close(fd);
+	return ret;
+}
+
+/**
+ * tracefs_function_filter - write to set_ftrace_filter file to trace
+ * particular functions
+ * @instance: ftrace instance, can be NULL for top tracing instance
+ * @filters: An array of function names ending with a NULL pointer
+ * @module: Module to be traced
+ * @reset: set to true to reset the file before applying the filter
+ * @errs: A pointer to array of constant strings that will be allocated
+ * on negative return of this function, pointing to the filters that
+ * failed.May be NULL, in which case this field will be ignored.
+ *
+ * The @filters is an array of strings, where each string will be used
+ * to set a function or functions to be traced.
+ *
+ * If @reset is true, then all functions in the filter are cleared
+ * before adding functions from @filters. Otherwise, the functions set
+ * by @filters will be appended to the filter file
+ *
+ * returns -x on filter errors (where x is number of failed filter
+ * srtings) and if @errs is not NULL will be an allocated string array
+ * pointing to the strings in @filters that failed and must be freed
+ * with free().
+ *
+ * returns 1 on general errors not realted to setting the filter.
+ * @errs is not set even if supplied.
+ *
+ * return 0 on success and @errs is not set.
+ */
+int tracefs_function_filter(struct tracefs_instance *instance, const char **filters,
+			    const char *module, bool reset, const char ***errs)
+{
+	char *ftrace_filter_path;
+	int ret = 0;
+
+	if (!filters)
+		return 1;
+
+	ftrace_filter_path = tracefs_instance_get_file(instance, TRACE_FILTER);
+	if (!ftrace_filter_path)
+		return 1;
+
+	ret = controlled_write(ftrace_filter_path, filters, module, reset, errs);
+	tracefs_put_tracing_file(ftrace_filter_path);
+	return ret;
+}
-- 
2.7.4

