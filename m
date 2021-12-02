Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EE9AC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:22:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358075AbhLBM0K (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:26:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358074AbhLBMZd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:25:33 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D4C2C06175C
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:22:10 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id r25so49129691edq.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y4pf0y4sfw6lh/CF4Bmam9SYLOsEz3impzwFSOxA4S4=;
        b=CQh4gWSvqNnCGYDkZ30LfodCkG0fJa9xYJpVl7LReeCBZ1BilA4D9ldc7kCl5ahqHD
         cnzorSXrOcXKZXh2UQTeJ6a0Ej+kfNIRCFgTttCURG+SYO7O+zij0YHupwAmvT4+O1Ky
         vYaUKBxk6TglfZJaNIs1owpw9tGYp04DSzgsbsziSJYEuEcBW6HxD+L/ZFA75gauccP9
         znH1MEyotCXmj2Jc6O7eSbaKJZX5S1PO66B1NaUH2ve8bmq70/0PpbbeUG92cfMIHuwe
         TG330YsyrtbYeKQN5RGf9ZSvOJkWumHLX2gOi371jhwSEeGWhwlkgXLB3ylO9+t3FXQ3
         /2NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y4pf0y4sfw6lh/CF4Bmam9SYLOsEz3impzwFSOxA4S4=;
        b=OqHzJSVQIrK03Yno0EEuYK1qPmfD7v8Ly5gPBoPk3co3nGdm1630Je13dGrhg1IMPD
         Jt65nk90HP1NdZRj3zYRr2Hqn0lpFEHfK8k+DwbOUWy/8Ck2ehSmR2hBC5So2UhMG1OR
         piroKb0s19QsiTTv/ZvVh6sZ2eQ2Mvta+0H1E0Di097vsfUdyW+WOdDIgeiwMtrNy6zB
         3VqTMDH3hbShD2QzxB3OwKA/vvEcVV9cPXxEnrLCKqffX/m/sP0ReRuIuiyGeJkHXrqR
         +k7NL+5js8fsyNLLa6MzjKP484JpzMGC7Qofm9jk3WgsKmiUDb7qvLVNzAkCsGquPudT
         FVfQ==
X-Gm-Message-State: AOAM531uzMx8PhTjGo/MdwBLaf+ECT5RtTO/1dk8cAN6WKK8UmR7YSMQ
        j8kdWqnItwBfL2eqG2IJJhYWEWMg3ECWBA==
X-Google-Smtp-Source: ABdhPJzanB4IFTKup0NTCufaGVk0cJ4J+xM5nZisI+cXhAPP1l4tPLg8MPvBQS+lk/CTS8x2hkj4Ow==
X-Received: by 2002:aa7:d748:: with SMTP id a8mr17345020eds.21.1638447726149;
        Thu, 02 Dec 2021 04:22:06 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gb42sm1892772ejc.49.2021.12.02.04.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:22:05 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 12/23] trace-cmd library: Introduce sections in trace file reading logic
Date:   Thu,  2 Dec 2021 14:21:41 +0200
Message-Id: <20211202122152.43275-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122152.43275-1-tz.stoyanov@gmail.com>
References: <20211202122152.43275-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace file version 7 is based on sections. Added an internal sections
database and new helper functions to add, read, open and close file
sections.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 69 +++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 0375afba..78f9effd 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -115,6 +115,14 @@ struct tsc2nsec {
 	unsigned long long offset;
 };
 
+struct file_section {
+	unsigned long long		section_offset;
+	unsigned long long		data_offset;
+	int				id;
+	int				flags;
+	struct file_section		*next;
+};
+
 struct tracecmd_input {
 	struct tep_handle	*pevent;
 	unsigned long		file_state;
@@ -154,6 +162,7 @@ struct tracecmd_input {
 	struct hook_list	*hooks;
 	struct pid_addr_maps	*pid_maps;
 	/* file information */
+	struct file_section	*sections;
 	size_t			header_files_start;
 	size_t			ftrace_files_start;
 	size_t			event_files_start;
@@ -377,6 +386,58 @@ static int read8(struct tracecmd_input *handle, unsigned long long *size)
 	return 0;
 }
 
+static struct file_section *section_get(struct tracecmd_input *handle, int id)
+{
+	struct file_section *sec;
+
+	for (sec = handle->sections; sec; sec = sec->next) {
+		if (sec->id == id)
+			return sec;
+	}
+
+	return NULL;
+}
+
+static struct file_section *section_open(struct tracecmd_input *handle, int id)
+{
+	struct file_section *sec = section_get(handle, id);
+
+	if (!sec)
+		return NULL;
+
+	if (lseek64(handle->fd, sec->data_offset, SEEK_SET) == (off64_t)-1)
+		return NULL;
+	return sec;
+}
+
+static void section_close(struct tracecmd_input *handle, struct file_section *sec)
+{
+	/* To Do */
+}
+
+static int section_add_or_update(struct tracecmd_input *handle, int id, int flags,
+				 unsigned long long section_offset,
+				 unsigned long long data_offset)
+{
+	struct file_section *sec = section_get(handle, id);
+
+	if (!sec) {
+		sec = calloc(1, sizeof(struct file_section));
+		if (!sec)
+			return -1;
+		sec->next = handle->sections;
+		handle->sections = sec;
+	}
+	sec->id = id;
+	if (section_offset)
+		sec->section_offset = section_offset;
+	if (data_offset)
+		sec->data_offset = data_offset;
+	if (flags > 0)
+		sec->flags = flags;
+	return 0;
+}
+
 static int read_header_files(struct tracecmd_input *handle)
 {
 	struct tep_handle *pevent = handle->pevent;
@@ -3493,6 +3554,7 @@ void tracecmd_ref(struct tracecmd_input *handle)
  */
 void tracecmd_close(struct tracecmd_input *handle)
 {
+	struct file_section *del_sec;
 	int cpu;
 	int i;
 
@@ -3532,6 +3594,12 @@ void tracecmd_close(struct tracecmd_input *handle)
 	free(handle->version);
 	close(handle->fd);
 
+	while (handle->sections) {
+		del_sec = handle->sections;
+		handle->sections = handle->sections->next;
+		free(del_sec);
+	}
+
 	for (i = 0; i < handle->nr_buffers; i++)
 		free(handle->buffers[i].name);
 	free(handle->buffers);
@@ -3976,6 +4044,7 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 	new_handle->nr_buffers = 0;
 	new_handle->buffers = NULL;
 	new_handle->version = NULL;
+	new_handle->sections = NULL;
 	new_handle->guest = NULL;
 	new_handle->ref = 1;
 	if (handle->trace_clock) {
-- 
2.33.1

