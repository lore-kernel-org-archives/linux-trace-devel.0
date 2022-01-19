Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAB53C4321E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:25:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352402AbiASIZb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:25:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352401AbiASIZ2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:25:28 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2729C06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:27 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id b13so7810333edn.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A3838AQ6PwuFvs4A3Z75lD6iChvJ325ckhNRXS1psH8=;
        b=Hk3/ZibB5vjT9SNkKK/xVVLau1NH9bjLGtX4e2OHU6QeUO3SGmAqozB94PdO3x7hS1
         KCoYnq0u30wWlX31vmJbwkIhpgGwTnFUEINqku9KMItxduTkAD46cJffXDSFxuQ8XLpU
         usANUDHhvUTUHNr00jIhH1zyffYbB/Ols4VAiWzr3E5WRnGlEICSm99Pm1xluDAR2QxC
         wSAB6s2wWMJBXT/+qemcRxdcDb8FLzIQezMWFlSPwNz2Z6Qx/AJF6yFQjUK4S4fBzGss
         e3bkTGgyswE5u5CCe5T5mmnNw5liWA4QLF0C1Ed7laWPa8Hh03kWtGPY+VP0hulJFJXA
         8gMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A3838AQ6PwuFvs4A3Z75lD6iChvJ325ckhNRXS1psH8=;
        b=4uWlhcUqw4Wsm5jaisz3Cb+3oX9ukeU3mKZE30qr1zlBGMbDM0lVL/HaYcDpCi0gGU
         Qtnobg9pXFwg5YrhDWCWEG6DvEOUb3+ycBlfOTj/5nN7UIQA4Kj0qSEsxSYjVsQLRkjl
         PzUmpKr1xeX8ipyGZk5JogZviq0xanJxX3X0Pd5w05++7ywW+DRJvOmB8Cr4DPMPP7vF
         YKaV5ywzzuOx4Y4Yhcr6uac7wUPJib+4vrRC3b1YKlf4LyoVVz9EkLqxTf4vmbbG8IgX
         HUZaAfuf2l8BOLU3poP9PN9POkLHygli1a0yz5CzZpmh1UuYbSU+zCq0bKucHI9F0Blu
         Uo+w==
X-Gm-Message-State: AOAM531QYXaJCn2C9RcFTrq6pH4d+BlCT7il3504xaJ1tPDHInYGyu2M
        Tx0Z8bUMMABeNFPz3sGJMHqrfZiJ2uU=
X-Google-Smtp-Source: ABdhPJyK9Eqki68cmgIdbvnnq0xcaq0ZZVqmVea1b6wR1X3GRZGKhGPQEkM67B5DqVJ2/NKBYy8rrg==
X-Received: by 2002:a17:906:e282:: with SMTP id gg2mr24465476ejb.607.1642580726579;
        Wed, 19 Jan 2022 00:25:26 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l1sm5011122ejf.44.2022.01.19.00.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:25:26 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 16/25] trace-cmd library: Read headers from trace file version 7
Date:   Wed, 19 Jan 2022 10:24:58 +0200
Message-Id: <20220119082507.245600-17-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082507.245600-1-tz.stoyanov@gmail.com>
References: <20220119082507.245600-1-tz.stoyanov@gmail.com>
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
index e8ece688..b7785700 100644
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
 
@@ -919,19 +918,7 @@ static int read_cpus(struct tracecmd_input *handle)
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
 
@@ -997,6 +984,126 @@ int tracecmd_read_headers(struct tracecmd_input *handle,
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
+	if (read2(handle, &fl))
+		return -1;
+	if (read4(handle, (unsigned int *)&desc))
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
+static int read_headers(struct tracecmd_input *handle)
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
+	return read_headers(handle);
+}
+
 static unsigned long long calc_page_offset(struct tracecmd_input *handle,
 					   unsigned long long offset)
 {
-- 
2.34.1

