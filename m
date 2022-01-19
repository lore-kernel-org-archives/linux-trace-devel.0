Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB14C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352380AbiASIZT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:25:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352370AbiASIZT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:25:19 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8050C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:18 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id j23so2428123edp.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lFnxoFsz5kg5KsMzJxsxj/4uxkULtcneOSCJSmq/cKw=;
        b=LGJT1lw5BsXcKrW85XRRbSm/LAfl43LZEhrGXyvhYoe5fRC7Brkmo1NEV3IPQSU8Tc
         JHpfbmOQPb2qiaxo8vXyt+Jq6eB6XF9xYX7iaDWSapdvCiDljAcmimF6sBJs0NNZsX9N
         8dP0BkdCPOqgeYcBkrNyaL0iCaijpbVobuWBnA+nHzlEDJX34OeeOQgyZusLh6zgynvL
         7LnGqGMppK92kXCHqtRvAV+TkaFy2WCahjMH9iuOXyy4VsWlTgDnv/K1tAu0O2FyVIuf
         s7m7qlJ7wEGzhX+ZqzaM+iArBlRYjkhABw1HPX/jGR0Ykqfgu5NQ+Mqjzhnfzvg6iYEH
         xu3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lFnxoFsz5kg5KsMzJxsxj/4uxkULtcneOSCJSmq/cKw=;
        b=Kp0cwTmVIR4i/HHwFXDrhi2lIGypenBFMO5TLDTDXNYuRIptOyd11UVLW0lW0x9RlH
         ej6cb/3LfuVfsCiV01E84aihWx3rpz1vlCZ3ubf5hEd61WITek2D62RHGC3L/sh9SePj
         cwugn2uGDeuAiIyBfAN5ncfIGrsfVlqsbpapnkU8DxOYvc1bB0abuUjARSdVnDq5+5Lf
         pe2F2mD4SCEMI3Sq6SaBUjHB0l602cf70EMWudnjzAADvxkoG4cMmsKLHPM/IfHgPcnL
         OxxRGhAWoIWnxg66csViwIEFTIZ3Rc7Rqm5UwofT/BOGVtY2AkM0j2O3Xov/LUu8O/Gt
         bHSw==
X-Gm-Message-State: AOAM53393VN2/GDVHzJSsUTmAzqErlsPUZCl3y6RZS4aXXwNCSso2uBm
        HXFUXIXqqksjbPHz40v2dnKOhBwj4Vg=
X-Google-Smtp-Source: ABdhPJyTM8yUFxSv9Py6QDY7LYnPP6euoHueeDDIhM9p0K6j/z7MrzogMUEMQUrXWs+gqjwInbZoPg==
X-Received: by 2002:a17:906:49c4:: with SMTP id w4mr23158142ejv.745.1642580717271;
        Wed, 19 Jan 2022 00:25:17 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l1sm5011122ejf.44.2022.01.19.00.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:25:16 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 07/25] trace-cmd library: Add multiple options sections in trace file version 7
