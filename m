Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6910EC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 470EF60F6E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237300AbhJHEWE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbhJHEWD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:22:03 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBA6C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:20:08 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id i20so15190545edj.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w+kwcFx0Cfy81nkcLVVoDarPmYzoxb/+slgzsNsCr+w=;
        b=nrhKLU2nBCl32cB1dvnzV0xzvJat/02Njd91ndjzlXCjnAPRm4gIS8o7uItDV0qmSM
         ZfEHTjudspbCvsjxwRDZKOzRiD/YuuRvC3Id+LnSV9/9txtPAGI9yerNDN0VQoo5I3Pq
         5bFUh9gP4PL26gTGYwlsGCvBWty87Jla0KGpQy5+B8qbJlgXIDCcwWAroGNnP1X/16Md
         YD2xU1qZPX20LCnfRxa8Cs2+dW0V/oFETVoF8L8xNo39Dg2NX5xH0RlxJ6HFa7fhmNFD
         kTsKMjqEc0rekeYbPrQdAKMMVRRt69jTPvlTFjpWAP7t3QHOKFpHar2QKcIjv0N0fdOk
         3tjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w+kwcFx0Cfy81nkcLVVoDarPmYzoxb/+slgzsNsCr+w=;
        b=kfuuquKquOBQHvKKgOzYHUKRSrWnaIu8/yTB9ilT0rtpTjKYsigbGMTrsvVGVtT525
         kOo0nD15L17RRsEAvxmQjqScQBcq1owHaxcf4eF4XMyXkKa1sdXqbRfKlPHMtqkTVs3F
         nRoXRxXrYLfhH659T9KNqH9xRmceYuVDMHcBwuj/qb/TqO4rTBAtVCLYpBI+94PmMcQZ
         PfGU1aRjNxK0b84nUH1V5gq3tc40SS58EmYMLENoLKtC97W7SZstHpgtdtk7h2USItsR
         lNL5N6THHuBHbCI7pcMCMqViDQ8VBEtVH/duC40QvWfwMaxIFSBsASKpyS43lfMZ3XSA
         R+oQ==
X-Gm-Message-State: AOAM531QVgzMRmqXdvEaapYSmWWuaFPUNY8Fu4JBBi9ShNfcqFvveGlr
        hydREDyLboQbjSX5ZjvWt1Tk3QubZLu+PQ==
X-Google-Smtp-Source: ABdhPJzPXUZSwRTUAMXHzD/yagEBlRor8t9aNLEGhltKRr2Szfg/EFPZ2rq250e5JRv3sdSbZ03kTw==
X-Received: by 2002:a17:906:4895:: with SMTP id v21mr1301348ejq.299.1633666807049;
        Thu, 07 Oct 2021 21:20:07 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p6sm511669edi.18.2021.10.07.21.20.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:20:06 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 06/25] trace-cmd library: Add multiple options sections in trace file version 7
Date:   Fri,  8 Oct 2021 07:19:39 +0300
Message-Id: <20211008041958.976309-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041958.976309-1-tz.stoyanov@gmail.com>
References: <20211008041958.976309-1-tz.stoyanov@gmail.com>
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
index 0de68a2d..7cafaca6 100644
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
2.31.1

