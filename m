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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1C78C4320A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCDBC60EB2
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234068AbhG2FLE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233875AbhG2FLE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:11:04 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6370C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:01 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id gn26so8488741ejc.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O3MlOCSVZr10henjb/kOmATFSY+Wwfn0tH13upLABCo=;
        b=W9PwlYMzixtAo31WJnjbDv1un1hxkxjZkNSsFRQ02E/93ZljWW+/OSWUXJHtEwHTfZ
         LaNbJPfoFsyqP+6AvWyaLLpa2u2qpjnpFtkZ2+mLTEHlnfcsMWLyo3ZvULDrP7Zu7lZa
         kfG4Q9+C+kEHsGPXtnqnDOf4Hjh5hTOM2nWR5tN0/oq2wbOB8QlBr1QJ4Lg05tLuebnp
         3HIruXBCvuRsSY15tLGdsBDodle/NwGoKQQU2rgWo8CnoigxPkEQrXPjptCCwXcG7Hx8
         j6lwBSkqLKigH9ptPlXFgdmqfnTnFRusaHjaEKbr2pfCD4HIYTqwar7ubXDxVIhONSTD
         O+yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O3MlOCSVZr10henjb/kOmATFSY+Wwfn0tH13upLABCo=;
        b=YQ2coxpJjzdvRAtUDFT0VASpwdsqG3ZLKDToY163Y+qAlAq04D3Ed645hbFEgpYnNE
         sSHuLrqnqo9Izji4ZY5Fr8BIRLCAxTSGhvpllQvuZyygJWbro4WmJS2oRIvqD9NzN0IB
         eClsbgXRfKkvAP5nClST+oWQXhtVD9pDrHIpJK3UKhKuk0hhwA9nZ1pRN2yPhZHK7bCi
         ce8WZJXm8HZek2WgE/MOi+cFHm7Ph0oQMTmLoTkmvEwlLmwXLkUy44jnWsUUcdcJGzYB
         MzQ+8eFy5bLmFl4T4P/iehNTsOPxNGR0joxUSAbZR7bfEsWe3+GTPvWz08Xp9gQo/V+A
         cezg==
X-Gm-Message-State: AOAM530IPw8hLhhsmGqpq36nfozPOq2Ho0q65LohREv5RfPagObJCLHD
        J73YgM0XkbGVX490UXePQ5LaiChAjt9JvA==
X-Google-Smtp-Source: ABdhPJx6eKPQJjvykaz7c6z8n6Vn+zjTaXc15I3U8LUZGr0ktyJ+qV2ejJkQRjSVpGlkwLcnlaZPsA==
X-Received: by 2002:a17:907:1b06:: with SMTP id mp6mr3017944ejc.188.1627535460391;
        Wed, 28 Jul 2021 22:11:00 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:59 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 61/87] trace-cmd: Call additional APIs when creating trace file
Date:   Thu, 29 Jul 2021 08:09:33 +0300
Message-Id: <20210729050959.12263-62-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When creating a trace file, two more APIs should be called, compared to
the old flow:
 - tracecmd_write_buffer_info(), to write version 6 buffers metadata in
   the file.
 - tracecmd_write_options() after the trace data is written, for version
   7 trace files, as the buffer metadata is appended to the options at
   the end.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-listen.c  | 6 ++++++
 tracecmd/trace-record.c  | 4 ++++
 tracecmd/trace-restore.c | 3 ++-
 tracecmd/trace-split.c   | 3 +++
 4 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index d812145b..3312a042 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -604,6 +604,9 @@ static int put_together_file(int cpus, int ofd, const char *node,
 
 	if (write_options) {
 		ret = tracecmd_write_cpus(handle, cpus);
+		if (ret)
+			goto out;
+		ret = tracecmd_write_buffer_info(handle);
 		if (ret)
 			goto out;
 		ret = tracecmd_write_options(handle);
@@ -612,6 +615,9 @@ static int put_together_file(int cpus, int ofd, const char *node,
 	}
 	ret = tracecmd_write_cpu_data(handle, cpus, temp_files, "");
 
+	if (!ret && tracecmd_get_out_file_version(handle) >= 7)
+		tracecmd_write_options(handle);
+
 out:
 	tracecmd_output_close(handle);
 	for (cpu--; cpu >= 0; cpu--) {
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 2e8db8a4..ddab7798 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3738,6 +3738,9 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 		if (ret)
 			goto error;
 		ret = tracecmd_write_cpus(network_handle, instance->cpu_count);
+		if (ret)
+			goto error;
+		ret = tracecmd_write_buffer_info(network_handle);
 		if (ret)
 			goto error;
 		ret = tracecmd_write_options(network_handle);
@@ -4109,6 +4112,7 @@ static void setup_agent(struct buffer_instance *instance,
 	add_options(network_handle, ctx);
 	tracecmd_write_cmdlines(network_handle);
 	tracecmd_write_cpus(network_handle, instance->cpu_count);
+	tracecmd_write_buffer_info(network_handle);
 	tracecmd_write_options(network_handle);
 	tracecmd_msg_finish_sending_data(instance->msg_handle);
 	instance->network_handle = network_handle;
diff --git a/tracecmd/trace-restore.c b/tracecmd/trace-restore.c
index 8d2fcae8..fbda42dd 100644
--- a/tracecmd/trace-restore.c
+++ b/tracecmd/trace-restore.c
@@ -163,6 +163,7 @@ void trace_restore (int argc, char **argv)
 
 	if (tracecmd_append_cpu_data(handle, args, &argv[first_arg]) < 0)
 		die("failed to append data");
-
+	if (tracecmd_get_out_file_version(handle) >= 7)
+		tracecmd_write_options(handle);
 	return;
 }
diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index e4a0c3b3..0768329f 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -391,6 +391,9 @@ static double parse_file(struct tracecmd_input *handle,
 	if (tracecmd_append_cpu_data(ohandle, cpus, cpu_list) < 0)
 		die("Failed to append tracing data\n");
 
+	if (tracecmd_get_out_file_version(ohandle) >= 7)
+		tracecmd_write_options(ohandle);
+
 	current = end;
 	for (cpu = 0; cpu < cpus; cpu++) {
 		/* Set the tracecmd cursor to the next set of records */
-- 
2.31.1

