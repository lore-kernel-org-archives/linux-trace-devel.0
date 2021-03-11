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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B47FC4332E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 08:49:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A6F464FC4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 08:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbhCKIts (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 03:49:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231700AbhCKItT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 03:49:19 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F101C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Mar 2021 00:49:19 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id p8so44503179ejb.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Mar 2021 00:49:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lz7i5CVQ8hJ13/3J0CL0Vw1ZQNOv4KoXY5o1XgGysU0=;
        b=vgSaoKbD7A9EvcZO0J4QEslNM+AeDwHzCtBvQLdgpswfOUBhvaarNllDoFrsTpK9G6
         c0V3JpMt2s9tc3dlKnN6XhzWEmDOIWKejaG5COihnbqeeV1X5S+o8P8Lw79U5E5uXF4Q
         pkDMzwYfGjoFAev1Kz2fzyBjrKD0X2IlPB0CLbH4YD10jm4afElODcRi2n+zNgYmPS3e
         IWD36QsBRSVUHGZ2ieYDe101n7guO+4FGzbjR3N5DccgpzRAxhdgi6FNJeVK1u31ByEk
         297ULGfyVONgVtvkszqbXKpkqaWtD/1p7e12Lqne57pOOWyVBKlxnthP37LAfrQn+SvS
         mjRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lz7i5CVQ8hJ13/3J0CL0Vw1ZQNOv4KoXY5o1XgGysU0=;
        b=PgrgkAfjWYXhdjZrRO3jyKymyIlw8JrJiT8uW0xJcvDKIFf0vgjFi7BbujT4/Msj9R
         JXxlLSnLR8YeNK0zTatE2WcDTez5UuaCV9fiAdsaDfanafSD4LY57GF2Gg5MJsQTWIH1
         Wks/lIBwvCEiIikGw/M4gOb6ynavj+Msc5xSpC9hxQsB/Lvuz6OikEZ7V2laEK2pPzp5
         wxeaPcVGrfrygBtnJAB6ki49FRLAR6GDKyxRpnDirLfmRnTOQrZoctZHn3hoek9zOOBD
         ehge2qX/DvH2rJpGz3sfOTmSi7HPFfYfb5tUkz+KwyCcTv6/tGJ6U0IAUooXtKL7UPl+
         6jwg==
X-Gm-Message-State: AOAM532IgTnFt4Bajw27ElfpAZrdpyBIl3K3rgALrbWPytrUjhoaA3jp
        Go3rAERgWz1zoRbk46uLCz8=
X-Google-Smtp-Source: ABdhPJxxsWwK2beoQMu1cgK8ITHSweYdhx/xFSnfXOgO7zTu6AJbmub3RPv9WQPOaKb1TG7al3FT2w==
X-Received: by 2002:a17:906:c24b:: with SMTP id bl11mr2118032ejb.80.1615452558312;
        Thu, 11 Mar 2021 00:49:18 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id fi11sm901647ejb.73.2021.03.11.00.49.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 00:49:17 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v31 12/16] trace-cmd: Save information for tsc to nanoseconds conversion in trace file
Date:   Thu, 11 Mar 2021 10:48:53 +0200
Message-Id: <20210311084857.1919805-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311084857.1919805-1-tz.stoyanov@gmail.com>
References: <20210311084857.1919805-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Store multiplier and shift, required for TSC clock to nanosecond
conversion in the metadata of the trace file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 15521d0d..1313af03 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -666,6 +666,17 @@ static void delete_thread_data(void)
 	}
 }
 
+static void
+add_tsc2nsec(struct tracecmd_output *handle, struct buffer_instance *instance)
+{
+	int array[] = { instance->tsc2nsec.mult,
+			instance->tsc2nsec.shift,
+			instance->tsc2nsec.offset};
+
+	tracecmd_add_option(handle, TRACECMD_OPTION_TSC2NSEC,
+			    sizeof(array), array);
+}
+
 static void host_tsync_complete(struct buffer_instance *instance)
 {
 	struct tracecmd_output *handle = NULL;
@@ -680,6 +691,16 @@ static void host_tsync_complete(struct buffer_instance *instance)
 		handle = tracecmd_get_output_handle_fd(fd);
 		if (!handle)
 			die("cannot create output handle");
+
+		/*
+		 * If  TSC is used as current trace clock and there is
+		 * information for tsc to nanosecond conversion, store it
+		 * in the trace file
+		 */
+		if (instance->tsc2nsec.mult && instance->clock &&
+		    !strncmp(top_instance.clock, TSC_CLOCK, strlen(TSC_CLOCK)))
+			add_tsc2nsec(handle, instance);
+
 		tracecmd_write_guest_time_shift(handle, instance->tsync);
 		tracecmd_append_options(handle);
 		tracecmd_output_close(handle);
@@ -4269,6 +4290,15 @@ static void record_data(struct common_record_context *ctx)
 				add_guest_info(handle, instance);
 		}
 
+		/*
+		 * If  TSC is used as current trace clock and there is
+		 * information for tsc to nanosecond conversion, store it
+		 * in the trace file
+		 */
+		if (top_instance.tsc2nsec.mult && top_instance.clock &&
+		    !strncmp(top_instance.clock, TSC_CLOCK, strlen(TSC_CLOCK)))
+			add_tsc2nsec(handle, &top_instance);
+
 		if (tracecmd_write_cmdlines(handle))
 			die("Writing cmdlines");
 
-- 
2.29.2

