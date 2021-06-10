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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E66C47094
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:36:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27BC3613FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhFJLiI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:38:08 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:42934 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbhFJLiF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:38:05 -0400
Received: by mail-wm1-f53.google.com with SMTP id l7-20020a05600c1d07b02901b0e2ebd6deso6209926wms.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ovTO2+bhZPsYG830hwQ0yxKfzcFEyCIHS3+j+KQAJbM=;
        b=NCI3y1AZzKbGTHm2DfAbluTuuvArMIhuJa+mP4g57FKkfy9BZap+p947ByhvYI4jEF
         Isu4c27QmaA+MbngUVqq0Pk3spy5ctsvfqK8dE1XVkWy/XhxJY+0+Kr8Qd180xF48t7y
         U0LOjvrwQ3oUlxwY9NR0kGbOTcimjjawj4xi/GUlSCZMV/4kl6wkC1159R+KoVMaRvaE
         jSzWKonBoV2qAyLgI9mvNGt6Uvj/BaSsH2eno4IiY+mf4GFLtgqxc1FzyllLd0LhnyhJ
         0zkzPVIjecEZbG2Ye3sS6thzunHgJS6ln6b2wBF+F0LiloHJzLj8xjYFy1J85s33oFEL
         sumA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ovTO2+bhZPsYG830hwQ0yxKfzcFEyCIHS3+j+KQAJbM=;
        b=ejQ8d+9rek6wkAzVSRJPtKvDvYHzUp539FS/ADEtpOObz0iI/QA+evi9ex+NdsC8IQ
         N4r+Ov+L7HMraH2UmvGKVG/P6vMoUhBxY4dmZto04OuJaPG0cYsgZRsb4Z3CVUP/a9QZ
         mEx0+4fVq/aIcGhVmZj+Y6ijRMFXCtQWRI3q1CQiWKoQniqyrm2KLdqJ6O8YwKtxa4qg
         VvHwmV0YCO3NaOxDIrJJD/AvdP9rlaJYE8rq1BB9SGrHwhVw1ORYNLml4GnG3+TDX/12
         zKVCvJ3Av5snuH8kWLMF3B1dX3vvHmUIxunxrT5Mz+P1qkydymMPT+o04cS8qnrY57HZ
         ihRA==
X-Gm-Message-State: AOAM531ZVfIN6htxOD3vJon69KywtLeKjGbkG1qwVe1ABd8BiKxBNNS2
        fQG4VT1Y+0ehO0gVmerNwTpdZiHlwBXVAA==
X-Google-Smtp-Source: ABdhPJzCu8nja4HolmIxUD3S4phalU0ZBI9F1TbqvJ8IV1xCbPg6NpE3/iFGSlFA1WXbnvESms+8Zg==
X-Received: by 2002:a7b:cf18:: with SMTP id l24mr14183369wmg.160.1623324898929;
        Thu, 10 Jun 2021 04:34:58 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:34:58 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 33/40] trace-cmd: Copy CPU count in tracecmd_copy
Date:   Thu, 10 Jun 2021 14:34:19 +0300
Message-Id: <20210610113426.257931-34-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610113426.257931-1-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Extend the tracecmd_copy() API to support copying of CPU count from
input to output trace hanlder.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c  | 30 ++++++++++++++++++++++++++++++
 lib/trace-cmd/trace-output.c |  2 +-
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 74d1ebf7..289102bf 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4043,6 +4043,23 @@ error:
 	return -1;
 }
 
+static int copy_cpu_count(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
+{
+	unsigned int size;
+
+	if (!check_in_state(in_handle, TRACECMD_FILE_CPU_COUNT) ||
+	    !check_out_state(out_handle, TRACECMD_FILE_CPU_COUNT))
+		return -1;
+
+	if (read_copy_size4(in_handle, out_handle, &size) < 0)
+		return -1;
+
+	in_handle->file_state = TRACECMD_FILE_CPU_COUNT;
+	out_set_file_state(out_handle, in_handle->file_state);
+
+	return 0;
+}
+
 /**
  * tracecmd_copy_headers - Copy headers from a tracecmd_input handle to a file descriptor
  * @in_handle: input handle for the trace.dat file to copy from.
@@ -4135,6 +4152,19 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
 			return 0;
 
 		ret = copy_command_lines(in_handle, out_handle);
+		if (ret < 0)
+			goto out;
+
+		/* fallthrough */
+	case TRACECMD_FILE_CPU_COUNT:
+		if (end_state <= in_handle->file_state)
+			return 0;
+
+		ret = copy_cpu_count(in_handle, out_handle);
+		if (ret < 0)
+			goto out;
+
+		/* fallthrough */
 	default:
 		break;
 	}
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index e3b018aa..a3d0f037 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1949,7 +1949,7 @@ struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle, const char
 	if (!handle)
 		return NULL;
 
-	fstate = state > TRACECMD_FILE_CMD_LINES ? TRACECMD_FILE_CMD_LINES : state;
+	fstate = state > TRACECMD_FILE_CPU_COUNT ? TRACECMD_FILE_CPU_COUNT : state;
 	if (tracecmd_copy_headers(ihandle, handle, 0, fstate) < 0)
 		goto out_free;
 
-- 
2.31.1

