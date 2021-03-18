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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 721C3C433E6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Mar 2021 16:02:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F41D64F44
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Mar 2021 16:02:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbhCQQCH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Mar 2021 12:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbhCQQB5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Mar 2021 12:01:57 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B615C06175F
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Mar 2021 09:01:57 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id g15so1426307pfq.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Mar 2021 09:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=mGA6rsT/KoVVUbrj1wwe4PQ9R01YvHM/Rme9TDGvRzQ=;
        b=Gk6f76PmDc3/r6W4ohU3eAKlhwB+TLg+zVHdNNKU2ZJSC61ZHxQI+OX7ghcY2n8zks
         kjOMp9hhZwMKUBfdPfznB9n+6/e8JLRrEq0P36qqlCjMyETOedRMGiiXH52/9L4Nz+rS
         06xEJ/emJTnIaT6dF0LKHDuzv5f07JJyXfWVER0HUj3yxqA+nB2rYw9ZIUfFLdJOwGP2
         ql8zkKaNasuOruWiYbMZQ2qaeTgz51UPwnyYkM22L+kchdR+1NgOBIHpZvZfU0t/Gn69
         JYHwwVswOuVzg8UUihCLTuxmHnzNSgJVlZKaDvoQZEy/ogY4rb2FYh59OTw+O91ol0jG
         Hl6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mGA6rsT/KoVVUbrj1wwe4PQ9R01YvHM/Rme9TDGvRzQ=;
        b=njaHQq9Y+lgf1H5/DcxzBWpLkfVTU7qmpse278jUM/5LwMiqUc5PKH6ICae3A8R1lt
         iyhbJPKGPlphGTKCgt3INBgYg90e/RA6C0UTwyp/JKQu145lb7/qAML4MvQ5tZH7YfmC
         4goyi4uYmiJdDHB/rj45Bmh6DuZhKuKlpPJOZcLAsbkCHtmVM1woW02PLgWtcO6uE761
         naFJc2vDaLJxaxGPDAWHD1JL9Lq/HckHflcy5CYdnK7DYaV2cG6aTyYeReCYBLgHLhmb
         8a/lMxkc1iN2i7sk7qq0lkpHxY2lF4FlkpNGH1tt2P4DZpZZ08y/xbvz12mfeNYDeb3Q
         Pn7Q==
X-Gm-Message-State: AOAM531JjHzmQ+jnR4Pi0r3HYCXJIbDI67OSjr2k2WDI6YGLxG3cX/he
        tWIOOEwsc3ZIIIVj6qsEGgMJFUMy73BfzA==
X-Google-Smtp-Source: ABdhPJwUw8oJUl46wp1g7fh1hZm0qEKBNQPe4dzWukLS6ULZ7hcoE84UHYW9d0AY+5OVWuVRwVEwSQ==
X-Received: by 2002:a17:903:31cc:b029:e4:bd48:c8e3 with SMTP id v12-20020a17090331ccb02900e4bd48c8e3mr4994589ple.40.1615994997952;
        Wed, 17 Mar 2021 08:29:57 -0700 (PDT)
Received: from localhost.localdomain ([115.98.13.163])
        by smtp.gmail.com with ESMTPSA id b22sm21605618pff.173.2021.03.17.08.29.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Mar 2021 08:29:57 -0700 (PDT)
From:   Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: [PATCH v2] libtracefs: An API to set the filtering of functions
Date:   Thu, 18 Mar 2021 21:00:17 +0530
Message-Id: <1616081417-4107-1-git-send-email-sameeruddin.shaik8@gmail.com>
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
Error handling is addressed as per the comments
if filters[i] is not NULL, then only we are going inside for loop, at the asprintf i think it won't be necessary to check the filters[i] is NULL or not again, when it throws error, if i am wrong please correct me.

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
index e2dfc7b..ca6077b 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -18,6 +18,7 @@
 #include "tracefs-local.h"
 
 #define TRACE_CTRL	"tracing_on"
+#define TRACE_FILTER	"set_ftrace_filter"
 
 static const char * const options_map[] = {
 	"unknown",
@@ -387,3 +388,108 @@ void tracefs_option_clear(struct tracefs_options_mask *options, enum tracefs_opt
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
+		if (write_size < 0) {
+			ret = 1;
+			goto error;
+		}
+		size = write(fd, each_str, write_size);
+		/* compare written bytes*/
+		if (size < write_size) {
+			if (errs) {
+				e = realloc(e, (j + 1) * (sizeof(char *)));
+				if (!e) {
+					ret = 1;
+					goto error;
+				}
+				e[j++] = filters[i];
+				ret -= 1;
+			}
+		}
+		free(each_str);
+		each_str = NULL;
+	}
+	if (errs) {
+		e = realloc(e, (j + 1) * (sizeof(char *)));
+		if (!e) {
+			free(e);
+			ret = 1;
+			goto error;
+		}
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

