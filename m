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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AFC4C432BE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9F1260D07
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236316AbhG1Ndy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236706AbhG1Ndy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:54 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5FAC061764
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:52 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id qk33so4577978ejc.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/uXd0AkR14v+fcQNlmPPBQh/xat9qOK9q4gLLkkZVxI=;
        b=Zyu3kPQBENB7+6U+vg0h1azwiP4edCmNNnuoDmNPkPoWGNlSel2pizRN9oyKCzcJxC
         /DrWOfU07ZY4AYlDSe4vObyXE+ScHu77wWb7b850KOPWLkKJqo/pXMcrT7XG0059pk1C
         bvwD7qOI+tkeyC9TZf3Wu2aPW9F6pGObo/BviMMv0ctqDk7X0Lwdglnd0ctntr4uU9ym
         NuSWvd2rarP6yAR8HZBPJ5MVl4teneFVnQ/KobCQ2aJ3tGgEP71pmQzRTcMA4LYRKFu4
         5MWl3fwBzxnXi4SkZ/zv4zwbql/RRByMUCwPxCBWU9tPFhI62oFtgofifAAillUgQkk3
         Jw+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/uXd0AkR14v+fcQNlmPPBQh/xat9qOK9q4gLLkkZVxI=;
        b=gTBWW/i2pPyLwO6BOWDzklEZSt23o0544i5rQSJKi8XncsfMvkjdXorPrDPPDMzAsS
         sivRe1c+z8o3IcXL3BrLvd4IOlSSwVoXgn7rXY6opXocifpxtas7Oe/9etVA7h2eXzKD
         WWoqQkQkCn7Sd0ngkh8paXYhP2wDg2NTRyUMTJSu5iSqXjszaXb7ZQjDdufQUPT37pYS
         C0kMCAFOrZq3+wODOdHZusNSuvRaVJH+78qafjQX9g/7TBG34OGXBRbalum3//8i7s2T
         oajM9SI2dOj9ujovygow9A+N0AsWccghReo+bqfd21onBtHCZ5ZMJ7pa8sJsUCGtIQ8j
         eEig==
X-Gm-Message-State: AOAM530RSWbfzAo4i2m9G9tGvqChlcC156sx/mVsc4Lf/TyHUq4TvWaJ
        KHHWSW/vLJ4k/gzIUwjJO/j5i1n5jdDI4g==
X-Google-Smtp-Source: ABdhPJyIkbmQorh6yLFJR2Tzro5uGKxJjTg2ag6stE0bei8oC6wzAnd/SMjRieN6LnJiWiuQ2kAOSQ==
X-Received: by 2002:a17:907:970f:: with SMTP id jg15mr7715885ejc.175.1627479230896;
        Wed, 28 Jul 2021 06:33:50 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:50 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 58/87] trace-cmd report: Close input file handlers on exit
Date:   Wed, 28 Jul 2021 16:32:21 +0300
Message-Id: <20210728133250.234140-59-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When "trace-cmd report" is interrupted with "ctrl-c", close the input
hanlders to opened trace files, to delete any temporary files used when
reading the trace data.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-read.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 416c6ee3..6384e52b 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1366,7 +1366,14 @@ struct tracecmd_input *read_trace_header(const char *file, int flags)
 
 static void sig_end(int sig)
 {
+	struct handle_list *handles;
+
 	fprintf(stderr, "trace-cmd: Received SIGINT\n");
+
+	list_for_each_entry(handles, &handle_list, list) {
+		tracecmd_close(handles->handle);
+	}
+
 	exit(0);
 }
 
-- 
2.31.1

