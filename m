Return-Path: <SRS0=87e6=WW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6079BC3A59F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Aug 2019 15:58:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31DBE21848
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Aug 2019 15:58:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="t910iLS8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730499AbfHZP6e (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Aug 2019 11:58:34 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:36503 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727864AbfHZP6d (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Aug 2019 11:58:33 -0400
Received: by mail-wr1-f42.google.com with SMTP id r3so15852201wrt.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Aug 2019 08:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dnqWm6DOts0vL0Un3HX08rfwJgqT69Ftu40GSzuSMFk=;
        b=t910iLS8wAo7sPfTWwXwVmpzRVbrz31Kvbx9Ej5DGqwd/LDaD7rYQH0WX+Kh6oT31X
         5pmCliLm8tPQ3fAv/igg9aidndGPHd39ScLQH4YOwInFWKx9KVNgxE980syR5iN5w6Ch
         LTj6/Q532LWjwJDzgrLu2qLi3BQDNgyBUbGx+mPQbOqS/XLS/jxkWBTj85qGAM/mMV6/
         zp+ghRTb2HwiYmFNZ5o+8OEolorZxcOuTb2S2FIPey7gDZjvse0NzG1n+xn5V4b0voyd
         cldp2Z9F5yiSl5F+59xX3t9cHtFrSiYV+qyDdckT8YUiSKokWLOrj09N+iv8s2LYaBFa
         /u4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dnqWm6DOts0vL0Un3HX08rfwJgqT69Ftu40GSzuSMFk=;
        b=RVMC1vnJod0PFhFpMvKCm9OH8VaP+fqUSB7/WHUWw6NlgulE/UiLnz4NQ+iwdvz+rc
         NQW/SCtFJORjMPbIrz1iAcA56FBtvclZMflEHwnHiME5mFYwDwQtSHvlV4HvR7rsAP+I
         SgYUvlCH4vg9XdnlwR+O70T8ZHtbXvC57RGYrJbTGEhPXJRCyxmuO2nMCsk30Ti1BGtG
         3WLcclu+AK3n0wEARaXD+nkGUFwhdvstPfVXPjJRJbozk+HbLQlfdK1hC0jTNxnStoxW
         PV1XWMkqWAWBewCErDOmBy+oVOzu3QqJ1ZMkGRIIH3oDRnIgr0a130/rxK7vWk/aZLQm
         Fv1Q==
X-Gm-Message-State: APjAAAWpuA83sSjASygHJXDtJIJGKxIK1O+YaHnGXJ7IVHHOqEK9R3BX
        X5f6sosPu5Nfp3u8o6xW1PonzQJz
X-Google-Smtp-Source: APXvYqxEjNHb9dxhi1jnjJ5j+g9JGD16bhJVbUrV3Yc7zS0XS5UcBZ4LNS6QlAUrtr7uCWr9C/VrgQ==
X-Received: by 2002:adf:a2cd:: with SMTP id t13mr21941909wra.251.1566835111896;
        Mon, 26 Aug 2019 08:58:31 -0700 (PDT)
Received: from localhost.localdomain ([84.40.85.140])
        by smtp.gmail.com with ESMTPSA id p13sm14447458wrw.90.2019.08.26.08.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 08:58:31 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, mike.auty@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 0/5] Handle the case when KernelShark is started as Root
Date:   Mon, 26 Aug 2019 18:58:06 +0300
Message-Id: <20190826155811.32021-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A patch set implementing the improvements suggested here:

https://bugzilla.kernel.org/show_bug.cgi?id=204475

Plus a minor improvements of the error messages printed when something goes
wrong withe the "Record" dialog.  

v2 changes:
  - Correcting typos in patch 1/5
  - Fixing a bug in patch 2/5. trace-cmd now gets correctly formatted list
  of command line arguments.
  - Patches 4/5 and 5/5 are new.

Yordan Karadzhov (VMware) (5):
  kernel-shark: Show warning message when running as Root
  kernel-shark: Don't use pkexec when running as Root
  kernel-shark: Use standart error message in KsMainWindow::_record()
  kernel-shark: Optimize the error messages when "Record" fails to start
  kernel-shark: Better formatting of the error messages from "Record"

 kernel-shark/src/KsMainWindow.cpp | 90 +++++++++++++++++++++++--------
 kernel-shark/src/KsMainWindow.hpp |  4 ++
 2 files changed, 71 insertions(+), 23 deletions(-)

-- 
2.20.1

