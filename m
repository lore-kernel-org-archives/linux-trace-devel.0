Return-Path: <SRS0=APAm=Q4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24B14C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Feb 2019 12:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3DBF20855
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Feb 2019 12:42:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbfBUMm0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Feb 2019 07:42:26 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44705 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbfBUMm0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Feb 2019 07:42:26 -0500
Received: by mail-wr1-f67.google.com with SMTP id w2so15251943wrt.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 21 Feb 2019 04:42:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Zvty2bF86Z/urDeaR/L5i5e76KnWvFrHOsKzFJIF2vc=;
        b=SsRVgWJQcAr/CRZ/FYDuwkvbWucunECMob8NdMQAiwgv8cOBAMhoJjXwP0WzgaIOGi
         Sp2nWoXtQ0lV6ADaSVVogIVY6iVdfxN7OW8V8S8YoBu5XSe+4+NYyunT2paLC3NHn30M
         9Ec0I5LW1Ta3713DthEWrgD4AxFGkbS4rwKz/5y7wlc1n/wKOWxsjD+ZtciIqWElB3Jl
         SPdBbZ8Gb5WIqI32gf4MfjNRS+FxqAIXxJ93LxYQ+jt/RHBaheJ01s+Ip5+niGzpuXWR
         cMVaVfgtCp3s4kyQJ2Yqm4O60iq/2tluP+naiv14QkvV9qeAjaksNKL3cLOWon6qJx03
         4tZA==
X-Gm-Message-State: AHQUAuY70K8rSpAWJnL0P1pR8aKOKFXg6wJAU+MCQDyHb0bCX/Uex6iA
        4oud5oR21i5GdUXqPzGDOFBDMjsU
X-Google-Smtp-Source: AHgI3IZgVb5rB5tjKmpJaxuXoNDWydqcKSqryWMouvoBZjO3sSQnSxyIc32muTeQmmhqTp95d9f6zw==
X-Received: by 2002:a1c:4844:: with SMTP id v65mr11045416wma.66.1550752944767;
        Thu, 21 Feb 2019 04:42:24 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id b4sm1359517wrr.64.2019.02.21.04.42.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Feb 2019 04:42:24 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 3/3] kernel-shark: Fix a bug in ksmodel_set_next_bin_edge()
Date:   Thu, 21 Feb 2019 14:42:05 +0200
Message-Id: <20190221124205.21115-4-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190221124205.21115-1-ykaradzhov@vmware.com>
References: <20190221124205.21115-1-ykaradzhov@vmware.com>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The modification of the last bin of the model makes no sense (this is
my mistake). The comment above the code that is doing this modification
is partially correct, however it speaks about increasing the size of
the last bin, while the code below the comment changes the lower edge
of this bin. The actual increase of the size of the last bin is done in
ksmodel_set_upper_edge() where the lower edge of the Upper Overflow bin
gets shifted (max + 1). This effectively increases the size of the last bin.

Reported-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Fixes: f97e31f00 ("kernel-shark-qt: Introduce the visualization model ..")
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/libkshark-model.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/kernel-shark/src/libkshark-model.c b/kernel-shark/src/libkshark-model.c
index b6d3612..4bd1e2c 100644
--- a/kernel-shark/src/libkshark-model.c
+++ b/kernel-shark/src/libkshark-model.c
@@ -266,15 +266,6 @@ static void ksmodel_set_next_bin_edge(struct kshark_trace_histo *histo,
 	/* Calculate the beginning of the next bin. */
 	time = histo->min + next_bin * histo->bin_size;
 
-	/*
-	 * The timestamp of the very last entry of the dataset can be exactly
-	 * equal to the value of the upper edge of the range. This is very
-	 * likely to happen when we use ksmodel_set_in_range_bining(). In this
-	 * case we have to increase the size of the very last bin in order to
-	 * make sure that the last entry of the dataset will fall into it.
-	 */
-	if (next_bin == histo->n_bins - 1)
-		++time;
 	/*
 	 * Find the index of the first entry inside
 	 * the next bin (timestamp > time).
-- 
2.17.1

