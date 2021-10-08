Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC0ADC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7BA3610CE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237473AbhJHEWL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbhJHEWL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:22:11 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7734BC061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:20:16 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id z20so30914310edc.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gWbpeXK7bysmi+g2vTaY2h/psM+Hyqt8Bo0DpqpORZ8=;
        b=QCXnsw3gJNgMOYaSlkoxz5t3NYKiyvVxDdUL3UAVnk7xMaJ5Jub19uyugX0nP4RdH0
         2o9jpjQMd8Vr/2qqfVIx1+fVyE/3cGtXx82ulI7RZUkhA5f5FxM5KBO3NG+zTr0KzMNd
         hNi54NXVqOnvieigf1vSOto7Pb6i0Qrppb1IINThAZweVFT/W026CwCpzEpCs1szKzR9
         QzMyjQhoamo8XM3ukjV7gErd2t0h3k/Cvk80/LqN01aQqLxrt4EAJu93sPud72NDw28t
         3FW5RSjzGtsIud1ShXEqJFOGmQIn9IUcqRZVtsNtlLCC/Lk/yiu7+C0jXO/DMqBBTwdN
         aPoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gWbpeXK7bysmi+g2vTaY2h/psM+Hyqt8Bo0DpqpORZ8=;
        b=aCsU67RIEIETXlz+0f0o40TYDTy+Vfj+aURPk/nfRjGrmTVqBf0NyYxsdgJ2ws9hUB
         opzUK3zFjSzMqFZTFU5BFJTBJZ2sJKpI0TBdvUJe31UpCgzM/en/sEQEmgzavHmlmmls
         gv59roK+3r/AjGOYOdTvYkZz6aGbWh7jo1Bjh4+g4b1GpBd/MLJ+xsZCiE71K6r+GtqU
         n1UPnCs38IyEuL24iVpKxqFk/ojPKoOtn53JtENZEX50vymbw4mlFHyRX39UN8lDEKEd
         ZmK8ttRC9GF+HHY4oEq+zD/PHBvnGRV3X3krtKOHclyFY6enZRWhEOhKpMoe1Eh7J/lX
         JJVg==
X-Gm-Message-State: AOAM530TSFQyk0WkuT+G7g3IoW2bcd7MDWiTMi9csvDITpHoSXev90Ne
        ZVWdjMAKbdAMFH9cUBYPumFSmeWo1IRJ/w==
X-Google-Smtp-Source: ABdhPJwLJwzKaWLR23HU5bprYNAGriDEf4eUHw6NdW/V5SnqUjG5NE38DfPnZLnvrTpWURuhHOJ6Ww==
X-Received: by 2002:a05:6402:34d2:: with SMTP id w18mr4796250edc.172.1633666815061;
        Thu, 07 Oct 2021 21:20:15 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p6sm511669edi.18.2021.10.07.21.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:20:14 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 14/25] trace-cmd library: Introduce sections in trace file reading logic
Date:   Fri,  8 Oct 2021 07:19:47 +0300
Message-Id: <20211008041958.976309-15-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041958.976309-1-tz.stoyanov@gmail.com>
References: <20211008041958.976309-1-tz.stoyanov@gmail.com>
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
index e7e86c14..45b4eeeb 100644
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
@@ -3494,6 +3555,7 @@ void tracecmd_ref(struct tracecmd_input *handle)
  */
 void tracecmd_close(struct tracecmd_input *handle)
 {
+	struct file_section *del_sec;
 	int cpu;
 	int i;
 
@@ -3533,6 +3595,12 @@ void tracecmd_close(struct tracecmd_input *handle)
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
@@ -3977,6 +4045,7 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 	new_handle->nr_buffers = 0;
 	new_handle->buffers = NULL;
 	new_handle->version = NULL;
+	new_handle->sections = NULL;
 	new_handle->guest = NULL;
 	new_handle->ref = 1;
 	if (handle->trace_clock) {
-- 
2.31.1

