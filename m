Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0386FC4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:22:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357960AbhLBMZi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:25:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234072AbhLBMZY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:25:24 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0DC8C0613D7
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:22:01 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id l25so115089905eda.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:22:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gmk8QkbXamIc6IdeCObeVeGTBJRKY9/xxtZgbIDt7iI=;
        b=S0LpxCrvATo2G/45YQ6hytE30enxTr54K9wvkHz64n/pOJy+M0QCtDlpD3b8xDN14/
         ibcSGBgm0ySzP3aI/5vOyb9b+5ujik9opmzXoajDvQeSr9Q+CTZ1wV3xy7zmYyDSm+eJ
         7KUivg6o9yLrGeo7Y1JrBQMXIAPuUv5r20bFdFkBR71KhqBSrZ1tRWpGo8nQ0mQ0q2rx
         S2P1e7uA3oogEvLuEFDZbbJJcETThiac/xOUB7Zwmn2c8McqABAsQRmETCZiTF4TQGm6
         REJKae0BruInIe3aBy1yPA514xwxIJKtZGtnSK6MeYtLHDZA3lVhB3Ls8d4DbNeIKruq
         l2PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gmk8QkbXamIc6IdeCObeVeGTBJRKY9/xxtZgbIDt7iI=;
        b=OVhjpAEnBroCKnuTS3FqUijrFQA0v2RJh0apQfjDm1CUhiM1yKgtafJiuRvOu/vVo3
         /9SNwyw37h0qc3quMn9m5/w+iE25m93bA7iUpbIIu4DcSSRFlmRZq6SIuZBxmvRGL9y+
         cw8DXfPK0iVvfOYORKPbDvMHDz+7ZGVfRF3R8J2sbtsvzDxC2Xudh33EfQy5ykrrodbw
         VETjakW6LfEDQrx/IvBbdh/NXefR8CeiCdTN8Eg9mkKn4Zhttgfqnw0Yk5GLmrIaRCbo
         q+gI2gPtnp9xpGlmYQLyU/UP83I8+5Rg+4a7qGz+Nq6kB+IbtVPHLZ/QBIfL41wJwm7M
         2kZg==
X-Gm-Message-State: AOAM532F0MOSLjC3rIbpKIdlrQjJ7kj9JIvuPvtuvN1pRT2kIG53I6rX
        4pr7RiUk2/GxKQYn3KiKqkKIsQN15vSAhQ==
X-Google-Smtp-Source: ABdhPJyazs7Ollhc64Tw8j1A2B/VRWV+OCACudir/mYuBJiY884v5KzqLin62yJ6QEhEwUQlrHc+TA==
X-Received: by 2002:a17:907:9488:: with SMTP id dm8mr15180420ejc.36.1638447720296;
        Thu, 02 Dec 2021 04:22:00 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gb42sm1892772ejc.49.2021.12.02.04.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:21:59 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 06/23] trace-cmd library: Add multiple options sections in trace file version 7
Date:   Thu,  2 Dec 2021 14:21:35 +0200
Message-Id: <20211202122152.43275-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122152.43275-1-tz.stoyanov@gmail.com>
References: <20211202122152.43275-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-output.c | 107 ++++++++++++++++++++++++++++++++---
 1 file changed, 100 insertions(+), 7 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 582d8480..40d5fe9c 100644
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
@@ -85,6 +85,8 @@ struct list_event_system {
 
 #define HAS_SECTIONS(H) ((H)->file_version >= FILE_VERSION_SECTIONS)
 
+static int write_options_v7(struct tracecmd_output *handle);
+
 static stsize_t
 do_write_check(struct tracecmd_output *handle, const void *data, tsize_t size)
 {
@@ -194,6 +196,10 @@ void tracecmd_output_close(struct tracecmd_output *handle)
 	if (!handle)
 		return;
 
+	/* write any unsaved options at the end of trace files with sections */
+	if (handle->file_version >= FILE_VERSION_SECTIONS)
+		write_options_v7(handle);
+
 	if (handle->fd >= 0) {
 		close(handle->fd);
 		handle->fd = -1;
@@ -1224,6 +1230,7 @@ int tracecmd_output_set_version(struct tracecmd_output *handle, int file_version
  */
 static int output_write_init(struct tracecmd_output *handle)
 {
+	unsigned long long offset;
 	char buf[BUFSIZ];
 	int endian4;
 
@@ -1257,6 +1264,14 @@ static int output_write_init(struct tracecmd_output *handle)
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
@@ -1325,7 +1340,7 @@ tracecmd_add_option_v(struct tracecmd_output *handle,
 	 * We can only add options before tracing data were written.
 	 * This may change in the future.
 	 */
-	if (handle->file_state > TRACECMD_FILE_OPTIONS)
+	if (!HAS_SECTIONS(handle) && handle->file_state > TRACECMD_FILE_OPTIONS)
 		return NULL;
 
 	for (i = 0; i < count; i++)
@@ -1338,8 +1353,7 @@ tracecmd_add_option_v(struct tracecmd_output *handle,
 			return NULL;
 		}
 	}
-
-	option = malloc(sizeof(*option));
+	option = calloc(1, sizeof(*option));
 	if (!option) {
 		tracecmd_warning("Could not allocate space for option");
 		free(data);
@@ -1402,7 +1416,7 @@ int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus)
 	return 0;
 }
 
-int tracecmd_write_options(struct tracecmd_output *handle)
+static int write_options_v6(struct tracecmd_output *handle)
 {
 	struct tracecmd_option *options;
 	unsigned short option;
@@ -1420,7 +1434,7 @@ int tracecmd_write_options(struct tracecmd_output *handle)
 
 	if (do_write_check(handle, "options  ", 10))
 		return -1;
-
+	handle->options_start = do_lseek(handle, 0, SEEK_CUR);
 	list_for_each_entry(options, &handle->options, list) {
 		endian2 = convert_endian_2(handle, options->id);
 		if (do_write_check(handle, &endian2, 2))
@@ -1444,11 +1458,83 @@ int tracecmd_write_options(struct tracecmd_output *handle)
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
@@ -1499,6 +1585,13 @@ int tracecmd_append_options(struct tracecmd_output *handle)
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

