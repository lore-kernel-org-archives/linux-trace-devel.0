Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9D64C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Nov 2022 11:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbiKALNC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 1 Nov 2022 07:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiKALNB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 1 Nov 2022 07:13:01 -0400
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 01 Nov 2022 04:12:59 PDT
Received: from mailrelay1-1.pub.mailoutpod1-cph3.one.com (mailrelay1-1.pub.mailoutpod1-cph3.one.com [46.30.210.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298F619026
        for <linux-trace-devel@vger.kernel.org>; Tue,  1 Nov 2022 04:12:58 -0700 (PDT)
Received: from mailrelay1.pub.mailoutpod2-cph3.one.com (mailrelay1.pub.mailoutpod2-cph3.one.com [104.37.34.6])
        by mailrelay1.pub.mailoutpod1-cph3.one.com (Halon) with ESMTPS
        id fe7ffdc0-59d5-11ed-a6d5-d0431ea8a283;
        Tue, 01 Nov 2022 11:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berginkonsult.se; s=rsa1;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
         from;
        bh=XEuiC55CqcY5Y45IzRom2Xf5gahr398JY0NHtYJwDWY=;
        b=Gf/7WqVdp939t3bSGc4OzcxyYgy1Mr0TQa69UogW6DR7muYN9qEQw/505bOQgU/vUanspiMEjtcI2
         kTDmnuoOwRrf1QnVnHYU3Kbh3GcLO9y2OfO/l9GYdg81Qll3RW/BzXSEpNJDq/WD+DNW9tGE1Iz9Ko
         O8zCbiPpEgJD+Oym+3428Lb0JwkLtqs7GyOB7KrItFKVe7OPFpWB8osvAPBZj36/k9XNTO9/24CI+y
         I1PYHPUg1yOPcApM4ZWBsfIKAc9idpuxeECIoNGLCnsukNeUOQ91kFuwgknaoR5+PeDaOnQ3ylKA/L
         3WM60DjOBZvR4PlRzv4A/r/s5YMfxjQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
        d=berginkonsult.se; s=ed1;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
         from;
        bh=XEuiC55CqcY5Y45IzRom2Xf5gahr398JY0NHtYJwDWY=;
        b=AwOlnIqUP1cynFAQjNAf222pt/BLeNASJwJ5dVifLvFZ+7P46NWDk4+dMRMkltChSMDTHE8SRtXzm
         HTGCtVQDw==
X-HalOne-ID: fc1220ba-59d5-11ed-98b9-1b2345786432
Received: from pbergin-7420.. (ua-213-113-159-147.bbcust.telenor.se [213.113.159.147])
        by mailrelay1 (Halon) with ESMTPSA
        id fc1220ba-59d5-11ed-98b9-1b2345786432;
        Tue, 01 Nov 2022 11:11:54 +0000 (UTC)
From:   Peter Bergin <peter@berginkonsult.se>
To:     linux-trace-devel@vger.kernel.org
Cc:     Peter Bergin <peter@berginkonsult.se>
Subject: [PATCH v2] libtracefs: make it possible to set libdir,includedir and mandir from outside
Date:   Tue,  1 Nov 2022 12:11:43 +0100
Message-Id: <20221101111143.191772-1-peter@berginkonsult.se>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When building in build frameworks such as openembedded it is desired
to use the defintion of directories from the build framework.

Signed-off-by: Peter Bergin <peter@berginkonsult.se>
---
v2: corrected prefix to libtracefs (from libtraceevent)

 Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 54ea247..8a6c697 100644
--- a/Makefile
+++ b/Makefile
@@ -52,12 +52,12 @@ endif
 
 libdir_relative ?= $(libdir_relative_temp)
 prefix ?= /usr/local
-man_dir = $(prefix)/share/man
+man_dir ?= $(prefix)/share/man
 man_dir_SQ = '$(subst ','\'',$(man_dir))'
-libdir = $(prefix)/$(libdir_relative)
+libdir ?= $(prefix)/$(libdir_relative)
 libdir_SQ = '$(subst ','\'',$(libdir))'
 includedir_relative ?= include/tracefs
-includedir = $(prefix)/$(includedir_relative)
+includedir ?= $(prefix)/$(includedir_relative)
 includedir_SQ = '$(subst ','\'',$(includedir))'
 pkgconfig_dir ?= $(word 1,$(shell $(PKG_CONFIG) 		\
 			--variable pc_path pkg-config | tr ":" " "))
-- 
2.34.1

