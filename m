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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16CA8C48BE0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED021613F1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbhFJLhG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbhFJLhD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:37:03 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8345EC061760
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:34:58 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id b145-20020a1c80970000b029019c8c824054so6320709wmd.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tY0jSkhEty4HDlJj4DNPTV9zO0ERvs1vyxa1BBJLEgQ=;
        b=CLBNh51paME0x98+P2jztuMnsIHs0pwVbEYswRxI+LVYMa76EmWLC+HHjhJxLtr59+
         IgS7GHZlqRupT7nuRUyjOuCH9Axs5G0M8k/KVAnHLSOEUNDtlTnWzWDk3si1cE9Po6F0
         U6W52IEwQcB32z3p3RkBD8UCeL1GUhYCM1cwj2U4RRkYNbR2xARulfc96h0yYFcYeV6v
         uccWYWOATtsy6CQYhKrREb0RjPP9kHbMO7p4mEG3SPjLi2XwjZ7ISm6teXY/PkAfdOVb
         w6oTmeunPazjUw889S/+jT/bY/3naxmUz7r2HnWdaP+Bib/vmpCa1LEg6pB4wlGokHcW
         QkWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tY0jSkhEty4HDlJj4DNPTV9zO0ERvs1vyxa1BBJLEgQ=;
        b=cQu0dGCkwt3vb5tBMfQgkqW0+J5xPDMsIl1IIL+nn/sbCLA1GBHW5hCeQeIz4FQplm
         uizX4TzzdTFnbfVvQn4pTMrW/Z4YZdt6mkW0sp5gQVj/pQ4cifc9NfsIRUVfbQkqGEM+
         vM0cw42mINOPAb8MwTgAhTekRubGBw/R8nGiCZ6xa7XKOpmpCxY7+2I6sAGrn83nli1Q
         47IU3kILBqs5IIhuuk+kFGSDiqFIoKopwFTT7bn9qYP+R1XaMAzhWPmc/KwKdVqZZDK2
         Dwmj5KFilkibspa0cReNd7NWJoNeilf1qmEEiV/yWni6yDjK+qTohzclnmOELTpV9sHz
         hZ6g==
X-Gm-Message-State: AOAM530dF00QmV4gd8o23MwMko7rlbbV0ARud9KF3i8+jtPgy3zt6LFF
        cM0p/5RAMpnxq+8CJ+vxovz7qaxkYaMK1Q==
X-Google-Smtp-Source: ABdhPJxiTXt0UuYh/Wq+9FqXGJcajjDkLFdoeufiVaNWshQUBq2btMkH6KiVFun3XASIxTwZ7kA/ww==
X-Received: by 2002:a05:600c:354f:: with SMTP id i15mr4534298wmq.38.1623324897174;
        Thu, 10 Jun 2021 04:34:57 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:34:56 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 31/40] trace-cmd library: Add new API to get file version of output handler
Date:   Thu, 10 Jun 2021 14:34:17 +0300
Message-Id: <20210610113426.257931-32-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610113426.257931-1-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added an API to get the version of the trace file, associated with given
output file handler.
  tracecmd_get_out_file_version()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h | 1 +
 lib/trace-cmd/trace-output.c                      | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 65e80cec..9a08a960 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -319,6 +319,7 @@ int tracecmd_append_cpu_data(struct tracecmd_output *handle,
 int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
 				    const char *name, int cpus, char * const *cpu_data_files);
 struct tracecmd_output *tracecmd_get_output_handle_fd(int fd);
+unsigned long tracecmd_get_out_file_version(struct tracecmd_output *handle);
 
 /* --- Reading the Fly Recorder Trace --- */
 
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 1b4210b5..ff9c9a34 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1966,3 +1966,12 @@ __hidden bool check_out_state(struct tracecmd_output *handle, int new_state)
 {
 	return check_file_state(handle->file_version, handle->file_state, new_state);
 }
+
+/**
+ * tracecmd_get_out_file_version - return the trace.dat file version
+ * @handle: output handle for the trace.dat file
+ */
+unsigned long tracecmd_get_out_file_version(struct tracecmd_output *handle)
+{
+	return handle->file_version;
+}
-- 
2.31.1

