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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 026A3C48BD1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D51D961425
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbhFJLhR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbhFJLhP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:37:15 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDC6C0617AF
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:35:06 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id a11so1890351wrt.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vcdi+S5Ov6ZUCcxdLyp6oZPs81fi1WITyWp1GWifBDk=;
        b=Oc4dti27ulG2s977K1Z+KhZSZBweJfSRRxremgffyj30xpvDa3yY/NHYMC1+F1vVdE
         7Es7O+gRFEReuzeH5PzHR/PKuey2pWUjBGmAVibFvFJ72P92OuQ8C/2mo/lE0fz/8MJw
         cg7woXu3NiEVFE/gp0gUUZCBIOnaag6HAvURK3b6ZDt29JZ8dOW06g8B9nKj61tRgxCa
         yY7apGrfqKwS5dvGB1m6ExsQAFsjOq3P2hVJ5kEiXP2rsOVRrOPr/ko3jmmAfjRexkhn
         RQIoyGCm8GC1HYxOArkBMNYkBqFMLiU5qqC6MtkZxDFrn6CR2p+ElcMS8thXSkXHJ8Mg
         V9gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vcdi+S5Ov6ZUCcxdLyp6oZPs81fi1WITyWp1GWifBDk=;
        b=noasNsYgJW3+sEEy0cCpgd86HqVYjNWLLC9Ykla0iIozyiSvDX0JwJsieqotpaeXs8
         4tY/1BRdT96sZqDbOLRaVQVB9FjRIOge4lhplLQdd3Lequfnras1GlDWApBe/MHMT9sA
         uD/92kRXmn+OHDQsTM367FMnk8Nv3hZXMSHPtYZ308VgeAVBsKKgbdRUBlTQJVmDRgyQ
         pjRGSYhZba3OK26ALxar6WBmzNFn45v8m4AKPwpIOcp7YueLrDi8YvDc7ZBPjkWxuACl
         ZAFyrYH6FdUItw505zBFf43CKLb6rFaorWXIbX1TBBbdAwRFwdy9w+JlRbf/K7yOuVh6
         LS2A==
X-Gm-Message-State: AOAM530DwVjdrIgpdX4V99Sq4BYoKRcpMu2k77D3PQurQtcU+5YPTFX0
        ArH8HCgCAEaE86/JbLtg778=
X-Google-Smtp-Source: ABdhPJyLTVMY2LLKwSu6ievZONKf6nuHrsunAtNVl9R3TGBjfnhZh0CVewOhlZPuza0MoMHPikLBRQ==
X-Received: by 2002:adf:f690:: with SMTP id v16mr5066352wrp.247.1623324904847;
        Thu, 10 Jun 2021 04:35:04 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:35:04 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 39/40] trace-cmd: Add compression parameter to tracecmd_copy
Date:   Thu, 10 Jun 2021 14:34:25 +0300
Message-Id: <20210610113426.257931-40-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610113426.257931-1-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added compression parameter to the tracecmd_copy() API, which allows to
select the compression of the created output file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h |  2 +-
 lib/trace-cmd/trace-output.c                      | 11 +++++++----
 tracecmd/trace-restore.c                          |  2 +-
 tracecmd/trace-split.c                            |  2 +-
 4 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 79fef884..c8f0ee93 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -316,7 +316,7 @@ int tracecmd_append_options(struct tracecmd_output *handle);
 void tracecmd_output_close(struct tracecmd_output *handle);
 void tracecmd_output_free(struct tracecmd_output *handle);
 struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle, const char *file,
-				      enum tracecmd_file_states state);
+				      enum tracecmd_file_states state, const char *compression);
 
 int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 			    int cpus, char * const *cpu_data_files);
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index fd7ea06c..01f08b61 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1999,20 +1999,23 @@ struct tracecmd_output *tracecmd_create_init_file_override(const char *output_fi
  * @ihandle: input handle of the trace.dat file to copy
  * @file: the trace.dat file to create
  * @state: what data will be copied from the source handle
+ * @compression: compression of the output file, can be one of:
+ *		 NULL - inherit compression from the input file
+ *		 "any" - compress the output file with the best available algorithm
+ *		 "none" - do not compress the output file
+ *		 algorithm_name - compress the output file with specified algorithm
  *
  * Reads the header information and creates a new trace data file
  * with the same characteristics (events and all) and returns
  * tracecmd_output handle to this new file.
  */
 struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle, const char *file,
-				      enum tracecmd_file_states state)
+				      enum tracecmd_file_states state, const char *compression)
 {
 	enum tracecmd_file_states fstate;
 	struct tracecmd_output *handle;
-	const char *compr_name = NULL;
 
-	tracecmd_get_file_compress_proto(ihandle, &compr_name, NULL);
-	handle = create_file(file, ihandle, NULL, NULL, &all_event_list, compr_name);
+	handle = create_file(file, ihandle, NULL, NULL, &all_event_list, compression);
 	if (!handle)
 		return NULL;
 
diff --git a/tracecmd/trace-restore.c b/tracecmd/trace-restore.c
index 7d439fd2..58913fa7 100644
--- a/tracecmd/trace-restore.c
+++ b/tracecmd/trace-restore.c
@@ -125,7 +125,7 @@ void trace_restore (int argc, char **argv)
 		if (tracecmd_read_headers(ihandle, TRACECMD_FILE_CMD_LINES) < 0)
 			die("error reading file %s headers", input);
 
-		handle = tracecmd_copy(ihandle, output, TRACECMD_FILE_CMD_LINES);
+		handle = tracecmd_copy(ihandle, output, TRACECMD_FILE_CMD_LINES, NULL);
 		tracecmd_close(ihandle);
 	} else
 		handle = tracecmd_create_init_file(output, NULL);
diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index 401e1d29..b98e6fc9 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -345,7 +345,7 @@ static double parse_file(struct tracecmd_input *handle,
 	dir = dirname(output);
 	base = basename(output);
 
-	ohandle = tracecmd_copy(handle, output_file, TRACECMD_FILE_CMD_LINES);
+	ohandle = tracecmd_copy(handle, output_file, TRACECMD_FILE_CMD_LINES, NULL);
 
 	cpus = tracecmd_cpus(handle);
 	cpu_data = malloc(sizeof(*cpu_data) * cpus);
-- 
2.31.1

