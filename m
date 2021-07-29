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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D69CC432BE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5694E61054
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233946AbhG2FKh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233607AbhG2FKg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:36 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64751C0613CF
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:33 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id b7so6430193edu.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eUjZjzWhSkd/cQ2BtYyOOQVWHRzI2U8AQq9A6uGfW30=;
        b=UR7KMBF3ZtPOPkk7+wcXurLSgP849Mnf6Z5ulLAno6bpo3tQ9m9MK7Yy2nNELOsdWi
         j22Qab3WbXT3Lg7A/w6LFvout3jHpr9mSwQWPYct4qe48lv98NYw1YzawkO3konA3OwI
         KhnYn1zKGOEp+6Mksq1skThvBEqCpgpoM5UPiQA9rrHVe2YXT9qIpC3mKM7BEXwXgxlc
         O3htRV9dYv/Zd4vrXnz/DyLeOi+pxGy0bj728r6zfkHxziewNpHY3csXL6lJTAXILrSt
         o+q3eB20ZM/uzEMerzq+h6gHLdgxxxW4JOew8zoLHNJRnppkmBjAdUV9fJTaZ2Zzk9K/
         3/Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eUjZjzWhSkd/cQ2BtYyOOQVWHRzI2U8AQq9A6uGfW30=;
        b=TzExf81y6KcyVMeiBnJjliCaQevkOQzdbZ08DHzXpdoMAp4UdJk8ehqFZxOem6G2rj
         WT7PVBD3HIzyJib7+AuTvlu17I8Og7Vau0ZKhHKZsvjxzDhzIISpGBfggA9QIhN+fb85
         H4SVPRFUBf5SSYuGwF3bP0ktNJ4q8GQwNzoRDzf6ui/ImeAY8gxGBKopdJFirDGuIE1c
         WRjr1Im0+5zMcaoKLuwX9W3i0YImZyev5rYoK1U5oFpR6aGorY5/l7fxplPGTjuIY3ge
         w3PMDqy5jsWAs5D7ra9aspFxJlFaZF5LshQr76ZtOi9jurked5HgWlTGec+mIWIkCXIu
         yi9Q==
X-Gm-Message-State: AOAM531CgnlPixobDM/hBpPK46ep59niXc0sYKpZ8D/b906LNcipU0WV
        xrfrXgRKCJV7go9G5kpIfOs=
X-Google-Smtp-Source: ABdhPJwQPyxiwfPiuOhG4LaKcODFCTe3B2mh7wjN7aJ0MJmP6g2wFVs/odnInRY8RTCTOCw4FW57tg==
X-Received: by 2002:a05:6402:53:: with SMTP id f19mr3943867edu.200.1627535431984;
        Wed, 28 Jul 2021 22:10:31 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:31 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 31/87] trace-cmd library: Fit CPU latency trace data in the new trace file version 7 format
Date:   Thu, 29 Jul 2021 08:09:03 +0300
Message-Id: <20210729050959.12263-32-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace file version 7 format is based on sections. To fit the latency
trace data in this structure, a new section and option for it is
defined:
  BUFFER_LAT
It is similar to the BUFFER section which holds the flyrecord data, but
has a latency specific design. The BUFFER_LAT section has:
 - section header, as all other sections
 - compression of the trace data, optional
 - corresponding trace option, pointing to the section

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  3 +-
 lib/trace-cmd/trace-output.c                  | 36 ++++++++++++++++---
 tracecmd/trace-record.c                       |  2 +-
 3 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 4e718c40..f2868576 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -135,6 +135,7 @@ enum {
 	TRACECMD_OPTION_TIME_SHIFT,
 	TRACECMD_OPTION_GUEST,
 	TRACECMD_OPTION_TSC2NSEC,
+	TRACECMD_OPTION_BUFFER_LAT,
 	TRACECMD_OPTION_HEADER_INFO,
 	TRACECMD_OPTION_FTRACE_EVENTS,
 	TRACECMD_OPTION_EVENT_FORMATS,
@@ -294,7 +295,7 @@ int tracecmd_output_write_headers(struct tracecmd_output *handler,
 				  struct tracecmd_event_list *list);
 
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus,
-						     int file_version);
+						     int file_version, const char *compression);
 struct tracecmd_output *tracecmd_create_init_fd(int fd);
 
 struct tracecmd_output *tracecmd_create_init_file(const char *output_file);
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 30a6acf4..83c3b9e7 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2034,9 +2034,11 @@ out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
 }
 
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus,
-						     int file_version)
+						     int file_version, const char *compression)
 {
+	enum tracecmd_section_flags flags = 0;
 	struct tracecmd_output *handle;
+	tsize_t offset;
 	char *path;
 	int fd;
 
@@ -2049,6 +2051,12 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 		goto out_free;
 	if (file_version && tracecmd_output_set_version(handle, file_version))
 		goto out_free;
+	if (compression) {
+		if (tracecmd_output_set_compression(handle, compression))
+			goto out_free;
+	} else if (file_version >= 7) {
+		tracecmd_output_set_compression(handle, "any");
+	}
 	if (tracecmd_output_write_init(handle))
 		goto out_free;
 	if (tracecmd_output_write_headers(handle, NULL))
@@ -2061,7 +2069,8 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 
 	if (tracecmd_write_cpus(handle, cpus) < 0)
 		goto out_free;
-
+	if (tracecmd_write_buffer_info(handle) < 0)
+		goto out_free;
 	if (tracecmd_write_options(handle) < 0)
 		goto out_free;
 
@@ -2071,23 +2080,42 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 		goto out_free;
 	}
 
-	if (do_write_check(handle, "latency  ", 10))
+	if (handle->file_version < 7 && do_write_check(handle, "latency  ", 10))
 		goto out_free;
 
 	path = get_tracing_file(handle, "trace");
 	if (!path)
 		goto out_free;
 
+	offset = do_lseek(handle, 0, SEEK_CUR);
+	if (handle->file_version >= 7 &&
+	    !out_add_buffer_option_v7(handle, "", TRACECMD_OPTION_BUFFER_LAT, offset, 0, NULL))
+		goto out_free;
+	if (handle->compress)
+		flags |= TRACECMD_SEC_FL_COMPRESS;
+
+	offset = out_write_section_header(handle, TRACECMD_OPTION_BUFFER_LAT,
+					  "buffer latency", flags, false);
+
 	copy_file_compress(handle, path, NULL);
+	if (out_update_section_header(handle, offset))
+		goto out_free;
 
 	put_tracing_file(path);
 
 	handle->file_state = TRACECMD_FILE_CPU_LATENCY;
 
+	if (tracecmd_get_out_file_version(handle) >= 7)
+		tracecmd_write_options(handle);
+
 	return handle;
 
 out_free:
-	tracecmd_output_close(handle);
+	if (handle)
+		tracecmd_output_close(handle);
+	else
+		close(fd);
+	unlink(output_file);
 	return NULL;
 }
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index f8c1c090..2e8db8a4 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4531,7 +4531,7 @@ static void record_data(struct common_record_context *ctx)
 
 	if (latency) {
 		handle = tracecmd_create_file_latency(ctx->output, local_cpu_count,
-						      ctx->file_version);
+						      ctx->file_version, ctx->compression);
 		tracecmd_set_quiet(handle, quiet);
 	} else {
 		if (!local_cpu_count)
-- 
2.31.1

