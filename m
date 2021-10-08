Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FAD7C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB3EE610CE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237331AbhJHEYR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbhJHEYP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:24:15 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369EBC061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:22:21 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id a25so15479719edx.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jZlOUq11WfGf2SYeJWLjV9onGqB7pK+xi6WjnShSs2Q=;
        b=MLAKU9PDB0PYq4uJ8JR1//Jxt/ByvsF9btFvdIXNx+L095HjefmajBXwIoFLzk+aug
         zToYTCvyWBSTZv8HQIaxosO+LagyJRB+vydnnzbP1hwmn7zypNpooi4+i7Wfyg5Ji3T5
         Z29wX1AmHami5wFxSeGwB5u8zoxOOf8FlitSD7ObEEW8c3r+CvB/kXzPdceAEXbdgKoX
         8ftkPKQe9LpfArt/nD+ZfHbNWWGMVpOcjWcBRmb8rkxYzeVJWcGCdNBAbcZ/R7PPlDvx
         CGpAvBO8rXlhQuBp5mnBmoIdWZiBd6crSTZ0SUxpQO4ShEkdl0J4jvxBfAqQXkA8GCfY
         vkOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jZlOUq11WfGf2SYeJWLjV9onGqB7pK+xi6WjnShSs2Q=;
        b=oDj/OOvw2g2zzd0PHJmvC1IuZmxsxNGI3xQX2dvpT4QqY1alcftauXxk92kLTbRKIO
         tfjMTcUdGZ/3pAZNTZqkxxSbGPhrvm+6u3rkrODI5jwLmEiC3gwid81kQBvhneSz8uUS
         h0BCGPSRkQVhR5K+ufvJG0YT2T9zz+W8FouOmU2fc85/aP5wlNj6MAvP9csQd3gp5NJx
         HzGPC1iSiogw0pZKh7JN8EQ+nq/6WonrKB8EzMUPzP8K0wOl2hg24is2TDxDSDPra7P8
         Cbt5e0gcQbeG1dxRvp5r1gQhzvARTwo6U3dYsDUj62ZtSoMWotoVT63cNTMtmfREZ8Pd
         Wplw==
X-Gm-Message-State: AOAM5306HILkAgoMKJ+I9zm1yrBpiHEZlMraHDpct+6UE0pclT+ttYXQ
        zn0e6SH584bHJurMKL4TQ/vgQPAAPI7ncQ==
X-Google-Smtp-Source: ABdhPJzLA1vrA34m9vcAXlECvweiN7qwNdqkmbYw7TKUS7baGP3YQgjR0FC9n51Qt/0uCbKKhoR7/w==
X-Received: by 2002:a05:6402:1778:: with SMTP id da24mr11927844edb.398.1633666939828;
        Thu, 07 Oct 2021 21:22:19 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g23sm517429edt.1.2021.10.07.21.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:22:19 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 03/20] trace-cmd library: Internal helpers for uncompressing data
Date:   Fri,  8 Oct 2021 07:21:57 +0300
Message-Id: <20211008042214.977193-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008042214.977193-1-tz.stoyanov@gmail.com>
References: <20211008042214.977193-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

New library internal helper functions are introduced, to add compression
functionality to the input trace handler.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h |  3 ++
 lib/trace-cmd/trace-input.c             | 49 ++++++++++++++++++++++---
 2 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 393d05e8..fd61150d 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -47,6 +47,9 @@ void out_compression_reset(struct tracecmd_output *handle, bool compress);
 unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,
 					int fd, unsigned long long max,
 					unsigned long long *write_size);
+void in_uncompress_reset(struct tracecmd_input *handle);
+int in_uncompress_block(struct tracecmd_input *handle);
+
 unsigned long long
 out_write_section_header(struct tracecmd_output *handle, unsigned short header_id,
 			 char *description, enum tracecmd_section_flags flags, bool option);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index bc1f4a87..71d5ea38 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -156,6 +156,9 @@ struct tracecmd_input {
 	long long		ts_offset;
 	struct tsc2nsec		tsc_calc;
 
+	bool			read_compress;
+	struct tracecmd_compression *compress;
+
 	struct host_trace_info	host;
 	double			ts2secs;
 	char *			cpustats;
@@ -262,13 +265,13 @@ static const char *show_records(struct page **pages, int nr_pages)
 
 static int init_cpu(struct tracecmd_input *handle, int cpu);
 
-static ssize_t do_read(struct tracecmd_input *handle, void *data, size_t size)
+static ssize_t do_read_fd(int fd, void *data, size_t size)
 {
 	ssize_t tot = 0;
 	ssize_t r;
 
 	do {
-		r = read(handle->fd, data + tot, size - tot);
+		r = read(fd, data + tot, size - tot);
 		tot += r;
 
 		if (!r)
@@ -280,6 +283,22 @@ static ssize_t do_read(struct tracecmd_input *handle, void *data, size_t size)
 	return tot;
 }
 
+static inline int do_lseek(struct tracecmd_input *handle, int offset, int whence)
+{
+	if (handle->read_compress)
+		return tracecmd_compress_lseek(handle->compress, offset, whence);
+	else
+		return lseek(handle->fd, offset, whence);
+}
+
+static inline ssize_t do_read(struct tracecmd_input *handle, void *data, size_t size)
+{
+	if (handle->read_compress)
+		return tracecmd_compress_read(handle->compress, data, size);
+	else
+		return do_read_fd(handle->fd, data, size);
+}
+
 static ssize_t
 do_read_check(struct tracecmd_input *handle, void *data, size_t size)
 {
@@ -304,9 +323,7 @@ static char *read_string(struct tracecmd_input *handle)
 
 	for (;;) {
 		r = do_read(handle, buf, BUFSIZ);
-		if (r < 0)
-			goto fail;
-		if (!r)
+		if (r <= 0)
 			goto fail;
 
 		for (i = 0; i < r; i++) {
@@ -332,7 +349,7 @@ static char *read_string(struct tracecmd_input *handle)
 	}
 
 	/* move the file descriptor to the end of the string */
-	r = lseek(handle->fd, -(r - (i+1)), SEEK_CUR);
+	r = do_lseek(handle, -(r - (i+1)), SEEK_CUR);
 	if (r < 0)
 		goto fail;
 
@@ -396,6 +413,26 @@ static int read8(struct tracecmd_input *handle, unsigned long long *size)
 	return 0;
 }
 
+__hidden void in_uncompress_reset(struct tracecmd_input *handle)
+{
+	if (handle->compress) {
+		handle->read_compress = false;
+		tracecmd_compress_reset(handle->compress);
+	}
+}
+
+__hidden int in_uncompress_block(struct tracecmd_input *handle)
+{
+	int ret = 0;
+
+	if (handle->compress) {
+		ret = tracecmd_uncompress_block(handle->compress);
+		if (!ret)
+			handle->read_compress = true;
+	}
+	return ret;
+}
+
 static struct file_section *section_get(struct tracecmd_input *handle, int id)
 {
 	struct file_section *sec;
-- 
2.31.1

