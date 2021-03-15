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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80200C4332D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 06:19:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6603C64E66
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 06:19:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbhCOGS7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Mar 2021 02:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbhCOGSm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Mar 2021 02:18:42 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F030EC061574
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Mar 2021 23:18:41 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id j3so15927328edp.11
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Mar 2021 23:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4bAXOBWqynurN7IbQYf4dThYpWPfY0J95xpkTl59hB8=;
        b=e94zhtHdmBg0FyULRzIf8eQYa6eomt7fsS4vM8L+R0jpvJxu4DkRut5h0EpbzDxUs2
         VsDyzV8c4Rvf1VBulpNXLmr59MzrUx5G7XCRQl1AgHiPBfG2bOIw+MCDwD67CJSRyoMt
         xuD1HLdW5m2jdwaZOG3Qx+sljZQDmyrtLd6Qo/mTjGNtkzjgFq8V8f2uNccEJnOwZPxb
         lrk0dKasK1NOW/qX/Vp3M6alGj7ugVzOxSyeMgx+9xmhlYFjgnsKou8X7xneqqQt/rLj
         pE2XuZAkvQfYKqM3z73FGCoexmiQdMw4ocDhIEFatqJyCyM34zXvWdBHZahp7RgtW3Tj
         NP1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4bAXOBWqynurN7IbQYf4dThYpWPfY0J95xpkTl59hB8=;
        b=ri/ENYNX/+lY69pgmkb+v+ETIw0dNgJFgv5pwyPp+TDsf9apY++k4zdDhr6llA7lKJ
         ZDwf0XErZQX93R+RLAtCKOrw9fTkph/v1srL3F9aSGMXlgel1wBSM0Q/R42Z6WlDYQF4
         8rYf6mc5kHD1R9bYl7HSk+0nyXSAdbcH5HrDo07taklvqdYSPej3l0khVfssqOiWGsrt
         LYIV4TPExR36zQbQV26zJbL7B7DQSCm/66wiNHy5BYsZF7n2x91VghhtkUEWNaAbfmXu
         obeqWjdvoOXj0MLN14kqcYXESXTphYTrBRQ11jJPz/JMvpS1AQLUX3VbmLmdfWGI1LmW
         gcZg==
X-Gm-Message-State: AOAM533qyka2dz6Rl7I6Nhx622LoIQqP0Ot7Imoq1h+m7gsGmGkB8hHQ
        Pt84o9sx+mOa+PeEzbVDf1I=
X-Google-Smtp-Source: ABdhPJxaD949Y3bnKqhQ5XBvuxagLmJEthxzXBxyRklXO37jXmoupvj7Cqf1nzwHB16ev588U4vfRA==
X-Received: by 2002:a05:6402:17d6:: with SMTP id s22mr27815742edy.232.1615789120764;
        Sun, 14 Mar 2021 23:18:40 -0700 (PDT)
Received: from localhost.localdomain ([130.185.229.134])
        by smtp.gmail.com with ESMTPSA id t6sm7468478edq.48.2021.03.14.23.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 23:18:40 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 05/12] trace-cmd: Save information for tsc to nanoseconds conversion in trace file
Date:   Mon, 15 Mar 2021 08:18:25 +0200
Message-Id: <20210315061832.168495-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210315061832.168495-1-tz.stoyanov@gmail.com>
References: <20210315061832.168495-1-tz.stoyanov@gmail.com>
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
index b064a1ff..30d3ed89 100644
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
+		 * If TSC is used as current trace clock and there is
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

