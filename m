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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF4E9C47094
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8460613F1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbhFJLhQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbhFJLhP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:37:15 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509DCC0617AD
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:35:02 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id o3so1904782wri.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RltyCT2fa2M7gYV3t/HTr8YblFBU8FIl+m0E7lH5+As=;
        b=ib8Fx5S5HPzLqnbLtZvDSKSfXfrxZZYKn6zDRhxuX4JpKJTS8TA+N//nDIlysPJTX9
         Xi/RucpkCoPZvyH1e2O9Xj3nM7aEH9+dKKMfMTKyKuXjmWhyv9DkjZlnbce4lxxk4O6H
         qhapMCweyd1zX6NLbO4gfOZPRsxsRFygt4y8Es/Gxha8Zp+NZ/naZ2DeToY+OdDqAGqZ
         D13ogUIy3sdG1Lz9/XqqobSRYAn9TaaYbYvgk6fGxdOQYZCINPDV/epk44AVQbHenAyW
         enDE4Ky/Vay70hCFcE0oEttdzY4wR6EgTHZkeLnIlmdo4A7gyQiwarUrnOj1tZ7OeibQ
         3Ssg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RltyCT2fa2M7gYV3t/HTr8YblFBU8FIl+m0E7lH5+As=;
        b=nEiaKewvpv6GTgm2GQIcGcjj9pi8kPjm5FStUYU37zALamYKpuZbQDzdgxvIrxWoUU
         x0zkF6vGPuypuKECR9HTcEzax3E4Dxw1VQ74Y8UpraCt3Z/7q+LHsantxKaPbNnj12+q
         vPWrtQcUyUU4eoAvB/YUe0y9dz/qctCHRmivmV/wz6yOpWsucL3i3nbfZOPUWxaRErlr
         YOMny+ORUllZt6RnpMbSbRDmZnoEkaTJ0/sxzlS+iQycti2ZX63CyxJpYyD6u1sJMmgJ
         jhssAZDd9MQPpkQ1WQ47n2ByHrjKYCkwQ7yhHb5ahe4dpPS0jY9a6k5l2u+aEFsTEDRm
         kfDQ==
X-Gm-Message-State: AOAM532jgfbGdvrzTVGz3ssQdEaLjXExcRgEBlOlhEyU42BLmndJRuAj
        qsxLM1yXPE9qDIvw/LWQ19ocFYUqMusbUg==
X-Google-Smtp-Source: ABdhPJxuFRlY4JCJFW5jnX6mY5Yqkz2MhajJx/s9U8d0uQxgyPz3iWq185YFjZeGdoAOxEnOcWnbMQ==
X-Received: by 2002:a05:6000:cb:: with SMTP id q11mr4953211wrx.13.1623324900895;
        Thu, 10 Jun 2021 04:35:00 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:35:00 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 35/40] trace-cmd: Copy options in tracecmd_copy
Date:   Thu, 10 Jun 2021 14:34:21 +0300
Message-Id: <20210610113426.257931-36-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610113426.257931-1-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Extend the tracecmd_copy() API to support copying of trace options
section from input to output trace handler.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  2 +
 lib/trace-cmd/include/trace-cmd-local.h       |  1 +
 lib/trace-cmd/trace-input.c                   | 80 +++++++++++++++++++
 lib/trace-cmd/trace-output.c                  |  8 ++
 4 files changed, 91 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 3735586d..595ba688 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -176,6 +176,8 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
 			  enum tracecmd_file_states end_state);
 int tracecmd_copy_buffer_descr(struct tracecmd_input *in_handle,
 			       struct tracecmd_output *out_handle);
+int tracecmd_copy_options(struct tracecmd_input *in_handle,
+			  struct tracecmd_output *out_handle);
 void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
 void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
 unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 135f52f3..628af16d 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -52,6 +52,7 @@ void in_uncompress_reset(struct tracecmd_input *handle);
 int in_uncompress_block(struct tracecmd_input *handle);
 
 void out_set_file_state(struct tracecmd_output *handle, int new_state);
