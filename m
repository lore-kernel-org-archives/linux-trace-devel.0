Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD37C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:13:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7669A60F6E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237133AbhJHEPV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbhJHEPU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:15:20 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697A7C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:13:25 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id d3so3831600edp.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+vzs8CFP8MRdUsZf0wYt3y8jinycwtDdu6GHRKFah8Y=;
        b=VUYBCbEs91VmeEHwym5klOiFjQZt5npIwLZorjpOtUMIYcjg21WEhqmJCVF1oOHYrm
         LwFGf8dV6OS81UKrkKdL59vRYCa27sV4AhqGmOxR2JCgwHGod/mNhMSfXjiuHCTUndSC
         ++mGXXNSwmA/xCLpjQU9+uCL+zI99BHsepVM+VRQJSpYtnJL9rOhXj/Rtk120ZJCH9MH
         VQ3PnBHVMpbTgV8kf6mauPsaJwCsXQL7UgNd5UIVBU3eE9LdSJCMwR60mrarbG+/pWpn
         RCrajUipLbbHxM87yqllZhafUT2wm/uNHDo4p20CYk1Tox3Khv4hnEx/662V3afPNDSn
         bVwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+vzs8CFP8MRdUsZf0wYt3y8jinycwtDdu6GHRKFah8Y=;
        b=LOHQvMPnYdJLE2T4YCMNIrLzmR4JfZaZ05vs3Z1Bg4muwdq+2sWM4ggYBJGe0Wu8sY
         1GLoKlRqLwCQhYFOg/jL6nJ2Q5DCIyzqsAeymHL71TaOFTiDt8IfJS+7dlbbsIjauKSG
         YMLvYEYSeo8VSTaeSmWCbwHmkZQ9fUUcIvyv08a5TNYKKe9SQKHO/1N+IehlZf5ZmEaE
         6QKHsIkORqTcdFT8uWddCFa4D0RwkDD8kLEQWI6YGEfz6w+oBW8Pjc3WJ0+oTWO7Iobu
         mth87c//8umcPDZAyo14Fv41+YlLICCjMe8GqKKD9YcOR+oE0G25Gu/09M4Q5wHRX9kh
         GCUw==
X-Gm-Message-State: AOAM532iW9lgFlOf4+TijhvPsIIBpub7LmM0tJx/76ZdGCfxoeMhFLdd
        0AJrJExUPKrKMI0CoZ5/iAu0mjm++D5l5Q==
X-Google-Smtp-Source: ABdhPJxWMaL6fkDsjPEnhpN3GEDcRZjhzcv8U9oQBjEtProYlvw3xroux7zHu6EcbIXj6GWvVVrEFg==
X-Received: by 2002:a50:bf0f:: with SMTP id f15mr11630337edk.43.1633666404080;
        Thu, 07 Oct 2021 21:13:24 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id lb12sm465740ejc.28.2021.10.07.21.13.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:13:23 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 01/10] trace-cmd library: New API for allocating an output handler
Date:   Fri,  8 Oct 2021 07:13:12 +0300
Message-Id: <20211008041321.973755-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041321.973755-1-tz.stoyanov@gmail.com>
References: <20211008041321.973755-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The API only allocates a handler and performs minimal initialization.
No data is written in the file.
  tracecmd_output_allocate()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  4 ++-
 lib/trace-cmd/trace-output.c                  | 36 +++++++++++++++++++
 2 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index c58b09e9..b4cee0f6 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -102,7 +102,8 @@ static inline int tracecmd_host_bigendian(void)
 /* --- Opening and Reading the trace.dat file --- */
 
 enum tracecmd_file_states {
-	TRACECMD_FILE_INIT = 1,
+	TRACECMD_FILE_ALLOCATED = 0,
+	TRACECMD_FILE_INIT,
 	TRACECMD_FILE_HEADERS,
 	TRACECMD_FILE_FTRACE_EVENTS,
 	TRACECMD_FILE_ALL_EVENTS,
@@ -268,6 +269,7 @@ struct tracecmd_event_list {
 struct tracecmd_option;
 struct tracecmd_msg_handle;
 
+struct tracecmd_output *tracecmd_output_allocate(int fd);
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus);
 struct tracecmd_output *
 tracecmd_create_init_file_glob(const char *output_file,
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index fe1d1aaa..3878b963 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -59,6 +59,7 @@ struct tracecmd_output {
 	unsigned long		file_state;
 	unsigned long		file_version;
 	size_t			options_start;
+	bool			big_endian;
 
 	struct list_head	options;
 	struct tracecmd_msg_handle *msg_handle;
@@ -883,6 +884,41 @@ out_free:
 	return ret;
 }
 
+/**
+ * tracecmd_output_allocate - allocate new output handler to a trace file
+ * @handle: file descriptor to an empty file, it can be -1 if the handler
+ *	    will not write to a file
+ *
+ * This API only allocates a handler and performs minimal initialization.
+ * No data is written in the file.
+ *
+ * Returns pointer to a newly allocated file descriptor, that can be used
+ * with other library APIs. In case of an error, NULL is returned. The returned
+ * handler must be freed with tracecmd_output_close() or tracecmd_output_free()
+ */
+struct tracecmd_output *tracecmd_output_allocate(int fd)
+{
+	struct tracecmd_output *handle;
+
+	handle = calloc(1, sizeof(*handle));
+	if (!handle)
+		return NULL;
+
+	handle->fd = fd;
+
+	handle->file_version = FILE_VERSION;
+
+	handle->page_size = getpagesize();
+	handle->big_endian = tracecmd_host_bigendian();
+
+	list_head_init(&handle->options);
+
+	handle->file_state = TRACECMD_FILE_ALLOCATED;
+
+	return handle;
+}
+
+
 static int select_file_version(struct tracecmd_output *handle,
 				struct tracecmd_input *ihandle)
 {
-- 
2.31.1

