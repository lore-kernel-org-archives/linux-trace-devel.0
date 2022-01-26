Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BF5EC63682
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239356AbiAZJtS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:49:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbiAZJtR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:49:17 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54A4C061744
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:16 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id w14so15182033edd.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=psw5w2Wwu/1u1m2FQq4EcV6QWZRBjZE93r/4r0H09h8=;
        b=MCpn185VpzFWcSbH4m8jWavxpGL5Kn6pp/vg5GvzA3+M+w4NVjtuK9hhdIpdu/kqlt
         dJkcrUz2ElGQYNQSAymT0B/8vHrcAZll7S2QM01DDik7mhzVzW9XKsNSQPli+2N7j5Aa
         tRM/bUP06pOfGEfg3i5QfLtbUJ6Jq03EdlRsAmnRI3hg9FK9Pu9eNBE1uW4AYWxx4F8s
         Li6Yw2UC9Nwls0/+asQTT/MDU9lyhh3jw2L6mL2QRqZaL9oylv1vvPzZSEzr1pHpLW/H
         gkW+AMX4JoGoN7QsQwmqb0SzvofC+6S37l7J+DwMFso8Vg0qNki8zweEySjJt8NsmjU2
         huMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=psw5w2Wwu/1u1m2FQq4EcV6QWZRBjZE93r/4r0H09h8=;
        b=lU3juXEWuHAKz9znHmN8vD0ASNIrrJYX4/eRWY1w9B6P9zvV23L1cGmstnQrijmh+t
         MX/B2V8Y1OaZB8AQO8XDi3VgiPepkaLvWeqkPvfUJ7oHYGxPS4dBF82pK3P5tWgOCyCx
         05EjZQY3ESXokNcLupbaNTDkQIpR2UVDx5OwIzJOA6zZ5YfMQCEKxbrE4S9ZtG8lXuMz
         izW69QLTvTOvucSJX6nzrYT6cIK2NhzYP3h5r/0Dv7PBWCnj4MS4VpkbRplPpiwKHogA
         5WOmA3un7MF7lOQlQcXtn/tMGiZcm6tfYfnUUiD32Ep9PRiho3/9NA9VnPc5iNuuV8zz
         ow3A==
X-Gm-Message-State: AOAM532RkuF8yuhKgqbuiJGxt5ZhlPjYOM9PAND+C9Z16ISwxtBIfEUD
        dDX20Nk2tgX8tKs1sBg+Jl8wAJphYk4=
X-Google-Smtp-Source: ABdhPJwGqzA1d+Q7jhpQWO3fxohsjk/rmIPGhhei9znUQfOVtRPuV35EUhziXmOXL1xAiGPoPcCXqg==
X-Received: by 2002:a05:6402:5244:: with SMTP id t4mr8082271edd.42.1643190555417;
        Wed, 26 Jan 2022 01:49:15 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id e17sm7119155eje.218.2022.01.26.01.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:49:14 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 04/20] trace-cmd library: Inherit compression algorithm from input file
Date:   Wed, 26 Jan 2022 11:48:50 +0200
Message-Id: <20220126094906.570451-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126094906.570451-1-tz.stoyanov@gmail.com>
References: <20220126094906.570451-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When a new trace file output handler is allocated, based on given trace
file input handler - use the same compression algorithm.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  2 ++
 lib/trace-cmd/trace-input.c                   | 18 ++++++++++++++++
 lib/trace-cmd/trace-output.c                  | 21 +++++++++++++++++++
 3 files changed, 41 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 0bdb66e5..01c4c7a7 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -261,6 +261,8 @@ tracecmd_get_cursor(struct tracecmd_input *handle, int cpu);
 
 unsigned long tracecmd_get_in_file_version(struct tracecmd_input *handle);
 size_t tracecmd_get_options_offset(struct tracecmd_input *handle);
+int tracecmd_get_file_compress_proto(struct tracecmd_input *handle,
+				     const char **name, const char **version);
 
 int tracecmd_ftrace_overrides(struct tracecmd_input *handle, struct tracecmd_ftrace *finfo);
 bool tracecmd_get_use_trace_clock(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 4b911818..2e75e9ac 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4661,6 +4661,24 @@ unsigned long tracecmd_get_in_file_version(struct tracecmd_input *handle)
 	return handle->file_version;
 }
 
+/**
+ * tracecmd_get_file_compress_proto - get name and version of compression algorithm
+ * @handle: input handle for the trace.dat file
+ * @name: return, name of the compression algorithm.
+ * @version: return, version of the compression algorithm.
+ *
+ * Get the name and the version of the compression algorithm, used to
+ * compress the file associated with @handle.
+ * Returns 0 on success, or -1 in case of an error. If 0 is returned,
+ * the name and version of the algorithm are stored in @name and @version.
+ * The returned strings must *not* be freed.
+ */
+int tracecmd_get_file_compress_proto(struct tracecmd_input *handle,
+				     const char **name, const char **version)
+{
+	return tracecmd_compress_proto_get_name(handle->compress, name, version);
+}
+
 /**
  * tracecmd_get_use_trace_clock - return use_trace_clock
  * @handle: input handle for the trace.dat file
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 87481e33..2b511bfc 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1310,6 +1310,9 @@ int tracecmd_output_set_kallsyms(struct tracecmd_output *handle, const char *kal
  */
 int tracecmd_output_set_from_input(struct tracecmd_output *handle, struct tracecmd_input *ihandle)
 {
+	const char *cname = NULL;
+	const char *cver = NULL;
+
 	if (!handle || !ihandle || handle->file_state != TRACECMD_FILE_ALLOCATED)
 		return -1;
 
@@ -1321,6 +1324,16 @@ int tracecmd_output_set_from_input(struct tracecmd_output *handle, struct tracec
 	handle->file_version = tracecmd_get_in_file_version(ihandle);
 	handle->big_endian = tep_is_file_bigendian(handle->pevent);
 
+	if (!tracecmd_get_file_compress_proto(ihandle, &cname, &cver)) {
+		handle->compress = tracecmd_compress_alloc(cname, cver, handle->fd,
+							    handle->pevent, handle->msg_handle);
+		if (!handle->compress)
+			return -1;
+
+		if (handle->file_version < FILE_VERSION_COMPRESSION)
+			handle->file_version = FILE_VERSION_COMPRESSION;
+	}
+
 	return 0;
 }
 
@@ -2281,6 +2294,8 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 {
 	struct tracecmd_output *handle = NULL;
 	struct tracecmd_input *ihandle;
+	const char *cname = NULL;
+	const char *cver = NULL;
 	int fd2;
 
 	/* Move the file descriptor to the beginning */
@@ -2321,6 +2336,12 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	list_head_init(&handle->options);
 	list_head_init(&handle->buffers);
 
+	if (!tracecmd_get_file_compress_proto(ihandle, &cname, &cver)) {
+		handle->compress = tracecmd_compress_alloc(cname, cver, handle->fd,
+							   handle->pevent, handle->msg_handle);
+		if (!handle->compress)
+			goto out_free;
+	}
 	tracecmd_close(ihandle);
 
 	return handle;
-- 
2.34.1

