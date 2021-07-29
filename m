Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79448C432BE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 645FC60FED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233967AbhG2FKk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233782AbhG2FKj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:39 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329E5C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:36 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id ga41so8408635ejc.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HiWFfARCbjGXEgSBoVkvTrq3/2OvWG8ajOxD5h3Vzy0=;
        b=A/TUX5zpYpuf0Nv7xERJPiBTd2UPtV3o+RuX2xICLX9eXPwUuOLHQ/eBNDHegqvhXv
         qkqvdnIBnca5KlSC7+4nn8Qg9+Kvtj6fmTOTr13v7UhJPjVRHQ1RtpENXbHZ7LxU3RDU
         r5jDRFEXo0AE8WUp3YkL99+Zls+bfL7S8mAN/rJAGCSbwm13ZrFFi7ZLfheWoB1XqJje
         UOWymShQfve30notDGdYK3dzFe58xUUi9whE3GhCliwTf5PFfYKonf5onakASLpGSYQT
         wBBvhh1hdv18HnG5wYSuiKhhzYlxsANY0Q+9XsMdJxrDAvSeQQv2h+8RGEL7hgXPcSvO
         eapg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HiWFfARCbjGXEgSBoVkvTrq3/2OvWG8ajOxD5h3Vzy0=;
        b=jF8yisSu5FrP0wxcpGOMO4ZzBIXN3XclGWHaNSj3KIvKcadhvgiubzruXb9CA3uG+p
         sUQWy0a+f0sG/9ahhCUToYZtePXdjZdatRcptE61lmJpO0+CCN0FgZzdTTFvr/t3598m
         /ktTycQXHVGLDV+zjgcOV2UztaxNsG4x49qdycUth4X51lF5l1QCfH8DxdAKr8nQIWdI
         fXFlGCDcp1luzPqjIhU/B+ub1nwdv1DH8DXberiDWI/JKncQM3Hu9A+bl0FKN8nygEBC
         1JSGcrTGIdVurDTa0koBaNDrgD0eTNbJw6g6nHrAuZdUWyPuG6XEdv9cduFRKxxltuO0
         Lmqg==
X-Gm-Message-State: AOAM5321s8rqi5wN6X3v+psRhU25Z9NoNFotuDDbF6p79810ZRVryuL0
        MCYSFIcTezSlTy7wTaRSXfLLntEBszAexA==
X-Google-Smtp-Source: ABdhPJxr+NOsGQ8Ssb6lth0NhPKXO4ojRfgFB54kAB0g0TyDhhDcJGg64RKzSLRT1/Xm6tjDy7oLJg==
X-Received: by 2002:a17:906:a445:: with SMTP id cb5mr2999165ejb.320.1627535434861;
        Wed, 28 Jul 2021 22:10:34 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:34 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 34/87] trace-cmd library: Introduce sections in trace file reading logic
Date:   Thu, 29 Jul 2021 08:09:06 +0300
Message-Id: <20210729050959.12263-35-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
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
index 6872f6ef..e8eefb5c 100644
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
@@ -154,6 +162,7 @@ struct tracecmd_input {
 	struct hook_list	*hooks;
 	struct pid_addr_maps	*pid_maps;
 	/* file information */
+	struct file_section	*sections;
 	size_t			header_files_start;
 	size_t			ftrace_files_start;
 	size_t			event_files_start;
@@ -411,6 +420,61 @@ __hidden int in_uncompress_block(struct tracecmd_input *handle)
 	return ret;
 }
 
+static struct file_section *get_section(struct tracecmd_input *handle, int id)
+{
+	struct file_section *sec = handle->sections;
+
+	while (sec) {
+		if (sec->id == id)
+			return sec;
+		sec = sec->next;
+	}
+	return NULL;
+}
+
+static struct file_section *open_section(struct tracecmd_input *handle, int id)
+{
+	struct file_section *sec = get_section(handle, id);
+
+	if (!sec)
+		return NULL;
+
+	if (lseek64(handle->fd, sec->data_offset, SEEK_SET) == (off64_t)-1)
+		return NULL;
+	if ((sec->flags & TRACECMD_SEC_FL_COMPRESS) && in_uncompress_block(handle))
+		return NULL;
+	return sec;
+}
+
+static void close_section(struct tracecmd_input *handle, struct file_section *sec)
+{
+	if (sec->flags & TRACECMD_SEC_FL_COMPRESS)
+		in_uncompress_reset(handle);
+}
+
+static int add_section(struct tracecmd_input *handle, int id, int flags,
+		       unsigned long long soffset, unsigned long long doffset)
+{
+	struct file_section *sec = get_section(handle, id);
+
+	if (!sec) {
+		sec = calloc(1, sizeof(struct file_section));
+		if (!sec)
+			return -1;
+		sec->next = handle->sections;
+		handle->sections = sec;
+	}
+	sec->id = id;
+	if (soffset)
+		sec->section_offset = soffset;
+	if (doffset)
+		sec->data_offset = doffset;
+	if (flags > 0)
+		sec->flags = flags;
+	return 0;
+}
+
+
 static int read_header_files(struct tracecmd_input *handle)
 {
 	struct tep_handle *pevent = handle->pevent;
@@ -3522,6 +3586,7 @@ void tracecmd_ref(struct tracecmd_input *handle)
  */
 void tracecmd_close(struct tracecmd_input *handle)
 {
+	struct file_section *del_sec;
 	int i;
 
 	if (!handle)
@@ -3560,6 +3625,11 @@ void tracecmd_close(struct tracecmd_input *handle)
 	free(handle->version);
 	close(handle->fd);
 
+	while (handle->sections) {
+		del_sec = handle->sections;
+		handle->sections = handle->sections->next;
+		free(del_sec);
+	}
 	for (i = 0; i < handle->nr_buffers; i++)
 		free(handle->buffers[i].name);
 
@@ -4006,6 +4076,7 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 	new_handle->nr_buffers = 0;
 	new_handle->buffers = NULL;
 	new_handle->version = NULL;
+	new_handle->sections = NULL;
 	new_handle->guest = NULL;
 	new_handle->ref = 1;
 	if (handle->trace_clock) {
-- 
2.31.1

