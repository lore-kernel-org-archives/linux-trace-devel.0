Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2EE1C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Nov 2022 10:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiKAK7U (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 1 Nov 2022 06:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiKAK7S (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 1 Nov 2022 06:59:18 -0400
X-Greylist: delayed 49004 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 01 Nov 2022 03:59:16 PDT
Received: from mailrelay1-2.pub.mailoutpod2-cph3.one.com (mailrelay1-2.pub.mailoutpod2-cph3.one.com [46.30.211.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C37178BC
        for <linux-trace-devel@vger.kernel.org>; Tue,  1 Nov 2022 03:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berginkonsult.se; s=rsa1;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
         from;
        bh=rYzoFOif1TG/mXKsGjuLv6xuxt0P904DJ1wN5IzvksY=;
        b=a/Eokem7x+WAolA6Ukq2HUqsVeuHiaySyIqPGXdch4Fd2GxdSMIeI8ju8TdmQjsLT6vVeCgxoZgTM
         th7D+XptC/cdu4uVM8vsgSGXR3THeBKQINB1mmNJB+gohi2o+saydroIhrw8LAVAhkM4Q60Bke9phb
         T/6NO0DUWPXF9lgvFSiTzKcZBB29x18MuhhIDlc14C0D8qKro0oXp3E3kc3bXQyLDyMwHsK975megj
         a1i3+/ogAkiF6APfP5qUVW59VPNElYEBfkeEKh0RkytEQprEb/8RBIDkaw+DXzgw77686iPgfuwr0K
         VRdQ2jLWvEmPegLnKnIVFmatKfooUuA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
        d=berginkonsult.se; s=ed1;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
         from;
        bh=rYzoFOif1TG/mXKsGjuLv6xuxt0P904DJ1wN5IzvksY=;
        b=RhRtZpZHMilJG/5T7kEcC0WuO6KBrOif+8oAksFDZ+9DERzveTEg8wmkRef4vlh1gqynTqpkp7ZtH
         ETVbffHAw==
X-HalOne-ID: 10f010b9-59d4-11ed-9889-1b2345786432
Received: from pbergin-7420.. (ua-213-113-159-147.bbcust.telenor.se [213.113.159.147])
        by mailrelay1 (Halon) with ESMTPSA
        id 10f010b9-59d4-11ed-9889-1b2345786432;
        Tue, 01 Nov 2022 10:58:11 +0000 (UTC)
From:   Peter Bergin <peter@berginkonsult.se>
To:     linux-trace-devel@vger.kernel.org
Cc:     Peter Bergin <peter@berginkonsult.se>
Subject: [PATCH] trace-cmd: make it build against musl C library
Date:   Tue,  1 Nov 2022 11:58:03 +0100
Message-Id: <20221101105803.191324-1-peter@berginkonsult.se>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add missing header file to make it compile with musl C library.

Signed-off-by: Peter Bergin <peter@berginkonsult.se>
---
 lib/trace-cmd/trace-timesync-kvm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/trace-cmd/trace-timesync-kvm.c b/lib/trace-cmd/trace-timesync-kvm.c
index aa1799b1..bbef8b60 100644
--- a/lib/trace-cmd/trace-timesync-kvm.c
+++ b/lib/trace-cmd/trace-timesync-kvm.c
@@ -10,6 +10,7 @@
 #include <sys/stat.h>
 #include <dirent.h>
 #include <ctype.h>
+#include <limits.h>
 
 #include "trace-cmd.h"
 #include "trace-cmd-private.h"
-- 
2.35.0

