Return-Path: <SRS0=47nt=6S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7480C4724C
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 06:27:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97161206EB
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 06:27:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ooEnpG+7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgEDG1U (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 May 2020 02:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbgEDG1U (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 May 2020 02:27:20 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC69C061A0E
        for <linux-trace-devel@vger.kernel.org>; Sun,  3 May 2020 23:27:19 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id u15so8519382ljd.3
        for <linux-trace-devel@vger.kernel.org>; Sun, 03 May 2020 23:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v7upXVE/4gpt5VBZUVOkGiaMzVyWAktQFIYMcVMTXk4=;
        b=ooEnpG+7Y3XstmMooQs3qDgcpMrm6nDuFNLHGDyJrCRnynDreQ7fU+snITMB1tlxtr
         94Q6LpEJc+okb1rFa5efoELGPDHuozfuj6HtId8zHUleYrdeoL2gCBOwoW5yzvJaX5iO
         CLf5Tm8qKyheJ3+7f//V/afl8vnwm56jf2lPtmzv931Et3GI0+Wm9FNRHGUpehjowMd9
         wLzPpptlEgUXb/Kny07zBp/zPvD3tFay/kPijN3+mQ+Veaj4lpPk3s8spyeXnYfPePlm
         Bnv5rv1623ffgNuh1qH8cVszJxA62+i9uzSOk209roaCSYWbPmyox8nz4GO9Y51NytHk
         P+Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v7upXVE/4gpt5VBZUVOkGiaMzVyWAktQFIYMcVMTXk4=;
        b=nNsKrng5eMv6xtV7j6i3mGx++TgruYp6mqwqND+g4wevtRmf4nqQ9GflOgQckowra3
         HGdaHLHSvcgo9Bc4NWnPoenu5IgR3hgHuWCJ0TU/axR/SE3wK6NHxWZRmyD3CQvjxs2I
         hLyGN1NMQPtptrE4+RKiiyrn1Tw6Eh7EAOoCW41+icJMewBVpkg78+pIQS0fggeZDEzn
         oe4u/EkgjKj90/o9UErRxD9L1no6hAXiD5GkqWUObZmbr3T5wkk2nodYWjg7DI3yk/lh
         IomgvEcpy2AMfbgbLzx2l/gKHaeNrC7yveh+50oZjXbdAeIw5sjsOZ9gANboxx0b6I8O
         L8NA==
X-Gm-Message-State: AGi0PubuVb/f20V0xaAL5g9+siPWcxiq5FrRNVv5LD2hOuRzjyVtmdaQ
        Dc5ybX7KLFSj0Fw3HR7WghbtjC18QZs=
X-Google-Smtp-Source: APiQypLhjyB4QpJ51AcOAcurFZL6MyDHlrovngRZo5AmZbihfxlpNSBEFrz4S0Y97cCerdst/iS9UA==
X-Received: by 2002:a2e:b0d4:: with SMTP id g20mr9609115ljl.18.1588573638305;
        Sun, 03 May 2020 23:27:18 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u6sm7397150ljd.68.2020.05.03.23.27.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2020 23:27:17 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 3/4] trace-cmd: Create ftrace instances before using them.
Date:   Mon,  4 May 2020 09:27:10 +0300
Message-Id: <20200504062711.107867-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504062711.107867-1-tz.stoyanov@gmail.com>
References: <20200504062711.107867-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Ftrace instances should be created physically in the tracefs, before
trying to access its files. In record_trace() function, the call to
make_instances() should be before the logic which reads the instance's
tracing file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index d8c24ebf..1e4d38fa 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -6222,6 +6222,8 @@ static void record_trace(int argc, char **argv,
 	if (!ctx->output)
 		ctx->output = DEFAULT_INPUT_FILE;
 
+	make_instances();
+
 	/* Save the state of tracing_on before starting */
 	for_all_instances(instance) {
 		instance->output_file = strdup(ctx->output);
@@ -6236,8 +6238,6 @@ static void record_trace(int argc, char **argv,
 			instance->tracing_on_init_val = 1;
 	}
 
-	make_instances();
-
 	if (ctx->events)
 		expand_event_list();
 
-- 
2.26.2

