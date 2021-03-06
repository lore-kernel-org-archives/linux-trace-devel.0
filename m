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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 320D6C433E0
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Mar 2021 11:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF7D465018
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Mar 2021 11:20:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbhCELU1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Mar 2021 06:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhCELT7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Mar 2021 06:19:59 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D05C061574
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Mar 2021 03:19:58 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id g20so1267541plo.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Mar 2021 03:19:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=InTGYNTfaL4kjg4JYdOj9L+WtXl9SVBLxHl7IgJIOCE=;
        b=jIx5dR5RJ284bKlZBHqMZNdyKSGw/Mpx34xkqO5eCQHTgjDnsyyXf4Ug/wBmhzgA2O
         2KW40XRJRBbi4/xdn4M5HekKW1tIZBNqY6b1RZMzB5MPiPvnBvO7J4dfItuQhHRxQjLH
         bQXz5VNnoiC5lW08oRHg8iajjanqxvQFbNr9GC4tCUrvLN+X7U2GnIYaETjOs1jC6gml
         5kGd1FY8JEEND6jHA3FYm25+Qn33+lfPZwUBMPQefX+I6senqUdoag/HpXDN5uPQsduP
         Q+rXISSz4C++Ahut1vWb4kEohiR10VoSK7IU2xWzerTEOqaJZte8UbCVv+mn8WxCFhKF
         cPRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=InTGYNTfaL4kjg4JYdOj9L+WtXl9SVBLxHl7IgJIOCE=;
        b=RyTNGsyS/JK6LdDDeHvh+VcRwuwSdzhWasgRw1l1fEOO9lBubf4LpxyNGQ9vh/iM0K
         twMZeHjYaS5GNOb3HZ4M1usVRpBMqympVPIonFXa8BUEKvA3FMWIpQvQD2UhpQxVnLD4
         3dnw8774af2T05Mt5pf0lcHbZYycB4A1oExS5y4cPCitj2/pV8ByaJyk0MrAhadc/fvr
         XeSuS0WPPMbHcwKPebfjQz5BBMHdSatcdzWssBwFCBERqLfZbx7U2QxheymO0ih05b7g
         Yuw3OzZDdIc1jbPtPhLRE4RDAALb8he2LrFFle80kfSJ309ffIoKjUsXEeRZvAFCSEwO
         4eaw==
X-Gm-Message-State: AOAM533DYLL0cki/TRp02dvEOXM0Qf0/3VD5MH/6IjKg64pZ7xVMfhp6
        sVSuhLBzZyy4VZSTgD0Wc4M=
X-Google-Smtp-Source: ABdhPJzi4TeODety4xxuOqGF7yYB13WoiKqXf4bohPjHQ3Wjy7Iu4NKOrjDtJac/uGc3f67aVjzKXQ==
X-Received: by 2002:a17:90a:c594:: with SMTP id l20mr7084473pjt.163.1614943198436;
        Fri, 05 Mar 2021 03:19:58 -0800 (PST)
Received: from localhost.localdomain ([45.118.75.3])
        by smtp.gmail.com with ESMTPSA id k69sm2293881pfd.4.2021.03.05.03.19.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Mar 2021 03:19:57 -0800 (PST)
From:   Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: [PATCH] libtracefs: An API to set the filtering of functions
Date:   Sat,  6 Mar 2021 16:50:25 +0530
Message-Id: <1615029625-9749-1-git-send-email-sameeruddin.shaik8@gmail.com>
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
index f3eec62..2e5d3e3 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -50,6 +50,7 @@ int tracefs_trace_on(struct tracefs_instance *instance);
 int tracefs_trace_off(struct tracefs_instance *instance);
 int tracefs_trace_on_fd(int fd);
 int tracefs_trace_off_fd(int fd);
+int tracefs_function_filter(struct tracefs_instance *instance, const char **filters, const char *module, bool reset, const char **errs);
 
 /**
  * tracefs_trace_on_get_fd - Get a file descriptor of "tracing_on" in given instance
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index e2dfc7b..8311191 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -18,6 +18,7 @@
 #include "tracefs-local.h"
 
 #define TRACE_CTRL	"tracing_on"
+#define TRACE_FILTER      "set_ftrace_filter"
 
 static const char * const options_map[] = {
 	"unknown",
@@ -387,3 +388,90 @@ void tracefs_option_clear(struct tracefs_options_mask *options, enum tracefs_opt
 	if (options && id > TRACEFS_OPTION_INVALID)
 		options->mask &= ~(1ULL << (id - 1));
 }
+
+static int controlled_write(const char *filter_path, const char **filters, const char *module, bool reset, const char **errs)
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
+		return -1;
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
+			return -1;
+		if (module)
+			write_size = snprintf(each_str, slen, "%s:mod:%s ", filters[i], module);
+		else
+			write_size = snprintf(each_str, slen, "%s ", filters[i]);
+
+		size = write(fd, each_str, write_size);
+		/* compare written bytes and also compare the written bytes with difference of added 5 bytes to string for ":mod:"*/
+		if ((size < write_size) && (size < (write_size - 5))) {
+			errs[j++] = filters[i];
+			ret -= 1;
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
+ * @errs: An Array of failed function names ending with a NULL pointer
+ *
+ * The @filters is an array of strings, where each string will be used to set
+ * a function or functions to be traced.
+ *
+ * If @reset is true, then all functions in the filter are cleared before
+ * adding functions from @filter. Otherwise, the functions set by @filter
+ * will be appended to the filter file
+ *
+ * The @errs is an array of strings, where each string is a failed function
+ * name
+ *
+ * returns -x (where x is number of failed filter srtings or it can be
+ * 1 for general errors), or 0 if there are no errors.
+ */
+int tracefs_function_filter(struct tracefs_instance *instance, const char **filters, const char *module, bool reset, const char **errs)
+{
+	char *ftrace_filter_path;
+	int ret = 0;
+
+	if (!filters)
+		return -1;
+
+	ftrace_filter_path = tracefs_instance_get_file(instance, TRACE_FILTER);
+	if (!ftrace_filter_path)
+		goto out;
+
+	ret = controlled_write(ftrace_filter_path, filters, module, reset, errs);
+ out:
+	tracefs_put_tracing_file(ftrace_filter_path);
+	return ret;
+}
-- 
2.7.4

