Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5014BC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AC8360F58
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233995AbhKKPO7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:14:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233991AbhKKPO6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:14:58 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF5BC061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:09 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id v11so25479210edc.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ysWlhe9zjnYL/T8prK0xXq8+XvsRI88igIHmwsQhv9M=;
        b=Sj0LecgrU4eGL4h+57FzIJfhXU0l4IfIs6UGss/0dCU/1eG/19c4kQCN1ezcBfnpXy
         aNDHm48iYs37SzO6Dp6cEXPd8knpg66Mo5HIOHiv4Lqb+Pb6mEEwzwmdGVhP3Q1MHi2e
         23nANApGm49VTt7DWKNLBDKiSqG+SB9OfIkNXmdBoU+/OdNdC4uAp62sn+pc89fouLKN
         vLYl8b6Bb17USp6UNFKSa9Q951uxd3W/CeMDh1+YtxvmEtDlEWle2J0eRuyelalavqJw
         OBQzsRwDZAUwoGRQnbqBrPvQMSWjTiRo4qSWWiU3G7uiM5wck5w9fyhJ0x4J1h1cs2m1
         2+iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ysWlhe9zjnYL/T8prK0xXq8+XvsRI88igIHmwsQhv9M=;
        b=y0Q4/nGZx6BDguueSGxHaG+N7VADTjTQsqL5FuQx+9ZVd/AzdLsB9LYcNKAvV3s8eS
         CVYqTDPEpLADHOaiNJGT7tUuAg3vuT2xXVqGj0L1kq5nP2cOpJZYObIDjdEUlGowMIEz
         FbI4BwQU8K93KfXZ0EduXVRn6ifT9CW5JhlpqK4m/F/7hPvtg2XoW45XL3FVy0BkwVeb
         bCKENtSVDXsu5EjQc+b/BUZNcZJCOcubRLDmqIa8tpaFqTsOou3H4XCss5cbJWk2m7Rh
         YWuYiu1e5z2FNp/gVPNCCs9M0tNqvlA3wM62BDxKcZ9VrGoba+A8MnDHnSfNeDvN5Jdi
         up4g==
X-Gm-Message-State: AOAM532c2Jm+Gmgmd0ADUPUSRZNp4N5g0kp3uxVMuvc3aQRdl99pFnj4
        DDAuZK5cS/CT1iSuRZ/Y7lBHPpHbDo4Npg==
X-Google-Smtp-Source: ABdhPJzfxHi9ex3Zjh8iBcOoiNfF2OUfwE9rh9a2RCZ65C4/t24xsGu7G6ruuwgJxPjPABM8al521A==
X-Received: by 2002:a17:906:6c83:: with SMTP id s3mr10527597ejr.13.1636643528047;
        Thu, 11 Nov 2021 07:12:08 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id qf9sm1479509ejc.18.2021.11.11.07.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:12:07 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 11/20] trace-cmd library: Read compression header
Date:   Thu, 11 Nov 2021 17:11:44 +0200
Message-Id: <20211111151153.86855-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151153.86855-1-tz.stoyanov@gmail.com>
References: <20211111151153.86855-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace file version 7 introduced new mandatory compression header,
storing information about the compression algorithm used to compress the
trace file. Added code to read that header and to initialize compression
context according to it.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index b7ad946c..2badc341 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -190,6 +190,7 @@ __thread struct tracecmd_input *tracecmd_curr_thread_handle;
 
 #define CHECK_READ_STATE(H, S) ((H)->file_version < FILE_VERSION_SECTIONS && (H)->file_state >= (S))
 #define HAS_SECTIONS(H) ((H)->flags & TRACECMD_FL_SECTIONED)
+#define HAS_COMPRESSION(H) ((H)->flags & TRACECMD_FL_COMPRESSION)
 
 static int read_options_type(struct tracecmd_input *handle);
 
@@ -3784,7 +3785,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	char test[] = TRACECMD_MAGIC;
 	unsigned int page_size;
 	size_t offset;
-	char *version;
+	char *version = NULL;
+	char *zver = NULL;
+	char *zname = NULL;
 	char buf[BUFSIZ];
 	unsigned long ver;
 
@@ -3822,9 +3825,12 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	}
 	handle->file_version = ver;
 	free(version);
+	version = NULL;
 
 	if (handle->file_version >= FILE_VERSION_SECTIONS)
 		handle->flags |= TRACECMD_FL_SECTIONED;
+	if (handle->file_version >= FILE_VERSION_COMPRESSION)
+		handle->flags |= TRACECMD_FL_COMPRESSION;
 
 	if (do_read_check(handle, buf, 1))
 		goto failed_read;
@@ -3854,6 +3860,26 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	handle->total_file_size = lseek64(handle->fd, 0, SEEK_END);
 	lseek64(handle->fd, offset, SEEK_SET);
 
+	if (HAS_COMPRESSION(handle)) {
+		zname = read_string(handle);
+		if (!zname)
+			goto failed_read;
+		zver = read_string(handle);
+		if (!zver)
+			goto failed_read;
+		if (strcmp(zname, "none")) {
+			handle->compress = tracecmd_compress_alloc(zname, zver,
+								   handle->fd,
+								   handle->pevent, NULL);
+			if (!handle->compress) {
+				tracecmd_warning("Unsupported file compression %s %s", zname, zver);
+				goto failed_read;
+			}
+		}
+		free(zname);
+		free(zver);
+	}
+
 	if (HAS_SECTIONS(handle)) {
 		if (read8(handle, &(handle->options_start))) {
 			tracecmd_warning("Filed to read the offset of the first option section");
@@ -3866,6 +3892,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	return handle;
 
  failed_read:
+	free(version);
+	free(zname);
+	free(zver);
 	free(handle);
 
 	return NULL;
@@ -4064,7 +4093,8 @@ void tracecmd_close(struct tracecmd_input *handle)
 	if (handle->flags & TRACECMD_FL_BUFFER_INSTANCE)
 		tracecmd_close(handle->parent);
 	else {
-		/* Only main handle frees plugins and pevent */
+		/* Only main handle frees plugins, pevent and compression context */
+		tracecmd_compress_destroy(handle->compress);
 		tep_unload_plugins(handle->plugin_list, handle->pevent);
 		tep_free(handle->pevent);
 	}
-- 
2.33.1

