Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F19CCC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 31 May 2022 23:58:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348753AbiEaX6y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 31 May 2022 19:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234487AbiEaX6x (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 31 May 2022 19:58:53 -0400
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95537546A2
        for <linux-trace-devel@vger.kernel.org>; Tue, 31 May 2022 16:58:52 -0700 (PDT)
Received: from sandvich.controleur.wifipass.org (unknown [185.234.140.80])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: hws@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 4E56082A57;
        Wed,  1 Jun 2022 01:58:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1654041530;
        bh=OeauUBINJulx7DnfRKOdEO2+gMyyP9rv2GmsNIYupPk=;
        h=From:To:Cc:Subject:Date:From;
        b=nxbP96+f1xGwodT8O4SPF/DnR25wgh1y5FVHrmNngSEDLdUn5h83SVvuyowIP4PrG
         54CEcw2+FKMrMlfc13lD4gPuIAI3zRyR+q52EYRoT4H+tqnbNL80QtQma25hh1xLEJ
         78T+HjX4EZ8GO3okBWRe5Fw7HNq0JyDAWsXN61pqq9BVAbb59NZByXT+TEBTIVNfSE
         zPB6WiA5pO+fu0oenVzR52p1jkjVS7JYhX7XaHg6MPidC0KtZHxHda6xU5k6C3rBnA
         LeVlK3Q6ac8dNZ2bQJqWOMJw+I2gWGprTcLIG+Zo1X7g2qcUUbSr/BekYqddtS3LFs
         FrsVVWK1qrNvg==
From:   Harald Seiler <hws@denx.de>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>, Harald Seiler <hws@denx.de>
Subject: [PATCH] libtracefs: Add missing ) in tracefs_sql docs
Date:   Wed,  1 Jun 2022 01:58:06 +0200
Message-Id: <20220531235806.47553-1-hws@denx.de>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.5 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fix a small typo.

Signed-off-by: Harald Seiler <hws@denx.de>
---
 Documentation/libtracefs-sql.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/libtracefs-sql.txt b/Documentation/libtracefs-sql.txt
index ba4271e..5e48baa 100644
--- a/Documentation/libtracefs-sql.txt
+++ b/Documentation/libtracefs-sql.txt
@@ -195,7 +195,7 @@ That is:
 
 [source,c]
 --
-  select CAST(common_pid AS comm, CAST(id AS syscall) FROM sys_enter
+  select CAST(common_pid AS comm), CAST(id AS syscall) FROM sys_enter
 --
 
 Which produces:
-- 
2.36.1

