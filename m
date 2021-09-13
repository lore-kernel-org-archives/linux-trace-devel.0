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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56AC7C43219
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 315E760F0F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:29:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240000AbhIMMbN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239998AbhIMMbM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:31:12 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF51DC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:29:56 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id b6so14395265wrh.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HH6uaP+3jm8DGFuX1jp0MoXtjy4BESmQMlz6XzmzWnk=;
        b=Tv1gwHNRjEWd4mRaWM8o5SGXg5bEWZueuMNSeFcy7ExsCxX7a0uKDFs8Wodj6WLcie
         70b7aZGxXcooHKFxcrtTcurDh6uxjlK2bVX11aSsYPh7FKKLa5HFzr2ojn9d8PcS40zJ
         20Fkb0E1thhepqH5rpu8yZEpXjMeiilPwe9zOv0Zt+gXd1GeQPHY58O8AvU5i1ParpyB
         W+X5EqGZYv9aMS2T4xvQ2HRkCsCTGVHK16uYtoQnm4ENkupPHs8amZ2JWqVFcO3BH7B8
         ml7HIr7oAWfYKI2EspSDdJRTiJVIhSkE+TlCWcM/rwo7cBPSOT0ZZCBfEnCU/VGAkykQ
         EYkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HH6uaP+3jm8DGFuX1jp0MoXtjy4BESmQMlz6XzmzWnk=;
        b=gbheX3tBAKa2boPsWhMVk6QFZJsTtpv29GBNGYTLtX4TqMjbKpEbwMeFUyrBj7qbwu
         ItQbEaCxV/YOqqFdqlPm5jo37MwsrMXb3dQahGJGQGRCY7emcUSceyn/BYh4FOlWnNSb
         nFZVXwrXNQ/M8JeuuYjsjtDNNps99WkpNY0JT7vT7agE9Ruj4Twny2sVFZsOsspX8suu
         inv0UqUoMmdtUNrWgH9To7mgg1+KCF2JTHQDkbMZdqDEEW1nDRXUQttGqesO1o/IUOA4
         +uSAkdn0DJCS1hCEWb/h1Yv7XzN9ZPGznI6Ht/mlWQ1G+a03o0FxF9Jj5t9JMkPnd0RT
         rgCg==
X-Gm-Message-State: AOAM533mDoea4S88UxMAaR4d36+EsqHP2ar+lCQCPJef6szNAie92ouF
        RGcBe3nBXxEf4MkXeVMGcTd7z8cVU38=
X-Google-Smtp-Source: ABdhPJz1I3Xu0GH4k0h/Py8LuHNWg0sBuj0MLk3IGmXNA/XTY3xVTGaGacBbHcP+dpQDHt/FT9/bjQ==
X-Received: by 2002:adf:90cc:: with SMTP id i70mr12201552wri.408.1631536195573;
        Mon, 13 Sep 2021 05:29:55 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z5sm6842030wmf.33.2021.09.13.05.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:29:55 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 06/25] trace-cmd library: Add multiple options sections in trace file version 7
Date:   Mon, 13 Sep 2021 15:29:28 +0300
Message-Id: <20210913122947.3673239-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
References: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
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
index 582792cc..ee06b00f 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -63,7 +63,7 @@ struct tracecmd_output {
 	bool			quiet;
 	unsigned long		file_state;
 	unsigned long		file_version;
-	size_t			options_start;
+	tsize_t			options_start;
 	bool			big_endian;
 
 	struct list_head	options;
@@ -1220,6 +1220,7 @@ int tracecmd_output_set_version(struct tracecmd_output *handler, int file_versio
  */
 int tracecmd_output_write_init(struct tracecmd_output *handler)
 {
+	unsigned long long offset;
 	char buf[BUFSIZ];
 	int endian4;
 
@@ -1253,6 +1254,14 @@ int tracecmd_output_write_init(struct tracecmd_output *handler)
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
@@ -1321,7 +1330,7 @@ tracecmd_add_option_v(struct tracecmd_output *handle,
 	 * We can only add options before tracing data were written.
 	 * This may change in the future.
 	 */
-	if (handle->file_state > TRACECMD_FILE_OPTIONS)
+	if (!HAS_SECTIONS(handle) && handle->file_state > TRACECMD_FILE_OPTIONS)
 		return NULL;
 
 	for (i = 0; i < count; i++)
@@ -1334,8 +1343,7 @@ tracecmd_add_option_v(struct tracecmd_output *handle,
 			return NULL;
 		}
 	}
-
-	option = malloc(sizeof(*option));
+	option = calloc(1, sizeof(*option));
 	if (!option) {
 		tracecmd_warning("Could not allocate space for option");
 		free(data);
@@ -1398,7 +1406,7 @@ int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus)
 	return 0;
 }
 
-int tracecmd_write_options(struct tracecmd_output *handle)
+static int write_options_v6(struct tracecmd_output *handle)
 {
 	struct tracecmd_option *options;
 	unsigned short option;
@@ -1416,7 +1424,7 @@ int tracecmd_write_options(struct tracecmd_output *handle)
 
 	if (do_write_check(handle, "options  ", 10))
 		return -1;
-
+	handle->options_start = do_lseek(handle, 0, SEEK_CUR);
 	list_for_each_entry(options, &handle->options, list) {
 		endian2 = convert_endian_2(handle, options->id);
 		if (do_write_check(handle, &endian2, 2))
@@ -1440,11 +1448,83 @@ int tracecmd_write_options(struct tracecmd_output *handle)
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
@@ -1495,6 +1575,13 @@ int tracecmd_append_options(struct tracecmd_output *handle)
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

