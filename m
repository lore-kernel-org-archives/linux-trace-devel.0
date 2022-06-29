Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A51E5C43334
	for <linux-trace-devel@archiver.kernel.org>; Wed, 29 Jun 2022 16:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiF2QS4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 29 Jun 2022 12:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiF2QSz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 29 Jun 2022 12:18:55 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3532338B9
        for <linux-trace-devel@vger.kernel.org>; Wed, 29 Jun 2022 09:18:54 -0700 (PDT)
Received: from fraeml737-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LY64958b2z67NYn;
        Thu, 30 Jun 2022 00:14:49 +0800 (CST)
Received: from lhreml739-chm.china.huawei.com (10.201.108.189) by
 fraeml737-chm.china.huawei.com (10.206.15.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 29 Jun 2022 18:18:52 +0200
Received: from A2003111773.china.huawei.com (10.81.220.201) by
 lhreml739-chm.china.huawei.com (10.201.108.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 29 Jun 2022 17:18:51 +0100
From:   <matteo.bertolino@huawei.com>
To:     <linux-trace-devel@vger.kernel.org>
CC:     <rostedt@goodmis.org>,
        "Matteo Bertolino (Huawei Technologies France)" 
        <matteo.bertolino@huawei.com>
Subject: [PATCH] trace-cmd: fixing description of a field in trace-cmd.dat.v7.5.txt doc
Date:   Wed, 29 Jun 2022 18:18:45 +0200
Message-ID: <20220629161845.2432-1-matteo.bertolino@huawei.com>
X-Mailer: git-send-email 2.35.1.windows.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.81.220.201]
X-ClientProxiedBy: fraeml713-chm.china.huawei.com (10.206.15.32) To
 lhreml739-chm.china.huawei.com (10.201.108.189)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Matteo Bertolino (Huawei Technologies France)" <matteo.bertolino@huawei.com>

Paragraph "Format of Section Header" states to write the size of a section on 4 bytes, but the actual size is 8 bytes (long long unsigned int).
Submitted bug: https://bugzilla.kernel.org/show_bug.cgi?id=216185

Signed-off-by: Matteo Bertolino (Huawei Technologies France) <matteo.bertolino@huawei.com>
---
 Documentation/trace-cmd/trace-cmd.dat.v7.5.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/trace-cmd/trace-cmd.dat.v7.5.txt b/Documentation/trace-cmd/trace-cmd.dat.v7.5.txt
index e5bcac7..b19d284 100644
--- a/Documentation/trace-cmd/trace-cmd.dat.v7.5.txt
+++ b/Documentation/trace-cmd/trace-cmd.dat.v7.5.txt
@@ -71,7 +71,7 @@ FORMAT OF THE SECTION HEADER
   <2 bytes> unsigned short integer, section flags:
     1 = the section is compressed.
   <4 bytes> ID of a string, description of the section.
-  <4 bytes> unsigned integer, size of the section in the file.
+  <8 bytes> long long unsigned integer, size of the section in the file.
 
   If the section is compressed, the above is the compressed size.
   The section must be uncompressed on reading. The described format of
-- 
2.35.1.windows.2

Hello, this is my first (little) contribution!
Please be nice :-) 
Matteo
