Return-Path: <SRS0=Wcha=6O=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D3C1C8300A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 Apr 2020 12:22:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C1282076D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 Apr 2020 12:22:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g9SexKs9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgD3MWb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 30 Apr 2020 08:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726500AbgD3MWb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 30 Apr 2020 08:22:31 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506DCC035494
        for <linux-trace-devel@vger.kernel.org>; Thu, 30 Apr 2020 05:22:31 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id f18so6208174lja.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 30 Apr 2020 05:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DZT5tWoSHDQAvAO50v+sySA4a79lkTuf/l0j81w5//0=;
        b=g9SexKs9zqqIF0R/04d5bUwAlpLOUi1/zg3nSbwLaUSvJ1M9epuyUjEJiuCWezZtHO
         zr9gT28YZ7EdeS1jRSHr2hfmQUYJSOC4X6JvRPKfv3UXEE2KC6es+8KmJCTeaWOBwaD4
         Qn5M63vKYlKo7DylVkr9xSGLB3Q6482eEmGwbkt7TEVAOjAtbw2Tc5sLZl48WiDAjnOj
         uCXpUhWKF6MJe2QIfmMICgvK7BMN7dUBB699c1QFRqz3IvXJDasca6URUtNRKwqDxMiR
         GQE96GwV3dqdchQlzPC9pGiJ1S5JSdVTwTg+g2AmVfRniv8g3Wu49jG9UHIYOdRje2+I
         CaAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DZT5tWoSHDQAvAO50v+sySA4a79lkTuf/l0j81w5//0=;
        b=FkWuohDL2lQbiELOY2V+kmXRQFhglA8uLKJlDdLttlssa/V8+deOAzRWKSfIyv/VNP
         Sjb7cJCQQUxx24NSfZlzYZaJ6fKjO01wfiFJLTUPROlYSppUpAMW5dXRZWHBUqyAgXt1
         DZlIL1zvVX2ERiQnD8UJTHG/npr5K19gHsVaEIgt7QyA5+6Ucru2gDidT8Y65JpHYJ+c
         IWMvBOtwCUx1iRTJB9iV0KjQVsqxkc4zzoQBvJBL8oULQi+uI6c6Eg9lxBeuqpn3XyLk
         kDWi5NrCLbcJI5ACpRU5KEzzShafkg9BrW4I5eAOTbskaN3a2p6TNcubtQuDDscZi6p4
         gpUA==
X-Gm-Message-State: AGi0Pub/8wcDPvGFoI38PFJ/+8RNMGYOhHt2yVej05Q35gOqK46y58Kn
        XoxnvWjiWSdw4b87xCOiYUw=
X-Google-Smtp-Source: APiQypIr8D/eYNAhxeYh2E+0guqFJqliQ8qwaN4JrODeJD095spTPRh/bMf/13WONPioRNyDH//pPQ==
X-Received: by 2002:a2e:3208:: with SMTP id y8mr2083714ljy.282.1588249349845;
        Thu, 30 Apr 2020 05:22:29 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id a26sm4793168lfl.66.2020.04.30.05.22.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 05:22:29 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/4] trace-cmd: Create ftrace instances before using them.
Date:   Thu, 30 Apr 2020 15:22:21 +0300
Message-Id: <20200430122222.101276-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200430122222.101276-1-tz.stoyanov@gmail.com>
References: <20200430122222.101276-1-tz.stoyanov@gmail.com>
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
2.25.4

