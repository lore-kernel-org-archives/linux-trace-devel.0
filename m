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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAB4BC433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:42:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA71F61004
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239998AbhIMMnd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239986AbhIMMnd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:43:33 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45487C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:42:16 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id d207-20020a1c1dd8000000b00307e2d1ec1aso725662wmd.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BqdXmJM70z8KjHEjztcSICoax63heaUEMM003tJ1TUg=;
        b=DEbS0LHe1j4Q2LbFeKQcQcOn8WHjWuJQmhkoXG+E7/+Xfj6CQ5SbIuMH4147Fxg/64
         UPH0pIH5tfNQ/tveRqjsowkb1+O2MpTEUlYsVGViRqrcSJQ4ukktatzrUWJBCtnkI1/r
         u01ZSYo0YSXWY44yZf6GsWnU4hqVgnoG1+cJRw/ute+CGZDN7D4uH/ARH5CgFoV0B3v3
         I1wjKgpsrhqIBOUh1WrUc/vRINiaU/A7yDHB6SV0YOs3lLQX2UkYGM65P9IAefzicFIb
         vAiMOef+ie3bzP57h1CvK+YmLV5+zdgBIWF/sSK6cR/dcod0kzOJTqGo4uqNFbgBLELn
         5OuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BqdXmJM70z8KjHEjztcSICoax63heaUEMM003tJ1TUg=;
        b=wn6p80m2BKf+gmxlDP3sR8qQIY6o30F6lKPI3DzTE9Q2pk1IJA6L8SbD8XLxyeCwwG
         bCAHqZvKNLOffQTUTEUKSR8wb7HZy9olD5LqXJc6iaFF/mFz8SnH6faTDgpBZ6tY94Zd
         vvHIf5Kgg3Hlyntd+CAEkPOMjamp7gxZqvX05ybYLoNkyX0McnYgg6D7LNG9rd7fouT5
         wreFOP7Up0NwOjawZiwv0d7dm7zAmoB+/ZW7OEUodMDJSfX1O2//NpdO59y7YYxoI+iN
         3nAT2Glt7JnNLDP99UGv5xlkpfI8L5rh++tGLkuU1aJaFErV2oWt1hRm2MrJF+G+tUnN
         6AsA==
X-Gm-Message-State: AOAM531oCLsFSp13o1bHGxiy9Ysnw1Zzf142KWbkAUVBq1rMOMHl+Ohx
        kO1uSK5LY3iDB30AFwdQv27YKXj1j2k=
X-Google-Smtp-Source: ABdhPJy0+Mmwpi6Ds4d1EclGVcxxYmqVzhKaPy4YpxCbIC/fjJgcK9aAfeDl+fARe1k/4jz4rUot+Q==
X-Received: by 2002:a05:600c:1c11:: with SMTP id j17mr11419120wms.138.1631536934846;
        Mon, 13 Sep 2021 05:42:14 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u13sm7244290wrt.41.2021.09.13.05.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:42:14 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 11/20] trace-cmd library: Read compression header
Date:   Mon, 13 Sep 2021 15:41:54 +0300
Message-Id: <20210913124203.3677760-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913124203.3677760-1-tz.stoyanov@gmail.com>
References: <20210913124203.3677760-1-tz.stoyanov@gmail.com>
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
index 320561d0..19a86269 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -189,6 +189,7 @@ __thread struct tracecmd_input *tracecmd_curr_thread_handle;
 
 #define CHECK_READ_STATE(H, S) ((H)->file_version < FILE_VERSION_SECTIONS && (H)->file_state >= (S))
 #define HAS_SECTIONS(H) ((H)->flags & TRACECMD_FL_SECTIONED)
+#define HAS_COMPRESSION(H) ((H)->flags & TRACECMD_FL_COMPRESSION)
 
 static int read_options_type(struct tracecmd_input *handle);
 
@@ -3795,7 +3796,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	char test[] = TRACECMD_MAGIC;
 	unsigned int page_size;
 	size_t offset;
-	char *version;
+	char *version = NULL;
+	char *zver = NULL;
+	char *zname = NULL;
 	char buf[BUFSIZ];
 	unsigned long ver;
 
@@ -3833,9 +3836,12 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
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
@@ -3865,6 +3871,26 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
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
@@ -3877,6 +3903,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	return handle;
 
  failed_read:
+	free(version);
+	free(zname);
+	free(zver);
 	free(handle);
 
 	return NULL;
@@ -4075,7 +4104,8 @@ void tracecmd_close(struct tracecmd_input *handle)
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
2.31.1

