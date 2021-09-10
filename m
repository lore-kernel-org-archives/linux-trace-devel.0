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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E123C4321E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E8C6611CB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233565AbhIJNwc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233777AbhIJNw3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:52:29 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4FE1C061764
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:17 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id eb14so2580577edb.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vo4X3RVVkqJEesjdbAvxSbmsz+lS8XQzw2rOXV/r4J0=;
        b=dQwt8pxg1pWVzsPwiWXnV4ZibTtw0lcF5FdoxIV4yFy45ZqGPVY0rKmL6T3+GZotd7
         L08ZJvp9uur6Lq99HDFZdn9xXcaf42JBW2YT1YXTqvtg1laow7/yZIiYtTeNLW9CmYgL
         L62mu9WIHFowR0pXVau14EcRyr+XcVgXQKuFcmHgWzzMsq2SjK3dqoClRU/CjlGz61Ld
         JM9Dy8GObuOINu4JnDmByChRFfb9WKBMjwdDJkRO2UJhadM3fc0ijQBTaIHF1zyB/f2M
         8hVHB5g6mOhP9DdalmqX+bCPXpCKqXZH2/Rq2ilKmy7Rj4srONnqehw5jBwPii08hULh
         Yn0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vo4X3RVVkqJEesjdbAvxSbmsz+lS8XQzw2rOXV/r4J0=;
        b=ZS8/tOYNQj9sb5ks+SQeBU1XUPKdn4pbxi5i5F6/PYOaYU5gFfrki+CIC1KxYczYj9
         D2mkFYqqdVsFbM5chGoAKbSvbjOLdbQyC8snj4JUtNMBQt0pspNW1YuTIB7oRR9FA5/O
         9MjGbKp1ErqbKbtrrNRQJzIB+pYRC0oFclLHIvVGc9ayhhQokXGMMt1a3K7FxnqpQNs8
         BG7I02I6nAXe697rn9TdSDbS6lQwo7c3BtMbthRAFq8A8+y+j6YtvePHUPCzd3Zf0pdR
         L9+qsSeGRkj3NuVCYpknx++yhcZ5ClyIJKX5NJwzPHjiLPgS0Y+AC9uzaFZVa0TWeqRC
         gC6w==
X-Gm-Message-State: AOAM531r6egCrN/+KddQhknRmdSLSI6zE/kGZraDzP0wT9OnvYuXa+F4
        /jKbJuFLrffEfyD8/aX8ppewe85oaQc=
X-Google-Smtp-Source: ABdhPJzAadGhBgVDK2SgAd7RWiyVsXuq8o6JOlGfyfS4r6t3e05kZcLhn9MVIKBScfiANzUlfzL/Qw==
X-Received: by 2002:a50:bb0d:: with SMTP id y13mr9153609ede.315.1631281876486;
        Fri, 10 Sep 2021 06:51:16 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w13sm2484683ejc.100.2021.09.10.06.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:51:16 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 14/25] trace-cmd library: Introduce sections in trace file reading logic
Date:   Fri, 10 Sep 2021 16:50:50 +0300
Message-Id: <20210910135101.2865226-15-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
References: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
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
index edb5ddb2..dfbd2d36 100644
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
@@ -3510,6 +3571,7 @@ void tracecmd_ref(struct tracecmd_input *handle)
  */
 void tracecmd_close(struct tracecmd_input *handle)
 {
+	struct file_section *del_sec;
 	int cpu;
 	int i;
 
@@ -3549,6 +3611,12 @@ void tracecmd_close(struct tracecmd_input *handle)
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
@@ -3993,6 +4061,7 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 	new_handle->nr_buffers = 0;
 	new_handle->buffers = NULL;
 	new_handle->version = NULL;
+	new_handle->sections = NULL;
 	new_handle->guest = NULL;
 	new_handle->ref = 1;
 	if (handle->trace_clock) {
-- 
2.31.1