Date:   Wed, 19 Jan 2022 10:24:49 +0200
Message-Id: <20220119082507.245600-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082507.245600-1-tz.stoyanov@gmail.com>
References: <20220119082507.245600-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-output.c | 105 ++++++++++++++++++++++++++++++++---
 1 file changed, 98 insertions(+), 7 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index d2f90f29..8a8d4e55 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -68,7 +68,7 @@ struct tracecmd_output {
 	/* current virtual offset of meta-data string */
 	unsigned long		strings_offs;
 
-	size_t			options_start;
+	unsigned long long	options_start;
 	bool			big_endian;
 
 	struct list_head	options;
@@ -94,6 +94,7 @@ struct list_event_system {
 
 #define HAS_SECTIONS(H) ((H)->file_version >= FILE_VERSION_SECTIONS)
 
+static int write_options(struct tracecmd_output *handle);
 static int save_string_section(struct tracecmd_output *handle);
 
 static stsize_t
@@ -223,6 +224,9 @@ void tracecmd_output_close(struct tracecmd_output *handle)
 		return;
 
 	if (HAS_SECTIONS(handle)) {
+		/* write any unsaved options at the end of trace files with sections */
+		write_options(handle);
+
 		/* write strings section */
 		save_string_section(handle);
 	}
@@ -1300,6 +1304,7 @@ int tracecmd_output_set_version(struct tracecmd_output *handle, int file_version
  */
 static int output_write_init(struct tracecmd_output *handle)
 {
+	unsigned long long offset;
 	char buf[BUFSIZ];
 	int endian4;
 
@@ -1333,6 +1338,14 @@ static int output_write_init(struct tracecmd_output *handle)
 	endian4 = convert_endian_4(handle, handle->page_size);
 	if (do_write_check(handle, &endian4, 4))
 		return -1;
+	if (HAS_SECTIONS(handle)) {
+		/* Write 0 as options offset and save its location */
+		offset = 0;
+		handle->options_start = do_lseek(handle, 0, SEEK_CUR);
+		if (do_write_check(handle, &offset, 8))
+			return -1;
+	}
+
 	handle->file_state = TRACECMD_FILE_INIT;
 	return 0;
 }
@@ -1401,7 +1414,7 @@ tracecmd_add_option_v(struct tracecmd_output *handle,
 	 * We can only add options before tracing data were written.
 	 * This may change in the future.
 	 */
-	if (handle->file_state > TRACECMD_FILE_OPTIONS)
+	if (!HAS_SECTIONS(handle) && handle->file_state > TRACECMD_FILE_OPTIONS)
 		return NULL;
 
 	for (i = 0; i < count; i++)
@@ -1414,8 +1427,7 @@ tracecmd_add_option_v(struct tracecmd_output *handle,
 			return NULL;
 		}
 	}
-
-	option = malloc(sizeof(*option));
+	option = calloc(1, sizeof(*option));
 	if (!option) {
 		tracecmd_warning("Could not allocate space for option");
 		free(data);
@@ -1478,7 +1490,7 @@ int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus)
 	return 0;
 }
 
-int tracecmd_write_options(struct tracecmd_output *handle)
+static int write_options_v6(struct tracecmd_output *handle)
 {
 	struct tracecmd_option *options;
 	unsigned short option;
@@ -1496,7 +1508,7 @@ int tracecmd_write_options(struct tracecmd_output *handle)
 
 	if (do_write_check(handle, "options  ", 10))
 		return -1;
-
+	handle->options_start = do_lseek(handle, 0, SEEK_CUR);
 	list_for_each_entry(options, &handle->options, list) {
 		endian2 = convert_endian_2(handle, options->id);
 		if (do_write_check(handle, &endian2, 2))
@@ -1520,6 +1532,72 @@ int tracecmd_write_options(struct tracecmd_output *handle)
 		return -1;
 
 	handle->file_state = TRACECMD_FILE_OPTIONS;
+	return 0;
+}
+
+static int write_options(struct tracecmd_output *handle)
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
+	if (!new)
+		return 0;
+	offset = do_lseek(handle, 0, SEEK_CUR);
+
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
+
+	offset = out_write_section_header(handle, TRACECMD_OPTION_DONE, "options", 0, false);
+	if (offset == (off_t)-1)
+		return -1;
+
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
@@ -1532,8 +1610,14 @@ int tracecmd_write_meta_strings(struct tracecmd_output *handle)
 	return save_string_section(handle);
 }
 
+int tracecmd_write_options(struct tracecmd_output *handle)
+{
+	if (!HAS_SECTIONS(handle))
+		return write_options_v6(handle);
+	return write_options(handle);
+}
 
-int tracecmd_append_options(struct tracecmd_output *handle)
+static int append_options_v6(struct tracecmd_output *handle)
 {
 	struct tracecmd_option *options;
 	unsigned short option;
@@ -1584,6 +1668,13 @@ int tracecmd_append_options(struct tracecmd_output *handle)
 	return 0;
 }
 
+int tracecmd_append_options(struct tracecmd_output *handle)
+{
+	if (!HAS_SECTIONS(handle))
+		return append_options_v6(handle);
+	return write_options(handle);
+}
+
 static struct tracecmd_option *
 add_buffer_option(struct tracecmd_output *handle, const char *name, int cpus)
 {
-- 
2.34.1

