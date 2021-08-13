Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63C99C4338F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Aug 2021 19:29:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37D6E61042
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Aug 2021 19:29:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233644AbhHMT30 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 Aug 2021 15:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233507AbhHMT3Z (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 Aug 2021 15:29:25 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68CEC061756
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Aug 2021 12:28:58 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id l11so13341296plk.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Aug 2021 12:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pTK9dE3dTJaS4vXb+kz3OckekDaUcVX2rnFZufWOjPs=;
        b=GsD7+U1dLtzEvTZywXW+J8aXhkB/CRmzA1gnX9xYLOclJDEAsKXYxG00QxwefPVmTE
         3bQqJy3hT+/0pF3j2HRjL0g+CpGnIVzkxb4Y4Vjn/tzmqFkGsBrB5nrnLJc1OBOsRizh
         HJMpzIvaHf34H9iXPJr9OtUaN/FVeCzaMDKx1QEd8r39ipsIdP6S4Tb1ElTqbuB4Dq0z
         bHguZuwlbeY1rLAuhu+zS3ADa64O9GWfflmQkLDYWz3KOEowNX/Qbt/yM1DudLJ1Gzx5
         qHiNFiSzeGb9MqUCEYrZOThfuS9LSlOa1YcWHYNBgLfiqswGVjv8RXpaXt8dLj20znxt
         9c/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pTK9dE3dTJaS4vXb+kz3OckekDaUcVX2rnFZufWOjPs=;
        b=RcZ42pWAoZJAj3g4rmLIM1rm8AUl4OMmLSQspBl2WQxLrWBfu4KKAxc+oxfGMmxLBT
         1QazcRfKdsCep9eh8V7ubxEqpc87Hww5pAQrNF7Yl1UvfYn7rHRA1jZKXVnRttmvdEw2
         QUj0s4uR83xXIA7+tWrcuxmzHWjBuBm90fgamdy5EDqtdXYo1fIBBSgX1REttsLTzq/1
         A+RFtlNB+0c3rbajsHaBiaPtaCDJ70V89ImxIDLsv8iIwFhCVUN5nTprZjAQiVvFFRVv
         lnDVQN8ykgIVhCN3cz7XpdAsJNyqJqt2bi8ZAhNEaCzdsnKJ1pmYzVB2MA6UDQHE1T+b
         DUDA==
X-Gm-Message-State: AOAM530OQQGfOzawPDPPxpOQsQx64n6zcP1+h0npExPV+5bssk/Sa5vD
        37MY71+2osRFEUnlEHq9wIPYttvL25NZ9g==
X-Google-Smtp-Source: ABdhPJwTQ0xucdtd4Ka/f5tXuclvIg9DOOte0QWfODUyegl181NkO+XQrks0VjzX4T6BYo2M3hxVSQ==
X-Received: by 2002:a17:902:b218:b029:11a:bf7b:1a80 with SMTP id t24-20020a170902b218b029011abf7b1a80mr3269607plr.82.1628882937965;
        Fri, 13 Aug 2021 12:28:57 -0700 (PDT)
Received: from localhost.localdomain ([186.223.220.136])
        by smtp.gmail.com with ESMTPSA id k6sm2500640pjl.55.2021.08.13.12.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 12:28:57 -0700 (PDT)
From:   victorcora98@gmail.com
To:     linux-trace-devel@vger.kernel.org
Cc:     Victor Cora Colombo <victorcora98@gmail.com>
Subject: [PATCH v2] trace-cmd: Add dependencies to BUILDING section in README
Date:   Fri, 13 Aug 2021 16:25:16 -0300
Message-Id: <20210813192516.24872-1-victorcora98@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Victor Cora Colombo <victorcora98@gmail.com>

KernelShark has instructions in its README on how to get necessary
dependencies to build it. trace-cmd could follow this example and
also add more information on how to build it.

This patch adds instructions to README on how to get necessary libraries
and dependencies to build trace-cmd.

Signed-off-by: Victor Cora Colombo <victorcora98@gmail.com>
---
 README | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/README b/README
index 1153152..094fce1 100644
--- a/README
+++ b/README
@@ -24,6 +24,23 @@ Lesser General Public License 2.1 (See COPYING.LIB).
 
 BUILDING:
 
+In order to install build dependencies on Ubuntu do the following:
+    sudo apt-get install build-essential git pkg-config -y
+
+In order to install build dependencies on Fedora, as root do the following:
+    dnf install gcc make git pkg-config -y
+
+To install required dependencies:
+    git clone https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
+    cd libtraceevent
+    make
+    sudo make install
+
+    git clone https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
+    cd libtracefs
+    make
+    sudo make install
+
 To make trace-cmd
     make
 
-- 
2.32.0

