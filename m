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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5994C43462
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:39:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75BA26145D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235099AbhDVHkB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Apr 2021 03:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235106AbhDVHjx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 03:39:53 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F49EC06138D
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:39:11 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id r12so67321651ejr.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fkr7MfEbaqEu6irilnmnsH8hTilJ7MkS5e4JiK0R2Ao=;
        b=IU27aaS7xNjpqr/lnQLB7CCasetuMoAZFTAlRYhFXTM3VjsB8zBb+SlGnml6zM5Cxb
         8h8B4G8rgD423zX1dHAgim1nACAG8tD+RE8GBdUOLIc7xmMS715zkXenhs1eKL1B18km
         n0uh3/7SyH6EqE8+MGfAdi+WGKTyy6rQ0xSFJjRXMJ1+blg+xfjQ1qsVwWG7eWVT021c
         4SAdwRVXmVbbCpTk+hZw9kSpnuDcvQOqqhXtdLh21HW4V5zabDMVYROmGcm3W/JzBiL8
         KkhUwTo03MzPkhB4m38swrxsIqmozm81lJnHAjF21regfOCQtRPTUiw7aQ11a07Lzxms
         ygeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fkr7MfEbaqEu6irilnmnsH8hTilJ7MkS5e4JiK0R2Ao=;
        b=F5UXkm62jGZNOw9b6IV8UhhqE8KOiWTvzxEduzNEM1VmTL3S/d7MOlWZi6el06apeC
         lbUPSxsoYvm+agJ6XmOCiV36VXMCcpYGK7WHStvQnG+XHDIcip8M0GbiUGRBoRKbqwkv
         C6dZnRdPXyEUP7V1yD1IjAO5jBukxVEjNUhbZ+5o+HPis+jvOIZXvpJs6ukeaAW+17KN
         wlZ6JcRgojgPQTnCEFXEpfw3gLx7f5KiNmC0PfNPBJR/2SZzruUt+3iEQngsEMO2mnXO
         bn51N9KE7PklGbnvHH9dJvyf3WtBNSkYDZosb5Auvj4tjopn+h761FByoVYvWHH1abQi
         4aOQ==
X-Gm-Message-State: AOAM533YVMzHjiM1qHlp+48cHH4zBqvHbksRQTyeKlkxd/Vg/QPTRSC+
        Yf1o6IvblF9r3aqpY8u5/G0GTvV2kmyM8Q==
X-Google-Smtp-Source: ABdhPJxrn5HFdufvUza29HPuPM4V5fAh2D1ZFaqNthhzr3fCyGbhelFi3ZuZBQQRIpcFLgl8DOkeBQ==
X-Received: by 2002:a17:906:1284:: with SMTP id k4mr1847768ejb.409.1619077149918;
        Thu, 22 Apr 2021 00:39:09 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s5sm1253692ejq.52.2021.04.22.00.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 00:39:09 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 06/10] trace-cmd library: Inherit compression algorithm from input file
Date:   Thu, 22 Apr 2021 10:38:58 +0300
Message-Id: <20210422073902.484953-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210422073902.484953-1-tz.stoyanov@gmail.com>
References: <20210422073902.484953-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When a new trace file output handler is allocated, based on given trace
file input handler - use the same compression algorithm.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 9d603cfe..75cf143d 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1026,6 +1026,7 @@ static int select_file_version(struct tracecmd_output *handle, struct tracecmd_i
 {
 	if (ihandle) {
 		handle->file_version = tracecmd_get_file_version(ihandle);
+		handle->compress_proto = tracecmd_get_file_comperssion(ihandle);
 	} else if (file_version > 0) {
 		handle->file_version = file_version;
 	} else {
@@ -1769,6 +1770,7 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	tep_ref(handle->pevent);
 	handle->page_size = tracecmd_page_size(ihandle);
 	handle->file_version = tracecmd_get_file_version(ihandle);
+	handle->compress_proto = tracecmd_get_file_comperssion(ihandle);
 	list_head_init(&handle->options);
 
 	tracecmd_close(ihandle);
-- 
2.30.2

