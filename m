Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C5AEC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:25:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352400AbiASIZb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:25:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352402AbiASIZ3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:25:29 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E8DC06173E
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:28 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id q25so7646953edb.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QS6PJhSLqh0bsb/HXlHjf6qtLioExB0jDJ2s/M3szr4=;
        b=YU0YnIIaqyX+A7ZBfkUpTf9GEDtNkhjko4U/sV+S0SQhnSjMDEcnJLFtp0Gm1tFkp/
         nvnI0B6OvH2NSYC1t0bR/cHux91Ae/qnMwItCwPbtDcmo35UYD/WNZmf7UH6+aIZkDPm
         a93Yn9BmZAvZO9q2UMgq51iclwa2PMtY82s5d1P2uE41QJsgrVbxYjrYnpgK63qHeaBR
         lSCIXiGecjVg8wbODwcfYdjLZZP9QhcD//RMhVis3GwJgGVyjC7IWakyQHxxGhcFk4w/
         aYoX5T/lQt89z6NRTyLSbvk78VAJKkqphxZ5h0NqawHk5lpUHpcaObh7+8l8iW5eqjg0
         BGZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QS6PJhSLqh0bsb/HXlHjf6qtLioExB0jDJ2s/M3szr4=;
        b=RpShCWGIFJ4B6z6TgTCUZeIdRbiZftcfptiYTGQoSf5PM5VsbrmUbSnjpcWKuRCQzd
         Ka7aj0JD8Cbl0foLOyT3rWepyVSD7iOcI6G8oeD8clMppmOLX4v+Qgtbcea0II2+kvNa
         f84LsXnTHpv27AKyt8hHD8tZMGBTrlPaNM4DZqwm7xZZU63YFPaK8kDfyQ47gJ38uNEZ
         QWKEoFSp41LAsTjLNI0a16LkIh4/zUhxe/Gsjy7xYGYSmo2B1/u+5zcQB/3h7Uvm17Lk
         vZc8yCqfUb156xed0SpeQVBQNHu9WVNbOpKIhB+BtKjsjI1lqGyadw+eHOhXTSD1mDVl
         hPcA==
X-Gm-Message-State: AOAM532M/4tGr06dbDFxOzoD0mulMze1a4XfG7fvVEA7MAZF1X8cA92I
        D7rpduvfIFD5wpwHFITTKHYSC3tk+jA=
X-Google-Smtp-Source: ABdhPJzsh52yW28V9CNTfubJNQrv2UkON00ZpCpoOEFJVi0JUG7T9RyF8jjJCkyfHa4grjr+WRG2+Q==
X-Received: by 2002:a17:906:4945:: with SMTP id f5mr2507128ejt.429.1642580727467;
        Wed, 19 Jan 2022 00:25:27 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l1sm5011122ejf.44.2022.01.19.00.25.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:25:27 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 17/25] trace-cmd library: Read strings sections on file load
