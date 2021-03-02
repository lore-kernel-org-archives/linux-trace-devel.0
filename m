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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36502C433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Mar 2021 17:19:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C961651F6
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Mar 2021 17:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237910AbhCARTo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Mar 2021 12:19:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237500AbhCARQ2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Mar 2021 12:16:28 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F66EC061788
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Mar 2021 09:15:29 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id o6so12316801pjf.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Mar 2021 09:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6KQEoLZVn5SQLc1QPjdz2tqD2ldfnp9/i2erm186lJA=;
        b=GJkWK1hJqjBmmNZ31nzdzOejwrMSJpqlgikuZJ6wU72IYyBiqaE+A4FFEhpnJRJgpH
         pFs5Eip67qtOaVi+FFM8BrR1mjNhIWR5c46D5k8bbXSBn0z8SbJuHA2lu70+ApJtQsZ1
         0ONz7f4pCwz1nizalRm3CKE9+iHJ0SOGJwOKdDe88OAnV6p2ctTF66sFI6aSll9qq19n
         v963od5XKiL4WDxGqbzhNNwtTkDufD3gc/FJLZ21G2bze3bqO3oIiasuX8g2+LBuyTy8
         lGlTbpZ/6E5+QJgHpu1M+paM5BZ1UPryXDgK7jzEIz/9erDW4hmCElMoJpMPHVykPl4K
         B80w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6KQEoLZVn5SQLc1QPjdz2tqD2ldfnp9/i2erm186lJA=;
        b=mKsSwSqMpCagkjEzlJvrxUbK3T1bIZBh4jT8DNoxZPbePRqzR4L5B6GYFO4Aqoy6da
         sU+sUGHt+xudMniZb2lov4bmSy4DKgHTTjnXbzZhVo+HMIba7P3ybQqtAfXJjlpN2Epj
         SP0cO7524hbtWlaDeekNR1jx29xKZLei1PMui6xAbE4Ar4tKwcYZFuHZoRbDfDOo/dF+
         Va1mbCTsEDTLKMYsOG0clpa+2hmb2jI2jHUb+o6A0Dp6iAsZ61rZPt0kqn96W/wdVNCf
         04RGjJARfOAvbttOU8Su8cSnLizkHDVmCES/Uhy8TKLouphhWiPIcXLrXud4MLAouvvy
         av6Q==
X-Gm-Message-State: AOAM5301RlZk8c7b1XSI37wj3CGei9AtcqEyh0T8ktpwOf4bHYa1nsZR
        jbGitRhFV7IZG+2ji7ht+7I=
X-Google-Smtp-Source: ABdhPJx72ynfFqbMD7AteQQjRCZLDNuP712be3BppSIGfDcl9HkAUdRWLNPYekmpiFY7GBQo7kpNnw==
X-Received: by 2002:a17:902:a614:b029:e1:5b43:956a with SMTP id u20-20020a170902a614b02900e15b43956amr16860684plq.38.1614618928981;
        Mon, 01 Mar 2021 09:15:28 -0800 (PST)
Received: from localhost.localdomain ([45.118.75.3])
        by smtp.gmail.com with ESMTPSA id y8sm19724185pfe.36.2021.03.01.09.15.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Mar 2021 09:15:28 -0800 (PST)
From:   Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: [PATCH] libtracefs: An API to set the filtering of functions
Date:   Tue,  2 Mar 2021 22:45:10 +0530
Message-Id: <1614705310-5887-1-git-send-email-sameeruddin.shaik8@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This new API will write the function filters into the
set_ftrace_filter file, it will write only string as of now, it can't
handle kernel glob or regular expressions.

tracefs_function_filter()

https://bugzilla.kernel.org/show_bug.cgi?id=210643

Signed-off-by: Sameeruddin shaik <sameeruddin.shaik8@gmail.com>

diff --git a/include/tracefs.h b/include/tracefs.h
index f3eec62..b5259f9 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -50,6 +50,7 @@ int tracefs_trace_on(struct tracefs_instance *instance);
 int tracefs_trace_off(struct tracefs_instance *instance);
 int tracefs_trace_on_fd(int fd);
 int tracefs_trace_off_fd(int fd);
+int tracefs_function_filter(struct tracefs_instance *instance, const char * const *filters, const char *module, bool reset);
 
 /**
  * tracefs_trace_on_get_fd - Get a file descriptor of "tracing_on" in given instance
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index e2dfc7b..b8d8c99 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -18,6 +18,7 @@
 #include "tracefs-local.h"
 
 #define TRACE_CTRL	"tracing_on"
+#define TRACE_FILTER      "set_ftrace_filter"
 
 static const char * const options_map[] = {
 	"unknown",
@@ -387,3 +388,85 @@ void tracefs_option_clear(struct tracefs_options_mask *options, enum tracefs_opt
 	if (options && id > TRACEFS_OPTION_INVALID)
 		options->mask &= ~(1ULL << (id - 1));
 }
+
+static int controlled_write(const char *filter_path, const char * const *filters, const char *module, bool reset)
+{
+	int write_size;
+	char *each_str;
+	int size = 0;
+	int slen;
+	int fd;
+	int i;
+
+
+	if (!filters)
+		return -1;
+	if (reset)
+		fd = open(filter_path, O_WRONLY | O_TRUNC);
+	else
+		fd = open(filter_path, O_WRONLY | O_APPEND);
+	if (fd < 0)
+		return -1;
+	for (i = 0; filters[i] != NULL ; i++) {
+		slen = 0;
+		slen = strlen(*(filters + i));
+		if (slen < 0)
+			continue;
+
+		if (module)
+			slen += strlen(module) + 5;
+		/* Adding 2 extra byte for the space and '\0' at the end*/
+		slen += 2;
+		each_str = calloc(1, slen);
+		if (!each_str)
+			return -1;
+		if (module)
+			write_size = snprintf(each_str, slen, "%s:mod:%s ", *(filters + i), module);
+		else
+			write_size = snprintf(each_str, slen, "%s ", *(filters + i));
+		if (write_size < (slen - 1)) {
+			free(each_str);
+			continue;
+		}
+		size += write(fd, each_str, write_size);
+		free(each_str);
+	}
+	close(fd);
+	return size;
+}
+
+/**
+ * tracefs_function_filter - write to set_ftrace_filter file to trace particular functions
+ * @instance: ftrace instance, can be NULL for top tracing instance
+ * @filter: An array of function names ending with a NULL pointer
+ * @module: Module Name to be traced
+ * @reset: set to true to reset the file before applying the filter
+ *
+ * The @filter is an array of strings, where each string will be use to set
+ * a function or functions to be traced.
+ *
+ * If @reset is true, then all functions in the filter are cleared before
+ * adding functions from @filter. Otherwise, the functions set by @filter
+ * will be appended to the filter
+ *
+ * Returns the number of bytes written into the filter file or -1 if
+ * there is any error in writing to filter file
+ */
+int tracefs_function_filter(struct tracefs_instance *instance, const char * const *filters, const char *module, bool reset)
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
+	ret = controlled_write(ftrace_filter_path, filters, module, reset);
+
+ gracefully_free:
+	tracefs_put_tracing_file(ftrace_filter_path);
+	return ret;
+}
-- 
2.7.4

