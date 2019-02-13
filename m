Return-Path: <SRS0=ndxz=QU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7E2DC282CA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Feb 2019 16:13:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A03820700
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Feb 2019 16:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404331AbfBMQNC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Feb 2019 11:13:02 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34626 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404347AbfBMQNC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Feb 2019 11:13:02 -0500
Received: by mail-wm1-f68.google.com with SMTP id y185so2235098wmd.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Feb 2019 08:13:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mKs1zarKSC8o1Uy90Brrsr+wBlmMCuceYalzEjoBYt4=;
        b=ekd0KgMdkSGnloLUwlCjuEgz9SuuNbBvv32P5ZccaNDFO+2LPvPICqAzcUXhpSQmg/
         INxbu6wisr39E0i87F8O5EsiMzqRiw8dc5eK2Nyk6fmbQzmkaWO8WZA1s2tAT8gFzyW3
         4mmYAN5j8kzjfiPueAqCRRs4HUoDqBnTECKKBCvs7HPIKSbYj4/ZFZ1mkvEhel2SOwsu
         d1qPsW68gFnbcNcL1/C3sOypllPbjTLydUuwB4428mMiLteAWpppQsvT+yPlrm7PJem3
         EqxODgEvtaXyu5SgL8pTEIMAt8/RRnU2N7MfcqYHUao99HcAhpAblDSNJFpux0Kw8fFC
         v6zA==
X-Gm-Message-State: AHQUAuYhUCHwTjYI5OwquNRI8WjLcMXftMwOYxldd5Tod7hEXQL9klET
        2R1ZF4ZlUefO17cfCeseg/0=
X-Google-Smtp-Source: AHgI3Ia+qybbPRmPMhWan0yTdYD3DGCR35T81ZfW2bli5SWhaym88JYQPsqGdO9dZm+Eusxs3jRuBw==
X-Received: by 2002:a1c:c008:: with SMTP id q8mr818983wmf.99.1550074380616;
        Wed, 13 Feb 2019 08:13:00 -0800 (PST)
Received: from localhost.localdomain ([95.87.211.218])
        by smtp.gmail.com with ESMTPSA id h9sm3111631wrv.11.2019.02.13.08.12.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Feb 2019 08:13:00 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 6/8] kernel-shark: Fix the compile warnings about _GNU_SOURCE being redefined
Date:   Wed, 13 Feb 2019 18:12:14 +0200
Message-Id: <20190213161216.14438-7-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190213161216.14438-1-ykaradzhov@vmware.com>
References: <20190213161216.14438-1-ykaradzhov@vmware.com>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fixes wornings from:

kernel-shark/src/libkshark-configio.c

and

kernel-shark/src/libkshark-plugin.c

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/libkshark-configio.c | 4 ++++
 kernel-shark/src/libkshark-plugin.c   | 5 +++++
 2 files changed, 9 insertions(+)

diff --git a/kernel-shark/src/libkshark-configio.c b/kernel-shark/src/libkshark-configio.c
index d7b8a69..ab88864 100644
--- a/kernel-shark/src/libkshark-configio.c
+++ b/kernel-shark/src/libkshark-configio.c
@@ -10,8 +10,12 @@
   */
 
 // C
+#ifndef _GNU_SOURCE
 /** Use GNU C Library. */
 #define _GNU_SOURCE
+
+#endif
+
 #include <stdio.h>
 #include <sys/stat.h>
 
diff --git a/kernel-shark/src/libkshark-plugin.c b/kernel-shark/src/libkshark-plugin.c
index 10e4647..4b21392 100644
--- a/kernel-shark/src/libkshark-plugin.c
+++ b/kernel-shark/src/libkshark-plugin.c
@@ -10,7 +10,12 @@
   */
 
 // C
+#ifndef _GNU_SOURCE
+/** Use GNU C Library. */
 #define _GNU_SOURCE
+
+#endif
+
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-- 
2.17.1

