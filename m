Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE4F2C4321E
	for <linux-trace-devel@archiver.kernel.org>; Mon,  7 Mar 2022 10:21:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238266AbiCGKVw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 7 Mar 2022 05:21:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239041AbiCGKQd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 7 Mar 2022 05:16:33 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA9E8F998
        for <linux-trace-devel@vger.kernel.org>; Mon,  7 Mar 2022 01:57:22 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id y11so18544931eda.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 07 Mar 2022 01:57:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1auzpZ17EtlhaWs+dX5rEMMRaOvOYwLsf/zFCNupxHM=;
        b=NXrp83Pp+LSaBzNvkia6X7mFfeLAMh4cDg5CmOK8Yf1BAhNbYXMmclkYRJxXM0hHWd
         1oQH4fyGaOYgF3oEYWGYJNPKx/+U7xFrT4Ogi1dC8fXQHCsMQk7e5i1Fwk3mPpxNJgXP
         mAqo8myhL1X2G4egAJj3VOH/NjVt03/KVugXWYBU0M18cpzzAuk8nQmKAjraRnc00x5L
         ibWzike2IRMmnhCcSOG52Pxf+ebxEmHqvV6C0Kheufun4+crU9mVYV0THDa0knMfwFf2
         eVxy7nS05byE9kPlNpAY/H9dOuIWEiqoceKR30OiSyfVyCQAzHL9tVBJGfvYxB+Sw7aJ
         gTRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1auzpZ17EtlhaWs+dX5rEMMRaOvOYwLsf/zFCNupxHM=;
        b=7cUVgJLDOE2a5PTVpZKjyX222745EYHYIrGZqd1ZTITsw+YI4LQwO4exFYGxKH0sBz
         uTwPOH9c9GboXfyb7nI5hhXa6kJoHHB8dFSFwR0Tih2a/3CMA98eCX/tOU32jHPG0M8z
         mLBkU3O/c2L1tvPhEN4IQP+eRl4JDE2ykaBo9YS7vL4WeXZmv3x2NgoRJV/aYSiInwPz
         dr2lTkxLvRBD5dQ1aD0W/DvX7UOvQZrMOKE0GdMDbVWp9lZyB/qM1wNLnpDakedN01TD
         5oBTIYQ/m/05z7VYhoInsceYz+5s7nbIaenM9Dq14l/pPInZ0TbFZT4kZUlgKk93BPHm
         671w==
X-Gm-Message-State: AOAM531PJz12ja6tbX8wnz65+/RQGKHMXviqFWhqCjv/06gIAqjzKfGC
        7qGSBEQK8UX16B8bjoh8rvP99r1jM6w=
X-Google-Smtp-Source: ABdhPJyQT4srCRwt08wUXjIipCvemJOJ4F1AMKJwzBict0YMSMawopLNIcjPMu7VhOd8VCoE77l/KQ==
X-Received: by 2002:aa7:d553:0:b0:416:4dfc:126d with SMTP id u19-20020aa7d553000000b004164dfc126dmr2571003edr.213.1646647038058;
        Mon, 07 Mar 2022 01:57:18 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id kq26-20020a170906abda00b006da87077172sm4592083ejb.29.2022.03.07.01.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 01:57:17 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH] TraceCruncher: Version 0.2.0 (Beta)
Date:   Mon,  7 Mar 2022 11:56:56 +0200
Message-Id: <20220307095656.28985-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 setup.py | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/setup.py b/setup.py
index c9c0142..21c627f 100644
--- a/setup.py
+++ b/setup.py
@@ -84,8 +84,8 @@ def main():
                           libraries=['kshark'])
 
     setup(name='tracecruncher',
-          version='0.1.0',
-          description='NumPy based interface for accessing tracing data in Python.',
+          version='0.2.0',
+          description='Interface for accessing Linux tracing data in Python.',
           author='Yordan Karadzhov (VMware)',
           author_email='y.karadz@gmail.com',
           url='https://github.com/vmware/trace-cruncher',
@@ -93,7 +93,7 @@ def main():
           packages=find_packages(),
           ext_modules=[module_ft, module_data, module_ks],
           classifiers=[
-              'Development Status :: 3 - Alpha',
+              'Development Status :: 4 - Beta',
               'Programming Language :: Python :: 3',
               ]
           )
-- 
2.32.0

