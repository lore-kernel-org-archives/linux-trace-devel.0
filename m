Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 488DBC4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352398AbiASIZ3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:25:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352393AbiASIZZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:25:25 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACBF1C06173E
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:24 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id c71so7589266edf.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1qLdqkJrMHt2l1qzDHy4fC1S3/yiXLV0StkQXfhhwrA=;
        b=ZKukvd+q6+3VzCJk61ckb/x4wuU0lbiLFlOHS9ItppikO1s0tAZoaEshmWuV6s7GVk
         EGYIrjKC+zzBhL0eJztYsFGJFPV//rx0m4ymBGTOsatsMTz7kzBXm+NdhLkA6awunwyZ
         v93Z6oxtraI4uySLleuiH9HEtepQ6kSsA35oZgJhqjkRuD6xT1psP4tQ3pC9q7YDu/4a
         5oG62mEELKR65z6J98sn5GOvx2f2q3fG5CHlE8U7jRD8A5umdZWc+jN0k+VvL8MrIDm7
         /NWM6sEg+PdS5Ktf4jt5Giu8Nvp0birWBHNGfSvzqwAsecJ+LX7LeSSZvLqV2T85sbA1
         RyEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1qLdqkJrMHt2l1qzDHy4fC1S3/yiXLV0StkQXfhhwrA=;
        b=EEYm/+GGzPOHGpvoSIe8yw2MoV7SaljyUCgf3+0g5LzQORGttRCOPRn561BNjlKPwt
         ZsJZy7ZUF+kXSQW9ogA6Wro/po8bDJWJM4MqKKJZN8lOzHVGQztWJCQK6y3i88QbfHnQ
         fn7FlVH3zlhnwsnNAOSe/xp0a7gG72oVDtvuMfAWexNXc9ObFtcrfz2v3hFsbKv5wkHn
         eYfr39rfRbUtSGl/dcHqwXidazt4P3eODbTFVelUJSTcF8FFOtw4MvHsHNJqinLAWHko
         H7SP/LbPwX39trjKzgcw3UJ+ygzuHBZNLBTCNlP1lGWQfVvXAwHA9Mp9RlbiXh+290It
         jFwg==
X-Gm-Message-State: AOAM530+lzNqm/9QnEL3jV/YMUI/oVrI53e3k4OnVpRFawvSJma+ns0H
        M9n3kwapJ9a0RTmdSg1wPbSdh4uQ7pE=
X-Google-Smtp-Source: ABdhPJxvcww5vO34ozVlcX03vTwMlRqabEBYjMtVRLsfDPJkP59fARnSIJ3pJ7pZlp9ApicvUeLBwA==
X-Received: by 2002:a17:907:728e:: with SMTP id dt14mr18780105ejc.723.1642580723330;
        Wed, 19 Jan 2022 00:25:23 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l1sm5011122ejf.44.2022.01.19.00.25.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:25:22 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 13/25] trace-cmd library: Introduce sections in trace file reading logic
Date:   Wed, 19 Jan 2022 10:24:55 +0200
Message-Id: <20220119082507.245600-14-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082507.245600-1-tz.stoyanov@gmail.com>
References: <20220119082507.245600-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-input.c | 71 +++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 50eaa5c0..22071caf 100644
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
@@ -377,6 +386,60 @@ static int read8(struct tracecmd_input *handle, unsigned long long *size)
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
+		sec->id = id;
+	}
+
+	if (section_offset)
+		sec->section_offset = section_offset;
+	if (data_offset)
+		sec->data_offset = data_offset;
+	if (flags >= 0)
+		sec->flags = flags;
+
+	return 0;
+}
+
 static int read_header_files(struct tracecmd_input *handle)
 {
 	struct tep_handle *pevent = handle->pevent;
@@ -3493,6 +3556,7 @@ void tracecmd_ref(struct tracecmd_input *handle)
  */
 void tracecmd_close(struct tracecmd_input *handle)
 {
+	struct file_section *del_sec;
 	int cpu;
 	int i;
 
@@ -3532,6 +3596,12 @@ void tracecmd_close(struct tracecmd_input *handle)
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
@@ -3976,6 +4046,7 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 	new_handle->nr_buffers = 0;
 	new_handle->buffers = NULL;
 	new_handle->version = NULL;
+	new_handle->sections = NULL;
 	new_handle->guest = NULL;
 	new_handle->ref = 1;
 	if (handle->trace_clock) {
-- 
2.34.1

