Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E95BCC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:22:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358070AbhLBM0J (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:26:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358075AbhLBMZd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:25:33 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B3FC06175D
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:22:10 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id y13so115181482edd.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o2Vsm1aAyXVane8Jhw6MtfMswz8BHgTERhibCTx+u8s=;
        b=YN28er3bx3aKbwbrsHNV7W7G8CybSNRN8F05v+582EjXMUsGnXv5jX5FltD5cbb6yB
         NzO65ezj/8P741pffwVpBAnqLZ0OnzTU3AiUR+532eXZWqfrsVzIGl+aF4birHVrI29Y
         wSMh+GdGaxWXnbQuUok6Qxoss9bueIv/UpBRr4Xp1r9w0kpXbtovMvp3APHxIsTwPf1I
         UuMJsEtBfTOrmNP0dfC4MyTeePyn2OphoXPS4PDfAPoYTCJhYtkhcnmqVN/o0EvttraY
         +KdPiHUN26Ywv4qLcsGLinZ3xcTxQx/ruBCsFznKo5Tzv7D9fwBdQsqpcKSqSDuQa83k
         XCzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o2Vsm1aAyXVane8Jhw6MtfMswz8BHgTERhibCTx+u8s=;
        b=fgrxUfhWjm73M/E9NLInViLe6+imgyt54RB4dJuf0AFoOqS4Eac8hW1jeUI3tFqj9b
         otu4cA2O2Z58lgg/ccoH03G8fYe7kqOMjAZDcIQ1McixSQb2BZyGQAx1NHGE2SlMvl4t
         Sm4HBzMm8m6k8wLbyQs1XBqLW7+EgktH3qz9EfOceMyugLKyVERhO2HAqrDmf73s4glS
         z/GyarYkECScuvZ2pb+n/TLGWQu1qMKLCkEryY+gU7IsAKNvlc0XcgnXzUoOy9YUIBg0
         nW86UfSQVHZAxIUYdWPVpCNrg4OxLDu4xnR/lEwoJ0EclQkjnhCeVYEM3ruTd3svzDKf
         arsw==
X-Gm-Message-State: AOAM531cmguuLgGoL5Hid4VI1530el6Ckdg7XWK82sDRO46u/45YcIOD
        XgnhHzSUJrtbH6uICuLNNoYRzjmnW1SUvg==
X-Google-Smtp-Source: ABdhPJx5Ynp9bqLF+AHjMkuqKUHvuVBLQvqXhUiTKV5nBooyew34+JhOTwCbBkhbyLk4ATBrKmeO2Q==
X-Received: by 2002:a50:e611:: with SMTP id y17mr17502920edm.270.1638447728992;
        Thu, 02 Dec 2021 04:22:08 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gb42sm1892772ejc.49.2021.12.02.04.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:22:08 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 15/23] trace-cmd library: Read headers from trace file version 7
Date:   Thu,  2 Dec 2021 14:21:44 +0200
Message-Id: <20211202122152.43275-16-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122152.43275-1-tz.stoyanov@gmail.com>
References: <20211202122152.43275-1-tz.stoyanov@gmail.com>
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
index 8f95bf3b..6d7813f7 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -163,8 +163,7 @@ struct tracecmd_input {
 	struct pid_addr_maps	*pid_maps;
 	/* file information */
 	struct file_section	*sections;
-	size_t			header_files_start;
-	size_t			ftrace_files_start;
+	bool			options_init;
 	unsigned long long	options_start;
 	size_t			total_file_size;
 
@@ -917,19 +916,7 @@ static int read_cpus(struct tracecmd_input *handle)
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
 
@@ -995,6 +982,134 @@ int tracecmd_read_headers(struct tracecmd_input *handle,
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
2.33.1

