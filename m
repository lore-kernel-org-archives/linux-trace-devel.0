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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52DAAC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:15:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AF01610CE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:15:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbhINNQR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233235AbhINNQQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:16:16 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5943C061760
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:14:58 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id w29so19379678wra.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gF9UzrkCpbQGU+P5Zr9zOkb81SGV9PwzYYl4jv5f5Kc=;
        b=lt6rn01r1294P13wboWE60OLzygdedhdwwlZ/brVnLhbSWy5bvSwexGu3F7Lg2qRLN
         aRgvdbTW6z//lW4QAiDAlpCymzKDiW6rynZufEN4/Q7aurnQUiGFk0OJHKOU15dtR8am
         L+3kgSWRtb+MTKUO+l7TpY8BcS49w9dC11nV8Nffg4CMuCLjUn/kkeGEqSCsAGXT2iS7
         ASLHwRC5Zh38tX13AXfu2sTEucs9lwPZpwiL0lFaEFwFyqtLZ4zlV3k7lf+ZsETvYOUZ
         dWGMQId2EzrpUFjvSZc0Yp9mihPe5ktrTXMHvkCYH2r6CbfZqcb8jaaz8isjpz+lHTW0
         Gw7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gF9UzrkCpbQGU+P5Zr9zOkb81SGV9PwzYYl4jv5f5Kc=;
        b=ODpP78AzvqD8KZFSbKRIo/j841IH8bAiExIbM/NJIj9GOUB29hsQ48lhfAX9QWVyyG
         IRV0U9UnLx05jlIJ3rcv+UxXexkvNjIpG4kqULsFcvi2cNMI5UQh+2dE6EdiW+n8VGHX
         BhVoCrqq9Qdm9bkJLwYWUpftLji3WQ3dHJtyzOqQbeSVIC0P1SZzJXGrZOMpukrWrady
         sm2H8V4ltud33tAaxMwgtYroZ1JHgWclJEddG0u2PULpTo0nK6NCkEqjJ+ruuMNBDg7o
         fddF1TLv5rea1NDm/tXvLSDwtMWCsWh2xrDOqKxz9WevOFBUEiTHX77gD/uKB0NSkQ5U
         gkNw==
X-Gm-Message-State: AOAM532nWCFtffWEJWw8+CuUjUHKUPmheAke3flmNg4Wp+iKZ1w9sW0O
        8129J/phOMXItBhNpv+Yj+N3+UxNm+Q=
X-Google-Smtp-Source: ABdhPJzs5bKVgfR83meNqO1PbQCE/u6jzqLmMsjLg3USbpBkg58jCO6Hcdi07HCqCI4OscU0rIeDyw==
X-Received: by 2002:adf:e108:: with SMTP id t8mr18501430wrz.84.1631625297422;
        Tue, 14 Sep 2021 06:14:57 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y9sm1274760wmj.36.2021.09.14.06.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:14:56 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 14/25] trace-cmd library: Introduce sections in trace file reading logic
Date:   Tue, 14 Sep 2021 16:14:27 +0300
Message-Id: <20210914131438.3965484-15-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
References: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
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

