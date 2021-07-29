Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF672C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A91AF61052
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbhG2FKc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbhG2FKc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:32 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71560C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:28 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id yk17so753064ejb.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RmoTo/DrBrKEPsjiYGWWfejteUIwXa2uLWnxdU4WRIg=;
        b=ddeV+4sinrWgohHEkdy6JmtcOp6QjNreREYfuKY83C4en3aqAUa+F82i5H4xg9lV2j
         +50U9X8lJb4HOpv+VVMvoPJNPwE33vV+LdnX4VeOU/WhLJ0MMBDVLikNZge3tBFaPajs
         BSO9i3PKYxtJd/eYYjGyGWO3qYY3hnwcIIM2yS/LuB7WqEVfpLuGgr3xKDYPc0l35XVk
         XC0u74FrSAL0B0tWJNQ34rPuwvyDzMwL/O7Dq5CUJ91UIpdN+ao2otc8FJdrlqyECJX/
         5mPSA1wajk/iuW1jL4CNWZY+HoOWN8U90hMZVsSD8d4g0DqMR2WNOIP3ghUK+Ns8KDWL
         b2uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RmoTo/DrBrKEPsjiYGWWfejteUIwXa2uLWnxdU4WRIg=;
        b=D8qXJjsHrFhdvmF9wjqjomUlwIc44ygQ6uQWTV1zZPuV9bJidq59EWEdZUJktYwbGw
         0wqk5Q7KCpv00mazIXNjuWCgAgbZWZMWkJaHaC3Ic/ThetCtmDbUTR6SY3wSIuuOEuI8
         hrSm568x498oenIK4LdPwkh1pgJ/PnzFm5y9PHrdgPL8Pqn5gOC0wRgKiXFozB7yTm/H
         V156JOxace6YFVCnAuz8fABjtKcJt7pFzMhAaRa1+c7A4non9WrJLRjnHoGl+RadC/Si
         ywDZNFoW7rcodaTkrbKY3kevvRmiTRswE9kMWO8+48w63hIRSXeaf1FMKUrrGyVIR1He
         QMOA==
X-Gm-Message-State: AOAM531hKwNcmhm5k+ytOEAJXFgcyvXzWMQDR+z2nZ6ZmYlMJpUwDfJn
        pnqjR8B97yHbJFhnFR2bUSJaJhf6DVOthQ==
X-Google-Smtp-Source: ABdhPJzWuSy4iGCi9lHdGuQ7NtwQ8pZY3GlqEZEg2oNoUEFIzYfEYMMVrz3KphgTnFObY+M2AxNl2w==
X-Received: by 2002:a17:906:ed1:: with SMTP id u17mr2840877eji.304.1627535427101;
        Wed, 28 Jul 2021 22:10:27 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:26 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 26/87] tarce-cmd library: Add multiple options sections in trace file version 7
