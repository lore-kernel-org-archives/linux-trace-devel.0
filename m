Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE1B1FA3741
	for <linux-trace-devel@archiver.kernel.org>; Mon, 31 Oct 2022 21:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiJaVhf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 31 Oct 2022 17:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiJaVhe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 31 Oct 2022 17:37:34 -0400
X-Greylist: delayed 964 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 31 Oct 2022 14:37:33 PDT
Received: from mailrelay3-2.pub.mailoutpod2-cph3.one.com (mailrelay3-2.pub.mailoutpod2-cph3.one.com [IPv6:2a02:2350:5:408::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E400F1A
        for <linux-trace-devel@vger.kernel.org>; Mon, 31 Oct 2022 14:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berginkonsult.se; s=rsa1;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
         from;
        bh=vmqnCs1MFq8BWUyfHn0Xw7/dSqTMzOcivkN+ukih0Bk=;
        b=lU0HYcCkdW1XKT5jWl2aqqK+3/ddSrrWOTMHK7OINVs5enG7XUXDTPwJ/db17y6s/D5qQQ1FKqePD
         vnNW9v6PUvytgluibaAqLLH83/FBwpaKP+/CipMJLt//YcrepJkifjb85tEZFvcOc7v2XNnfZdI+M8
         zUaoI3k3eXVvcEEcKV1TBepSxWG0rs9p1OU/72A7KJamVAzVXe69ioMSlb7TlfLrjWZe8ABae/qV4m
         WMscq3mxFDHAM4xQSoZZmAFQ3PJUZdvtMC7qczSMSqs7QGOaK/RgL/w3ztI9sock8JLRq6S6DhRm0U
         JW57MteLzwj44M53vXPK/rBcLJYRH2A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
        d=berginkonsult.se; s=ed1;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
         from;
        bh=vmqnCs1MFq8BWUyfHn0Xw7/dSqTMzOcivkN+ukih0Bk=;
        b=QKhc6aA4mFoyvUcY/ni1XQDkOwCEd8yIsp4QszpyVoS9UOAT74/OYn+opNz+KSOnj+R0osqTRXTAD
         SYP4keEBA==
X-HalOne-ID: f845a907-5961-11ed-b660-7b202c25bcfe
Received: from pbergin-7420.. (ua-213-113-159-147.bbcust.telenor.se [213.113.159.147])
        by mailrelay3 (Halon) with ESMTPSA
        id f845a907-5961-11ed-b660-7b202c25bcfe;
        Mon, 31 Oct 2022 21:21:27 +0000 (UTC)
From:   Peter Bergin <peter@berginkonsult.se>
To:     linux-trace-devel@vger.kernel.org
Cc:     Peter Bergin <peter@berginkonsult.se>
Subject: [PATCH] libtraceevent: make it possible to set libdir,includedir and mandir from outside
Date:   Mon, 31 Oct 2022 22:21:10 +0100
Message-Id: <20221031212110.170564-1-peter@berginkonsult.se>
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

