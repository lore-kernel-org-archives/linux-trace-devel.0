Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 913FEC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:11:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E23361252
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:11:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233890AbhKKPOG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:14:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233854AbhKKPOF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:14:05 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C14C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:11:16 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id z21so25404188edb.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:11:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k6NE8OO3euVt7z09x9MAKo0Pnnt76BjxGY33SBas1nE=;
        b=FJiDX1yN+LKuFot/fougt/QoeftyyfmcZ367pj7jrCKpuUrsTik3WsPbsnj9wPDFa1
         K1etZFh+epIkNxaYpf8I4la5zL3H7ogdZ9txvFQP0y8uvpgmrQ6PBPT6qUf75VqpPI7A
         9k6/z8rgkSjCf3JWn3pqBMRP2YRW+ccZ+QU6IM8zK6M+S0GsAeZWt8NwTkYXpHCxVHWu
         Z9gzkDVm2K0jzusVsW5Hs5dnVk1RNfxUPnnq+psZadgR+BbClw/F6Sz7hYUmang5BtXH
         4Om4pzyqC7X3QrbQ4jD4RXNBsgYwtq2aGs4Gc3EifNgblgZD7pphcOHyH9RRmrqMRorc
         YThg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k6NE8OO3euVt7z09x9MAKo0Pnnt76BjxGY33SBas1nE=;
        b=nbUJRPT7zId390ApDFQny+zPTU+qU4dAXiG0kkMbjaT8ncN86x87/u2zjpV8AY1bwl
         +BIeW4zYQ7eddW0K8ZewA0ti1NcLlZ6L4kTH/h2hSygOvjb3ks3ezlSO9ryr8wqRNnpC
         nAA8XPKxa0f8AGeghGNp1Om3bddcO4/jAq+n9cgqThh0rX/uvEgRHhFcpxi26+SMclDa
         r5hGnnXBRiwk9Zm8pHLBKRRI6fTsUXFWU4xRSbL286RDsMNr05UZ2/enRGJ6oatAWz94
         luWpDBVCOXbpMlhmARw9j2P72Xgm1mO3IHq7V+XLIBOb0MHaSY5od/NyvMowp0l0TikQ
         hg3g==
X-Gm-Message-State: AOAM530VWGD5J9L34Q0tXi9Fz18i1aJM7lHi0NeaFwkBvkn8ZIHrrsfO
        hY/BYVIMxrN3Ah44AlUyPVzna3TpJlwGxQ==
X-Google-Smtp-Source: ABdhPJxs95xmJ4v6pkHuQCEX4zlDOed4d7IfmVhsi14dmcaqP/M/qXI9RROw1vbNVsa9sOjNZOp/Fg==
X-Received: by 2002:a17:906:6bc4:: with SMTP id t4mr9980719ejs.259.1636643474836;
        Thu, 11 Nov 2021 07:11:14 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id nc30sm1648803ejc.35.2021.11.11.07.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:11:14 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 11/25] trace-cmd library: Fit CPU latency trace data in the new trace file version 7 format
Date:   Thu, 11 Nov 2021 17:11:04 +0200
Message-Id: <20211111151112.86751-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151112.86751-1-tz.stoyanov@gmail.com>
References: <20211111151112.86751-1-tz.stoyanov@gmail.com>
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
index be9c79cc..8159c2a9 100644
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
index baa262fb..028ad580 100644
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
2.33.1