Date:   Wed, 19 Jan 2022 10:24:59 +0200
Message-Id: <20220119082507.245600-18-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082507.245600-1-tz.stoyanov@gmail.com>
References: <20220119082507.245600-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Internal strings database is added to trace input handle, containing all
metadata strings from trace file. When a trace file is opened, all
strings sections are located and the internal strings database is
initialised.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h |  1 +
 lib/trace-cmd/trace-input.c             | 65 +++++++++++++++++++++++++
 lib/trace-cmd/trace-output.c            |  1 +
 3 files changed, 67 insertions(+)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 4a0a691c..ac7e7f17 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -53,5 +53,6 @@ struct cpu_data_source {
 int out_write_cpu_data(struct tracecmd_output *handle, int cpus,
 		       struct cpu_data_source *data, const char *buff_name);
 off64_t msg_lseek(struct tracecmd_msg_handle *msg_handle, off_t offset, int whence);
+unsigned int get_meta_strings_size(struct tracecmd_input *handle);
 
 #endif /* _TRACE_CMD_LOCAL_H */
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index b7785700..2e10ebad 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -147,6 +147,9 @@ struct tracecmd_input {
 	long long		ts_offset;
 	struct tsc2nsec		tsc_calc;
 
+	unsigned int		strings_size;	/* size of the metadata strings */
+	char			*strings;	/* metadata strings */
+
 	struct host_trace_info	host;
 	double			ts2secs;
 	char *			cpustats;
@@ -986,6 +989,14 @@ static int read_headers_v6(struct tracecmd_input *handle, enum tracecmd_file_sta
 
 static int handle_options(struct tracecmd_input *handle);
 
+static const char *get_metadata_string(struct tracecmd_input *handle, int offset)
+{
+	if (!handle || !handle->strings || offset < 0 || handle->strings_size >= offset)
+		return NULL;
+
+	return handle->strings + offset;
+}
+
 static int read_section_header(struct tracecmd_input *handle, unsigned short *id,
 			       unsigned short *flags, unsigned long long *size, const char **description)
 {
@@ -1009,6 +1020,8 @@ static int read_section_header(struct tracecmd_input *handle, unsigned short *id
 		*flags = fl;
 	if (size)
 		*size = sz;
+	if (description)
+		*description = get_metadata_string(handle, desc);
 
 	return 0;
 }
@@ -2841,6 +2854,11 @@ tracecmd_search_task_map(struct tracecmd_input *handle,
 	return lib;
 }
 
+__hidden unsigned int get_meta_strings_size(struct tracecmd_input *handle)
+{
+	return handle->strings_size;
+}
+
 static int handle_options(struct tracecmd_input *handle)
 {
 	long long offset;
@@ -3474,6 +3492,50 @@ struct hook_list *tracecmd_hooks(struct tracecmd_input *handle)
 	return handle->hooks;
 }
 
+static int init_metadata_strings(struct tracecmd_input *handle, int size)
+{
+	char *tmp;
+
+	tmp = realloc(handle->strings, handle->strings_size + size);
+	if (!tmp)
+		return -1;
+
+	handle->strings = tmp;
+	if (do_read_check(handle, handle->strings + handle->strings_size, size))
+		return -1;
+
+	handle->strings_size += size;
+
+	return 0;
+}
+
+static int read_metadata_strings(struct tracecmd_input *handle)
+{
+	unsigned short flags;
+	int found = 0;
+	unsigned short id;
+	unsigned long long size;
+	off64_t offset;
+
+	offset = lseek64(handle->fd, 0, SEEK_CUR);
+	do {
+		if (read_section_header(handle, &id, &flags, &size, NULL))
+			break;
+		if (id == TRACECMD_OPTION_STRINGS) {
+			found++;
+			init_metadata_strings(handle, size);
+		} else {
+			if (lseek64(handle->fd, size, SEEK_CUR) == (off_t)-1)
+				break;
+		}
+	} while (1);
+
+	if (lseek64(handle->fd, offset, SEEK_SET) == (off_t)-1)
+		return -1;
+
+	return found ? 0 : -1;
+}
+
 /**
  * tracecmd_alloc_fd - create a tracecmd_input handle from a file descriptor
  * @fd: the file descriptor for the trace.dat file
@@ -3570,6 +3632,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 			tracecmd_warning("Filed to read the offset of the first option section");
 			goto failed_read;
 		}
+		read_metadata_strings(handle);
 	}
 
 	handle->file_state = TRACECMD_FILE_INIT;
@@ -3742,6 +3805,7 @@ void tracecmd_close(struct tracecmd_input *handle)
 	free(handle->cpu_data);
 	free(handle->uname);
 	free(handle->trace_clock);
+	free(handle->strings);
 	free(handle->version);
 	close(handle->fd);
 
@@ -4201,6 +4265,7 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 	new_handle->buffers = NULL;
 	new_handle->version = NULL;
 	new_handle->sections = NULL;
+	new_handle->strings = NULL;
 	new_handle->guest = NULL;
 	new_handle->ref = 1;
 	if (handle->trace_clock) {
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 7e1849c8..2b5671ae 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2255,6 +2255,7 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	handle->page_size = tracecmd_page_size(ihandle);
 	handle->file_version = tracecmd_get_in_file_version(ihandle);
 	handle->options_start = tracecmd_get_options_offset(ihandle);
+	handle->strings_offs = get_meta_strings_size(ihandle);
 	list_head_init(&handle->options);
 	list_head_init(&handle->buffers);
 
-- 
2.34.1

