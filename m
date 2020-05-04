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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5FECC3A5A9
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 06:27:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5181206EB
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 06:27:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fv0eWr8B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgEDG1T (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 May 2020 02:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbgEDG1T (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 May 2020 02:27:19 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E09C061A0E
        for <linux-trace-devel@vger.kernel.org>; Sun,  3 May 2020 23:27:18 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id b24so8697844lfp.7
        for <linux-trace-devel@vger.kernel.org>; Sun, 03 May 2020 23:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2NBZ1LuATzVc7Xyf6NgNIDbMe7hwPDdsRUWSbR/nmlA=;
        b=Fv0eWr8BuCBPCx8sUxGkjyo6pdNZwDEpgxD4oMdOl/e4py9zqwFq+XEIZgtMLbWNM2
         V2PqCWVZcyZFVvRM76j1UMvN6qzI2EtONBnmaPCTfuXfib3h3qAiHpm1qA95eoHpDlAo
         +cQh6yiEMXwMQCGNfvlttLLu9HD+J7x971EIWO+Z7DKqlWaxK3gu2EA83ECv8jv6CZVJ
         Sht958JYGMt7KH1PU3UK79AtBOnQmbw/mFMdWo68ycLkrJHR0WMOQUO1F88PkwiHE1MD
         7z9rqQIeoyr/2LatgRGCJlwA5FXV1s+zLdSWqeU5oBJiKVJD91R8dswW7L9fRPPPtgGG
         cszw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2NBZ1LuATzVc7Xyf6NgNIDbMe7hwPDdsRUWSbR/nmlA=;
        b=NJnXKyNb2qd0bORX0IUUmdgJINXumH9QiJbSPhoMHbNF8xiW9VEjELZP56wHHRQ8Y/
         QJ9TzKkPhXzhIulwWbm7yAwxktMNYMWSdHU1VqZ9H+VNMxIb8DDXSbndpc2DDZ7se20M
         /kfv4/EYhGIpZG5PzD5o3i1celQKq9wdYrOq8snZRl12RCXEDCVMsYxBbiCL9EaXsBBp
         TRh6AzqwQRwVSr+OmKgi/OapIjs7dFu+85DAqgyJUz++oyC5RQW8FfGjkDGH3c7pC1wF
         3mVSshvqybn7l7ZWGpe/GM8d/M7U1fSCR5i1oet4lUMnys7bGRKiK4Df/R8A+AJfUaIX
         d5Ww==
X-Gm-Message-State: AGi0PuZ5IXYCiG04lMN4BBqFLwi3U3uLx5MYyhyxcDVnt1L+i1bsXQJF
        wjd/XwN8c2a3MuR4v77kCUU=
X-Google-Smtp-Source: APiQypLlo/P3ySZ5/RJmxMmKS/I9zF6/hFAeE4QCo9ZjkKw/c/q+sP5Pxb7mgLXTgOsDdpz9WzELsw==
X-Received: by 2002:a19:2282:: with SMTP id i124mr10427295lfi.98.1588573636800;
        Sun, 03 May 2020 23:27:16 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u6sm7397150ljd.68.2020.05.03.23.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2020 23:27:16 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/4] trace-cmd: Add "main" in the output of trace-cmd stat when displaying main instance
Date:   Mon,  4 May 2020 09:27:09 +0300
Message-Id: <20200504062711.107867-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504062711.107867-1-tz.stoyanov@gmail.com>
References: <20200504062711.107867-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

By default, "trace-cmd stat" command prints status of the main ftrace instance. When more
instances are configured, the user could be confused which status is displayed.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-stat.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
index c5057978..dcf2789c 100644
--- a/tracecmd/trace-stat.c
+++ b/tracecmd/trace-stat.c
@@ -920,8 +920,10 @@ static void stat_instance(struct buffer_instance *instance)
 			printf("---------------\n");
 		printf("Instance: %s\n",
 			tracefs_instance_get_name(instance->tracefs));
-	} else
+	} else {
 		report_instances();
+		printf("\nInstance: main\n\n");
+	}
 
 	report_plugin(instance);
 	report_events(instance);
-- 
2.26.2

