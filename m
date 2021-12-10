Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 181A8C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:55:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236851AbhLJK6j (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 05:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237147AbhLJK6i (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 05:58:38 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70EDFC061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:55:03 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id g14so27928468edb.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:55:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y4pf0y4sfw6lh/CF4Bmam9SYLOsEz3impzwFSOxA4S4=;
        b=gRoWNs27ywduOoQWRXEZ3EXhRfNIMzXac+RA4gtbDSBnSf6OpGBPHbR4vyPml/4cH5
         Zeu6HD/eGARBZ1Bm3yWkaPAmrOesVcCv4iReuOBlVfDKuRRAn6znus2VSqWDZ3oDoqoH
         jAtR66bs65cpGQLQ0RylBrcvWZ+ZyYOUkS4FvgXecrxhr3hg0+d+2E7r0PTodf1Wox59
         FvRe++6hNMShcAKf1k4a198lwf+9Dlu+uWjrbQhW6bh1U+INPcMjqyoGfz6BDmvwT0K6
         PkN+8ZmJrqRS1xhkrJf1eRF6nl/YGcEHG9Q+D4KgvtK+BxB3CnWtsUhpErPgq3KzopLo
         pPGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y4pf0y4sfw6lh/CF4Bmam9SYLOsEz3impzwFSOxA4S4=;
        b=AFe14Cy01hnqsAfsSTjtnuXSMiNKv+1A7cU6OR1YaSlp00Zu6BYIU9xswi8jHZkfee
         LMDhzniDBnTv5jOSN+3OyHrv7+2133+7N+BUw7GgIOWMsmMF17ivqzeKRRQuSN543mVE
         oFAoiTfihEL3i9sHKPzcBQixfvtc3bGh9h6xZa5T+SITPi0HN2AqIQbUPFkatT5axWrh
         QVlNzxgMlt9UVhGRJ0zuBia0bz6x6vfolBs80rS5DiBOnfQP5AXH+kzA9BIXO0I9hWFw
         x/jnxkjrb5sAuRXVU52LevbiSkVn9CeXV7o1KS+V4VTX5GequJ6rjC32jFShVdJz0M4J
         h7Dg==
X-Gm-Message-State: AOAM531ooZiEhloHRpxCAA/UrF1GIej5MbD19AJIUxfRsg2jydHQccJ8
        bJEYhqVd11eYJF5zial7PYbyOReWpTs=
X-Google-Smtp-Source: ABdhPJzWiR8L/XciOEtlHZuQG58UROIV7787g6tvJSwmR1tTV5uQ9t6yJpn31bKmuQBqotbZIZZdeg==
X-Received: by 2002:a05:6402:2079:: with SMTP id bd25mr38517994edb.116.1639133702086;
        Fri, 10 Dec 2021 02:55:02 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x7sm1306314edd.28.2021.12.10.02.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:55:01 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 13/25] trace-cmd library: Introduce sections in trace file reading logic
Date:   Fri, 10 Dec 2021 12:54:36 +0200
Message-Id: <20211210105448.97850-14-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105448.97850-1-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
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

