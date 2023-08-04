Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4AB6C04A6A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Aug 2023 15:52:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbjHDPw3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Aug 2023 11:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232176AbjHDPw2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Aug 2023 11:52:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86E9170F;
        Fri,  4 Aug 2023 08:52:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55E836207A;
        Fri,  4 Aug 2023 15:52:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F84FC433CA;
        Fri,  4 Aug 2023 15:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691164346;
        bh=tPmxXhf66VncNKJK+vndDb+F6Ii3wvgP4mAYTkpL4kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I1i2HxIZaHgL1mgzvBOn23KDcqn+sK9vCqus1XqEdcnDg9GTncI29cMTFaospxsQA
         rPSC18psAjYUQQ9VXSGT9IuNF3GD7dG6DTezEFLKv7TxYd/rcwBeSemuZCkaBU/Nlu
         PJim7T0MNxbpa7YJE4qrJAPVQLAdGQx4aydG11DdqSOO3hCn3waCgDXGmI/QYdCX3N
         8d/b0ygvA2p+f/nhJwB+aass2JRtbkj8/lmoRbA+wgngkZ7vRJjdVx4TxpfM3tNcpe
         vZfnSsTrqzhh4jaEQjIma5xSV98a49NmD5jVfmn1+zOVJHtuL4uG0g88EZOCy1cTpV
         X0IUqGLhQhSxQ==
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     William White <chwhite@redhat.com>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: [PATCH 1/3] rtla/timerlat_aa: Zero thread sum after every sample analysis
Date:   Fri,  4 Aug 2023 17:52:11 +0200
Message-Id: <97bff55b0141f2d01b47d9450a5672fde147b89a.1691162043.git.bristot@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1691162043.git.bristot@kernel.org>
References: <cover.1691162043.git.bristot@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The thread thread_thread_sum accounts for thread interference
during a single activation. It was not being zeroed, so it was
accumulating thread interference over all activations.

It was not that visible when timerlat was the highest priority.

Fixes: 27e348b221f6 ("rtla/timerlat: Add auto-analysis core")
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
---
 tools/tracing/rtla/src/timerlat_aa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/tracing/rtla/src/timerlat_aa.c b/tools/tracing/rtla/src/timerlat_aa.c
index e0ffe69c271c..dec5b4c4511e 100644
--- a/tools/tracing/rtla/src/timerlat_aa.c
+++ b/tools/tracing/rtla/src/timerlat_aa.c
@@ -159,6 +159,7 @@ static int timerlat_aa_irq_latency(struct timerlat_aa_data *taa_data,
 	taa_data->thread_nmi_sum = 0;
 	taa_data->thread_irq_sum = 0;
 	taa_data->thread_softirq_sum = 0;
+	taa_data->thread_thread_sum = 0;
 	taa_data->thread_blocking_duration = 0;
 	taa_data->timer_irq_start_time = 0;
 	taa_data->timer_irq_duration = 0;
-- 
2.38.1

