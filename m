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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C36FFC433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Mar 2021 16:39:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87AEB64EB9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Mar 2021 16:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhCRQip (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Mar 2021 12:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232071AbhCRQik (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Mar 2021 12:38:40 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2F6C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Mar 2021 09:38:39 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id bt4so3208424pjb.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Mar 2021 09:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=XCZWJQRsHODcou727K44yRFw4X2nc7jl3atVrkJLxE0=;
        b=PNB9POmjjO1z4YMFAs9emzDLpxW0ASTRs2IVUdaroxSQvqeA3es9HhpCcN45xObUhw
         jXXGdEmdjXrGxs8ysvyXkaIPkmsD3duxz6+k9D0s/d3gZcqtgwSH179LnQGdYET6KJgR
         8gjni7bvSgQcBVsatIxMlJuKsEDrpwrma+OLNRkJ3nh56WM67EUk0AHlk8FF6GVirHi8
         RYM68f2ItPj+oX0vVQyxW7kefw4thv5HBJMv/BllGZlNTvAlvQdyeLgvmNnFPsoxDDlO
         pbSez0zDC/0PktFJmW3GegJv9mCGagG/vpdBL7J00AMXBIp25ljv6vzDLwmf4E0DR9Dh
         +zmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=XCZWJQRsHODcou727K44yRFw4X2nc7jl3atVrkJLxE0=;
        b=jAtOTaH3QAucRoWgM4dQTdDcRf6nh6NRQtRxvqKdiEZCyUBgk8hJEOngeDdgD6pe6P
         R/2frsFqSUDJGnYoQ+TYnX1lqviIzEETZTcjSpslef2aB+xVxyA/w2ZqHXUweBpYhA//
         WmGydHwgodGGVOzkrf+dq8x++zmqYvnc9J/z8MyBy/pdr5WTQBHnr6321099oHyxnpFh
         tISWQCniRJvzndJGpGHK3MiC/AQMY4p59XaFoO6VWZBnDkRXB6Hiw6ppvALXr+ph3VAr
         W/zQyXEkyCd0/3Z+AQG+q4VsBFdTHtRw42WgI4mp7zsunE9Xd6XFfU8TaESWMy3H95w5
         bt3w==
X-Gm-Message-State: AOAM533+BAySBT+yJo7CSB26L7fXzEOD+ZIIRQCr9CmKwgIOwQSlo12/
        TfIshS/376GBnmigNcNL0SgwtI570CERbg==
X-Google-Smtp-Source: ABdhPJxOS5zgN3OHbU1707C5iHXW5Qtb0lkkXFtco6No/JA2ZiNFgUakB/TEsCYSusVYLnI2y+POUQ==
X-Received: by 2002:a17:90b:3587:: with SMTP id mm7mr5188693pjb.21.1616085519278;
        Thu, 18 Mar 2021 09:38:39 -0700 (PDT)
Received: from localhost.localdomain ([116.74.250.179])
        by smtp.gmail.com with ESMTPSA id fh19sm2915412pjb.33.2021.03.18.09.38.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Mar 2021 09:38:38 -0700 (PDT)
From:   Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
To:     tz.stoyanov@gmail.com
Cc:     linux-trace-devel@vger.kernel.org,
        Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: [PATCH v3] libtracefs: An API to set the filtering of functions
Date:   Fri, 19 Mar 2021 22:08:58 +0530
Message-Id: <1616171938-18914-1-git-send-email-sameeruddin.shaik8@gmail.com>
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
Addressed the realloc comments
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
index e2dfc7b..4f8bcdc 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -18,6 +18,7 @@
 #include "tracefs-local.h"
 
 #define TRACE_CTRL	"tracing_on"
+#define TRACE_FILTER	"set_ftrace_filter"
 
 static const char * const options_map[] = {
 	"unknown",
@@ -387,3 +388,113 @@ void tracefs_option_clear(struct tracefs_options_mask *options, enum tracefs_opt
 	if (options && id > TRACEFS_OPTION_INVALID)
 		options->mask &= ~(1ULL << (id - 1));
 }
+
+static int controlled_write(const char *filter_path, const char **filters,
+			    const char *module, bool reset, const char ***errs)
+{
+	int flags = reset ? O_TRUNC : O_APPEND;
+	const char **temp = NULL;
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
+		if (write_size < 0) {
+			ret = 1;
+			goto error;
+		}
+		size = write(fd, each_str, write_size);
+		/* compare written bytes*/
+		if (size < write_size) {
+			if (errs) {
+				temp = realloc(e, (j + 1) * (sizeof(char *)));
+				if (!temp) {
+					free(e);
+					ret = 1;
+					goto error;
+				} else
+					e = temp;
+
+				e[j++] = filters[i];
+				ret -= 1;
+			}
+		}
+		free(each_str);
+		each_str = NULL;
+	}
+	if (errs) {
+		temp = realloc(e, (j + 1) * (sizeof(char *)));
+		if (!temp) {
+			free(e);
+			ret = 1;
+			goto error;
+		} else
+			e = temp;
+		e[j] = NULL;
+		*errs = e;
+	}
+ error:
+	if (each_str)
+		free(each_str);
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

