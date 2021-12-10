Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38FD9C43217
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:55:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237147AbhLJK6l (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 05:58:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239265AbhLJK6l (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 05:58:41 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B657C0617A1
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:55:06 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id o20so28963181eds.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:55:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9seU/0jtTZkA/kCeOnpKe6St/FZ0+JwTnMCqXTNzcdA=;
        b=lzAqs5WAMY0KmsFrZZKYJuo0zAoq8GR/qMDjYjz3xEyv0qWPIXNt1PTwWwC70vTJY4
         GK6DJzJQhNQIPU6YrZjeEHfYRzFqPn5DZ5K9b80yOAmG5vpnM6SSrKDSYyFnMlAPNugo
         +B3mkDoLKKUfHSQMjlHSPARS4MtrZhd9NxsfiZv0wZLUWbali1ijeuFspJpiH/yfqwvh
         0WWXgsB7qNOY7YBSI3Ih+ZfcWgI3o51EAB1/uTY7db8M0ZTqOzRX2olixN3pVGsfsDLu
         uqqyTESeoDMjZ6WDsK8Vq9GUiG71lOBiBwmPtDtxx0OT74U3l4E5Hcll0FkiuUs5MWoG
         bB9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9seU/0jtTZkA/kCeOnpKe6St/FZ0+JwTnMCqXTNzcdA=;
        b=wM/ek/Pzmb1bBh4WUM2QhSpt3vNAQfr5dYTlYi9jziPPshAQiHRvZKbKKo/OwFJYw0
         whCHHqVIhvq1MJEkaM4RbQ6RoLJ7juFZTNNdJQvuKTLlCGZJAIzDL+On4nqahX6ZMjt3
         I/VR5CEhDfmujDkrf5X5ywipHx836mPA26Uc3K7StL/9P19hWI1Yq19xjrIBofJqLWL2
         mmgUWVi7A9GdNntklAcZnCL8scIF0cgeUHDNyBewwHEDkT/+zEBSPqx/Mrdfjmgco1Nd
         teRhMkoncYyUVcVg3eQJuMZ4sAwnfWFBQ+9uPsBGg1UjpjUwOJVPtFjMuTAHcQZW4a5h
         viqQ==
X-Gm-Message-State: AOAM531eTZv2nJ9ddSfVX4thomMemcs6CYGW8dgMxcc8eqE5nZbsQzP1
        aw3DSrKDuY+GO4R8kh5ixxyxmy2hJ04=
X-Google-Smtp-Source: ABdhPJx0dzCgjf0+HqfNTRCDPyrlTfZMhnFjLlY8SvxOGD2WsCbfnGBj4BO45KtQiLoai6Eb8gLvJQ==
X-Received: by 2002:a05:6402:170a:: with SMTP id y10mr37191135edu.324.1639133704707;
        Fri, 10 Dec 2021 02:55:04 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x7sm1306314edd.28.2021.12.10.02.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:55:04 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 16/25] trace-cmd library: Read headers from trace file version 7
Date:   Fri, 10 Dec 2021 12:54:39 +0200
Message-Id: <20211210105448.97850-17-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105448.97850-1-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-input.c | 137 ++++++++++++++++++++++++++++++++----
 1 file changed, 122 insertions(+), 15 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 8f95bf3b..9027729e 100644
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
 
@@ -995,6 +982,126 @@ int tracecmd_read_headers(struct tracecmd_input *handle,
 	return 0;
 }
 
+static int handle_options(struct tracecmd_input *handle);
+
+static int read_section_header(struct tracecmd_input *handle, unsigned short *id,
+			       unsigned short *flags, unsigned long long *size, const char **description)
+{
+	unsigned short fl;
+	unsigned short sec_id;
+	unsigned long long sz;
+	int desc;
+
+	if (read2(handle, &sec_id))
+		return -1;
+	if (read4(handle, (unsigned int *)&desc))
+		return -1;
+	if (read2(handle, &fl))
+		return -1;
+	if (read8(handle, &sz))
+		return -1;
+
+	if (id)
+		*id = sec_id;
+	if (flags)
+		*flags = fl;
+	if (size)
+		*size = sz;
+
+	return 0;
+}
+
+static int handle_section(struct tracecmd_input *handle, struct file_section *section)
+{
+	unsigned short id, flags;
+	unsigned long long size;
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

