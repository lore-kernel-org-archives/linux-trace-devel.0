Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2BB2C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:08:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B560461252
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233820AbhKKPK7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:10:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233191AbhKKPK7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:10:59 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D64E2C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:08:09 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id c8so25025309ede.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:08:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bOvASMiHnoTgV/RV4y7rZXaI1AIEHyKAUsVohjEHmGw=;
        b=a8Did8/8ZvDFzbIV33/Oi6MpbbPdDRJZS7ISQopndYQ1kpPAeAicyUfScg0yL8GE29
         3J8YpdiKbtpO/1cyOwdYFrUO4Ay/GzJPtIcYkNpxQ74Y0ciCKJf0aBttc4RLc8yRGbsN
         EvcpoD5fyxIpv5yspZ43R1axqboWaqoPe/FBA1D1uXWMH4VBdpf76Fc8RnJEOIPjajUo
         AeQL/NCpKBxwFh4lk+0J0FWsHR/Zvd2oIXnd/+7vw0Pa9cobbrMWoL2cS05UWvXNWmHc
         zJrOBdTBwD5Ajy2wAPwiXAXJJxvMvk6F3JOkUdlBoZmfwkHi6cs6nlFCEttRaOFQBVat
         NEew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bOvASMiHnoTgV/RV4y7rZXaI1AIEHyKAUsVohjEHmGw=;
        b=oo+ny9Vf6DxntV9YtoWSczv/3VH0+T0mA9eiP1oQrULYU9PhtmvBU4lKo5f1m4GRl/
         icQN6vKCttN8/ZC29Rdpb0BrmtVk5c2TW9YX1x99kf2+xxUIUYyNP1HasubkxneMKqKe
         lRH4tH3vBul7FaC07ALRZTCK/QBGnKlYUmjAmJmx16ou/NzGKyHs79KAklSkLePIA+/T
         RsUJBTY/usOI00wmhgjO+TTrXOB2ELC07N9JmnNSHPjzztJOc1H2uR7bgX80xt7pwzR0
         AqsDvJO9OFyZhZ9DXDrp52IvJpcC2U4K8hizqhJl7LnTEvdPQlMwMsAq8jnGvn2Pk7wz
         AIZw==
X-Gm-Message-State: AOAM531MrXA/wybjjw2IAZf/OK41VpDnDSKb+JzhfVG2/BT+FGWXtuVI
        vlutYa8vIBf4V3bQ2j6L3kQ71sBdW4Os+w==
X-Google-Smtp-Source: ABdhPJyrWAlt6LCuGN06AAOXIaLTLsBhAhusxzHjmjfpwPtMQeP1L+MWpmpPo3oz1iVLsCcKk+0G8A==
X-Received: by 2002:a17:906:4452:: with SMTP id i18mr10017303ejp.374.1636643288430;
        Thu, 11 Nov 2021 07:08:08 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y15sm1869027eda.35.2021.11.11.07.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:08:07 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 1/4] trace-cmd library: Add internal database for trace buffers
Date:   Thu, 11 Nov 2021 17:08:02 +0200
Message-Id: <20211111150805.86419-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111150805.86419-1-tz.stoyanov@gmail.com>
References: <20211111150805.86419-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new list with trace buffers information is added in the output
handler, and internal APIs to work with that list. Storing various trace
buffers information in the handler hides the complexity of this
logic inside the library and simplifies possible extensions in the
future.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  2 +
 lib/trace-cmd/trace-output.c                  | 58 ++++++++++++++++++-
 2 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index fb050671..c0a07045 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -292,6 +292,8 @@ tracecmd_add_option_v(struct tracecmd_output *handle,
 
 struct tracecmd_option *tracecmd_add_buffer_option(struct tracecmd_output *handle,
 						   const char *name, int cpus);
+int tracecmd_add_buffer_info(struct tracecmd_output *handle, const char *name, int cpus);
+int tracecmd_write_buffer_info(struct tracecmd_output *handle);
 
 int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus);
 int tracecmd_write_cmdlines(struct tracecmd_output *handle);
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 27f296dd..f0f6aeed 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -39,6 +39,14 @@ struct tracecmd_option {
 	struct list_head list;
 };
 
