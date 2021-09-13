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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A77FC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:30:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48B1760F6D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239995AbhIMMbV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240001AbhIMMbU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:31:20 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D300C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:30:05 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id n7-20020a05600c3b8700b002f8ca941d89so6475407wms.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gF9UzrkCpbQGU+P5Zr9zOkb81SGV9PwzYYl4jv5f5Kc=;
        b=LCWlodVFXBnRQ056qsldJCQ/eA0bFy6tgh+77iBe0UVA1QKFRED14oZs7cEGU5gutb
         tBmQ3FHeP0pBOBQK1Pyrf2u6KI6DFRpdFQnnQjD8ZNejuIOmU8BQffQpC1HfdXetPvrX
         Gd5hVRXKiEQTWlmoIX8+HN6moxfh52kbqAlATwVDJFyu+9WIRJ3EA7lAal/n85BNFeUe
         WdKCyknc2Kg2cBj8/TRBoB6/7gymPMX3qkFsqo39EWJcM/qse2QyMkgbcSkFi4DpNxzc
         mzP5nMUAWf+Db8fTXTTUjI+ZzvW4Z4MbpD0oCYxCcq9Nq8yle6rb81JO5LHEGzSPHSaX
         V4KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gF9UzrkCpbQGU+P5Zr9zOkb81SGV9PwzYYl4jv5f5Kc=;
        b=b53o+1U6YOQ/2k2eUiqkODmUEuC329JMpRDtDEASK/AIkdSE8fj6fmjc69f+W0CbUc
         98Gin5QT2jUWYppF3/tyqUI20QG9FAmTBUPbNhM/l5tSpfClLgHW1ScrmFK0AB3wGtYI
         TJxdw51xCN15qd50Wwh611Qb5ID+XWA8QuBHluXHAKSd39GZWbvc2AxwecBA7mM8Jlm5
         vrxxx4DFPFnwvW2Puz3TCQqoVaqk3rmNUe/F0f/23cpS+pE1Y7lEOF6mvKkONdroQlke
         AQ8isvgrohHnhU4Ua9An1SndITZbnwiSKgucTifQx/8RkldnnUll+Lz7r2dYaU0Un7hj
         hE4A==
X-Gm-Message-State: AOAM5302T/LnDzn9F/Wxkk/RCgKqXIUhKyqu/3evkuywKSu1Yind8oGa
        YY7fMLDAmART6vETfn8SyCefNeyesvI=
X-Google-Smtp-Source: ABdhPJxl++LcGbx9R9OFfvcq1OorWH0ubdNvHGNrMi9ZEEOzWkgPDBBTNaX364NXUdCKTzTO7uZDvw==
X-Received: by 2002:a7b:c191:: with SMTP id y17mr3187072wmi.122.1631536203771;
        Mon, 13 Sep 2021 05:30:03 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z5sm6842030wmf.33.2021.09.13.05.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:30:03 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 14/25] trace-cmd library: Introduce sections in trace file reading logic
Date:   Mon, 13 Sep 2021 15:29:36 +0300
Message-Id: <20210913122947.3673239-15-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
References: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
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
index 85100aa4..978758c0 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -114,6 +114,14 @@ struct tsc2nsec {
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
@@ -153,6 +161,7 @@ struct tracecmd_input {
 	struct hook_list	*hooks;
 	struct pid_addr_maps	*pid_maps;
 	/* file information */
+	struct file_section	*sections;
 	size_t			header_files_start;
 	size_t			ftrace_files_start;
 	size_t			event_files_start;
@@ -376,6 +385,58 @@ static int read8(struct tracecmd_input *handle, unsigned long long *size)
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
@@ -3508,6 +3569,7 @@ void tracecmd_ref(struct tracecmd_input *handle)
  */
 void tracecmd_close(struct tracecmd_input *handle)
 {
+	struct file_section *del_sec;
 	int cpu;
 	int i;
 
@@ -3547,6 +3609,12 @@ void tracecmd_close(struct tracecmd_input *handle)
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
@@ -3991,6 +4059,7 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 	new_handle->nr_buffers = 0;
 	new_handle->buffers = NULL;
 	new_handle->version = NULL;
+	new_handle->sections = NULL;
 	new_handle->guest = NULL;
 	new_handle->ref = 1;
 	if (handle->trace_clock) {
-- 
2.31.1

