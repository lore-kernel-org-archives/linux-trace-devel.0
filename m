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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89AE3C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:30:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 762F860F6D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235143AbhIMMbY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240001AbhIMMbX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:31:23 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E1AEC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:30:08 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id l7-20020a1c2507000000b002e6be5d86b3so6468874wml.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xNattvz/J11LjzAivA6IFJjNMkWHPy25Olv8iAQWFFA=;
        b=BRO5yw1VS9lCGuBJnFAcVsqOqGgbG/a5wbJvBAriFbmavQ+kTnqM7Vv4XkkFTUKGbj
         fLJbpk20ivbK//bo3ENMwpfCWtMJVHBGbjV3dZT+vXnVwHnXxKuWJKtOrUi/Lr4M9GkL
         oXb7KXFcn5MNYFji/iuWRNlnekmR60XIqPKUvZR0YbL3SDj5/E3sIAabaUPXn7Zy3iy+
         aCAkvDRzkytzsNBz8DUAjEzCDbThNP9DAYU3WxqWompXSJrmRPLl3ncEHwJpu9AKzPXL
         f9i9HqIdC4N0ij0NwR9xa4he9fYqFrQwEjn4qJaJdaC6fz4BEDv31gx1Dmnee5l9GlNa
         29Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xNattvz/J11LjzAivA6IFJjNMkWHPy25Olv8iAQWFFA=;
        b=u2dkX3e+szQ1jDKKck7fG+CVQJiRmTvW1nb+UUeV05P5/U69rPeyQr66M7idyBunm0
         vXlixwtcs9Yq9M0C5HJFOciStm+ihuuU4O+BaMGxSikqP/GCVSwDvOJAq6NRA/nrw86h
         cfChq1KPdnTyLsP0cUJ85wJOfrZU7D49PHy4UypuwjcF4g7gBVX6TB1Smi8fbc4wX10G
         AdFu8dPKJyiijnjkUDk4GPOzmtDhg7ZpeY82/7HE20TrD4zRNzDoC2nDMx/tsz1dYDF8
         SZFkH1uRZqqe/+MURdM4QhskyvDpA5XFX4e15sPZfPgcqr02i4PjQvZ0fJoWhyDmuT8L
         Iv9A==
X-Gm-Message-State: AOAM531NubkeDwi7J4T5OaZ6BdQP0mCljg6e6MJZvmxpTOtC1S8OqEmo
        P2IUNHAHE0xOeri8NsfjgBpylwftJwg=
X-Google-Smtp-Source: ABdhPJyLtW8dLU4Ka/De14yeCCFPsNGNpB05KdVhNas0TZz2jZwP0gj20JKtkUR+HIHEaEessGwCQA==
X-Received: by 2002:a7b:c7c3:: with SMTP id z3mr11216935wmk.96.1631536206733;
        Mon, 13 Sep 2021 05:30:06 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z5sm6842030wmf.33.2021.09.13.05.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:30:06 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 17/25] trace-cmd library: Read headers from trace file version 7
Date:   Mon, 13 Sep 2021 15:29:39 +0300
Message-Id: <20210913122947.3673239-18-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
References: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace file version 7 has more flexible structure than version 6, headers
are not located at fixed position in the file. A new logic is
implemented to read and parse the headers from this new format.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 145 ++++++++++++++++++++++++++++++++----
 1 file changed, 130 insertions(+), 15 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 785a1b93..686655bd 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -162,8 +162,7 @@ struct tracecmd_input {
 	struct pid_addr_maps	*pid_maps;
 	/* file information */
 	struct file_section	*sections;
-	size_t			header_files_start;
-	size_t			ftrace_files_start;
+	bool			options_init;
 	unsigned long long	options_start;
 	size_t			total_file_size;
 
@@ -924,19 +923,7 @@ static int read_cpus(struct tracecmd_input *handle)
 	return 0;
 }
 
