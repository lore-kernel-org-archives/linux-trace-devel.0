Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 431E7C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E90A610D0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234023AbhKKPPa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:15:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234019AbhKKPP3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:15:29 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF62C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:39 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id t18so6029351edd.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+zEbactRHyc+qOzh4NY8Xvh4kOR6bUeU97CKEjkzZ6s=;
        b=aY6bKNwZINgV5447jrmsVcxaad0OuazsxNam4aoUwyywNIB7PJeTb5SOA3VwvqUTDR
         ZnU4soGBakwSe+8Fj8cYep9mBmqWeQ528xHgHU7K9CT0+wlU6UZ7k1q0KNtdaxnlP+KU
         AvRQ3yUcFg15gGTRpEKQs2Uoc9Po8l/eK5gmrKSnvzIgJQuM25woD/KrmJsW2qxxGFzf
         lx/gRxxCkn5FT8iIKH5MvJOdBbjtWy5+C8fqipXiPy9fXRwSHPiM9iCx2+cfJN1JsqSk
         rAtcYDRgRnPKGMxbBQIGLMgyIo4h0trdgD0JVSRTB04bPfThVY/WlKtJXse7crDuha0c
         658Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+zEbactRHyc+qOzh4NY8Xvh4kOR6bUeU97CKEjkzZ6s=;
        b=yiEWBMy/Kzz/aoSMN93ploW8uaNB4uHGyynYUN5PiR3OSkm+MaMFG+0kQ/vkzNhD78
         qTZ3wgnU5mIfpUm9Uto6m055kG5lC7x2vqCwtCd77qW5kaudAJ3lPAIfWbEIP7x+QR4u
         JzhjeBbmgts0e8MXbLCPdT74EE/UOuanuLw7uD3klHF6qQhHSy6IoIdMs/SR5LtjQDSE
         ssBiTMMDDzDb8wZtZa1P+rZEsqrJYIacbe6JAkxOw/t5Y442xxXdP0K4kqF1DVQDy+GR
         3HKgJFT+OKtD+etBVbo0L1g9c4ZSbwHdyfchiJ/rCwKmzvNmT6meyVG+jstdfxwDsnXv
         FTqA==
X-Gm-Message-State: AOAM533dG0yNdhstLkA7CETj9e5gXa4sZ730vxlafPye1q3V+KjL/duy
        /PvSt9nWI2IDwL2hcE178SU=
X-Google-Smtp-Source: ABdhPJz+ze2zrat+ZW5YpRTQ2T58AkzUvHPmOrJz2SaxRUOAaIqCqNNTkIgV3m2ttEyMp23Ys2gd+A==
X-Received: by 2002:a50:d68e:: with SMTP id r14mr5731785edi.5.1636643554249;
        Thu, 11 Nov 2021 07:12:34 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id dk5sm1686835edb.20.2021.11.11.07.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:12:33 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 4/8] trace-cmd library: New API to copy buffer description between trace files
Date:   Thu, 11 Nov 2021 17:12:24 +0200
Message-Id: <20211111151228.86922-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151228.86922-1-tz.stoyanov@gmail.com>
References: <20211111151228.86922-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new library API is introduced, to copy buffers description between
trace files:
	tracecmd_copy_buffer_descr()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h |  2 ++
 lib/trace-cmd/trace-input.c                       | 13 +++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index e0661287..177a6ff8 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -189,6 +189,8 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
 			  struct tracecmd_output *out_handle,
 			  enum tracecmd_file_states start_state,
 			  enum tracecmd_file_states end_state);
+int tracecmd_copy_buffer_descr(struct tracecmd_input *in_handle,
+			       struct tracecmd_output *out_handle);
 void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
 void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
 unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 03dddcbd..d93e6eb3 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4889,6 +4889,19 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
 	return ret < 0 ? -1 : 0;
 }
 
+int tracecmd_copy_buffer_descr(struct tracecmd_input *in_handle,
+			       struct tracecmd_output *out_handle)
+{
+	int i;
+
+	if (tracecmd_get_out_file_version(out_handle) >= FILE_VERSION_SECTIONS)
+		return 0;
+
+	for (i = 0; i < in_handle->nr_buffers; i++)
+		tracecmd_add_buffer_info(out_handle, in_handle->buffers[i].name, 0);
+	return tracecmd_write_buffer_info(out_handle);
+}
+
 /**
  * tracecmd_record_at_buffer_start - return true if record is first on subbuffer
  * @handle: input handle for the trace.dat file
-- 
2.33.1

