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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2EDBC433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:53:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8039613D6
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:53:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236867AbhEGJyo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 May 2021 05:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236599AbhEGJym (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 May 2021 05:54:42 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7563FC061574
        for <linux-trace-devel@vger.kernel.org>; Fri,  7 May 2021 02:53:42 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id f24so12675471ejc.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 07 May 2021 02:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z0LcYKshq465WgeE8dPD2Nn0zo3Dp6s7Ui2Y7fj6Jpk=;
        b=s4RYRCE0LPwhEck40T3dYENjz4UrTm2LzWLxGv8rRIBK5t9BA3ktFPyzxYUFVQKswI
         BFQgVDYg04k17KLrNbikoUeztWE5yw0tQSRKh1L7bUVroJ6mot6nBn46Q4Oq1kSm31ic
         UyVIwHiOgLAd4w1WUao9nHepvSf4DuRk8B2BFXigVGF4EnyJ/YfhfniTplSc0+nB3/Hf
         DdZ7tO+BCMNRIyik6uGChCNhHfpij9cQGjRe7LD6bTwNmbqXCq0y1l2qEga1uVveyIXb
         NOU6XEaEk3YmnmoaO+t5ZMIxEFfRfQK4EKLjKuHfflvnlhNdBEEp+pQBaj3zO/AnAyi+
         W43Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z0LcYKshq465WgeE8dPD2Nn0zo3Dp6s7Ui2Y7fj6Jpk=;
        b=FpYVPRTCmpg7Kd/fKuClxzy7S7Xh39J2NVHOXz17cpjzzunaB766bbWz654i/QQLYD
         LYC0/EdM10LlOBC8TNHbLUlmkXERbDBOBSIw5nInAGRiNZKbucrkZekafuk/8mBfVLIX
         FJk99KsvBU8W3LonW98G7TnIS0+FHeS7MD9U4wuAbj7ZUNyjeFYJVNNdXW6PIlYmTT2t
         eu1cgdB9twDYTsFJvKFEJeEQzVmtnCH8mgzOEcWWl6aVkVdPix7q/3yUF654Ag1H9XqQ
         alwYKJRYMjni7cB1LrK2Gz6LUPRvH43wNFpDl1aMLV9IWO4mtvA5w+RrkTENxOmVj6Cm
         ku1g==
X-Gm-Message-State: AOAM530oknKCYDwMtSe0epP0U/1jGj1Qpxc8Er9sdjrdwfNnyNOU+iRV
        CqCmdXxYMyxbiIYQk9EO3PkCH1CT+3hm9A==
X-Google-Smtp-Source: ABdhPJw77PetzbymOZ49MKp62E5xotCN06x7tmUN1UMyJvzrxa6M6Mtqaes8RIjQ8Z4UgOC4s32WnQ==
X-Received: by 2002:a17:906:58d1:: with SMTP id e17mr9253504ejs.179.1620381221259;
        Fri, 07 May 2021 02:53:41 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id cr21sm3105812ejc.2.2021.05.07.02.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 02:53:40 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 7/8] trace-cmd report: Set the log level with -V and -q options
Date:   Fri,  7 May 2021 12:53:32 +0300
Message-Id: <20210507095333.1080910-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210507095333.1080910-1-tz.stoyanov@gmail.com>
References: <20210507095333.1080910-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When "trace-cmd report -V" is specified, set the log level to INFO.
When "trace-cmd report -q" is specified, set the log level to NONE.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-read.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index b315283e..0cf6e773 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1703,9 +1703,11 @@ void trace_report (int argc, char **argv)
 			break;
 		case 'V':
 			show_status = 1;
+			tracecmd_set_loglevel(TEP_LOG_INFO);
 			break;
 		case 'q':
 			silence_warnings = 1;
+			tracecmd_set_loglevel(TEP_LOG_NONE);
 			break;
 		case OPT_cpu:
 			parse_cpulist(optarg);
-- 
2.31.1

