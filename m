Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31E3BC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:55:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239436AbhLJK6o (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 05:58:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237197AbhLJK6n (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 05:58:43 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85B6C061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:55:08 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id o20so28963544eds.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:55:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4gGdB7bqLgCCFEbsAEpdD3m1MTdk33CE7JFBFdg6Qs8=;
        b=OVEvCP2/yS8TnBS6vnq1n28gzegEWXO/FbmziqIO9O0HH9AbidCQ34ESo/XEFd5GDi
         zRMeb3OjvhXeeSYbYyx+RdkVbnah8/xQaH8JOzcDBZBiKTEmei/bk3vuqnFq4jGDPXir
         KOgApvzwEcEf4ly6WE8GeP9OkmGQKpVByHTJ7t53jC/dg6/aQMdL4MQzw3zgE0eKKhD2
         hRqG8sBorQGd22N3vZhbRQyOUhS37kjMWXkL4+SvviV60SKjwORYkTKHH+oJJlxk7Bdq
         vBKWeFJY0iY7oKksq+T7W2GhmjK50GW9BfNj5JaRVj80022KqGOztB4B4bxjfzreYWEP
         90pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4gGdB7bqLgCCFEbsAEpdD3m1MTdk33CE7JFBFdg6Qs8=;
        b=uKqlwKq/M0Ex3SRwMH9tQfoHNx44OXusnH51ZfIO+DnI+cYzASRj0h2q4+ic7tbGr0
         91V5P4j64J2cih26pumKX8J7PClHKHLASovu97up5Ct7ufCob+nI+4DuPwp52nlzcFk0
         1ZpyQ2aga/ZqoUf5xvxRISCXhP5X6QbC2u4Ar+P7dnPZta/tvZiqP1QPVKNyV9/WWmVG
         bKIXPg2/SGr2EcgNMQt+sj3EjoH1hZFabcvOyZLPIQCQMQpOjw8PxMapAAexd+XW1LCt
         W+4yRgvUunmsAg3tsYYluE+dszOs/ITvpDGHYMOPiS4r/Osl2DrhL95JYiGHLeC6Huk1
         lY3w==
X-Gm-Message-State: AOAM532G5/4joB4JGHAyxTnHTUK6lRf8VRWwD/P3dxTKfvOnSxG2Je7a
        L9+LQHHZYqGje2TMOCT/V5JORpiktWQ=
X-Google-Smtp-Source: ABdhPJw6VKLj4VsMS5Kp8gLf1yxO8cBBmCINLYgLurzRzIwthWW7tSMJ9KAnjg9Sfli9Xu0NMuLMcQ==
X-Received: by 2002:a17:907:7f9e:: with SMTP id qk30mr23138018ejc.313.1639133707448;
        Fri, 10 Dec 2021 02:55:07 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x7sm1306314edd.28.2021.12.10.02.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:55:07 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 19/25] trace-cmd library: Handle the extended DONE option
Date:   Fri, 10 Dec 2021 12:54:42 +0200
Message-Id: <20211210105448.97850-20-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105448.97850-1-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7 the DONE option is extended to store the offset
in the file to the next options section. This way a list of options
sections can be stored in the file. Added logic to recursively read all
option sections from the file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h |  1 +
 lib/trace-cmd/trace-input.c             | 42 +++++++++++++++++++++++--
 lib/trace-cmd/trace-output.c            |  2 +-
 3 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index ac7e7f17..b4f3d8c8 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -53,6 +53,7 @@ struct cpu_data_source {
 int out_write_cpu_data(struct tracecmd_output *handle, int cpus,
 		       struct cpu_data_source *data, const char *buff_name);
 off64_t msg_lseek(struct tracecmd_msg_handle *msg_handle, off_t offset, int whence);
+unsigned long long get_last_option_offset(struct tracecmd_input *handle);
 unsigned int get_meta_strings_size(struct tracecmd_input *handle);
 
 #endif /* _TRACE_CMD_LOCAL_H */
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 5625e367..a25919a3 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -179,6 +179,7 @@ struct tracecmd_input {
 	struct file_section	*sections;
 	bool			options_init;
 	unsigned long long	options_start;
+	unsigned long long	options_last_offset;
 	size_t			total_file_size;
 
 	/* For custom profilers. */
@@ -2868,6 +2869,30 @@ __hidden unsigned int get_meta_strings_size(struct tracecmd_input *handle)
 	return handle->strings_size;
 }
 
+__hidden unsigned long long get_last_option_offset(struct tracecmd_input *handle)
+{
+	return handle->options_last_offset;
+}
+
+static int handle_option_done(struct tracecmd_input *handle, char *buf, int size)
+{
+	unsigned long long offset;
+
+	if (size < 8)
+		return -1;
+	offset = lseek64(handle->fd, 0, SEEK_CUR);
+	if (offset >= size)
+		handle->options_last_offset = offset - size;
+	offset = tep_read_number(handle->pevent, buf, 8);
+	if (!offset)
+		return 0;
+
+	if (lseek64(handle->fd, offset, SEEK_SET) == (off_t)-1)
+		return -1;
+
+	return handle_options(handle);
+}
+
 static inline int save_read_number(struct tep_handle *tep, char *data, int *data_size,
 				   int *read_pos, int bytes, unsigned long long *num)
 {
@@ -2970,19 +2995,27 @@ static int handle_options(struct tracecmd_input *handle)
 	long long offset;
 	unsigned short option;
 	unsigned int size;
+	unsigned short id, flags;
 	char *cpustats = NULL;
 	struct hook_list *hook;
 	char *buf;
 	int cpus;
 	int ret;
 
-	handle->options_start = lseek64(handle->fd, 0, SEEK_CUR);
+	if (!HAS_SECTIONS(handle)) {
+		handle->options_start = lseek64(handle->fd, 0, SEEK_CUR);
+	} else {
+		if (read_section_header(handle, &id, &flags, NULL, NULL))
+			return -1;
+		if (id != TRACECMD_OPTION_DONE)
+			return -1;
+	}
 
 	for (;;) {
 		if (read2(handle, &option))
 			return -1;
 
-		if (option == TRACECMD_OPTION_DONE)
+		if (!HAS_SECTIONS(handle) && option == TRACECMD_OPTION_DONE)
 			break;
 
 		/* next 4 bytes is the size of the option */
@@ -3122,7 +3155,10 @@ static int handle_options(struct tracecmd_input *handle)
 			section_add_or_update(handle, option, -1,
 					      tep_read_number(handle->pevent, buf, 8), 0);
 			break;
-
+		case TRACECMD_OPTION_DONE:
+			ret = handle_option_done(handle, buf, size);
+			free(buf);
+			return ret;
 		default:
 			tracecmd_warning("unknown option %d", option);
 			break;
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 08f74c87..1fa83e93 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2238,7 +2238,7 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	tep_ref(handle->pevent);
 	handle->page_size = tracecmd_page_size(ihandle);
 	handle->file_version = tracecmd_get_in_file_version(ihandle);
-	handle->options_start = tracecmd_get_options_offset(ihandle);
+	handle->options_start = get_last_option_offset(ihandle);
 	handle->strings_offs = get_meta_strings_size(ihandle);
 	list_head_init(&handle->options);
 	list_head_init(&handle->buffers);
-- 
2.33.1