+void out_save_options_offset(struct tracecmd_output *handle);
 
 int write_buffers_description_v7(struct tracecmd_output *handle);
 int write_buffers_description_v6(struct tracecmd_output *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 7d0a41c2..794f8ea3 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4211,6 +4211,86 @@ int tracecmd_copy_buffer_descr(struct tracecmd_input *in_handle,
 	return tracecmd_write_buffers_description(out_handle);
 }
 
+static int copy_options(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
+{
+	unsigned short option;
+	unsigned short en2;
+	unsigned int size;
+	unsigned int en4;
+
+	if (in_uncompress_block(in_handle))
+		return -1;
+	out_save_options_offset(out_handle);
+	out_compression_start(out_handle);
+	for (;;) {
+		if (do_read_check(in_handle, &option, 2))
+			goto error;
+		en2 = tep_read_number(in_handle->pevent, &option, 2);
+		if (en2 == TRACECMD_OPTION_DONE)
+			break;
+		/* next 4 bytes is the size of the option */
+		if (do_read_check(in_handle, &size, 4))
+			goto error;
+		en4 = tep_read_number(in_handle->pevent, &size, 4);
+		/* Do not copy buffers description, as there is a file specific offset */
+		if (en2 == TRACECMD_OPTION_BUFFER) {
+			/* Skip the option */
+			do_lseek(in_handle, en4, SEEK_CUR);
+			continue;
+		}
+
+		if (do_write_check(out_handle, &option, 2))
+			goto error;
+		if (do_write_check(out_handle, &size, 4))
+			goto error;
+		if (read_copy_data(in_handle, en4, out_handle))
+			goto error;
+	}
+	if (do_write_check(out_handle, &option, 2))
+		goto error;
+	in_uncompress_reset(in_handle);
+	if (out_compression_end(out_handle))
+		goto error;
+	in_handle->file_state = TRACECMD_FILE_OPTIONS;
+	out_set_file_state(out_handle, in_handle->file_state);
+	/* Append local options */
+	return tracecmd_append_options(out_handle);
+error:
+	out_compression_reset(out_handle);
+	in_uncompress_reset(in_handle);
+	return 0;
+}
+
+int tracecmd_copy_options(struct tracecmd_input *in_handle,
+			  struct tracecmd_output *out_handle)
+{
+	off64_t offset;
+	char buf[10];
+
+	if (!check_in_state(in_handle, TRACECMD_FILE_OPTIONS) ||
+	    !check_out_state(out_handle, TRACECMD_FILE_OPTIONS))
+		return -1;
+
+	/* Save where we currently are */
+	offset = lseek64(in_handle->fd, 0, SEEK_CUR);
+
+	if (do_read_check(in_handle, buf, 10))
+		return -1;
+	/* check if this handles options */
+	if (strncmp(buf, "options", 7) == 0) {
+		if (do_write_check(out_handle, "options  ", 10))
+			return -1;
+		if (copy_options(in_handle, out_handle) < 0)
+			return -1;
+	} else {
+		if (lseek64(in_handle->fd, offset, SEEK_SET) == (off_t)-1)
+			return -1;
+		in_handle->file_state = TRACECMD_FILE_OPTIONS;
+		out_set_file_state(out_handle, in_handle->file_state);
+	}
+	return 0;
+}
+
 /**
  * tracecmd_record_at_buffer_start - return true if record is first on subbuffer
  * @handle: input handle for the trace.dat file
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 960d9a44..cbe641fd 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1955,6 +1955,9 @@ struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle, const char
 	if (state >= TRACECMD_FILE_BUFERS &&
 	    tracecmd_copy_buffer_descr(ihandle, handle) < 0)
 		goto out_free;
+	if (state >= TRACECMD_FILE_OPTIONS &&
+	    tracecmd_copy_options(ihandle, handle) < 0)
+		goto out_free;
 
 	/* The file is all ready to have cpu data attached */
 	return handle;
@@ -1974,6 +1977,11 @@ __hidden bool check_out_state(struct tracecmd_output *handle, int new_state)
 	return check_file_state(handle->file_version, handle->file_state, new_state);
 }
 
+__hidden void out_save_options_offset(struct tracecmd_output *handle)
+{
+	handle->options_start = lseek64(handle->fd, 0, SEEK_CUR);
+}
+
 /**
  * tracecmd_get_out_file_version - return the trace.dat file version
  * @handle: output handle for the trace.dat file
-- 
2.31.1

