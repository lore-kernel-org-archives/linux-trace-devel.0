Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A71D8C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9065260F6E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237528AbhJHEWP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbhJHEWO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:22:14 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE25AC061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:20:19 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id g10so30370805edj.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FErkVfh3h/S6xvv3sz3VAIp06/J4DLvECW0h7FdeorE=;
        b=LwoGhH18xY+NZeg+xEvScnFMs+/gVDxL0m+cEAG7SskU0TgEZCjJH7wVq49LaSAvL+
         q3r5Z4OK0qOW+hbyqOS0GLoqwwWLZ0w1WpcGbTblx43fol2jqwSebUFC9xRf1EyhrEFJ
         xrpjPtwJReEsLgVstLyMVu1PwFV6lk7cET2nW48cCNKzRbuismUp1Y6FeOBovWj9UjhV
         8EZvRtQCjO8tD88BxizasEkjtla5JYvDTqctLSwqwycaIW050uqTZYHSqYFt0+R7qmAJ
         kgWqKZRjVilGUJ/zzsuF7oLmJHFJeh4fn2d0hjM+i3o8JogHwrOmI2LXXOJzjzF3gnTF
         CjAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FErkVfh3h/S6xvv3sz3VAIp06/J4DLvECW0h7FdeorE=;
        b=BLv/k5Yjf8kUvgAV5XCrntFR4w136lIh/JSssRd3IqkIw0SiROmFEPd4BsMrbGfuX0
         B4hOF835Eio2uDy+JfiwWOH+kdGEu87Uq6tNXQeV7y5fwpl7Z7161ptb2R2l7K+qEfzJ
         4MikdAK5mU6qtmdtkkg90X57lMUQw6M2bYRRqB0Pek9v2Bx+/8csivJVfc8Hb24MjeR9
         IQij/Fwrtu7aFaHpSKmJHd6Ec92I6lyCe1cUKsJ1aV/F9r4JeilcFYedqplMr09pjQzA
         K1vrrg6+Qsz5MTEVICVm6yprJv5m8WdSKuVLEZUkSCD6KjL746C0uEJlPprbbG3dEE9A
         lGAg==
X-Gm-Message-State: AOAM530pN6JmPBD+90JnIVstDYiwFfGr//i0tPrLRwBt9KpwSV00uTw9
        1MKBgZeC9p9SDD7mmrz0n91M054u6QKA0A==
X-Google-Smtp-Source: ABdhPJxgj4mSQ8w41vhe08DQMAkH4B5xSmSuRX0PU5h4iUsKkty4KGsaeLcvm47Eh/3Yg2P2tjEfxg==
X-Received: by 2002:a50:d885:: with SMTP id p5mr11563456edj.255.1633666818450;
        Thu, 07 Oct 2021 21:20:18 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p6sm511669edi.18.2021.10.07.21.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:20:17 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 17/25] trace-cmd library: Read headers from trace file version 7
Date:   Fri,  8 Oct 2021 07:19:50 +0300
Message-Id: <20211008041958.976309-18-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041958.976309-1-tz.stoyanov@gmail.com>
References: <20211008041958.976309-1-tz.stoyanov@gmail.com>
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
index 7386f407..769bdcc3 100644
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
 
@@ -916,19 +915,7 @@ static int read_cpus(struct tracecmd_input *handle)
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
 
@@ -994,6 +981,134 @@ int tracecmd_read_headers(struct tracecmd_input *handle,
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

