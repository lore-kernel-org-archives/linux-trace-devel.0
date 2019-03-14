Return-Path: <SRS0=grb/=RR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B510C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 15:10:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7F0E20811
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 15:10:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbfCNPKt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 11:10:49 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45911 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfCNPKt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 11:10:49 -0400
Received: by mail-pf1-f196.google.com with SMTP id v21so4019434pfm.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Mar 2019 08:10:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y3cbyVMfq+8I0WeCaweE+oE9AfAwLE3JBJg9n2ZIxCo=;
        b=XWTC2nuFYJLpBrLtGJi05L1Ne/t1LJKLdG5/mup8jehoDhy8arVyeFyC5b3sCFoT1q
         PTdF6ZRqHu9ahlFD6xK9RFD0xay7LD3Sf1Mk6l9LkHiHTwTrPH7ZgVCFRJ2DXLi8UWLZ
         hZBY3eLSxTk7geY5Ehf08iAMDZ9wE/11YHMHyzUfF92SiA9bGAFif93Kvlav3FYantKx
         LF9wUqCRcFzDxesZ1xDh7XciHEeNF2B3llWFprxZ6HvzVyvkR9v94u26qE+FFx0oqkLF
         0hLIN0HsO6t2ImG/fT4aRvr1gSWucydbWD4t6hHyXdJsP7/VNRdifdh4lYEgn+wBpcvx
         RPwg==
X-Gm-Message-State: APjAAAUgY0gPPLBiO82rdpUCjtSz7k0aYyBfqAe8matCKnr8IKF9Dg2R
        d4xXLtxlrafg5uxOpTQt1RE=
X-Google-Smtp-Source: APXvYqzaD/i83XSjsgalTHw5Wt+kWzUW2I3DbH65QA+70feDACHmRxxsABLUTi8wmbxihSrbiF4NOw==
X-Received: by 2002:a17:902:7b92:: with SMTP id w18mr4065208pll.237.1552576248973;
        Thu, 14 Mar 2019 08:10:48 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f65sm8165585pfg.98.2019.03.14.08.10.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Mar 2019 08:10:48 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 10/12] kernel-shark: Avoid 0/0 spliter ratio in KsSession
Date:   Thu, 14 Mar 2019 17:10:10 +0200
Message-Id: <20190314151012.905-11-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190314151012.905-1-ykaradzhov@vmware.com>
References: <20190314151012.905-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Sometimes when we save the session QSplitter::sizes() returns
0/0 ratio (no idea why). Later when we load the session the
0/0 ratio results in misbehavior of the splitter position.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsSession.cpp | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel-shark/src/KsSession.cpp b/kernel-shark/src/KsSession.cpp
index b151818..9d86776 100644
--- a/kernel-shark/src/KsSession.cpp
+++ b/kernel-shark/src/KsSession.cpp
@@ -256,7 +256,7 @@ void KsSession::loadSplitterSize(QSplitter *splitter)
 {
 	kshark_config_doc *spl = kshark_config_alloc(KS_CONFIG_JSON);
 	json_object *jspl, *jgraphsize, *jviewsize;
-	int graphSize, viewSize;
+	int graphSize(1), viewSize(1);
 	QList<int> sizes;
 
 	if (!kshark_config_doc_get(_config, "Splitter", spl))
@@ -269,6 +269,10 @@ void KsSession::loadSplitterSize(QSplitter *splitter)
 
 		graphSize = json_object_get_int(jgraphsize);
 		viewSize = json_object_get_int(jviewsize);
+		if (graphSize == 0 && viewSize == 0) {
+			/* 0/0 spliter ratio is undefined. Make it 1/1. */
+			viewSize = graphSize = 1;
+		}
 	}
 
 	sizes << graphSize << viewSize;
-- 
2.19.1

