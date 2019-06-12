Return-Path: <SRS0=CcWV=UL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EFE9C31E46
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 03:59:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB1B02082C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 03:59:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LXT41P1m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfFLD7J (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 11 Jun 2019 23:59:09 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46974 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbfFLD7J (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 11 Jun 2019 23:59:09 -0400
Received: by mail-pg1-f193.google.com with SMTP id v9so6426706pgr.13
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 Jun 2019 20:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TuJeq85uKu21AVHH/Gsx0/Y5FXuV1WzUdCKmnlzZtGw=;
        b=LXT41P1mZIBSUxYDEbRgc1z4mFo50d0v35vdnnvP323APckNyMaOCyxvrU+rldaezW
         45HrIOY3wzFpMaLUmOBnlKzhR5W4pls59zHaMUexfXY78jLxIG3nfSDFJ7kG8aAKKecW
         zF/ohI7OF9+2adNWZp0EXYu18DRjmuQ90zCGLNMl9g6OngbzPrKP3pX1Z/a4OnywNfRz
         RX1lRf2Sb+69GAj6GtUJQmDXdtm4IouN51nq/lQX18+b3yCwzeM3tGvYLiQE80COmgxO
         n5j1ZyL/uqsR1rkWgyIm9IZNB0g6qYyF/Ci2TRV54XUe2FFiXteqdBogk9nPzp+7YTtm
         8L9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TuJeq85uKu21AVHH/Gsx0/Y5FXuV1WzUdCKmnlzZtGw=;
        b=RKT3AvOjyrjoKJk/XNu4z0k8Ul36YuaMmpWlPWrshVAnj2nLc07HJGb6mval1MISbW
         1qO+insXmp5FPr1GcCkjJQlyq+heZmVfH10uY1lYLqYgm8ecm5hyK0xnh5BHG/VMHKtZ
         H1Q76MXS7udxNbM1+Vmj6wmEMczFUM74CiPYIIl3cmQyvKbfNcTdUrwKsWvY06strdkr
         APxRaOh+yT0ewIPNxlTCuhRilVpuwJ+JCU1O98dPaj0Gh0fTJTg6Y+JmWu/3O56gWstM
         uscVaXJ7VpWZOnVPEaExfFU3SFssprLmJ3cGjPyJkeGAtMdnbkPBo4kJf+bDnrF0PIiF
         X49A==
X-Gm-Message-State: APjAAAVNfHGuPTP2aPTlL9RIsuAve945GeFyy+tNlhymVx4IgnUEiwBw
        nrTfU2XZ3QkCygi0Fiq3hjyLDjHKSmg=
X-Google-Smtp-Source: APXvYqzKmR7T/jJgnjfbdK4mssl1SQZKmrCdXkB3ZuEv2njyLWKqjFUijXcuX0jqaGm6LXBLEyRYOQ==
X-Received: by 2002:a63:29c2:: with SMTP id p185mr23152673pgp.216.1560311948224;
        Tue, 11 Jun 2019 20:59:08 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-144-161.hsd1.ca.comcast.net. [73.241.144.161])
        by smtp.gmail.com with ESMTPSA id c124sm18578862pfa.115.2019.06.11.20.59.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 20:59:07 -0700 (PDT)
From:   Alan Mikhak <alanmikhak@gmail.com>
X-Google-Original-From: Alan Mikhak <amikhak@wirelessfabric.com>
To:     linux-trace-devel@vger.kernel.org, rostedt@goodmis.org,
        ykaradzhov@vmware.com
Cc:     Alan Mikhak <amikhak@wirelessfabric.com>
Subject: [PATCH] Fix compiler error in KsSession.cpp on Raspberry Pi 3
Date:   Tue, 11 Jun 2019 20:59:02 -0700
Message-Id: <20190612035902.16366-1-amikhak@wirelessfabric.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fix compiler error at KsSession.cpp:457:30 on Raspberry Pi 3

Fix by changing the type of local variable 'pos' from uint64_t to
size_t in KsSession::loadDualMarker().

KsSession.cpp:457:30: error: no matching function for call to
‘KsSession::_getMarker(const char [6], uint64_t*)’
  if (_getMarker("markA", &pos)) {
                              ^
In file included from KsSession.cpp:14:0:
KsSession.hpp:97:7: note: candidate:
 bool KsSession::_getMarker(const char*, size_t*)
  bool _getMarker(const char* name, size_t *pos);
       ^~~~~~~~~~
KsSession.hpp:97:7: note:   no known conversion for
argument 2 from ‘uint64_t* {aka long long unsigned int*}’
to ‘size_t* {aka unsigned int*}’

Signed-off-by: Alan Mikhak <amikhak@wirelessfabric.com>
---
 kernel-shark/src/KsSession.cpp | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel-shark/src/KsSession.cpp b/kernel-shark/src/KsSession.cpp
index 9d86776..a581bbf 100644
--- a/kernel-shark/src/KsSession.cpp
+++ b/kernel-shark/src/KsSession.cpp
@@ -450,7 +450,7 @@ void KsSession::saveDualMarker(KsDualMarkerSM *dm)
  */
 void KsSession::loadDualMarker(KsDualMarkerSM *dm, KsTraceGraph *graphs)
 {
-	uint64_t pos;
+	size_t pos;
 
 	dm->reset();
 	dm->setState(DualMarkerState::A);
-- 
2.17.1

