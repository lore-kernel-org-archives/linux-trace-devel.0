Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BAA6C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:25:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352399AbiASIZ0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:25:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352397AbiASIZX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:25:23 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7276C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:22 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id m11so7402639edi.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0pLou1Be3byddCLV3Mi5US8QWZoFw9sYxhCJMlrcNzE=;
        b=aaju71/qqc1BPa7QmWMawS3MUwRNmc4rlt6NtNsmLuT4imrUOzPtwIyTKd8MNgpeNz
         HaXgV+beHoXNMWLc275/C8HhwxuhA0rPaIj+53KKptyq8kVF5K5GxpplpItLB1vUSOJO
         +OsXk6n1S25+qjQSQDNUcXCtujzO3r+nFRIDqOBryQG0XYQ79yZkSMEeH1wAks0JfF3J
         jqBJ/D8TYrCFYQccQgMz3hqmqvilQKAzhKEOKOFMXd53M+I6IvD6LyMYbgacylGO9jGM
         JAiXvBtVGpgV8dFmrLrMXgTBcOnkSnd3QT0p8dLhEwWcjXjp+QKCE2/zExZTZMKnKFKW
         J2fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0pLou1Be3byddCLV3Mi5US8QWZoFw9sYxhCJMlrcNzE=;
        b=b8oNWewfWXQQpfiT90wgQ91zZA0rLlRB3AprE19Y6ae8ZHaiZ4/RZC63aD3h98ySNV
         kTcQwSV3mrBoc5d+QZAnOnJfovND7IoY32q3w1+JT354EVDj7yxRcn8rriHT39ruhbRt
         biNGYQtk8Ls9UPaznsvTT+2uoqDTMMGN44RIqUG5dJ7SUrRTk0cWDdzafBAyKQaUUD7w
         EFCC62gFGcGW9vREE0oCQGHDAOlPYO1Ma873KNXk2PCgubyfdO59z1ZBYOpdf8eHSDr5
         +nOE6T7F5AP6BwbMNlraCO6NyJCH89oTpLkwkL9hGLmNFPAT41ra57jjIXKeW15yA9F0
         l3VQ==
X-Gm-Message-State: AOAM533ogYwonWb9CQSzXAmPS9A+K3frZM/o6PrW6mN1wIP0BhMmUV/H
        SxujV3v/WYFUf1k66YG5uFiApL/yUso=
X-Google-Smtp-Source: ABdhPJzxV1cgF5xKdwRJm41ZEgI03eepi351hX4UmBp5f6ELdDG+1sseTCeZofDs9u/gZ1hDFAxjBw==
X-Received: by 2002:a17:907:1c8a:: with SMTP id nb10mr23781839ejc.5.1642580721250;
        Wed, 19 Jan 2022 00:25:21 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l1sm5011122ejf.44.2022.01.19.00.25.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:25:20 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 11/25] trace-cmd library: Fit CPU latency trace data in the new trace file version 7 format
Date:   Wed, 19 Jan 2022 10:24:53 +0200
Message-Id: <20220119082507.245600-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082507.245600-1-tz.stoyanov@gmail.com>
References: <20220119082507.245600-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-output.c                  | 20 +++++++++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index eaf51f5f..953297f3 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -150,6 +150,7 @@ enum {
 	TRACECMD_OPTION_KALLSYMS,
 	TRACECMD_OPTION_PRINTK,
 	TRACECMD_OPTION_CMDLINES,
+	TRACECMD_OPTION_BUFFER_TEXT,
 	TRACECMD_OPTION_MAX,
 };
 
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 30bf0dd1..7e1849c8 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1892,7 +1892,9 @@ out_add_buffer_option(struct tracecmd_output *handle, const char *name,
 
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus)
 {
+	enum tracecmd_section_flags flags = 0;
 	struct tracecmd_output *handle;
+	tsize_t offset;
 	char *path;
 
 	handle = tracecmd_output_create(output_file);
@@ -1909,7 +1911,8 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 
 	if (tracecmd_write_cpus(handle, cpus) < 0)
 		goto out_free;
-
+	if (tracecmd_write_buffer_info(handle) < 0)
+		goto out_free;
 	if (tracecmd_write_options(handle) < 0)
 		goto out_free;
 
@@ -1919,19 +1922,32 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
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
+	    !out_add_buffer_option(handle, "", TRACECMD_OPTION_BUFFER_TEXT, offset, 0, NULL))
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
-- 
2.34.1

