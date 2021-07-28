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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4252EC432BE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D69B61019
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236577AbhG1NdO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236567AbhG1NdM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:12 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889C1C0613CF
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:10 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id v21so4685504ejg.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m22+wkkbAq5SigJvmJ/9a6c2tSZv21Q/Q29kb7moj4g=;
        b=n08r7ej3DUZgPtZHshNLlmNGYB92D+2M8LIbQRnF6VJOVT/xYoNdQPScWen8isXWsK
         ILECE2NQlAU9qDrIpt2+PQyDpgvoH4Tnh4SQicCKAosxnbGNSYwTP0yV/MUb7GrqR5Rk
         8SgbfYaEaU9klUXFuF4ZJiKox2fU4J9LQI1lBhgxzylJTL6IUNavhy7P+t2/yaEWMi0T
         /CbDyGnbF+584w6dm/fF5PYJvO5RIH0t8O73vdGSIkJrrLhHRX/40LnpJ+kFQf8ztsYF
         n/b6Zj3lSH/ngwt0wJZ3QmvkxtgE5ZxLsfq3y2hSzQylgFuv9A9UpX5E4ohJPprtWsAj
         zUnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m22+wkkbAq5SigJvmJ/9a6c2tSZv21Q/Q29kb7moj4g=;
        b=BFFAmoL2byu3HYiVqGhi8+quqr4dBjUprrQyVMsC7qZGgFRNA/1lZ+GdK2P2/3wKLn
         fgsZH1PEBdBeOfuWb1sdoKmZebXHYaN8drr00fEjQvorYSsVwHRGOybtRGCFjwOr4Ikz
         9Y38ROfbwqAqeUsM+Pt3toudYMqPnHTKN4enBCWLMO5T+rfqXCn1oXPLGYfChqqTH2LU
         HLUoBBBo2eiGS0B1EJlD+R5zqA98qb04bQEPpoBN3T/thxFtleKnhuoM05wxvt0QwfBH
         NJ1fqNWRQ/RiuhVJj0CDb6KjaABgwvfm7PvPzUISqxtU1GWwvMrQT6cUhc8cAr5kiUmD
         JZMA==
X-Gm-Message-State: AOAM531xO7EV4jEw86QnN0OTPeY9iLyu2PSL8NF7cXpEODF9lupgmLos
        hjTnmmCapw9/61vJ8B+7P6BIAdMcWwq0cQ==
X-Google-Smtp-Source: ABdhPJzlPF2RyLFW9hlYrk+aj9m/QulNtEJp9Oqi7PA0JTAqO9aX5L/+qmsCdghjlZ38wEvnw2K/vg==
X-Received: by 2002:a17:906:6046:: with SMTP id p6mr23760275ejj.344.1627479189163;
        Wed, 28 Jul 2021 06:33:09 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:08 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 17/87] trace-cmd library: New API to configure compression on an output handler
Date:   Wed, 28 Jul 2021 16:31:40 +0300
Message-Id: <20210728133250.234140-18-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

New API can be used to configure compression algorithm on a output
handler to a trace file.
 tracecmd_output_set_compression()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  1 +
 lib/trace-cmd/trace-output.c                  | 44 +++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 455ff680..ee224903 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -281,6 +281,7 @@ int tracecmd_output_set_trace_dir(struct tracecmd_output *handler, const char *t
 int tracecmd_output_set_kallsyms(struct tracecmd_output *handler, const char *kallsyms);
 int tracecmd_output_set_from_input(struct tracecmd_output *handler, struct tracecmd_input *ihandle);
 int tracecmd_output_set_version(struct tracecmd_output *handler, int file_version);
+int tracecmd_output_set_compression(struct tracecmd_output *handler, const char *compression);
 int tracecmd_output_write_init(struct tracecmd_output *handler);
 int tracecmd_output_write_headers(struct tracecmd_output *handler,
 				  struct tracecmd_event_list *list);
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index b0ec0c51..4a3ca2d0 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -219,6 +219,7 @@ void tracecmd_output_free(struct tracecmd_output *handle)
 		free(option);
 	}
 	free(handle->trace_clock);
+	tracecmd_compress_destroy(handle->compress);
 	free(handle);
 }
 
@@ -1127,6 +1128,49 @@ int tracecmd_output_set_version(struct tracecmd_output *handler, int file_versio
 	return 0;
 }
 
+/**
+ * tracecmd_output_set_compression - Set file compression algorithm of the output handler
+ * @handle: output handler to a trace file.
+ * @compression: name of the desired compression algorithm. Can be one of:
+ *		 - "none" - do not use compression
+ *		 - "all" - use the best available compression algorithm
+ *		 - or specific name of the desired compression algorithm
+ *
+ * This API must be called before tracecmd_output_write_init().
+ *
+ * Returns 0 on success, or -1 in case of an error:
+ *   - the output file handler is not allocated or not in expected state.
+ *   - the specified compression algorithm is not available
+ */
+int tracecmd_output_set_compression(struct tracecmd_output *handler, const char *compression)
+{
+	if (!handler || handler->file_state != TRACECMD_FILE_ALLOCATED)
+		return -1;
+
+	handler->compress = NULL;
+	if (compression && strcmp(compression, "none")) {
+		if (!strcmp(compression, "any")) {
+			handler->compress = tracecmd_compress_alloc(NULL, NULL, handler->fd,
+								    handler->pevent,
+								    handler->msg_handle);
+			if (!handler->compress)
+				tracecmd_warning("No compression algorithms are supported");
+		} else {
+			handler->compress = tracecmd_compress_alloc(compression, NULL, handler->fd,
+								    handler->pevent,
+								    handler->msg_handle);
+			if (!handler->compress) {
+				tracecmd_warning("Compression algorithm %s is not supported",
+						  compression);
+				return -1;
+			}
+		}
+	}
+	if (handler->compress && handler->file_version < 7)
+		handler->file_version = 7;
+
+	return 0;
+}
 
 /**
  * tracecmd_output_write_init - Write the initial magics in the trace file
-- 
2.31.1

