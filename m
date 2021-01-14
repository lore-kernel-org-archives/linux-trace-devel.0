Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	DATE_IN_FUTURE_03_06,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00410C4321A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Jan 2021 01:44:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABE822343E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Jan 2021 01:44:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbhANBod (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Jan 2021 20:44:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727329AbhANBQA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Jan 2021 20:16:00 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455BBC061786
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Jan 2021 17:15:19 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id h186so2389948pfe.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Jan 2021 17:15:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=rPoUHQ0abDAiaELfgQO3j9rhbvdJCoV44KYIRA5rl7g=;
        b=XurWnUmWJ0j8r20v0ysCvR/4jsxrujn6cRo80SXWDoQfDrabw9eN8kmFZw7kQhyxtK
         iZHK5OMylQ4C2C+2JwylJt/Y+8puhGMZS8jwug9R/JPICsv2uoxGlzbHNP1MQJQ6jESz
         o2oIcolhncDy8U9R9kg5c22HsWGpnBX2xi3L1cvlBLB6xQ77mDDlPDhP82hDOfBbKSO/
         TSwWOrLi3yD0KGSF5UgqHC+9ZQy1QG/rxjG8jq2zeQGwkBLapQt/Xh3WwXxtAdF2H73V
         CBM+yL/4kQ0AJNor9JgNKmTF1sMhNMPGJSycmT1VnmcP/9GW9RlOHuESlIm9+3Ezc1rP
         I0Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rPoUHQ0abDAiaELfgQO3j9rhbvdJCoV44KYIRA5rl7g=;
        b=kdR7VaBUTppMS/P3Xrueiv9TTKTwsrjLCochckalIfu3aZ6ICPNj/qhvzLZu/Kss7q
         u2g72G0z2qL769G8UBtY0rtA5V3B0O54gGciWC7OHYb0rxq/7wcM8OWYYmbUt2jIN9fa
         liTXXg5Y0RlmKDZUFq1xI028wRzB9wNvYNqLFtd0MUmKZUqziN4wlNzSekP5JVK2jFNj
         P5EZ1EzycJ06ri5Cw4CcJz2kPhyz8dY/NC62tgI0g8nvPkvrZzjNL5LWIuEaTeOw0YF/
         H2w57y4erRg0PUuIQsRQe+75cT/H3dXv2qZEmDaRpXPivzyTgMJiyOUFtbbhdAlWY7Qv
         rMGQ==
X-Gm-Message-State: AOAM531rWxqVD4YhsFKS7y5xplKz4eialANjFCA9oBujQAktFXEJLtcd
        kfT2p7A5mLUy/HfroDoapACC/VtA0mcLvw==
X-Google-Smtp-Source: ABdhPJyhVmKgKTeyUd8RqyL1s/eRb5yvZHzHRoi7hiZk4uWJv4Vlu7b0apj5uBs08vsIrPOelbWbeA==
X-Received: by 2002:a05:6a00:88b:b029:19c:780e:1cd with SMTP id q11-20020a056a00088bb029019c780e01cdmr4897404pfj.64.1610586918561;
        Wed, 13 Jan 2021 17:15:18 -0800 (PST)
Received: from localhost.localdomain ([119.235.49.124])
        by smtp.gmail.com with ESMTPSA id z11sm3969345pjn.5.2021.01.13.17.15.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Jan 2021 17:15:17 -0800 (PST)
From:   Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: [PATCH] trace-cmd: Fix lib audit warning message
Date:   Thu, 14 Jan 2021 12:14:48 +0530
Message-Id: <1610606688-5186-1-git-send-email-sameeruddin.shaik8@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

statically updated the warning message which we will get, when
compiling trace-cmd without the libaudit library.

Following are the the messages which will pop out when compiling

Before:
-------
trace-profile.c:23:3: warning: #warning "lib audit not found, using raw syscalls " "(install libaudit-devel and try again)"

After:
-------
trace-profile.c:23:3: warning: #warning "lib audit not found, using raw syscalls " "(install libaudit-devel(for fedora) or libaudit-dev(for debian/ubuntu) and try again)"

Signed-off-by: Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
---
 tracecmd/trace-profile.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-profile.c b/tracecmd/trace-profile.c
index cfae2a2..9b5c385 100644
--- a/tracecmd/trace-profile.c
+++ b/tracecmd/trace-profile.c
@@ -21,7 +21,7 @@
 
 #ifdef WARN_NO_AUDIT
 # warning "lib audit not found, using raw syscalls "	\
-	"(install libaudit-devel and try again)"
+	"(install libaudit-devel(for fedora) or libaudit-dev(for debian/ubuntu) and try again)"
 #endif
 
 #define TASK_STATE_TO_CHAR_STR "RSDTtXZxKWP"
-- 
2.7.4

