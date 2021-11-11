Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7253EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:09:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 564B361252
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:09:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233868AbhKKPMJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:12:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233810AbhKKPMG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:12:06 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA24C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:09:17 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id z21so25381891edb.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:09:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=77jR0p82kdn+GCoB+qgvModi8/WHtgjAp8mMa+wm5Zg=;
        b=W5z+3G3iVGTtbx/hmuHYoiuqkv+1HxwIwdoVDFrZU+Xs6y0wDHWlYd7zZivoBFtoJa
         Fh3s+839ABS6go2giaBHvULrTbZsdi91O5FIe6Id4mFYdZY/Q5BVipFoXDCCFIrHLN11
         +L5xcC3aaO8AxUVxcFOc1YKIm8b5bl50/f/2PODrWILMdrWq2sIo8bBrKH8fNjilD7aB
         3OBEWJ8dxPnuczqIRw9GvCVTiIiE2VNXk0Ia0NrrlhMbQ2ur+rRjKR/dlXZRRZWvLGJd
         CTZ2irpQfL8KiClKfnj/tybHJSMz/A3WOGKUnqNcHr4AU5WROCnQ6STZDRjEmIOmNAD8
         Lkuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=77jR0p82kdn+GCoB+qgvModi8/WHtgjAp8mMa+wm5Zg=;
        b=r1tzSIZJ8rz7zgb/eLeBTY5z9RBEG+eQv1GzbDso7HwxOXIbExTcwbmqU4tejTs1F9
         P11ViKh3isTVUCDSxOIaVxSDNIGw6SP0+2Odw94mevbDHHgxa5XzQ3cV6C4PFiZASKH1
         VoJcaAt+BJhcTMVROHc2J4YZTfWhUPoNgUtMwopneDRR22VYztKVgXtd4cDvlNCSx840
         +yR9thovaycNqoY3+ISVU1NU05EsGYobp4fquD3thWaOiwSSMjSXdDCLOpTSUBi1umj/
         /A8gWqaZmyaZpiLG14425dcg7WKVRRRaZbMgAftXkMKk4TI0X7EOgRZ2mD36lRA0k+ww
         oltg==
X-Gm-Message-State: AOAM5304j/lIfQ4DXz2MgnA6zXBs8lmm6HcpTAR8IXwGU8pCMgClz1QR
        0bxH3kYTxmf7Ko63evWvhE2M1rzGgBoGzA==
X-Google-Smtp-Source: ABdhPJyV7aIRcGup+Hic3V6G7rwxR8za/EapP6DxNOf5CgzeWTC7+YSNioKMejVgmjFH4T2noX4aRw==
X-Received: by 2002:a17:907:1626:: with SMTP id hb38mr10222178ejc.481.1636643355869;
        Thu, 11 Nov 2021 07:09:15 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id hg19sm713267ejc.1.2021.11.11.07.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:09:15 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 06/25] trace-cmd library: Add multiple options sections in trace file version 7
Date:   Thu, 11 Nov 2021 17:09:14 +0200
Message-Id: <20211111150914.86620-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Introduced chain of options sections in trace file version 7. Extended
the "DONE" option to hold the offset into the file to the next options
section.
Format of trace file version 7 is extended with a new mandatory field
after the compression algorithm header:
 <8 bytes>, unsigned long long integer - offset into the trace file
