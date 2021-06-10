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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B37BDC48BE6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 903D6613F1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbhFJLhG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbhFJLhD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:37:03 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C13EC0617A8
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:35:01 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id i94so1917419wri.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GOtu+Wh1wifdgaEDNzuuGtxIZ37pnZ0Ef/YmVURzFrM=;
        b=CO368FZMkGAYMtt4ZKFGjxwxHHzjGuppVPcZlRJgXNXS1Ucq8SkRi5bG9R+cywZadO
         XdcFkg4xtuG926lSqJNBR+HJaH2QJerwH4eY0tNjSSrkYAYYnZ9rPuncQaaHluAfWZVb
         sYIgwmWbkdgBur/I8Vpskk/GwcpHCC0qSCKzDF2LyBUbblvMT2PxKKjEEdcyY044VmbU
         Dv6FU72hO+LOkgqtVGW411TdAIBk9qGkzwLUACxBMGArh5nzpHWqgTaN/rOetIxQy2qn
         t/15gERTHLssjM00O8MNzMIBd8Qu6tuW02ijfXdLQnZGheQEWhqvdMeVQaZ5G4suF/sl
         FK7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GOtu+Wh1wifdgaEDNzuuGtxIZ37pnZ0Ef/YmVURzFrM=;
        b=tYIiDv2rNauIpcMpbil79LFez61koDdLMsX8RpXIFMjv8vulXcAtTNo6PD8JiTC1xR
         CPLvY5mLaT8g0OUUZiA8XmDyoyUDYJvoHNG4Nem9YrSNT3EczuBJn8fJzulXqVI/BjP5
         EQYOh5H7Gz7fOiz5Soy5UEsC0D01D2gVOLdnWFYPTtsW+oU672MyTrezQfb50f/feFED
         9Y3Gs22UHMKjkqxp8DWX2VH00LNZxjwlOVg5Wm4XNi+fbCTK3KULuFOwDFfTcmSfgSkc
         MoPcKWD+eiO/WXn/64GbU3xBWUbZrUMvA8+Pvc+/BZakvx3ruWmgb6vo9dme6iEn93VO
         bPQA==
X-Gm-Message-State: AOAM530qUj7l7eU/AQUGA9FMZgEmJgEJeaqtRXyxJP0VO3VsAdxuk6En
        8RjhABK66J5yyogyyi508JCUfLSBXdH/pg==
X-Google-Smtp-Source: ABdhPJxuPiIHMYAFnfD6Csax1zyNUGjB5CEs+fL47nSxkvSAFwDnCXB8Wk+lZwDsdlXD2DjFI506Qg==
X-Received: by 2002:a5d:5151:: with SMTP id u17mr5050940wrt.302.1623324899914;
        Thu, 10 Jun 2021 04:34:59 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:34:59 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 34/40] trace-cmd: Copy buffers description in tracecmd_copy
Date:   Thu, 10 Jun 2021 14:34:20 +0300
Message-Id: <20210610113426.257931-35-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610113426.257931-1-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Extend the tracecmd_copy() API to support copying of trace buffers
description from input to output trace handler.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  2 +
 lib/trace-cmd/trace-input.c                   | 38 +++++++++++++++++++
 lib/trace-cmd/trace-output.c                  |  3 ++
 3 files changed, 43 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 2c31be5f..3735586d 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -174,6 +174,8 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
 			  struct tracecmd_output *out_handle,
 			  enum tracecmd_file_states start_state,
 			  enum tracecmd_file_states end_state);
+int tracecmd_copy_buffer_descr(struct tracecmd_input *in_handle,
+			       struct tracecmd_output *out_handle);
 void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
 void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
 unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 289102bf..7d0a41c2 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4173,6 +4173,44 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
 	return ret < 0 ? -1 : 0;
 }
 
+static int skip_buffers(struct tracecmd_input *handle)
+{
+	unsigned long long offset;
+	unsigned int count;
+	char *bname;
+	int i;
+
+	if (read4(handle, &count) < 0)
+		return -1;
+
+	for (i = 0; i < count; i++) {
+		if (read8(handle, &offset) < 0)
+			return -1;
+		bname = read_string(handle);
+		free(bname);
+	}
+
+	handle->file_state = TRACECMD_FILE_BUFERS;
+	return 0;
+}
+
+int tracecmd_copy_buffer_descr(struct tracecmd_input *in_handle,
+			       struct tracecmd_output *out_handle)
+{
+	int i;
+
+	if (in_handle->file_version >= 7) {
+		if (!check_in_state(in_handle, TRACECMD_FILE_BUFERS))
+			return -1;
+		skip_buffers(in_handle);
+	}
+	for (i = 0; i < in_handle->nr_buffers; i++)
+		tracecmd_add_buffer_description(out_handle,
+						in_handle->buffers[i].name, 0);
+
+	return tracecmd_write_buffers_description(out_handle);
+}
+
 /**
  * tracecmd_record_at_buffer_start - return true if record is first on subbuffer
  * @handle: input handle for the trace.dat file
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index a3d0f037..960d9a44 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1952,6 +1952,9 @@ struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle, const char
 	fstate = state > TRACECMD_FILE_CPU_COUNT ? TRACECMD_FILE_CPU_COUNT : state;
 	if (tracecmd_copy_headers(ihandle, handle, 0, fstate) < 0)
 		goto out_free;
+	if (state >= TRACECMD_FILE_BUFERS &&
+	    tracecmd_copy_buffer_descr(ihandle, handle) < 0)
+		goto out_free;
 
 	/* The file is all ready to have cpu data attached */
 	return handle;
-- 
2.31.1