Date:   Thu, 29 Jul 2021 08:08:58 +0300
Message-Id: <20210729050959.12263-27-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-output.c | 110 ++++++++++++++++++++++++++++++-----
 1 file changed, 96 insertions(+), 14 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index e232a678..6bb7f4de 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -63,7 +63,7 @@ struct tracecmd_output {
 	bool			quiet;
 	unsigned long		file_state;
 	unsigned long		file_version;
-	size_t			options_start;
+	tsize_t			options_start;
 	bool			big_endian;
 	bool			do_compress;
 	struct tracecmd_compression *compress;
@@ -1453,6 +1453,7 @@ int tracecmd_output_set_compression(struct tracecmd_output *handler, const char
  */
 int tracecmd_output_write_init(struct tracecmd_output *handler)
 {
+	unsigned long long offset;
 	char buf[BUFSIZ];
 	int endian4;
 
@@ -1489,6 +1490,11 @@ int tracecmd_output_write_init(struct tracecmd_output *handler)
 	if (handler->file_version >= 7) {
 		if (write_compression_header(handler))
 			return -1;
+		/* Write 0 as options offset and save its location */
+		offset = 0;
+		handler->options_start = do_lseek(handler, 0, SEEK_CUR);
+		if (do_write_check(handler, &offset, 8))
+			return -1;
 	}
 
 	handler->file_state = TRACECMD_FILE_INIT;
@@ -1563,7 +1569,7 @@ tracecmd_add_option_v(struct tracecmd_output *handle,
 	 * We can only add options before tracing data were written.
 	 * This may change in the future.
 	 */
-	if (handle->file_state > TRACECMD_FILE_OPTIONS)
+	if (handle->file_version < 7 && handle->file_state > TRACECMD_FILE_OPTIONS)
 		return NULL;
 
 	for (i = 0; i < count; i++)
@@ -1576,8 +1582,7 @@ tracecmd_add_option_v(struct tracecmd_output *handle,
 			return NULL;
 		}
 	}
-
-	option = malloc(sizeof(*option));
+	option = calloc(1, sizeof(*option));
 	if (!option) {
 		tracecmd_warning("Could not allocate space for option");
 		free(data);
@@ -1640,7 +1645,7 @@ int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus)
 	return 0;
 }
 
-int tracecmd_write_options(struct tracecmd_output *handle)
+static int write_options_v6(struct tracecmd_output *handle)
 {
 	struct tracecmd_option *options;
 	unsigned short option;
@@ -1658,7 +1663,7 @@ int tracecmd_write_options(struct tracecmd_output *handle)
 
 	if (do_write_check(handle, "options  ", 10))
 		return -1;
-
+	handle->options_start = do_lseek(handle, 0, SEEK_CUR);
 	list_for_each_entry(options, &handle->options, list) {
 		endian2 = convert_endian_2(handle, options->id);
 		if (do_write_check(handle, &endian2, 2))
@@ -1669,7 +1674,7 @@ int tracecmd_write_options(struct tracecmd_output *handle)
 			return -1;
 
 		/* Save the data location in case it needs to be updated */
-		options->offset = lseek64(handle->fd, 0, SEEK_CUR);
+		options->offset = do_lseek(handle, 0, SEEK_CUR);
 
 		if (do_write_check(handle, options->data,
 				   options->size))
@@ -1682,11 +1687,83 @@ int tracecmd_write_options(struct tracecmd_output *handle)
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
+	if (handle->file_version < 7)
+		return write_options_v6(handle);
+	return write_options_v7(handle);
+}
+
+
+static int append_options_v6(struct tracecmd_output *handle)
 {
 	struct tracecmd_option *options;
 	unsigned short option;
@@ -1701,14 +1778,12 @@ int tracecmd_append_options(struct tracecmd_output *handle)
 	 */
 	if (handle->file_state != TRACECMD_FILE_OPTIONS)
 		return -1;
-
-	if (lseek64(handle->fd, 0, SEEK_END) == (off_t)-1)
+	if (do_lseek(handle, 0, SEEK_END) == -1)
 		return -1;
-	offset = lseek64(handle->fd, -2, SEEK_CUR);
+	offset = do_lseek(handle, -2, SEEK_CUR);
 	if (offset == (off_t)-1)
 		return -1;
-
-	r = pread(handle->fd, &option, 2, offset);
+	r = do_preed(handle, &option, 2, offset);
 	if (r != 2 || option != TRACECMD_OPTION_DONE)
 		return -1;
 
@@ -1722,7 +1797,7 @@ int tracecmd_append_options(struct tracecmd_output *handle)
 			return -1;
 
 		/* Save the data location in case it needs to be updated */
-		options->offset = lseek64(handle->fd, 0, SEEK_CUR);
+		options->offset = do_lseek(handle, 0, SEEK_CUR);
 
 		if (do_write_check(handle, options->data,
 				   options->size))
@@ -1737,6 +1812,13 @@ int tracecmd_append_options(struct tracecmd_output *handle)
 	return 0;
 }
 
+int tracecmd_append_options(struct tracecmd_output *handle)
+{
+	if (handle->file_version < 7)
+		return append_options_v6(handle);
+	return write_options_v7(handle);
+}
+
 static struct tracecmd_option *
 add_buffer_option(struct tracecmd_output *handle, const char *name, int cpus)
 {
-- 
2.31.1

