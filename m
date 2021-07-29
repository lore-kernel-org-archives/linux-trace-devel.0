Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54783C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 15:14:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32D9A60462
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 15:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbhG2PO7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 11:14:59 -0400
Received: from gateway34.websitewelcome.com ([192.185.148.140]:26568 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229864AbhG2PO7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 11:14:59 -0400
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id C3B19171F6
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Jul 2021 09:50:22 -0500 (CDT)
Received: from gator4132.hostgator.com ([192.185.4.144])
        by cmsmtp with SMTP
        id 97McmStQxLjoR97McmkIMk; Thu, 29 Jul 2021 09:50:22 -0500
X-Authority-Reason: nr=8
Received: from host-95-239-202-226.retail.telecomitalia.it ([95.239.202.226]:48616 helo=f34.bristot.me)
        by gator4132.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <bristot@kernel.org>)
        id 1m97Mc-002CQn-6W; Thu, 29 Jul 2021 09:50:22 -0500
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>
Subject: [PATCH 0/3] libtracefs documentation fixes
Date:   Thu, 29 Jul 2021 16:50:07 +0200
Message-Id: <cover.1627568431.git.bristot@kernel.org>
X-Mailer: git-send-email 2.31.1
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
X-Exim-ID: 1m97Mc-002CQn-6W
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: host-95-239-202-226.retail.telecomitalia.it (f34.bristot.me) [95.239.202.226]:48616
X-Source-Auth: kernel@bristot.me
X-Email-Count: 20
X-Source-Cap: YnJpc3RvdG1lO2JyaXN0b3RtZTtnYXRvcjQxMzIuaG9zdGdhdG9yLmNvbQ==
X-Local-Domain: no
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

I started using libtracefs last week, and I am really impressed!

While learning about it, I ended up finding three small issues
in the documentation, here they are.

Daniel Bristot de Oliveira (3):
  libtracefs: Fix example in libtracefs-events-tep
  libtracefs: Fix example in libtracefs-events
  libtracefs: Fix a typo in libtracefs-files

 Documentation/libtracefs-events-tep.txt | 2 +-
 Documentation/libtracefs-events.txt     | 2 +-
 Documentation/libtracefs-files.txt      | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.31.1

