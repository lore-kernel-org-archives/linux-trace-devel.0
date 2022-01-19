Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0917EC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352027AbiASI2w (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:28:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiASI2w (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:28:52 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75E3C06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:28:51 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id a18so7588197edj.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=057i7c+9MvT661qKYwzUh3d658GbAi540WoCbvc0TjI=;
        b=Mrb4bSb+upEuIUtbomvUzREaDLaIPNwo+HIqsijUKrCeqvnC6g517NAm6x61f8g7Lh
         mrvOSgDOpsMpM3BqcA0ngaXmEmoJxUYPc9qbnWTZ8lOeJZiU1sHyWXEvkzyhRedu/l3L
         kFpZ/YqhPgHizK1AXcCHBLiYI2Pz8dYxnz7KXgi0A6x/QXXxhnkiD7OPN6lWjGne8wVD
         nk3BfMOZjVXfnfQ5+PYetjqf6JdzuTo6o8BQJG/AmJB9m74Zj9TGOcI4J+JxOlQVrsK0
         m1ZhszMEfBKsRPPOpEobhuVKhux1Hb0vhYc/L0ezQ2FkmM/zpOvjFGs30ZnxWWEO8zrT
         39BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=057i7c+9MvT661qKYwzUh3d658GbAi540WoCbvc0TjI=;
        b=L770/TaOxSOrZNTxlzICJOv5nxruYvMTZzdjVy+MSf89n1/vKrzObXoLMK0YR098Uw
         6m0f/bNuy9aj066knisL0Wm8hMrHYzLH5+7U0gM0nXkoSVeuMJ4jVfRRGt8W5fDWeeLx
         2RpSqP7zGzap8QVfU9R6WrznvJ0l8JaNT2SYrD0LOFGPOu70rEKQj+4dXX7yXltfuOGc
         lmt7nbD11QIdOXA4QslZZmi1IfI/IoHzreyVv1w/vqkEJmccMPDgq5a8uvm6c8NYdZXc
         xdbdKGOSiB1+SE51czb47h4rpRDZs04YI2BN2TOc3+sGcDSkHFJRqLUGdZAnCTzsa3cL
         SD0Q==
X-Gm-Message-State: AOAM533kPv0485JkWPhr24HvDLYH2oWT87Vyd/V5kzMj+WfLN8TN+Njn
        aNaLRGMgX6qi6aGxh+lDCDF8th7zcz8=
X-Google-Smtp-Source: ABdhPJwe8tS/0/IbGYZtBf/ueYSnaIej2f5/8gEiImxkzvgjDMPHa3TOoaL9bNO1030ab46Ekg66KQ==
X-Received: by 2002:a05:6402:2550:: with SMTP id l16mr29093267edb.83.1642580930528;
        Wed, 19 Jan 2022 00:28:50 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id t14sm860838edq.24.2022.01.19.00.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:28:50 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 4/9] trace-cmd library: New API to copy buffer description between trace files
Date:   Wed, 19 Jan 2022 10:28:40 +0200
Message-Id: <20220119082845.245993-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082845.245993-1-tz.stoyanov@gmail.com>
References: <20220119082845.245993-1-tz.stoyanov@gmail.com>
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
index 6e15c097..279af562 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -195,6 +195,8 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
 			  struct tracecmd_output *out_handle,
 			  enum tracecmd_file_states start_state,
 			  enum tracecmd_file_states end_state);
+int tracecmd_copy_buffer_descr(struct tracecmd_input *in_handle,
+			       struct tracecmd_output *out_handle);
 void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
 void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
 unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index d35be370..b6ad92a8 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4968,6 +4968,19 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
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
2.34.1

