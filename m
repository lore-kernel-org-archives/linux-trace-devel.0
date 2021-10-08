Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A51CFC4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:13:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B26A60F55
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:13:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237325AbhJHEP2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237288AbhJHEP1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:15:27 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B85C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:13:33 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id d3so3832409edp.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HKqSsAljzOi3bpGyyBEOR9QJLA1ahp92JGLNoMGVxq4=;
        b=eqzrgJTTbDCe6xwqbTXdlV0zSAcoOQmD5Szy+GVwJH5GCnjLVRffsULRDZosyY2ypa
         +hndZcIOQUjAe6pCIItK706jfbGqrjfG/XzyKlB3aYb9hemZ1oFLFbtayh840qo/sJMX
         YU5/3k0ua0fig85p+Nx9Sxak3kltHLOCd4T/qBkLTzUxjQwTIionNSg6YPI5WgFdPZ+I
         QhesrNKjLsx3dTUOB3JFXtWhvB9csjfG9QcwmATR0XV0uHDh7CRjq6x8MR0v2/urpc90
         9aFMQhYnTa9P3S0HmWjGHYte34JxBDiruoJB/oCixC9Y2/tfNZyCIRZvQ2Fbbxnb8mHU
         i3Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HKqSsAljzOi3bpGyyBEOR9QJLA1ahp92JGLNoMGVxq4=;
        b=CmoivEwntyMSsVKEZc4f0JWeqJEyaKgfAi2Aldf2Lix0WRQVfA49dUqB4YFSDTdYnj
         jQalT2VaVfPkoubrDZ7QgQ+4D8nTLm+Mob2hTSPfhWogg5ZLAG/Rx/WOR96JfE/YlHEd
         7iEIsUYnTtG83OI4dJ4Ydztzm/urwL9gdj2sbzILs8zJ1T1AgNJvhkw9FMTjLrBj5m8z
         80fLHHdZjPDIFNYwu3Q5lxfWNmwtaeKTvdvmZEJ4cHmM4Rbx6r+gYjUBMSVpPbXXszBR
         0ehXqbvfYBICxZwrZP96LdqPAxhuqkZMsYn19HDjUBBkuf62QeEg1qzXlz7/3Kzp8Z08
         LLzQ==
X-Gm-Message-State: AOAM532WEkB7eaThig91DCsda3BkhqEwXBYbQT0JJKtC8b4Zst0o4N5B
        Ip4FESnZ0VMA0uDTmhz3JOKDpg0UEYECoA==
X-Google-Smtp-Source: ABdhPJxGg15VMxo6hlbiC9FhdZkJ3d4PKeZe6Crjizl5/nejwAf8ilbeFcuUTMfgqsuPmB/axMa16g==
X-Received: by 2002:a17:906:2cd5:: with SMTP id r21mr1237023ejr.435.1633666411719;
        Thu, 07 Oct 2021 21:13:31 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id lb12sm465740ejc.28.2021.10.07.21.13.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:13:31 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 08/10] trace-cmd library: Use the new flow when creating output handler
Date:   Fri,  8 Oct 2021 07:13:19 +0300
Message-Id: <20211008041321.973755-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041321.973755-1-tz.stoyanov@gmail.com>
References: <20211008041321.973755-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The trace-cmd library APIs, that create a new output handler to a trace
file, are converted to use the newly introduced APIs. Affected are:
 tracecmd_create_file_latency()
 tracecmd_create_init_fd()
 tracecmd_create_init_file()
 tracecmd_copy()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 54 ++++++++++++++++++++++++++++++++----
 1 file changed, 48 insertions(+), 6 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index f8a16d82..9ea85b1c 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1503,11 +1503,19 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 {
 	struct tracecmd_output *handle;
 	char *path;
+	int fd;
 
-	handle = create_file(output_file, NULL, NULL, NULL, &all_event_list);
-	if (!handle)
+	fd = open(output_file, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
+	if (fd < 0)
 		return NULL;
 
+	handle = tracecmd_output_allocate(fd);
+	if (!handle)
+		goto out_free;
+	if (tracecmd_output_write_init(handle))
+		goto out_free;
+	if (tracecmd_output_write_headers(handle, NULL))
+		goto out_free;
 	/*
 	 * Save the command lines;
 	 */
@@ -1801,7 +1809,20 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 
 struct tracecmd_output *tracecmd_create_init_fd(int fd)
 {
-	return create_file_fd(fd, NULL, NULL, NULL, &all_event_list, NULL);
+	struct tracecmd_output *out;
+
+	out = tracecmd_output_allocate(fd);
+	if (!out)
+		return NULL;
+	if (tracecmd_output_write_init(out))
+		goto error;
+	if (tracecmd_output_write_headers(out, NULL))
+		goto error;
+
+	return out;
+error:
+	tracecmd_output_close(out);
+	return NULL;
 }
 
 struct tracecmd_output *
@@ -1826,7 +1847,20 @@ tracecmd_create_init_file_glob(const char *output_file,
 
 struct tracecmd_output *tracecmd_create_init_file(const char *output_file)
 {
-	return create_file(output_file, NULL, NULL, NULL, &all_event_list);
+	struct tracecmd_output *handle;
+	int fd;
+
+	fd = open(output_file, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
+	if (fd < 0)
+		return NULL;
+	handle = tracecmd_create_init_fd(fd);
+	if (!handle) {
+		close(fd);
+		unlink(output_file);
+		return NULL;
+	}
+
+	return handle;
 }
 
 struct tracecmd_output *tracecmd_create_init_file_override(const char *output_file,
@@ -1849,11 +1883,19 @@ struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle,
 				      const char *file)
 {
 	struct tracecmd_output *handle;
+	int fd;
 
-	handle = create_file(file, ihandle, NULL, NULL, &all_event_list);
-	if (!handle)
+	fd = open(file, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
+	if (fd < 0)
 		return NULL;
 
+	handle = tracecmd_output_allocate(fd);
+	if (!handle)
+		goto out_free;
+	if (tracecmd_output_set_from_input(handle, ihandle))
+		goto out_free;
+	tracecmd_output_write_init(handle);
+
 	if (tracecmd_copy_headers(ihandle, handle->fd, 0, 0) < 0)
 		goto out_free;
 
-- 
2.31.1

