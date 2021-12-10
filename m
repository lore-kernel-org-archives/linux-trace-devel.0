Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7FA5C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:55:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237059AbhLJK6e (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 05:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237054AbhLJK6e (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 05:58:34 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41487C0617A1
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:54:59 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id x10so11321796edd.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:54:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EzxSFr7Zq0xkiHAZ9iDeKaidhlzhmtwIfV0NwVFdS1Y=;
        b=qHnRr0mMYwCxa4Ktl76leMZB9dP4YxQr8kP6rSZZnlU+QQxMOAU2nI/coluHCGDQ4y
         dcrkqBN65cBYoajn8gcF6bjO+7lf+s2hDpi8YYO4tgSHXjQz0ymASnD8Gg6RQEfDQ3gD
         KTR+kl8nMeIJun1KInxq/KXRNvOSpEZp4Va370gnWYraGRQ6yHFskSdhxu/OZ42e6IHZ
         IGgzlWkrsnTq1AZ79Sjj8XI+EVbKnDpDZczg82KnXu7kzYR8h2rzO69yU+NZTNBdIJYF
         UqLZiIrT/T08Et7nXabjPKK8SywDZhINV51jD4kNVLWPUR6gP9571LBQ9CVOFCPVlIaO
         bgvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EzxSFr7Zq0xkiHAZ9iDeKaidhlzhmtwIfV0NwVFdS1Y=;
        b=Z0qsk26o9gXFFp1e/DINYHIWSaVNde4TkjX9hKcgX2cC6zfaoJQ4ccJmWHkqD+mqVK
         6fg13v0l1HnEc0OyFB6Uerl58PCuhNkBAEQWIH+h6N0RrrweltHrtP3OjKYqx3TzUUu/
         kyJKNeygGZWNbJTqaaaEvDfrtzAonXhVfNv+oOgOeRR6VOyBamh3iLQQCBZMxIx2QBDY
         d2B60CPCfj/tRgrfymcBgIJa1H8YtfJGv4AP7eoAujHAl/iONHuqHZ03rQMr4ky9YmTx
         IyjaKQh0LfMvV36pGcKY1bZSY1y42Lu0Ntn1c0PCHAJGS0MWQT2W+qUP9hKeqErc+3LB
         tqvA==
X-Gm-Message-State: AOAM530Nc549U4x2idO+AheC3QmVJzlgyUYqi8RaqUpE8xX45q7rYMMO
        4KZg7YSaFwK4WaLDnTPbGnUpKr/yn7s=
X-Google-Smtp-Source: ABdhPJxofTvY2PGuCIFOBN0XIQ64DHXIoBYw4SzIU1Uh+Uw8AvA1m1JPfeafFiJK+jJV3/kHrFwPqg==
X-Received: by 2002:a17:907:3e1d:: with SMTP id hp29mr23097113ejc.70.1639133696766;
        Fri, 10 Dec 2021 02:54:56 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x7sm1306314edd.28.2021.12.10.02.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:54:56 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 07/25] trace-cmd library: Add multiple options sections in trace file version 7
Date:   Fri, 10 Dec 2021 12:54:30 +0200
Message-Id: <20211210105448.97850-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105448.97850-1-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-output.c | 103 ++++++++++++++++++++++++++++++++---
 1 file changed, 96 insertions(+), 7 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index aa55aad7..6e07fece 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -64,7 +64,7 @@ struct tracecmd_output {
 	unsigned long		file_version;
 	unsigned long		strings_p;
 	unsigned long		strings_offs;
-	size_t			options_start;
+	tsize_t			options_start;
 	bool			big_endian;
 
 	struct list_head	options;
@@ -89,6 +89,7 @@ struct list_event_system {
 
 #define HAS_SECTIONS(H) ((H)->file_version >= FILE_VERSION_SECTIONS)
 
+static int write_options_v7(struct tracecmd_output *handle);
 static int save_string_section(struct tracecmd_output *handle);
 
 static stsize_t
@@ -218,6 +219,9 @@ void tracecmd_output_close(struct tracecmd_output *handle)
 		return;
 
 	if (handle->file_version >= FILE_VERSION_SECTIONS) {
+		/* write any unsaved options at the end of trace files with sections */
+		write_options_v7(handle);
+
 		/* write strings section */
 		save_string_section(handle);
 	}
@@ -1295,6 +1299,7 @@ int tracecmd_output_set_version(struct tracecmd_output *handle, int file_version
  */
 static int output_write_init(struct tracecmd_output *handle)
 {
+	unsigned long long offset;
 	char buf[BUFSIZ];
 	int endian4;
 
@@ -1328,6 +1333,14 @@ static int output_write_init(struct tracecmd_output *handle)
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
@@ -1396,7 +1409,7 @@ tracecmd_add_option_v(struct tracecmd_output *handle,
 	 * We can only add options before tracing data were written.
 	 * This may change in the future.
 	 */
-	if (handle->file_state > TRACECMD_FILE_OPTIONS)
+	if (!HAS_SECTIONS(handle) && handle->file_state > TRACECMD_FILE_OPTIONS)
 		return NULL;
 
 	for (i = 0; i < count; i++)
@@ -1409,8 +1422,7 @@ tracecmd_add_option_v(struct tracecmd_output *handle,
 			return NULL;
 		}
 	}
-
-	option = malloc(sizeof(*option));
+	option = calloc(1, sizeof(*option));
 	if (!option) {
 		tracecmd_warning("Could not allocate space for option");
 		free(data);
@@ -1473,7 +1485,7 @@ int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus)
 	return 0;
 }
 
-int tracecmd_write_options(struct tracecmd_output *handle)
+static int write_options_v6(struct tracecmd_output *handle)
 {
 	struct tracecmd_option *options;
 	unsigned short option;
@@ -1491,7 +1503,7 @@ int tracecmd_write_options(struct tracecmd_output *handle)
 
 	if (do_write_check(handle, "options  ", 10))
 		return -1;
-
+	handle->options_start = do_lseek(handle, 0, SEEK_CUR);
 	list_for_each_entry(options, &handle->options, list) {
 		endian2 = convert_endian_2(handle, options->id);
 		if (do_write_check(handle, &endian2, 2))
@@ -1515,6 +1527,70 @@ int tracecmd_write_options(struct tracecmd_output *handle)
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
@@ -1527,8 +1603,14 @@ int tracecmd_write_meta_strings(struct tracecmd_output *handle)
 	return save_string_section(handle);
 }
 
+int tracecmd_write_options(struct tracecmd_output *handle)
+{
+	if (!HAS_SECTIONS(handle))
+		return write_options_v6(handle);
+	return write_options_v7(handle);
+}
 
-int tracecmd_append_options(struct tracecmd_output *handle)
+static int append_options_v6(struct tracecmd_output *handle)
 {
 	struct tracecmd_option *options;
 	unsigned short option;
@@ -1579,6 +1661,13 @@ int tracecmd_append_options(struct tracecmd_output *handle)
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

