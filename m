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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDACFC433E0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Feb 2021 05:54:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A726D64EC4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Feb 2021 05:54:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhBSFyi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Feb 2021 00:54:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhBSFyh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Feb 2021 00:54:37 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A747C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Feb 2021 21:53:57 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id i14so7419545eds.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Feb 2021 21:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7ZrYZbEMVTLkshnWMsZdCxxZsj5RjVi3hAefjXgGvqQ=;
        b=PeBiPdBTavnBxS7tZxoiwQCVVHSA5vqaUyMV/Cv1UqOdw1/kZWnDx/gJZicGrjzdcc
         cxpfkFgAm8Q1+B3X5ssf5djhUV4bSvtsCCArqRtV/C9NG/od2Z2kKgDNZkVhcYJmmXnv
         47VZsHcv29tNMhAP1uR/gx0cVcKv1A/4LIkNomeL/CjtUlmQ+7QwFvAk1+zwEeRTIxW1
         ltw3xqVq9lzxUtgSTDdYUtUUK9t7wvAFjI5gHxSI2bBWcN92Mropdu3HqxGU3zsKOMYi
         kmEA96DRrtyLT38fNQtRURtS1HfknXwJfRw74VWIlMEXBvps3FM/bb2SxQhjTA3qd6Js
         J5RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7ZrYZbEMVTLkshnWMsZdCxxZsj5RjVi3hAefjXgGvqQ=;
        b=IvW+gLkDupem3kV8/US6vIYUTA02lWXWXaOme60n8Du3XqieaW540oOW8JEQlhukiK
         aRva0H2EPubQuwOtOlV8slvy4NaBUucIoBA04VWAScQ3rDofPWPo3bHZFoADCizQRd9t
         dUg3RweaCUcw5VvCTfc199SmYtJgarU+hHlfzl6MiK0Yo/iyf0fnuzorKBiwodgiQYfR
         8444FpdOCvOhhS7xa7hRPBjmamtPn/2AWkWrOLZvXh1UY1x00tkL4t1ZckCn5Z5QxqP5
         CeDDUCpoiwpyrOkF9+Eh3WT+XAgFzsbE/JtjLm02qqsVsv788RdEf7P+KOuNauCG9dXU
         Aa1A==
X-Gm-Message-State: AOAM532l9ikOwpFpJeIrweD+JldETCv3yEa2euBRjVfv0PSvLaIehThs
        9flcqSAFRUh0iYsV5FukQst+/I708jgReg==
X-Google-Smtp-Source: ABdhPJxmSveo8IlICRgKYrQ27YARVBzf5vZY4tp3/G5Czt2mCI/7F41xMSp5mWpj0Ds9N9vXuSYK+w==
X-Received: by 2002:a05:6402:1ec:: with SMTP id i12mr7738827edy.222.1613714036000;
        Thu, 18 Feb 2021 21:53:56 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id o10sm3805651eju.89.2021.02.18.21.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 21:53:55 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] libtracefs: Add new API for open trace marker file
Date:   Fri, 19 Feb 2021 07:53:53 +0200
Message-Id: <20210219055353.2244340-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added new API for opening trace_marker file of given instance:
   tracefs_trace_marker_get_fd();

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-utils.txt | 20 +++++++++++++++++++-
 include/tracefs.h                  | 13 +++++++++++++
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtracefs-utils.txt b/Documentation/libtracefs-utils.txt
index 41544ab..0935199 100644
--- a/Documentation/libtracefs-utils.txt
+++ b/Documentation/libtracefs-utils.txt
@@ -3,7 +3,8 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_tracers, tracefs_get_clock, tracefs_list_free -
+tracefs_tracers, tracefs_get_clock, tracefs_list_free,
+tracefs_trace_marker_get_fd -
 Helper functions for working with trace file system.
 
 SYNOPSIS
@@ -15,6 +16,7 @@ SYNOPSIS
 char pass:[*]pass:[*]*tracefs_tracers*(const char pass:[*]_tracing_dir_);
 char pass:[*]*tracefs_get_clock*(struct tracefs_instance pass:[*]_instance_);
 void *tracefs_list_free*(char pass:[*]pass:[*]_list_);
+int *tracefs_trace_marker_get_fd*(struct tracefs_instance pass:[*]_instance_);
 --
 
 DESCRIPTION
@@ -36,6 +38,10 @@ The _tracefs_list_free()_ function frees an array of strings, returned by
 _tracefs_event_systems()_, _tracefs_system_events()_ and _tracefs_tracers()_
 APIs.
 
+The _tracefs_trace_marker_get_fd()_ function returns a file deascriptor to the "trace_marker" file
+from the given _instance_. If _instance_ is NULL, the top trace instance is used. The returned
+descriptor can be used for writing trace markers in the trace buffer of the instance.
+
 RETURN VALUE
 ------------
 The _tracefs_tracers()_ returns array of strings. The last element in that
@@ -45,6 +51,10 @@ In case of an error, NULL is returned.
 The _tracefs_get_clock()_ returns string, that must be freed with free(), or NULL
 in case of an error.
 
+The _tracefs_trace_marker_get_fd()_ function returns a file descriptor to "trace_marker"
+file for reading and writing, which must be closed wuth close(). In case of an error -1 is returned.
+
+
 EXAMPLE
 -------
 [source,c]
@@ -66,6 +76,14 @@ char *clock = tracefs_get_clock(NULL);
 		...
 		free(clock);
 	}
+...
+int marker_fd = tracefs_trace_marker_get_fd(NULL);
+char *my_marker = "User tarce event";
+	if (marker_fd < 0) {
+		/* Failed to open marker file */
+	}
+	write(marker_fd, my_marker, strlen(my_marker));
+	close(marker_fd);
 --
 FILES
 -----
diff --git a/include/tracefs.h b/include/tracefs.h
index f3eec62..dff365a 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -63,6 +63,19 @@ static inline int tracefs_trace_on_get_fd(struct tracefs_instance *instance)
 	return tracefs_instance_file_open(instance, "tracing_on", O_RDWR);
 }
 
+/**
+ * tracefs_trace_marker_get_fd - Get a file descriptor of "trace_marker" in
+ * given instance
+ * @instance: ftrace instance, can be NULL for the top instance
+ *
+ * Returns -1 in case of an error, or a valid file descriptor to "trace_marker"
+ * file for reading and writing. The returned FD must be closed with close().
+ */
+static inline int tracefs_trace_marker_get_fd(struct tracefs_instance *instance)
+{
+	return tracefs_instance_file_open(instance, "trace_marker", O_RDWR);
+}
+
 /* events */
 void tracefs_list_free(char **list);
 char **tracefs_event_systems(const char *tracing_dir);
-- 
2.29.2

