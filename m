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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4A42C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D14FF61052
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbhG2FKX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233700AbhG2FKX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:23 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5686C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:19 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id qk33so8385909ejc.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VTibhOmDlgGuWwU/En+DQyC3NtThrVKX7g+NNQCZhR0=;
        b=WIZRmCU0qzTK5lLYZLFnUO/ZJea6cWtgzQvW2VTvhFPZY/V9oN+5LBm73vdLYkap95
         NhXpb4IjXdePI340puWCgb6+sX9kLpO7zwGBTKi5lZRD6WPUcVGfkwP3zT0LYMmbweAZ
         9Wsf5JgkQfmzZ3HL2I/EM2B+H9SVw3Z04yP9X5q1Zx1t6Fwh+PTNaef8OOZwfo/vyoRM
         tq0aER2ZDeizTisct7VA4U2OAYCvkwKqZH1aGVQnpWUbX4QgbMI0YfVoh+ieOGgR30WA
         oFNCgOYQh5D3VTBsQxLk2YJWfJRTbRkIkdoDOmbtcYyqqEfJPi2CXMqBxwuRcwEb+CBE
         m2Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VTibhOmDlgGuWwU/En+DQyC3NtThrVKX7g+NNQCZhR0=;
        b=aRxMUk+g8gsVDwxjyw6f5gKF0wgCXF2epFTBiEdEkTkYiB6/MkdQBOadGYcaQOBprR
         YUk2/BLkdgLtJ3WzgEsJZNDD2EoZvfWUViYtXbcOkuMnKTPQvMHOnJluRu9Vawr8eWIN
         sTl87NGFsjjuXehEffoE4cGV4MuvDKiO12WC42AJGCzIA+e77LcXbyX+IiL4hSFmnmMl
         MCN+HuzJ0vyhlWpJEUnTsTsvklFn/BVxLpcdE0ARANaK+NvvttLYSGXrNdzO8b4hZUhA
         ZNrA0Uyrli4gTG6CrEVXJLZ5TynoE0EYL4bEvJbZiG8ANTEepaKhwiz758tdkOZJeF39
         lg0A==
X-Gm-Message-State: AOAM533MAgsKOXIvW1DZ2IhJYOVqAO8Punegrkdg9I+cIsPa1zk4byb/
        CkxkWLN0sTiJ7uQgslfEwME=
X-Google-Smtp-Source: ABdhPJwR/IVhbNI16YDAOqeYm8uCu9qQwhiGD4g0vpGP4lcSu69MC8Xm2rwFcvJHXK1J1nBcN+3Hsw==
X-Received: by 2002:a17:906:1703:: with SMTP id c3mr2927958eje.64.1627535418406;
        Wed, 28 Jul 2021 22:10:18 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:17 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 17/87] trace-cmd library: New API to configure compression on an output handler
Date:   Thu, 29 Jul 2021 08:08:49 +0300
Message-Id: <20210729050959.12263-18-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

New API can be used to configure compression algorithm on a output
handler to a trace file.
 tracecmd_output_set_compression()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  1 +
 lib/trace-cmd/trace-output.c                  | 47 +++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 455ff680..ee224903 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -281,6 +281,7 @@ int tracecmd_output_set_trace_dir(struct tracecmd_output *handler, const char *t
 int tracecmd_output_set_kallsyms(struct tracecmd_output *handler, const char *kallsyms);
 int tracecmd_output_set_from_input(struct tracecmd_output *handler, struct tracecmd_input *ihandle);
 int tracecmd_output_set_version(struct tracecmd_output *handler, int file_version);
+int tracecmd_output_set_compression(struct tracecmd_output *handler, const char *compression);
 int tracecmd_output_write_init(struct tracecmd_output *handler);
 int tracecmd_output_write_headers(struct tracecmd_output *handler,
 				  struct tracecmd_event_list *list);
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 42b193dc..23a10edc 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -219,6 +219,7 @@ void tracecmd_output_free(struct tracecmd_output *handle)
 		free(option);
 	}
 	free(handle->trace_clock);
+	tracecmd_compress_destroy(handle->compress);
 	free(handle);
 }
 
@@ -1127,6 +1128,52 @@ int tracecmd_output_set_version(struct tracecmd_output *handler, int file_versio
 	return 0;
 }
 
+/**
+ * tracecmd_output_set_compression - Set file compression algorithm of the output handler
+ * @handle: output handler to a trace file.
+ * @compression: name of the desired compression algorithm. Can be one of:
+ *		 - "none" - do not use compression
+ *		 - "all" - use the best available compression algorithm
+ *		 - or specific name of the desired compression algorithm
+ *
+ * This API must be called before tracecmd_output_write_init().
+ *
+ * Returns 0 on success, or -1 in case of an error:
+ *   - the output file handler is not allocated or not in expected state.
+ *   - the specified compression algorithm is not available
+ */
+int tracecmd_output_set_compression(struct tracecmd_output *handler, const char *compression)
+{
+	if (!handler || handler->file_state != TRACECMD_FILE_ALLOCATED)
+		return -1;
+
+	handler->compress = NULL;
+	if (compression && strcmp(compression, "none")) {
+		if (!strcmp(compression, "any")) {
+			handler->compress = tracecmd_compress_alloc(NULL, NULL, handler->fd,
+								    handler->pevent,
+								    handler->msg_handle);
+			if (!handler->compress)
+				tracecmd_warning("No compression algorithms are supported");
+		} else {
+			handler->compress = tracecmd_compress_alloc(compression, NULL, handler->fd,
+								    handler->pevent,
+								    handler->msg_handle);
+			if (!handler->compress) {
+				tracecmd_warning("Compression algorithm %s is not supported",
+						  compression);
+				return -1;
+			}
+		}
+	}
+	if (handler->compress && handler->file_version < 7) {
+		handler->file_version = 7;
+		if (handler->msg_handle)
+			tracecmd_msg_handle_cache(handler->msg_handle);
+	}
+
+	return 0;
+}
 
 /**
  * tracecmd_output_write_init - Write the initial magics in the trace file
-- 
2.31.1

