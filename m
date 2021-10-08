Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DFBFC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 211D160F6E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237483AbhJHEWK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237403AbhJHEWI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:22:08 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CEE0C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:20:13 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id p13so31773764edw.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MCSjcAZzl8HvLf62GLpS1jNY5zBOtwa1ytwFqmY3pMY=;
        b=iMVH38SGEDNm85n8FcgpT5ThijAqCT8rLqavWaPm5GFxU+W3+M88kYeTw8mEmnBiAa
         sLfcAKLSr2GPu392DPFIQvkra1mI8gDGYefUTArmTu/qJ/RmzVvWOqFVcVgeK/XlYkqJ
         T2NNqFTt3BYeRAgnuqXu7BbbkwJleNitZFhFilPgWcAhkR7HzM6CEJg2wCmyP6YfC5CI
         +4H96niNXdgdPxyG+K/OZTlr4TtfL8EqVZHYxFYPVN8m+aam5YL5WLuONEUipIa7vvgM
         M/ajf+FdUlGDL8vlJPV5NGxa/peHEaV7+jNWmh5aB0Wd7SsGvMsQUx//pIY05LdcvRAL
         XWaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MCSjcAZzl8HvLf62GLpS1jNY5zBOtwa1ytwFqmY3pMY=;
        b=B3UZfefOStlLrLijOT5TBN38gs0HnNoug32PJLIlTMUkkJPuz5o9/CoT/Md0avJZBd
         JXFBDyT6QYmvkKvNVZ+nKz5Nn7WYMIEoKfO886K8A8+Q2n1fDI0qJYXz18JnaJCIC3bP
         xaU2ns+diRBlPrW/pe0/nLuQMTknYjHItrAV8W4JQ9KdgtT8YE/F8RyKOU5snF3tZkK6
         eA8lCfrFOw2gNkRV0YaMjwsBj9FEbdmXq49Y45lgM1AeYS+/qXXsjohAPSfqn7IfwdX6
         bKWt8cYGQ21JmAyZWIEVw3D+fRUSYxXAenuo6ig1IR4AdiM8qdVP0o1hkHijTPP3IW/Q
         N5mA==
X-Gm-Message-State: AOAM533ADn9aNYWR6AP4HYAojvQF4Tct03n/JUgc/nlaFoHeo8vB/rBK
        0rlR6YZ7wANHyWjPRGzUzycTl1+hH954dw==
X-Google-Smtp-Source: ABdhPJw2nS5hOE6UerBsBMWjlhSoibFoe6/oO3eKJSkjQ2Wyk+FPQsLNYVMpIa03JVk82e/P8mvAdQ==
X-Received: by 2002:a05:6402:142e:: with SMTP id c14mr11787486edx.209.1633666812113;
        Thu, 07 Oct 2021 21:20:12 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p6sm511669edi.18.2021.10.07.21.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:20:11 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 11/25] trace-cmd library: Fit CPU latency trace data in the new trace file version 7 format
Date:   Fri,  8 Oct 2021 07:19:44 +0300
Message-Id: <20211008041958.976309-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041958.976309-1-tz.stoyanov@gmail.com>
References: <20211008041958.976309-1-tz.stoyanov@gmail.com>
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
index a5025d50..ebe5b179 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1780,7 +1780,9 @@ out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
 
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus)
 {
+	enum tracecmd_section_flags flags = 0;
 	struct tracecmd_output *handle;
+	tsize_t offset;
 	char *path;
 	int fd;
 
@@ -1803,7 +1805,8 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 
 	if (tracecmd_write_cpus(handle, cpus) < 0)
 		goto out_free;
-
+	if (tracecmd_write_buffer_info(handle) < 0)
+		goto out_free;
 	if (tracecmd_write_options(handle) < 0)
 		goto out_free;
 
@@ -1813,23 +1816,40 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
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

