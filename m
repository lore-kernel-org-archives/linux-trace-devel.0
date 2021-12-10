Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04901C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:55:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237114AbhLJK6h (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 05:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237063AbhLJK6g (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 05:58:36 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4BCC061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:55:01 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id v1so28965086edx.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7jO+1zAhEQQUC5aodROOKBTW6wi8tRaIXN8NYqLc7O4=;
        b=brDDBUegbOuTBEzVtMJ/adepGYgV9Fubs2Kzecip1bGCTT1IFN1knQbCvnme7Ytdps
         5T3SxM3+wicBBWPD2o7zAzUm+6D/6tusH9lUSPif42IEUIsaZOCSs0OZibhjdpk3P3cN
         Z+yu0WKf2W1a1DhpFK6bohSWvoLTXjAuRGNBx/TyBP7HMeISyzr0OL8ljTmCIyRmlXJl
         iIrtIGQp2r6Jj0qw8j9C98XGQf8ZrtLhBUfi98VL3luwIGRu2uHgM2UreXGnJxtUX7Fu
         7OYAt15cBIqHvINHWaNlZ9NLL/kcTs8cWZA2Pw3V7fWQgINb7A//HqUGDvTDACIe5JzI
         hQTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7jO+1zAhEQQUC5aodROOKBTW6wi8tRaIXN8NYqLc7O4=;
        b=SYdnOQFmPja3cMiq0SpZb5ixVczi44PQQk3Y+J3Tmbs94sFWY9g24lWqUeWy5FK5W2
         5yyGmUsQwHaScrUDf36JHgHZx0897t/0vVyUXILIFQg0zNoenfqHYogQe60oWXVQjl4h
         +Y6KT5d8MMkFFcrZfvuWKhn7POCfC6hLwNkvJRAc6iE8a/l99iUWLEl+j7CbCyxm+AsX
         KSwybMnb/VWdcJh7L/RxFDhogC15m1WylbCZ6vZXQIi9e+/5Tr32CigFDAGCumSQSod6
         ZgyarDMGZCcXi0y5sWHZwCj0LKogAn7706GseK1QwED2WapKOCvHv3iZlN43Z47ucf5w
         BoNw==
X-Gm-Message-State: AOAM531jKkCCFcd91xtYFF2nVGHuNmXmwpMPLu0IrMoZ+YRfXOB3v8nP
        vPd6diy5XxEPVIwR/3A5p33TWuxlNmU=
X-Google-Smtp-Source: ABdhPJyzbdFF4bwPWbYPnqQQrD+30HjizArUaWbJ+K+XHKRPqtlO7DiBhIxEtxYNGOBSuR1FjZApeg==
X-Received: by 2002:aa7:d0d1:: with SMTP id u17mr37221560edo.135.1639133700418;
        Fri, 10 Dec 2021 02:55:00 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x7sm1306314edd.28.2021.12.10.02.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:55:00 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 11/25] trace-cmd library: Fit CPU latency trace data in the new trace file version 7 format
Date:   Fri, 10 Dec 2021 12:54:34 +0200
Message-Id: <20211210105448.97850-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105448.97850-1-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace file version 7 format is based on sections. To fit the latency
trace data in this structure, a new section and option for it is
defined:
  BUFFER_TEXT
It is similar to the BUFFER section which holds the flyrecord binary
data, but has a latency specific design for text data. The BUFFER_TEXT
section has:
 - section header, as all other sections
 - compression of the trace data, optional
 - corresponding trace option, pointing to the section

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  1 +
 lib/trace-cmd/trace-output.c                  | 24 ++++++++++++++++---
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 047fc26f..d8ee9b74 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -145,6 +145,7 @@ enum {
 	TRACECMD_OPTION_KALLSYMS,
 	TRACECMD_OPTION_PRINTK,
 	TRACECMD_OPTION_CMDLINES,
+	TRACECMD_OPTION_BUFFER_TEXT,
 	TRACECMD_OPTION_MAX,
 };
 
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 44050dc8..47227728 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1874,7 +1874,9 @@ out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
 
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus)
 {
+	enum tracecmd_section_flags flags = 0;
 	struct tracecmd_output *handle;
+	tsize_t offset;
 	char *path;
 
 	handle = tracecmd_output_create(output_file);
@@ -1891,7 +1893,8 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 
 	if (tracecmd_write_cpus(handle, cpus) < 0)
 		goto out_free;
-
+	if (tracecmd_write_buffer_info(handle) < 0)
+		goto out_free;
 	if (tracecmd_write_options(handle) < 0)
 		goto out_free;
 
@@ -1901,23 +1904,38 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 		goto out_free;
 	}
 
-	if (do_write_check(handle, "latency  ", 10))
+	if (!HAS_SECTIONS(handle) && do_write_check(handle, "latency  ", 10))
 		goto out_free;
 
 	path = get_tracing_file(handle, "trace");
 	if (!path)
 		goto out_free;
 
+	offset = do_lseek(handle, 0, SEEK_CUR);
+	if (HAS_SECTIONS(handle) &&
+	    !out_add_buffer_option_v7(handle, "", TRACECMD_OPTION_BUFFER_TEXT, offset, 0, NULL))
+		goto out_free;
+
+	offset = out_write_section_header(handle, TRACECMD_OPTION_BUFFER_TEXT,
+					  "buffer latency", flags, false);
+
 	copy_file(handle, path);
+	if (out_update_section_header(handle, offset))
+		goto out_free;
 
 	put_tracing_file(path);
 
 	handle->file_state = TRACECMD_FILE_CPU_LATENCY;
 
+	if (HAS_SECTIONS(handle))
+		tracecmd_write_options(handle);
+
 	return handle;
 
 out_free:
-	tracecmd_output_close(handle);
+	if (handle)
+		tracecmd_output_close(handle);
+	unlink(output_file);
 	return NULL;
 }
 
-- 
2.33.1