-/**
- * tracecmd_read_headers - read the header information from trace.dat
- * @handle: input handle for the trace.dat file
- * @state: The state to read up to or zero to read up to options.
- *
- * This reads the trace.dat file for various information. Like the
- * format of the ring buffer, event formats, ftrace formats, kallsyms
- * and printk. This may be called multiple times with different @state
- * values, to read partial data at a time. It will always continue
- * where it left off.
- */
-int tracecmd_read_headers(struct tracecmd_input *handle,
-			  enum tracecmd_file_states state)
+static int read_headers_v6(struct tracecmd_input *handle, enum tracecmd_file_states state)
 {
 	int ret;
 
@@ -1002,6 +989,134 @@ int tracecmd_read_headers(struct tracecmd_input *handle,
 	return 0;
 }
 
+static int handle_options(struct tracecmd_input *handle);
+
+static int read_section_header(struct tracecmd_input *handle, unsigned short *id,
+			       unsigned short *flags, unsigned int *size, char **description)
+{
+	unsigned short fl;
+	char *desc = NULL;
+	unsigned short sec_id;
+	unsigned int sz;
+
+	if (read2(handle, &sec_id))
+		return -1;
+	desc = read_string(handle);
+	if (!desc)
+		return -1;
+	if (read2(handle, &fl))
+		goto error;
+	if (read4(handle, &sz))
+		goto error;
+
+	if (id)
+		*id = sec_id;
+	if (flags)
+		*flags = fl;
+	if (size)
+		*size = sz;
+	if (description)
+		*description = desc;
+	else
+		free(desc);
+	return 0;
+
+error:
+	free(desc);
+	return -1;
+}
+
+static int handle_section(struct tracecmd_input *handle, struct file_section *section)
+{
+	unsigned short id, flags;
+	unsigned int size;
+	int ret;
+
+	if (lseek64(handle->fd, section->section_offset, SEEK_SET) == (off_t)-1)
+		return -1;
+	if (read_section_header(handle, &id, &flags, &size, NULL))
+		return -1;
+	section->flags = flags;
+	if (id != section->id)
+		return -1;
+
+	section->data_offset = lseek64(handle->fd, 0, SEEK_CUR);
+
+	switch (section->id) {
+	case TRACECMD_OPTION_HEADER_INFO:
+		ret = read_header_files(handle);
+		break;
+	case TRACECMD_OPTION_FTRACE_EVENTS:
+		ret = read_ftrace_files(handle, NULL);
+		break;
+	case TRACECMD_OPTION_EVENT_FORMATS:
+		ret = read_event_files(handle, NULL);
+		break;
+	case TRACECMD_OPTION_KALLSYMS:
+		ret = read_proc_kallsyms(handle);
+		break;
+	case TRACECMD_OPTION_PRINTK:
+		ret = read_ftrace_printk(handle);
+		break;
+	case TRACECMD_OPTION_CMDLINES:
+		ret = read_and_parse_cmdlines(handle);
+		break;
+	default:
+		ret = 0;
+		break;
+	}
+
+	return ret;
+}
+
+static int read_headers_v7(struct tracecmd_input *handle)
+{
+	struct file_section *section;
+
+	if (handle->options_init)
+		return 0;
+
+	if (!handle->options_start)
+		return -1;
+
+	if (lseek64(handle->fd, handle->options_start, SEEK_SET) == (off64_t)-1) {
+		tracecmd_warning("Filed to goto options offset %lld", handle->options_start);
+		return -1;
+	}
+
+	if (handle_options(handle))
+		return -1;
+
+	section = handle->sections;
+	while (section) {
+		if (handle_section(handle, section))
+			return -1;
+		section = section->next;
+	}
+
+	handle->options_init = true;
+	return 0;
+}
+
+/**
+ * tracecmd_read_headers - read the header information from trace.dat
+ * @handle: input handle for the trace.dat file
+ * @state: The state to read up to or zero to read up to options.
+ *
+ * This reads the trace.dat file for various information. Like the
+ * format of the ring buffer, event formats, ftrace formats, kallsyms
+ * and printk. This may be called multiple times with different @state
+ * values, to read partial data at a time. It will always continue
+ * where it left off.
+ */
+int tracecmd_read_headers(struct tracecmd_input *handle,
+			  enum tracecmd_file_states state)
+{
+	if (!HAS_SECTIONS(handle))
+		return read_headers_v6(handle, state);
+	return read_headers_v7(handle);
+}
+
 static unsigned long long calc_page_offset(struct tracecmd_input *handle,
 					   unsigned long long offset)
 {
-- 
2.31.1

