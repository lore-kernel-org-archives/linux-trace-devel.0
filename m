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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB93FC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7AF6611CC
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233703AbhIJNwd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233753AbhIJNwc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:52:32 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0441AC061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:21 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id ho42so4370824ejc.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y//uJVrIVO3JQdJ0a4IjagsXNM23/JJFQuOxOKQIPYw=;
        b=nWYtNTe/BeXq+jU9ZrlEUy2ShHuP7NISVr0DbOhPtv2P/iMKdoUXarPpk1K0XYHk9K
         P6nChCfTA4P0PYhSjQZDUW9pDKKFyXHcEGEZNjl4hkUbJYk6wShy9Trb2ZnAbZ8Vo+Ei
         uGhRT7bS5H/hHiRVMDs/RUdaNFPd2azu+OcYhQ+WsrfbIfxsLY3qJedYhbkf4xBkpIEs
         BMOLqfHmHB5P9JXKAWDBH+mMGP7wEZm+ul96lZt//XZgSV0nwpCzfFc891T1ZCytd12e
         ttof+VZOYYutkx+ShtUJcz186OQ1ogkslnXl0WrtWrMIjf9bghID/OapMgLkFF7749JQ
         87iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y//uJVrIVO3JQdJ0a4IjagsXNM23/JJFQuOxOKQIPYw=;
        b=j+hczYlEoJRQJrNWK189X6IDJWMDXpwPFeJkN78TjDgId6h5MdXFuSylefJubXwXj3
         OXv6bY3IHiNIiNojccJXRL7kdSns6IQEc1G7XQ2ew3bIu/Hqxa/SQtTflCO5OL0NtrhJ
         DPSiVH3lGvVgJYQWtvLYajs0Fa103dZXs3GZA4ti870tXDkmDq/ebKsZxd/llcIJIc1l
         k7iyCI02XiCCuGNEggWxngKNA8GwLGbdCrpC6GS9cfUN/WopoaST+AiK6Dh9VbPNW9YC
         +qJtbKcLSfRTceDe+/Q7uvfA0328I9HqhDHfdMwMLN++grF6jkIi2FHHfneT5OdIGKSf
         DHTA==
X-Gm-Message-State: AOAM5313nEvIShGgNGei7JEV00qnBa6YQH4pYoZKJpkoibMVGe3I0Jby
        17Fwx/lG1EVC4ZUUrBnNhuz5Tgir1kE=
X-Google-Smtp-Source: ABdhPJwI0vrAZzi2squZkmhiM8KgfuLbBWrPE5Nos7gfeWAL7mRnT1Q+rj0NfvdSwdsOZIVEeVswiw==
X-Received: by 2002:a17:906:114f:: with SMTP id i15mr9578403eja.534.1631281879547;
        Fri, 10 Sep 2021 06:51:19 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w13sm2484683ejc.100.2021.09.10.06.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:51:19 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 17/25] trace-cmd library: Read headers from trace file version 7
Date:   Fri, 10 Sep 2021 16:50:53 +0300
Message-Id: <20210910135101.2865226-18-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
References: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
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
index 6eabd04e..0aa263ba 100644
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

