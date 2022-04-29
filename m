Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB471C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Apr 2022 16:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379142AbiD2QcK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 29 Apr 2022 12:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379183AbiD2Qb5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Apr 2022 12:31:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA9F6DAA23;
        Fri, 29 Apr 2022 09:28:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61276B83698;
        Fri, 29 Apr 2022 16:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0AE1C385B0;
        Fri, 29 Apr 2022 16:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651249705;
        bh=vRyEqlNcMpIbrSgln4JDEa9oplTOWlImSzdZw5sUCBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=baepLr4jpL37Oq2cFOG6UyXqVVjrYaexwbyvAgrVKjnp0LMroCSC4Gd70FbRBmCpz
         9Phbu6WlzSEMBZLa/iHo+24WQ2iRhZg3gNf/VF3Jb/fSEwDZqJ9n4Zqu5N/PaodiYH
         VGg+jfdRvf7sMXigEw6DdfRH8/OWzZQSLbevUo+3vstolTOY/zR75+tL8fJ4AQVwZo
         97YiFcowDrRLiDijnz3pSHp6aabR96K2OBxlyg87L/qMTSBTiH2oj16FHzBxK/CqrL
         9a650fK96J4iel+WS7AaGpwXUwwpxrGZAZN1aQ84L+XTnZCYNkm9LCfdGtMKk9hrw9
         urKw54HJWd5KQ==
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH 3/4] rtla: Minor grammar fix for rtla README
Date:   Fri, 29 Apr 2022 18:28:12 +0200
Message-Id: <437f0accdde53713ab3cce46f3564be00487e031.1651247710.git.bristot@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1651247710.git.bristot@kernel.org>
References: <cover.1651247710.git.bristot@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: John Kacur <jkacur@redhat.com>

- Change to "The rtla meta-tool includes"
- Remove an unnecessary "But, "
- Adjust the formatting of the paragraph resulting from the changes.
- Simplify the wording for the libraries and tools.

Link: https://lore.kernel.org/r/20220408161012.10544-1-jkacur@redhat.com/

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Daniel Bristot de Oliveria <bristot@kernel.org>
Fixes: 79ce8f43ac5a ("rtla: Real-Time Linux Analysis tool")
Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: John Kacur <jkacur@redhat.com>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
---
 tools/tracing/rtla/README.txt | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/tools/tracing/rtla/README.txt b/tools/tracing/rtla/README.txt
index 6c88446f7e74..0fbad2640b8c 100644
--- a/tools/tracing/rtla/README.txt
+++ b/tools/tracing/rtla/README.txt
@@ -1,15 +1,13 @@
 RTLA: Real-Time Linux Analysis tools
 
-The rtla is a meta-tool that includes a set of commands that
-aims to analyze the real-time properties of Linux. But, instead of
-testing Linux as a black box, rtla leverages kernel tracing
-capabilities to provide precise information about the properties
-and root causes of unexpected results.
+The rtla meta-tool includes a set of commands that aims to analyze
+the real-time properties of Linux. Instead of testing Linux as a black box,
+rtla leverages kernel tracing capabilities to provide precise information
+about the properties and root causes of unexpected results.
 
 Installing RTLA
 
-RTLA depends on some libraries and tools. More precisely, it depends on the
-following libraries:
+RTLA depends on the following libraries and tools:
 
  - libtracefs
  - libtraceevent
-- 
2.32.0

