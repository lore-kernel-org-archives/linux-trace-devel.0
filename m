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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6EDBC433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jan 2021 10:37:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D3BA23444
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jan 2021 10:37:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729650AbhAUKhM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Jan 2021 05:37:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729649AbhAUKg4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Jan 2021 05:36:56 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC70C061786
        for <linux-trace-devel@vger.kernel.org>; Thu, 21 Jan 2021 02:36:11 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id d16so531705wro.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 21 Jan 2021 02:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=psGKLNDPdXV625xS+aomrQ8fiBGHSfBKtlQ9B6km6oY=;
        b=DKW5ZPprIncyTuWVyOY1fvoC1OdKLDseg7zaaSZMIPbwAERL4wVnmK/CTq8N0vNglO
         vJhvTj3cojidtFTawWcFYG7nE5eTkmxZlLg9tiThjsuU1eF/LB/bbAezYy/JJWz0vMm0
         /G1xSxIAydMcGSeReEO3ecv0kRe6YM/nnY5hr9RgkduYkzvG+4Qfpv0+XDOtPh4E77eS
         ci9g7viiv6S1xaKSdtqGsE+kWdcuND0L3eyDtKZnLHPFwdEuK11Ke/iQsjotTeUeNGM+
         g2/BEZZRFtajDZpUx1xUovGLYSghGup5QLXe7jkm4yWn0ZxSmH1UAqXOzIddvUhZlskw
         M+xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=psGKLNDPdXV625xS+aomrQ8fiBGHSfBKtlQ9B6km6oY=;
        b=tUhXviTCFvXYjdWZUHfZv4kkUFUZY6pabAOOhvg6kryb5ujwWdVneG8kkwvkAfRaie
         LAIvcodFkat2n3b1iUW9JcCnLfjInd5yvLyEBhnTdlVgc3n8XOmSBux4rwZXS2Ra7EgR
         Xg59EOj0RSbaxH58HrsZLH7K8r7LraZkhzW+nSEZvi44gv8yiYRo+XQj+sxASrM+NhPa
         dlDhz9s8uoXY13fhPiV0EZ3oJc0dm+n0D84AmnY+q1wMnJyOIr8yz2OZmCfpgP0GTB11
         3w7dq0AeclNii5wbPiobRgXn9vpiqmZA0sQssOd8NN6lQ1c0JMMO9kJ83NvMmeaqa+9c
         et+A==
X-Gm-Message-State: AOAM531zEkGXWQRM/7anfRYmPz+vR9CHGIxtXJua/nL/+nXXM5IEZ59E
        SM6flfkoanBhPJKoZbHN0zQoVzbUklCnCVp2
X-Google-Smtp-Source: ABdhPJwOJ5CmekJaPCTz43g3aavN3/9M0HYKCS6kUv7Q3JKyD2jDgawh/n6+UImDTyRzPFJJ1R/Hnw==
X-Received: by 2002:adf:fb52:: with SMTP id c18mr13325017wrs.186.1611225370716;
        Thu, 21 Jan 2021 02:36:10 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l18sm7294123wme.37.2021.01.21.02.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 02:36:10 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/4] trace-cmd library man pages: Documented APIs for opening trace file
Date:   Thu, 21 Jan 2021 12:36:04 +0200
Message-Id: <20210121103605.224108-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210121103605.224108-1-tz.stoyanov@gmail.com>
References: <20210121103605.224108-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Documented APIs:
 tracecmd_open()
 tracecmd_open_fd()

Moved tracecmd_init_data() documentation to more appropriate man page.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../libtracecmd/libtracecmd-files.3.txt       | 89 +++++++++++++++++--
 .../libtracecmd/libtracecmd-record.3.txt      | 22 +----
 2 files changed, 84 insertions(+), 27 deletions(-)

diff --git a/Documentation/libtracecmd/libtracecmd-files.3.txt b/Documentation/libtracecmd/libtracecmd-files.3.txt
index 75809223..c5f0ad0a 100644
--- a/Documentation/libtracecmd/libtracecmd-files.3.txt
+++ b/Documentation/libtracecmd/libtracecmd-files.3.txt
@@ -3,7 +3,8 @@ libtracecmd(3)
 
 NAME
 ----
