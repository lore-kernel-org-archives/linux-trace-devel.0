Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A0CC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:29:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346817AbhLBMcf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:32:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232383AbhLBMcc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:32:32 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A84AC06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:29:10 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id e3so115414856edu.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:29:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J2NGJvtQYfbUQvBJF6ssgiamB1DCI1rE81ufqGIG6wE=;
        b=erTAXPl3NMbjMFyyfgHKKhVSaXKMtX0xV2d99DOm6JuxGfnwoAYse3ZZD/N1XDP+M7
         Yk9yiM5bMzirlF5U3edioLsRDlMYVXY5UrA8P3qwmaM9m44l+CxVIWMHSVGy29Ahj9kA
         om5UWeJibNZ7sRbAOiQZH0JJsZiMRBOJ7GiWvd+wPJflyXt2sKsiyS+n1cpC0icKhwFp
         4jvi0ClvJjx0/ECTfyoO1wBHrErZpLDQZDY/fYKoGZ6vkcTgU30b1l1xRM+L3WRr9+qy
         2ZGuSK5+WTwKzFdcU2AmbQOu/1qdusBfRHVtzZt+Ta+mCjyDulXgzaJUpVLF645u/C1o
         eC6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J2NGJvtQYfbUQvBJF6ssgiamB1DCI1rE81ufqGIG6wE=;
        b=i3nlDozT0iUq51qfpKFl21aPux6uXEbSdrvR5nrEtzMXaBqYzp9b308DBBFPYYPTTB
         V37W/QDz+d4530K4Wtrg+BzCmPIbOzPVG3SsvBICL6Dqt6BKZgSX7U2Zq28urY4l8Q19
         EQ5dI4+mR18uUqDGcppMj497OkLvPLtuN1YbsEZ56+0FlGEGS9hSNB2uq1JFJmYzLS0G
         2ueMjs4Gae0o0s2tSsloBSmDoJpUeKK5m4SwIi0Aob4vXxRW5juHT40v2Zr5asYa3XW6
         41BojsGuS8QmlengI8pDtSO/+GFtpQGw1hZzzXNBS8i4XYX1Y2fo7MBHy69ZLhxbDZXY
         WjVw==
X-Gm-Message-State: AOAM531KsZ0OBbz/kxb/aWDCRJgSEEallkBZL43FPj/dAzN0rPR7+BKG
        /FrPVyArHNygPyYtGJDZ2uuBMrvwVeuGpw==
X-Google-Smtp-Source: ABdhPJwJ7ad4C7DbiS3/fcfuKmpKtOb2lTnVqfxtpKVsD3RGU/67mUEu0dU8O2gX99yLjSgXm0eW2A==
X-Received: by 2002:a17:907:c22:: with SMTP id ga34mr14555062ejc.217.1638448148706;
        Thu, 02 Dec 2021 04:29:08 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id m16sm2182692edd.61.2021.12.02.04.29.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:29:08 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 00/10] trace-cmd dump - v7 update
Date:   Thu,  2 Dec 2021 14:28:57 +0200
Message-Id: <20211202122907.44008-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Updated the "trace-cmd dump" subcommand to work with trace files version 7.

This patch-set depends on:
 "[PATCH v5 0/8] trace-cmd convert" patch set.
  https://lore.kernel.org/linux-trace-devel/20211202122726.43775-1-tz.stoyanov@gmail.com/

v5 changes:
 - Rebased on top of the latest master.
v4 changes:
 - Rebased on top of the latest master.
v3 changes:
 - Rebased on top of the latest master.
v2 changes:
 - fixed issues of split and convert commands with some corner cases

Tzvetomir Stoyanov (VMware) (10):
  trace-cmd dump: Add helpers for processing trace file version 7
  trace-cmd dump: Print compression header
  trace-cmd dump: Add helpers for processing trace file sections
  trace-cmd dump: Read recursively all options sections
  trace-cmd dump: Read extended BUFFER option
  trace-cmd dump: Dump sections
  trace-cmd dump: Dump trace file version 7
  trace-cmd dump: Dump sections content
  trace-cmd dump: Add new argument --sections
  trace-cmd dump: Align better the output of flyrecord dump

 tracecmd/trace-dump.c | 458 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 413 insertions(+), 45 deletions(-)

-- 
2.33.1

