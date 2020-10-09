Return-Path: <SRS0=rOCb=DQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F070C433E7
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Oct 2020 14:04:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C624522267
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Oct 2020 14:03:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QUj4Dh5s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387416AbgJIOD7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Oct 2020 10:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729347AbgJIOD7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Oct 2020 10:03:59 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA8FC0613D2
        for <linux-trace-devel@vger.kernel.org>; Fri,  9 Oct 2020 07:03:57 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id p15so13237618ejm.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 09 Oct 2020 07:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kWUa9elM/32MOlBImDPhdkbbNdIMDTU8dzsrjWEnb84=;
        b=QUj4Dh5sO07WfzsnWl2KlzYkV8kgBAQv7VXedXfw9g7I2uG2fJh3XsW8r6T3W9nwWU
         P+Eh4FVrnnqykBo3dR4uiFpLDK7gcYmyEz6FxdnHMmR6k3AorijttaCsTXPXoEViFdo/
         UJ4TGgE0ffYF2H5cTBR4+NGGETlTo/J37NPlzYhnGoCVNRRx9j3TD6pejtvqSDOk6LH/
         LFOjbeKTMcxdxWQyScny5CD68iXQLzGQrq/z8imjVeOJctbCayfPkawZjTJG/KmvInHL
         z8K1uI8MAB5xUmODfcKflEP0GJ97lsJElXsrsxRmaMUySNmINPsQGccD2NAEvSAGBRxX
         xrgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kWUa9elM/32MOlBImDPhdkbbNdIMDTU8dzsrjWEnb84=;
        b=VbKJw0sVptdjj1hoej3f5th4yxtvr5TWuwLhesLU6PH0dhlnOn4QQFBXGNJuZwWvk8
         Pq9dc/TSv2sDzU2hcnhfsGpXAFHP7340MEWp97PdoVGtoHzNlwOBPRLqfPqhq+7T+RAZ
         LQ37xjTirS1nbs7Pv+QuDJmtsrU74/CBdEuPvhmfZb8vSSOdj8dESenOVQ53V9x9mPqf
         HAKgosqI3xoS8VrNIU813E2dUbyrERH/bvw0+3j8bc6UJuxcjwVJwRGi2L4LjWtwa9sL
         uwpvLNNO2RQkA/kfxYWDeEajw+DuXMtEG47Gqex2MgKOfkiNmgzkuDhza7c/73nVbmpH
         2J4w==
X-Gm-Message-State: AOAM530VeCcZ+zrfHT2kYP/KQtTP+RoIF44GDbs3b+nTOgNAnotgIq2D
        mjO62/dfKkQqY2L4euEIyHU=
X-Google-Smtp-Source: ABdhPJxNiLEdZ/Zu46R/9r2B88MQ2I2qSYgMVqLm3wknN/1tu+tKT14SIbY1PHHZGLJ2yk8n5ApNxQ==
X-Received: by 2002:a17:906:4c84:: with SMTP id q4mr14716281eju.525.1602252236430;
        Fri, 09 Oct 2020 07:03:56 -0700 (PDT)
Received: from localhost.localdomain ([151.251.253.218])
        by smtp.gmail.com with ESMTPSA id ck19sm6362483ejb.99.2020.10.09.07.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 07:03:55 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v24 09/10] trace-cmd: Fixed bitmask logic tracecmd_tsync_proto_getall()
Date:   Fri,  9 Oct 2020 17:03:37 +0300
Message-Id: <20201009140338.25260-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201009140338.25260-1-tz.stoyanov@gmail.com>
References: <20201009140338.25260-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The tracecmd_tsync_proto_getall () function returns a bitmask of all
registered timestamp synchronization plugins, which match given criteria.
There was a bug in that logic - it was working with wrong bitmask size,
 which leads to broken bitmask.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-timesync.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 10ab82f0..2fbb319b 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -217,21 +217,21 @@ int tracecmd_tsync_proto_getall(char **proto_mask, int *words, const char *clock
 		if (proto->proto_id > proto_max)
 			proto_max = proto->proto_id;
 
-	count = proto_max / PROTO_MASK_SIZE + 1;
-	protos = calloc(count, sizeof(char));
+	count = proto_max / PROTO_MASK_BITS + 1;
+	protos = calloc(count, PROTO_MASK_SIZE);
 	if (!protos)
 		return -1;
 
 	for (proto = tsync_proto_list; proto; proto = proto->next) {
-		if ((proto->proto_id / PROTO_MASK_SIZE) >= count)
+		if ((proto->proto_id / PROTO_MASK_BITS) >= count)
 			continue;
 		if (!(proto->roles & role))
 			continue;
 		if (proto->supported_clocks && clock_id &&
 		    !(proto->supported_clocks & clock_id))
 			continue;
-		protos[proto->proto_id / PROTO_MASK_SIZE] |=
-				(1 << (proto->proto_id % PROTO_MASK_SIZE));
+		protos[proto->proto_id / PROTO_MASK_BITS] |=
+				(1 << (proto->proto_id % PROTO_MASK_BITS));
 	}
 
 	*proto_mask = protos;
-- 
2.26.2