where the first options section is located. This allows to place this
section anywhere in the file. As all other sections have corresponding
options, describing their offsets into the trace file, this change makes
the structure of trace file version 7 flexible.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 101 ++++++++++++++++++++++++++++++++---
 1 file changed, 94 insertions(+), 7 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index db72f47d..48e69850 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -62,7 +62,7 @@ struct tracecmd_output {
 	bool			quiet;
 	unsigned long		file_state;
 	unsigned long		file_version;
-	size_t			options_start;
+	tsize_t			options_start;
 	bool			big_endian;
 
 	struct list_head	options;
@@ -1212,6 +1212,7 @@ int tracecmd_output_set_version(struct tracecmd_output *handler, int file_versio
  */
 int tracecmd_output_write_init(struct tracecmd_output *handler)
 {
+	unsigned long long offset;
 	char buf[BUFSIZ];
 	int endian4;
 
@@ -1245,6 +1246,14 @@ int tracecmd_output_write_init(struct tracecmd_output *handler)
 	endian4 = convert_endian_4(handler, handler->page_size);
 	if (do_write_check(handler, &endian4, 4))
 		return -1;
+	if (HAS_SECTIONS(handler)) {
+		/* Write 0 as options offset and save its location */
+		offset = 0;
+		handler->options_start = do_lseek(handler, 0, SEEK_CUR);
+		if (do_write_check(handler, &offset, 8))
+			return -1;
+	}
+
 	handler->file_state = TRACECMD_FILE_INIT;
 	return 0;
 }
@@ -1313,7 +1322,7 @@ tracecmd_add_option_v(struct tracecmd_output *handle,
 	 * We can only add options before tracing data were written.
 	 * This may change in the future.
 	 */
-	if (handle->file_state > TRACECMD_FILE_OPTIONS)
+	if (!HAS_SECTIONS(handle) && handle->file_state > TRACECMD_FILE_OPTIONS)
 		return NULL;
 
 	for (i = 0; i < count; i++)
@@ -1326,8 +1335,7 @@ tracecmd_add_option_v(struct tracecmd_output *handle,
 			return NULL;
 		}
 	}
-
-	option = malloc(sizeof(*option));
+	option = calloc(1, sizeof(*option));
 	if (!option) {
 		tracecmd_warning("Could not allocate space for option");
 		free(data);
@@ -1390,7 +1398,7 @@ int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus)
 	return 0;
 }
 
-int tracecmd_write_options(struct tracecmd_output *handle)
+static int write_options_v6(struct tracecmd_output *handle)
 {
 	struct tracecmd_option *options;
 	unsigned short option;
@@ -1408,7 +1416,7 @@ int tracecmd_write_options(struct tracecmd_output *handle)
 
 	if (do_write_check(handle, "options  ", 10))
 		return -1;
-
+	handle->options_start = do_lseek(handle, 0, SEEK_CUR);
 	list_for_each_entry(options, &handle->options, list) {
 		endian2 = convert_endian_2(handle, options->id);
 		if (do_write_check(handle, &endian2, 2))
@@ -1432,11 +1440,83 @@ int tracecmd_write_options(struct tracecmd_output *handle)
 		return -1;
 
 	handle->file_state = TRACECMD_FILE_OPTIONS;
+	return 0;
+}
+
+static int write_options_v7(struct tracecmd_output *handle)
+{
+	struct tracecmd_option *options;
+	unsigned long long endian8;
+	unsigned short endian2;
+	unsigned int endian4;
+	bool new = false;
+	tsize_t offset;
+
+	/* Check if there are unsaved options */
+	list_for_each_entry(options, &handle->options, list) {
+		if (!options->offset) {
+			new = true;
+			break;
+		}
+	}
+
+	if (!new)
+		return 0;
+	offset = do_lseek(handle, 0, SEEK_CUR);
+	/* Append to the previous options section, if any */
+	if (handle->options_start) {
+		if (do_lseek(handle, handle->options_start, SEEK_SET) == (off64_t)-1)
+			return -1;
+		endian8 = convert_endian_8(handle, offset);
+		if (do_write_check(handle, &endian8, 8))
+			return -1;
+		if (do_lseek(handle, offset, SEEK_SET) == (off_t)-1)
+			return -1;
+	}
+	offset = out_write_section_header(handle, TRACECMD_OPTION_DONE, "options", 0, false);
+	if (offset == (off_t)-1)
+		return -1;
+	list_for_each_entry(options, &handle->options, list) {
+		/* Option is already saved, skip it */
+		if (options->offset)
+			continue;
+		endian2 = convert_endian_2(handle, options->id);
+		if (do_write_check(handle, &endian2, 2))
+			return -1;
+		endian4 = convert_endian_4(handle, options->size);
+		if (do_write_check(handle, &endian4, 4))
+			return -1;
+		/* Save the data location */
+		options->offset = do_lseek(handle, 0, SEEK_CUR);
+		if (do_write_check(handle, options->data, options->size))
+			return -1;
+	}
+
+	endian2 = convert_endian_2(handle, TRACECMD_OPTION_DONE);
+	if (do_write_check(handle, &endian2, 2))
+		return -1;
+	endian4 = convert_endian_4(handle, 8);
+	if (do_write_check(handle, &endian4, 4))
+		return -1;
+	endian8 = 0;
+	handle->options_start = do_lseek(handle, 0, SEEK_CUR);
+	if (do_write_check(handle, &endian8, 8))
+		return -1;
+	if (out_update_section_header(handle, offset))
+		return -1;
 
 	return 0;
 }
 
-int tracecmd_append_options(struct tracecmd_output *handle)
+int tracecmd_write_options(struct tracecmd_output *handle)
+{
+	if (!HAS_SECTIONS(handle))
+		return write_options_v6(handle);
+	return write_options_v7(handle);
+}
+
+
+static int append_options_v6(struct tracecmd_output *handle)
 {
 	struct tracecmd_option *options;
 	unsigned short option;
@@ -1487,6 +1567,13 @@ int tracecmd_append_options(struct tracecmd_output *handle)
 	return 0;
 }
 
+int tracecmd_append_options(struct tracecmd_output *handle)
+{
+	if (!HAS_SECTIONS(handle))
+		return append_options_v6(handle);
+	return write_options_v7(handle);
+}
+
 static struct tracecmd_option *
 add_buffer_option(struct tracecmd_output *handle, const char *name, int cpus)
 {
-- 
2.33.1

