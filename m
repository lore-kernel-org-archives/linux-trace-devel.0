Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E9C4C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C770611CC
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233743AbhIJNwb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233753AbhIJNw0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:52:26 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5591C06175F
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:14 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id t6so1169288edi.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=siYT70cnWkBDQ2BIxekO7y5eI3OpEmuxN8weLZQnF3s=;
        b=YP4yCvPF5CbMkuYdolH7ZQ9K3a481nHaK/+mcckW4qh+5sI5CG2oAui17qy40w4iXN
         gMTV4cqEagEYu6HAxPZ5eX06YvQgzhs00VVtohTqircSGWZZt1DjUyR4IVvAJ96nVa5w
         tkRG90gFHwGw6Zw6Av0nW5Q72+0V/40sVbOK/RY4rUCtf8eZmABgpKUcNdAAxm1uevOr
         8RttYab/L9ep/Qd9dUl57C1MC2xG494R7lL8YHx3EaBfvfrl5//rXaUCdczrktZ5+X//
         XTp+P3C9+bD4qEp1lCpbCOR60CIVlQUarSpHIsLH4pyDDXUTfW/a4rIwUbKhdrbwEJav
         8m5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=siYT70cnWkBDQ2BIxekO7y5eI3OpEmuxN8weLZQnF3s=;
        b=SGETAQRbBLLkL4/QbWp9llbeGAx3LCWG7S8bnNrJmpkfl3qFEdMu858FKUBf63QUAW
         R630ei6x1Gc2FG/TIcgA4QexaquKZ95NReIK4ZvUfAfoe+0inoBcNDCR1z9c5IJh/MX8
         rN/fpLeUJW+NUWw700IAQQKmE1liQeybK2I2Hw2x0hxefrAepNpmxijrjmx8LQ/QsyR8
         tm24liyfSIyIwoDKB08YpgkoTyBoZd3C5WC7e7vg4l67I36QV2hiOHbeGIlsWoIyEXpK
         fjJQg44PnsYe3h9q16PEnydcPDa5SujVjsIzSV9FWFjIG4PJVpQgI4hWkQAsKml7Ims0
         5G1w==
X-Gm-Message-State: AOAM530WZIw1/hbjU4B0vqMf5nqrigo9ZsNPUD4QEnLnR/4otQ71/kGi
        4MK5p7nFj6+IgWz+Uct5m0fg52yDFhc=
X-Google-Smtp-Source: ABdhPJywyXD2mslGEiwn7PzsQ7dipsxAyCLPutgton5TLi/pXCntGjVrYWLCo4rQH5HQ5NX2j+hMpg==
X-Received: by 2002:aa7:cad7:: with SMTP id l23mr9169054edt.75.1631281873569;
        Fri, 10 Sep 2021 06:51:13 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w13sm2484683ejc.100.2021.09.10.06.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:51:13 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 11/25] trace-cmd library: Fit CPU latency trace data in the new trace file version 7 format
Date:   Fri, 10 Sep 2021 16:50:47 +0300
Message-Id: <20210910135101.2865226-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
References: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-output.c                  | 26 ++++++++++++++++---
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index d85a4b3b..d8a981af 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -144,6 +144,7 @@ enum {
 	TRACECMD_OPTION_KALLSYMS,
 	TRACECMD_OPTION_PRINTK,
 	TRACECMD_OPTION_CMDLINES,
+	TRACECMD_OPTION_BUFFER_TEXT,
 	TRACECMD_OPTION_MAX,
 };
 
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 4602a1d4..0e928858 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1788,7 +1788,9 @@ out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
 
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus)
 {
+	enum tracecmd_section_flags flags = 0;
 	struct tracecmd_output *handle;
+	tsize_t offset;
 	char *path;
 	int fd;
 
@@ -1811,7 +1813,8 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 
 	if (tracecmd_write_cpus(handle, cpus) < 0)
 		goto out_free;
-
+	if (tracecmd_write_buffer_info(handle) < 0)
+		goto out_free;
 	if (tracecmd_write_options(handle) < 0)
 		goto out_free;
 
@@ -1821,23 +1824,40 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
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
+	else
+		close(fd);
+	unlink(output_file);
 	return NULL;
 }
 
-- 
2.31.1

