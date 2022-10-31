Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6F23ECAAA1
	for <linux-trace-devel@archiver.kernel.org>; Mon, 31 Oct 2022 21:38:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiJaVh7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 31 Oct 2022 17:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiJaVh6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 31 Oct 2022 17:37:58 -0400
X-Greylist: delayed 964 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 31 Oct 2022 14:37:56 PDT
Received: from mailrelay4-2.pub.mailoutpod2-cph3.one.com (mailrelay4-2.pub.mailoutpod2-cph3.one.com [IPv6:2a02:2350:5:409::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DC61403F
        for <linux-trace-devel@vger.kernel.org>; Mon, 31 Oct 2022 14:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berginkonsult.se; s=rsa1;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
         from;
        bh=G+/FgcLPunIFc0v/Qys6a6DaVoXUSiiAG9nSRw/qIN8=;
        b=P37uZgLf5KU4Dwr8fN9J/vTNW+evUAcHeqrD2rQc5z0GB2tajAnxzm4YZn/IhOdpQj0Fi/m23DP6S
         zcr3pf95IRNi6PUFKy30DKf084RPagSoTx0mslVix6JguQF+7Qt1GbEx3AvAm1L6+Y20AqYOInVWGV
         00/YL9pyg4ubxK+NKPQmdVV0aUoWCRIpUyxGgTpTRenlC8DeoFxo8r3vHG+kJVVGVPxStobhrtmc/c
         9mr5enClNEdte+Cigwj95WJXHegOLrbZk45WwojP0JbQzjCfQxi3BNYSCRL2wZ3bqkYAgaCeDqan/L
         RI/h8rmgBT4hRMLi9gaGyRG/uy4Esdw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
        d=berginkonsult.se; s=ed1;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
         from;
        bh=G+/FgcLPunIFc0v/Qys6a6DaVoXUSiiAG9nSRw/qIN8=;
        b=I8fYYNhxYgEfG1mvwYvpEDtmIIhRi5elNb3w/XPFh6YO9Q4aF6gxavdJy9BHLDwpFqAnQt7SrbY2h
         st6owHwBA==
X-HalOne-ID: 060403ef-5962-11ed-baee-45c065e8efb0
Received: from pbergin-7420.. (ua-213-113-159-147.bbcust.telenor.se [213.113.159.147])
        by mailrelay4 (Halon) with ESMTPSA
        id 060403ef-5962-11ed-baee-45c065e8efb0;
        Mon, 31 Oct 2022 21:21:50 +0000 (UTC)
From:   Peter Bergin <peter@berginkonsult.se>
To:     linux-trace-devel@vger.kernel.org
Cc:     Peter Bergin <peter@berginkonsult.se>
Subject: [PATCH] libtraceevent: make it possible to set libdir and mandir from outside
Date:   Mon, 31 Oct 2022 22:21:40 +0100
Message-Id: <20221031212140.170601-1-peter@berginkonsult.se>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When building in build frameworks such as openembedded it is desired
to use the defintion of libdir and mandir from the build framework.

Signed-off-by: Peter Bergin <peter@berginkonsult.se>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index fab8f7e..e974117 100644
--- a/Makefile
+++ b/Makefile
@@ -46,8 +46,8 @@ endif
 
 libdir_relative ?= $(libdir_relative_temp)
 prefix ?= /usr/local
-libdir = $(prefix)/$(libdir_relative)
-man_dir = $(prefix)/share/man
+libdir ?= $(prefix)/$(libdir_relative)
+man_dir ?= $(prefix)/share/man
 man_dir_SQ = '$(subst ','\'',$(man_dir))'
 pkgconfig_dir ?= $(word 1,$(shell $(PKG_CONFIG) 		\
 			--variable pc_path pkg-config | tr ":" " "))
-- 
2.34.1

