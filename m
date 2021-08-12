Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5B85C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 22:34:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B680660FC0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 22:34:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234949AbhHLWea (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Aug 2021 18:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234716AbhHLWea (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Aug 2021 18:34:30 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083DFC061756
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Aug 2021 15:34:05 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id f3so9314275plg.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Aug 2021 15:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d/sF2/F9SeRx1P3U4gC4itbT1gl2Q+lqbpBD0R73xco=;
        b=QDlfBJCGgkDNCt6ryFZKYjaJe31SQMP+e/w94ORKDNvdMbHo5aQ2Ax6drM/UjSXd2p
         B0p3HDc+JJWmO4v9/wZoUdS9Ux0QOjkd1C0V7sM3/QHCj2UqlKTuKpDDIyZyVZyRylj8
         pNx45PY8M1UeRFKEKyWk1FvA+ykZc4nGf+kl09J6HldwSZtt6BvI3UhI9qIdUdWS94oj
         1n7X+vxBFfcOGrVrOFgD26Mss5xfqRnB3X6Pro4jQYbeTLFiR4wgv0eEqYHM2XbCtERS
         j7TMowB2ufMGwZtrQ4MqChrxqq7P4nVIWyp3OTl2TjegnexxKbO0C0T33GntPUabbaKw
         09Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d/sF2/F9SeRx1P3U4gC4itbT1gl2Q+lqbpBD0R73xco=;
        b=kB6+7pLdf3hbeub7eQAnFhBT45hj9PVI+4H8upLTUXj8H6sNNfXsPS/WTXxOPGGVtv
         LnViIYUq+NfzFw6VpriaY7OBNPiUpjOAQqaTNrZp77Qe7FpW7QT9Ll8jJHviGIbKLJVt
         rXz6n623gPPyQUxtDmjHLVvIHxodMF8zNB6Hw9Rf0QtwpY08spbUJD3hWYhNDVMM57kb
         CTx62ePLqnMtO3HlyVPcy+cQNH3HLL5d6hG0g8J2WQuOMIY5khPa3olPrKqDakWwC3zF
         YyV2xBwNo0d0R+xlENyKIgkfDirMS5iajSKyF3MXmZwVZ2MKuzOWsMqSnDwL0AcomvFN
         Sr4w==
X-Gm-Message-State: AOAM5332+alN9CNZAuZ/ntYC2OG+q0mqQX69RjyLVzCVeABBelrrasqW
        yzmBFkSEnDEVFQOsM3irYXpwsWxfS4etBQ==
X-Google-Smtp-Source: ABdhPJw/+zSjuu6DftiQ/teA8sYLnr/bO2fx8fjG08iHTcmGYDLpu1iJeeXgU4SZ7nJmz+VLUk+HkA==
X-Received: by 2002:a17:902:b601:b029:12b:d9a:894f with SMTP id b1-20020a170902b601b029012b0d9a894fmr5247337pls.63.1628807644411;
        Thu, 12 Aug 2021 15:34:04 -0700 (PDT)
Received: from localhost.localdomain ([185.153.176.156])
        by smtp.gmail.com with ESMTPSA id n23sm4689151pgv.76.2021.08.12.15.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 15:34:04 -0700 (PDT)
From:   victorcora98@gmail.com
To:     linux-trace-devel@vger.kernel.org
Cc:     Victor Cora Colombo <victorcora98@gmail.com>
Subject: [PATCH] trace-cmd: Add dependencies to BUILDING section in README
Date:   Thu, 12 Aug 2021 19:33:53 -0300
Message-Id: <20210812223353.28135-1-victorcora98@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Victor Cora Colombo <victorcora98@gmail.com>

KernelShark has instructions in its README on how to get necessary
dependencies to build it. trace-cmd could follow this example and
also add more information on how to build it.

This patch adds instructions to README on how to get necessary libraries
and dependencies to build trace-cmd.

Signed-off-by: Victor Cora Colombo <victorcora98@gmail.com>
---
 README | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/README b/README
index 1153152..16aedac 100644
--- a/README
+++ b/README
@@ -24,6 +24,20 @@ Lesser General Public License 2.1 (See COPYING.LIB).
 
 BUILDING:
 
+In order to install build dependencies on Ubuntu do the following:
+    sudo apt-get install build-essential git pkg-config bison flex -y
+
+To install required dependencies:
+    git clone https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
+    cd libtraceevent
+    make
+    sudo make install
+
+    git clone https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
+    cd libtracefs
+    make
+    sudo make install
+
 To make trace-cmd
     make
 
-- 
2.32.0

