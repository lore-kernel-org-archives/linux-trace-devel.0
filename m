Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D19C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Nov 2021 14:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE03061106
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Nov 2021 14:38:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbhKJOk7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Nov 2021 09:40:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbhKJOk7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Nov 2021 09:40:59 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62301C061764
        for <linux-trace-devel@vger.kernel.org>; Wed, 10 Nov 2021 06:38:11 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id b15so11290497edd.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 10 Nov 2021 06:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3q8iXzB4/auFLv5PTm6ro10W6p7lz/8VSeh9ER9VxAA=;
        b=a3upig0hOy0rCEayHyORTJe1vXrq0FNs1fMwNgjyaffOvfwm7TrZeVN2VqhaK7xbby
         gQTHSrFnOmnFDwhY7oGUbb/dx3/SKjY1bsHYgBY6v+AjiOR0cLu06Q5/3qfy8IF3cUF3
         2q3BqMUvMBizbdg4M24p4aTVP015w2OrvW+g+VUn4JbTYnL4HXNE7ECWDDDAGrF7WohZ
         CnHyDmg2D/nOdA81VB+inlTr1Id3Ox7FFgLjY+2zMVNyLVfAdUPhtdnn6R/ZqohXqiAt
         x0z6p8voTkthxxN24jrw4iFuMdM6KBKuK4QgEj3Ywj0KZpEXu3vZCAugbMTxdQEwV5kt
         jl3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3q8iXzB4/auFLv5PTm6ro10W6p7lz/8VSeh9ER9VxAA=;
        b=PhhI6ltPcCZUAPPKa6d/2YcEWa16g7X4VnQlf7x1HcXP7BbldvO9RWbx8iDIPc0wOf
         7evVq/msLqNiYWrnU/DMjkr/s/A9rF0Vh9+USEl1udrXyDVL75UZy24WRBWrKac1317v
         SrCz0yErqKb2CUCksQE70JN+kZStMW1bQQn7uh1nFwQ3uxwaEkwMa3prUTdwGr81qVVn
         Xfh9L2mEI9M0pjKNY6PXY09XoRAmGyvhkI6PKxIiXfNY0q8tdhf9oIZHwxX8uhNhFzwa
         ItAoyR0JG1p5bUp829S69dHMZ8K/rSQ5G5SXRxLp4c2YPkiWjplVPchrKRN7vkeceSH/
         id2g==
X-Gm-Message-State: AOAM5319GEyW0kMXHPzHs1X41u97m86gCdBkJRQKFKhX8YUSNz54gU9h
        9pkaZZ0FzOZQITGnOJ9E3DQurBFIcTU=
X-Google-Smtp-Source: ABdhPJxX68LQYpryRj+l+mp0Qj3W2cDyaEx0UgOKak2ulWf/x+xkg0yIEDulj1ANmjcMTrmm/KF8PQ==
X-Received: by 2002:aa7:d90e:: with SMTP id a14mr97345edr.252.1636555089316;
        Wed, 10 Nov 2021 06:38:09 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id hc10sm11477039ejc.99.2021.11.10.06.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 06:38:08 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/5] kernel-shark: Silence a warning from 'cmake_clean.sh'
Date:   Wed, 10 Nov 2021 16:37:43 +0200
Message-Id: <20211110143747.32833-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The file 'CTestTestfile.cmake' may not exist if the CI tests were
never executed.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 build/cmake_clean.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/build/cmake_clean.sh b/build/cmake_clean.sh
index d645c32..8defa67 100755
--- a/build/cmake_clean.sh
+++ b/build/cmake_clean.sh
@@ -2,7 +2,7 @@ make clean
 rm CMakeCache.txt
 rm cmake_install.cmake
 rm Makefile
-rm CTestTestfile.cmake
+rm -f CTestTestfile.cmake
 rm -f DartConfiguration.tcl
 rm -rf CMakeFiles/
 rm -rf src/
-- 
2.33.1