+struct tracecmd_buffer {
+	int				cpus;
+	void				*name;
+	tsize_t				offset;
+	struct tracecmd_option		*option;
+	struct list_head		list;
+};
+
 enum {
 	OUTPUT_FL_SEND_META	= (1 << 0),
 };
@@ -58,6 +66,7 @@ struct tracecmd_output {
 	bool			big_endian;
 
 	struct list_head	options;
+	struct list_head	buffers;
 	struct tracecmd_msg_handle *msg_handle;
 	char			*trace_clock;
 };
@@ -140,6 +149,7 @@ bool tracecmd_get_quiet(struct tracecmd_output *handle)
 void tracecmd_output_free(struct tracecmd_output *handle)
 {
 	struct tracecmd_option *option;
+	struct tracecmd_buffer *buffer;
 
 	if (!handle)
 		return;
@@ -150,6 +160,13 @@ void tracecmd_output_free(struct tracecmd_output *handle)
 	if (handle->pevent)
 		tep_unref(handle->pevent);
 
+	while (!list_empty(&handle->buffers)) {
+		buffer = container_of(handle->buffers.next,
+				      struct tracecmd_buffer, list);
+		list_del(&buffer->list);
+		free(buffer->name);
+		free(buffer);
+	}
 	while (!list_empty(&handle->options)) {
 		option = container_of(handle->options.next,
 				      struct tracecmd_option, list);
@@ -157,6 +174,7 @@ void tracecmd_output_free(struct tracecmd_output *handle)
 		free(option->data);
 		free(option);
 	}
+
 	free(handle->trace_clock);
 	free(handle);
 }
@@ -907,6 +925,7 @@ struct tracecmd_output *tracecmd_output_allocate(int fd)
 	handle->big_endian = tracecmd_host_bigendian();
 
 	list_head_init(&handle->options);
+	list_head_init(&handle->buffers);
 
 	handle->file_state = TRACECMD_FILE_ALLOCATED;
 
@@ -1323,7 +1342,7 @@ tracecmd_add_buffer_option(struct tracecmd_output *handle, const char *name,
 	char *buf;
 	int size = 8 + strlen(name) + 1;
 
-	buf = malloc(size);
+	buf = calloc(1, size);
 	if (!buf) {
 		tracecmd_warning("Failed to malloc buffer");
 		return NULL;
@@ -1345,6 +1364,38 @@ tracecmd_add_buffer_option(struct tracecmd_output *handle, const char *name,
 	return option;
 }
 
+int tracecmd_add_buffer_info(struct tracecmd_output *handle, const char *name, int cpus)
+{
+	struct tracecmd_buffer *buf;
+
+	buf = calloc(1, sizeof(struct tracecmd_buffer));
+	if (!buf)
+		return -1;
+	buf->name = strdup(name);
+	buf->cpus = cpus;
+	if (!buf->name) {
+		free(buf);
+		return -1;
+	}
+	list_add_tail(&buf->list, &handle->buffers);
+	return 0;
+}
+
+int tracecmd_write_buffer_info(struct tracecmd_output *handle)
+{
+	struct tracecmd_option *option;
+	struct tracecmd_buffer *buf;
+
+	list_for_each_entry(buf, &handle->buffers, list) {
+		option = tracecmd_add_buffer_option(handle, buf->name, buf->cpus);
+		if (!option)
+			return -1;
+		buf->option = option;
+	}
+
+	return 0;
+}
+
 int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 {
 	int ret;
@@ -1580,7 +1631,9 @@ int tracecmd_append_cpu_data(struct tracecmd_output *handle,
 	ret = tracecmd_write_cpus(handle, cpus);
 	if (ret)
 		return ret;
-
+	ret = tracecmd_write_buffer_info(handle);
+	if (ret)
+		return ret;
 	ret = tracecmd_write_options(handle);
 	if (ret)
 		return ret;
@@ -1658,6 +1711,7 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	handle->file_version = tracecmd_get_in_file_version(ihandle);
 	handle->options_start = tracecmd_get_options_offset(ihandle);
 	list_head_init(&handle->options);
+	list_head_init(&handle->buffers);
 
 	tracecmd_close(ihandle);
 
-- 
2.33.1