-tracecmd_open_head, tracecmd_close - Open and close a trace file.
+tracecmd_open, tracecmd_open_fd, tracecmd_open_head, tracecmd_init_data,
+tracecmd_close - Open and close a trace file.
 
 SYNOPSIS
 --------
@@ -11,7 +12,10 @@ SYNOPSIS
 --
 *#include <trace-cmd.h>*
 
+struct tracecmd_input pass:[*]*tracecmd_open*(const char pass:[*]_file_);
+struct tracecmd_input pass:[*]*tracecmd_open_fd*(int _fd_);
 struct tracecmd_input pass:[*]*tracecmd_open_head*(const char pass:[*]_file_);
+int *tracecmd_init_data*(struct tracecmd_input pass:[*]_handle_);
 void *tracecmd_close*(struct tracecmd_input pass:[*]_handle_);
 --
 
@@ -23,32 +27,99 @@ Linux kernel tracer. The opened file is represented by a _tracecmd_input_
 structure, all other library APIs that work with the file require a pointer
 to the structure.
 
-The _tracecmd_open_head()_ function opens a given trace _file_, parses the
-headers from the file, allocates and initializes _tracecmd_input_ structure
-representing the file.
+The _tracecmd_open()_ function opens a given trace _file_, parses the
+metadata headers from the file, allocates and initializes а _tracecmd_input_
+handler structure representing the file. It also initializes the handler
+for reading trace data from the file. The returned handler is ready to be
+used with _tracecmd_read__ APIs.
+
+The _tracecmd_open_fd()_ function does the same as _tracecmd_open()_, but
+works with a file descriptor to a trace file, opened for reading.
+
+The _tracecmd_open_head()_ function is the same as _tracecmd_open()_, but
+does not initialize the handler for reading trace data. It reads and parses
+the metadata headers only. The _tracecmd_init_data()_ should be used before
+using the _tracecmd_read__ APIs.
+
+The _tracecmd_init_data()_ function initializes a _handle_, allocated with
+_tracecmd_open_head()_, for reading trace data from the file associated with
+it. This API must be called before any of the _tracecmd_read__ APIs.
 
 The _tracecmd_close()_ function frees a _handle_, pointer to tracecmd_input
-structure, previously allocated with _tracecmd_open_head()_.
+structure, previously allocated with _tracecmd_open()_, _tracecmd_open_fd()_
+or _tracecmd_open_head()_ APIs.
 
 RETURN VALUE
 ------------
-The _tracecmd_open_head()_ function returns a pointer to tracecmd_input
-structure or NULL in case of an error. The returned structure must be free
-with _tracecmd_close()_.
+The _tracecmd_open()_, _tracecmd_open_fd()_ and _tracecmd_open_head()_
+functions return a pointer to tracecmd_input structure or NULL in case of
+an error. The returned structure must be free with _tracecmd_close()_.
+Note that if _tracecmd_open_fd()_ is used to allocate a tracecmd_input handler,
+when _tracecmd_close()_ is called to close it, that fd will be closed also.
+
+The _tracecmd_init_data()_ function returns -1 in case of an error or
+0 otherwise.
 
 EXAMPLE
 -------
 [source,c]
 --
+The are two different use patterns for opening and reading trace data from
+a trace file, which can be used depending on the use case.
+
+1. Open and initialise the trace file in а single step:
+
 #include <trace-cmd.h>
 ...
-struct tracecmd_input *handle = tracecmd_open_head("trace.dat");
+struct tracecmd_input *handle = tracecmd_open("trace.dat");
 	if (!handle) {
 		/* Failed to open trace.dat file */
 	}
+...
+	/* Read tracing data from the file, using the handle */
 ...
 	tracecmd_close(handle);
+...
+int fd;
+ 	fd = = open("trace.dat", O_RDONLY);
+ 	if (fd < 0) {
+ 		/* Failed to open trace file for reading */
+ 	}
+ 	handle = tracecmd_open_fd(fd);
+	if (!handle) {
+		close(fd);
+		/* Failed to initialise handler for reading the trace file */
+	}
+...
+	/* Read tracing data from the file, using the handle */
+...
+	tracecmd_close(handle);
+...
 
