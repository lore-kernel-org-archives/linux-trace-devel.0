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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77C64C433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Mar 2021 16:22:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CAC264FE3
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Mar 2021 16:22:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhCIQVq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Mar 2021 11:21:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231699AbhCIQVm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Mar 2021 11:21:42 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68BC6C06174A
        for <linux-trace-devel@vger.kernel.org>; Tue,  9 Mar 2021 08:21:42 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id c16so6842434ply.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 09 Mar 2021 08:21:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=dtUE813ri06LBN4pF3K0ZutYKQhxK88OqNrnB5imSdg=;
        b=u3LyxOlVwp08k48jUbibMI/fqc1xeJg2y++nx4/VpVxhKc3Y8dbHIqqZtBFOETgaSE
         JreMnvRqiivup+/oHMBjHGRsX5qarhveiI5jh0imOs8KhkvznS/DOYn4y27QcMID3RN3
         TkaExRw941s6nvHz76WEGmYK8jsrjVgFmOGI6eOfxV75irHAL6Gcse3sSk0HGF/93If5
         vxJcz5EBja9AVFnD2Qn6DyQuWI3CRXgh3X6K4pcsOhXiTnGeEoIBBVf+EfLGCL7vyFO3
         SvUuCh145nqDxCbDLzEnz7KqKHg8Qxxyjf+5d/4PQ3Ra1BIQtqVFVHD4N4wTdPuKRjlq
         BWYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dtUE813ri06LBN4pF3K0ZutYKQhxK88OqNrnB5imSdg=;
        b=Z+UiSwxBDIwtD+2g0eo5wo64pzPXulBBjjhf1qhW/+fEht+5ZeHHkLNUU7wXry5iM7
         By7l4Fm+XiWS1Tg+prU+wbNFhPyWw4Jtg9w0Ajbi0zig67FIJSmbIg47JNe9aamGVSgr
         A94izRTE7VZ3qOZdp5YzIQ76lwSZgkOEQTZkMzacpCmxaZs4YD36CbEuOcBQo54ys62h
         N/E1QaK/HLLVzilrI/d9zYbxNvgojrFpmaV0lmeE+sVsC7t+HNU/6azeihoXZ778sgsN
         tF/UPIDy/rDcP43erJom+eMtOybJAXr2gCJL09RC0KU7mhiy7awMS56Ovp2ZmlCyeUU4
         oXkQ==
X-Gm-Message-State: AOAM533WxCRqBgqLh47GFJKMkb63e2VJZ0RxICsqBJICw06F2f9zAj+T
        EjE4CNPVmZOUBOKh7LNl5UI=
X-Google-Smtp-Source: ABdhPJxovtG1D0Fot4E8Ew3GMkcLEccAn63mgGRJukQKSDrr3HmzGB9YyasYq1faWHa1UCmdrEzPog==
X-Received: by 2002:a17:90a:a4cb:: with SMTP id l11mr5354691pjw.144.1615306901813;
        Tue, 09 Mar 2021 08:21:41 -0800 (PST)
Received: from localhost.localdomain ([60.243.212.85])
        by smtp.gmail.com with ESMTPSA id 21sm9345958pgf.69.2021.03.09.08.21.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Mar 2021 08:21:40 -0800 (PST)
From:   Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: [PATCH] libtracefs: An API to set the filtering of functions
Date:   Wed, 10 Mar 2021 21:51:27 +0530
Message-Id: <1615393287-12344-1-git-send-email-sameeruddin.shaik8@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This new API will write the function filters into the
set_ftrace_filter file.

tracefs_function_filter()

https://bugzilla.kernel.org/show_bug.cgi?id=210643

Signed-off-by: Sameeruddin shaik <sameeruddin.shaik8@gmail.com>

diff --git a/include/tracefs.h b/include/tracefs.h
index f3eec62..a2249d0 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -50,6 +50,7 @@ int tracefs_trace_on(struct tracefs_instance *instance);
 int tracefs_trace_off(struct tracefs_instance *instance);
 int tracefs_trace_on_fd(int fd);
 int tracefs_trace_off_fd(int fd);
+int tracefs_function_filter(struct tracefs_instance *instance, const char **filters, const char *module, bool reset, const char ***errs);
 
 /**
  * tracefs_trace_on_get_fd - Get a file descriptor of "tracing_on" in given instance
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index e2dfc7b..4e168df 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -18,6 +18,7 @@
 #include "tracefs-local.h"
 
 #define TRACE_CTRL	"tracing_on"
+#define TRACE_FILTER      "set_ftrace_filter"
 
 static const char * const options_map[] = {
 	"unknown",
@@ -387,3 +388,96 @@ void tracefs_option_clear(struct tracefs_options_mask *options, enum tracefs_opt
 	if (options && id > TRACEFS_OPTION_INVALID)
 		options->mask &= ~(1ULL << (id - 1));
 }
+
+static int controlled_write(const char *filter_path, const char **filters, const char *module, bool reset, const char ***errs)
+{
+	int flags = reset ? O_TRUNC : O_APPEND;
+	int write_size;
+	char *each_str;
+	int ret = 0;
+	int j = 0;
+	int size;
+	int slen;
+	int fd;
+	int i;
+
+	fd = open(filter_path, O_WRONLY | flags);
+	if (fd < 0)
+		return 1;
+
+	for (i = 0; filters[i]; i++) {
+		slen = strlen(filters[i]);
+		if (!slen)
+			continue;
+
+		if (module)
+			/* Adding 5 extra bytes for ":mod:"*/
+			slen += strlen(module) + 5;
+
+		/* Adding 2 extra byte for the space and '\0' at the end*/
+		slen += 2;
+		each_str = calloc(1, slen);
+		if (!each_str)
+			return 1;
+		if (module)
+			write_size = snprintf(each_str, slen, "%s:mod:%s ", filters[i], module);
+		else
+			write_size = snprintf(each_str, slen, "%s ", filters[i]);
+
+		size = write(fd, each_str, write_size);
+		/* compare written bytes*/
+		if (size < write_size) {
+			if (errs) {
+				errs[j++] = &filters[i];
+				ret -= 1;
+			}
+		}
+		free(each_str);
+	}
+	errs[j] = NULL;
+	close(fd);
+	return ret;
+}
+
+/**
+ * tracefs_function_filter - write to set_ftrace_filter file to trace particular functions
+ * @instance: ftrace instance, can be NULL for top tracing instance
+ * @filters: An array of function names ending with a NULL pointer
+ * @module: Module to be traced
+ * @reset: set to true to reset the file before applying the filter
+ * @errs: A pointer to array of constant strings that will be allocated
+ * on negative return of this function, pointing to the filters that failed.
+ * May be NULL, in which case this field will be ignored.
+ *
+ * The @filters is an array of strings, where each string will be used to set
+ * a function or functions to be traced.
+ *
+ * If @reset is true, then all functions in the filter are cleared before
+ * adding functions from @filters. Otherwise, the functions set by @filters
+ * will be appended to the filter file
+ *
+ * returns -x on filter errors (where x is number of failed filter srtings)
+ * and if @errs is not NULL will be an allocated string array pointing to the
+ * strings in @filters that failed and must be freed with free().
+ *
+ * returns 1 on general errors not realted to setting the filter.
+ * @errs is not set even if supplied.
+ *
+ * return 0 on success and @errs is not set.
+ */
+int tracefs_function_filter(struct tracefs_instance *instance, const char **filters, const char *module, bool reset, const char ***errs)
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

