Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E3BDC4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 15:39:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0F7760F01
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 15:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237854AbhG2Pjh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 11:39:37 -0400
Received: from gateway22.websitewelcome.com ([192.185.46.156]:12060 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237846AbhG2Pjg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 11:39:36 -0400
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id 18047569F3
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Jul 2021 09:52:27 -0500 (CDT)
Received: from gator4132.hostgator.com ([192.185.4.144])
        by cmsmtp with SMTP
        id 97MgmzCLcMGeE97MgmGmam; Thu, 29 Jul 2021 09:50:26 -0500
X-Authority-Reason: nr=8
Received: from host-95-239-202-226.retail.telecomitalia.it ([95.239.202.226]:48616 helo=f34.bristot.me)
        by gator4132.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <bristot@kernel.org>)
        id 1m97Mg-002CQn-12; Thu, 29 Jul 2021 09:50:26 -0500
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>
Subject: [PATCH 3/3] libtracefs: Fix a typo in libtracefs-files
Date:   Thu, 29 Jul 2021 16:50:10 +0200
Message-Id: <0da236ead7e1e7364423f9bcc3c4688d9b313fbb.1627568431.git.bristot@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1627568431.git.bristot@kernel.org>
References: <cover.1627568431.git.bristot@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4132.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.org
X-BWhitelist: no
X-Source-IP: 95.239.202.226
X-Source-L: No
X-Exim-ID: 1m97Mg-002CQn-12
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: host-95-239-202-226.retail.telecomitalia.it (f34.bristot.me) [95.239.202.226]:48616
X-Source-Auth: kernel@bristot.me
X-Email-Count: 29
X-Source-Cap: YnJpc3RvdG1lO2JyaXN0b3RtZTtnYXRvcjQxMzIuaG9zdGdhdG9yLmNvbQ==
X-Local-Domain: no
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

s/trasefs/tracefs/

Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
---
 Documentation/libtracefs-files.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/libtracefs-files.txt b/Documentation/libtracefs-files.txt
index dc85f2d..d6da507 100644
--- a/Documentation/libtracefs-files.txt
+++ b/Documentation/libtracefs-files.txt
@@ -24,7 +24,7 @@ system mount point and trace files in it.
 
 The _tracefs_get_tracing_file()_ function returns the full path of the
 file with given _name_ in the trace file system. The function works
-only with files in the trasefs main directory, it is not trace instance
+only with files in the tracefs main directory, it is not trace instance
 aware. It is recommended to use _tracefs_instance_get_file()_ and
 _tracefs_instance_get_dir()_ instead. The returned string must be freed
 with _tracefs_put_tracing_file()_.
-- 
2.31.1

