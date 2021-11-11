Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61878C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:11:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4844661252
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:11:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbhKKPOI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:14:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233616AbhKKPOI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:14:08 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B79C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:11:19 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id g14so25471799edz.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:11:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rjWkABomLOW1NqtQQBs+E+WWRI1oaiGoxLAEByFvk0I=;
        b=OZmUn+aTMQBXAteqHmZE1GCmel+kT9wie+1MlXidBXl+3nWdmk8jAMH18VNl6nftSb
         0WOoowgnW3V6WeCdlPrIPW6LUoNQg/PodOzCyeJ6OKjUwnhlbzbh40FCHvN7TEZBe+SX
         gxoXvj73rsrjw9hqEuA0Z5U4hA1ETD/7wyFhfOBjkvnVioDdhJxpo1xjM9YfTyj0VBKk
         Xt/KHJCMGEtlHdbJjovgSQfHBMP2WaViCHiK0vRNOeS6L35Hd7EAaX8iFZFPWQcskj51
         P+uDVKAbZnH9sUjwWRZsCdbG6HTF4TH3R8GSvQIA9Jr6WimqWTJMN9UV+Mm741RwLD0m
         dZhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rjWkABomLOW1NqtQQBs+E+WWRI1oaiGoxLAEByFvk0I=;
        b=Ux7pA/lgq/oRIIR0SgcEtZb9paiaK+3KJBkG1LmsmHtTbfHcDd1KKuY3YwGhJckxfS
         MvcIr/MG25+33USdT9WJDlGS0vWO6YZFvFjQCVm2l5YyMqMJZ1Tl5GnL+DDJWf7lIXje
         i1zKzXYk1NqkZUQlYkmjMiILgRK3SP4qmgW3Jid4gVqlllRT03QzLI1+4EOYrU2l7Al1
         jJewa3hxJwg8fiGVyQqBYJhLtphuMtSuckHEabTzDQvnecBRIlG2PSQEClCQiAyp4ppd
         LbLryXkGAflpLTnkPrSlkiQ6gQHqNgQvc+mfZWc3vxJ7P72cRyT160K+MLBwxgUR0Cza
         baXA==
X-Gm-Message-State: AOAM533e9dxsKfc5Kcb50if8VKC/UjLSMHFBGCTNFPpPnPi3VKPZb+IQ
        1+1r0zBECe6ywXqUKz48F2x0W1qNy72/9g==
X-Google-Smtp-Source: ABdhPJyzJAnYmSUu4X41HIZ87sk84CpEoji0I4RMbAIcNW2+bbpsh/Pm2k71g5nsVR4FnJcyEipmvg==
X-Received: by 2002:a17:907:1c0a:: with SMTP id nc10mr10420695ejc.211.1636643477747;
        Thu, 11 Nov 2021 07:11:17 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id nc30sm1648803ejc.35.2021.11.11.07.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:11:17 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 14/25] trace-cmd library: Introduce sections in trace file reading logic
Date:   Thu, 11 Nov 2021 17:11:07 +0200
Message-Id: <20211111151112.86751-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151112.86751-1-tz.stoyanov@gmail.com>
References: <20211111151112.86751-1-tz.stoyanov@gmail.com>
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
index 0375afba..cc292236 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -115,6 +115,14 @@ struct tsc2nsec {
 	unsigned long long offset;
 };
 
+struct file_section {
+	int				id;
+	unsigned long long		section_offset;
+	unsigned long long		data_offset;
+	enum tracecmd_section_flags	flags;
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