+2. Open and initialise the trace file in two steps. This allows to perform
+some processing based on metadata, read from the file, before initialising
+the trace data for reading. Example for such use case is when opening multiple
+trace files recorded in a same trace session. In that case timestamps of all
+trace events must be adjusted based on the information from  the file's metadata
+and before reading the trace data.
+
+#include <trace-cmd.h>
+...
+struct tracecmd_input *handle = tracecmd_open_head("trace.dat");
+	if (!handle) {
+		/* Failed to open trace.dat file */
+	}
+...
+	/* do some processing, before initialising the trace data for reading */
+...
+	if (tracecmd_init_data(handle) < 0) {
+		/* Failed to initialize hadle for reading the trace data */
+	}
+...
+	/* Read tracing data from the file, using the handle */
+...
+	tracecmd_close(handle);
+...
 --
 FILES
 -----
diff --git a/Documentation/libtracecmd/libtracecmd-record.3.txt b/Documentation/libtracecmd/libtracecmd-record.3.txt
index f25dd34c..aa1a4a66 100644
--- a/Documentation/libtracecmd/libtracecmd-record.3.txt
+++ b/Documentation/libtracecmd/libtracecmd-record.3.txt
@@ -3,9 +3,8 @@ libtracecmd(3)
 
 NAME
 ----
-tracecmd_init_data, tracecmd_read_cpu_first, tracecmd_read_data,
-tracecmd_read_at, tracecmd_free_record, tracecmd_get_tep
-- Read recorded events from a trace file.
+tracecmd_read_cpu_first, tracecmd_read_data, tracecmd_read_at,
+tracecmd_free_record, tracecmd_get_tep - Read recorded events from a trace file.
 
 SYNOPSIS
 --------
@@ -13,7 +12,6 @@ SYNOPSIS
 --
 *#include <trace-cmd.h>*
 
-int *tracecmd_init_data*(struct tracecmd_input pass:[*]_handle_);
 struct tep_record pass:[*]*tracecmd_read_cpu_first*(struct tracecmd_input pass:[*]_handle_, int _cpu_);
 struct tep_record pass:[*]*tracecmd_read_data*(struct tracecmd_input pass:[*]_handle_, int _cpu_);
 struct tep_record pass:[*]*tracecmd_read_at*(struct tracecmd_input pass:[*]_handle_, unsigned long long _offset_, int pass:[*]_cpu_);
@@ -24,11 +22,7 @@ struct tep_handle pass:[*]*tracecmd_get_tep*(struct tracecmd_input pass:[*]_hand
 DESCRIPTION
 -----------
 This set of APIs can be used to read tracing data from a trace file opened
-with _tracecmd_open_head()(3)_
-
-The _tracecmd_init_data()_ function initializes the _handle_ for reading
-trace data from the file associated with it. This API must be called before
-any of the _tracecmd_read__ APIs.
+with _tracecmd_open()(3)_, _tracecmd_open_fd()(3)_ or _tracecmd_open_head()(3)_.
 
 The _tracecmd_read_cpu_first()_ function reads the first trace record
 for a given _cpu_ from a trace file associated with _handle_. The returned
@@ -54,9 +48,6 @@ _handle_.
 
 RETURN VALUE
 ------------
-The _tracecmd_init_data()_ function returns -1 in case of an error or
-0 otherwise.
-
 The _tracecmd_read_cpu_first()_, _tracecmd_read_data()_ and
 _tracecmd_read_at()_ functions return a pointer to struct tep_record or
 NULL in case of an error.The returned record must be freed with
@@ -72,7 +63,7 @@ EXAMPLE
 --
 #include <trace-cmd.h>
 ...
-struct tracecmd_input *handle = tracecmd_open_head("trace.dat");
+struct tracecmd_input *handle = tracecmd_open("trace.dat");
 	if (!handle) {
 		/* Failed to open trace.dat file */
 	}
@@ -80,11 +71,6 @@ struct tracecmd_input *handle = tracecmd_open_head("trace.dat");
 unsigned long long offset = 0;
 struct tep_record *rec;
 int cpu = 0;
-
-	if (tracecmd_init_data(handle) < 0) {
-		/* Failed to initialize hadle for reading the trace data */
-	}
-
 	rec = tracecmd_read_cpu_first(handle, cpu);
 	while (rec) {
 		...
-- 
2.29.2

