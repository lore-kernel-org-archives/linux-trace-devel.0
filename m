Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46204C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:11:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 250B260FC4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:11:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbhJHENY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbhJHENX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:13:23 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5061C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:11:28 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id p13so31713732edw.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0DHXFhnrCyHrwEyz/mTg5d6BHCerlL/+ZLYsQ5Zrtok=;
        b=Y74AVTXRPM9a6XCs7W2aKitjmZRI0FQsEjp+B0Mt1t+gjFcy786xSIreKFAAnFrGVH
         cUj5iIWYsy0NJpOhfFcmUrV0ahmziisHKfg04F1zAWNxi20P0CYixC5c3UkyPctxYttG
         9DkC2OsNyfxAgBRazK3xdDSMQzYLLa9KC5k6mZQo6t+OvRKsCkeQZWYw9V5s0Ngm5gNc
         iXCBI4Jmh9dSbU5ZBp0RY7u7+Li9NlsIrxpzlbXw5wDXZWYT/IsSlYURuIpoyA8N45xX
         ty5cvDiE9S2y4ev3YV6dLgIac7lPBS9CKosHCPcIo9jznk1jU4fp+UyRPoq/ZnxnAlMW
         pRPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0DHXFhnrCyHrwEyz/mTg5d6BHCerlL/+ZLYsQ5Zrtok=;
        b=tcQ9fUgPoQXnnO13jvAG/9XZDb0fEGyDKy4T3MH3zdUh6g/n/f76gU/CvLAOKBd+kW
         vzTvgfNw/se0URkWBrjriBQ8g1J487zqWmMCyp/7O8s38dM173JV057bwpsq2NoMPgrd
         wwYxAgxKmfNg5U3D2R0MIDEvHqFtZ5qUd6prGT0F7vBaRGz8knPzaklRmDrIjWEPYDzH
         4GzjqBo4ESboGGF92BdkEHeJHM3mTKYwQbEy3/6VvIkMzJM5ZZTuin95V9y1GbVrcuAx
         Fhb1Xc0VOqgRXaHxjj9Qf+T5uXXh2oUMGqqyt7I7Zz6ZUhZAdideOUNxQ5FwpNoT7ygB
         u0NA==
X-Gm-Message-State: AOAM531ZpWzQo8rgiA7IEN7hMDHkKMTKdX/KbpIEM/yiyRC2xIOUImLZ
        oOEVcYxp7SwfbV2m80Ij2tcjcNZA1lbb9g==
X-Google-Smtp-Source: ABdhPJy/o79tea6KxM/xed1PM0YrSxjGO9DB2l8VQEK+bR79Et5xAYez1jXgjS72Puxam/XA6BXsIA==
X-Received: by 2002:a17:906:c252:: with SMTP id bl18mr1162992ejb.519.1633666287504;
        Thu, 07 Oct 2021 21:11:27 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s3sm447970ejm.49.2021.10.07.21.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:11:26 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 0/6] trace-cmd fixes and clean-ups
Date:   Fri,  8 Oct 2021 07:11:18 +0300
Message-Id: <20211008041124.972956-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Various trace-cmd application and library fixes, clean-ups and internal
refactoring, needed for trace file version 7 and compression changes.

v4 changes:
 - Removed from the set the patches that were already merged upstream.
 - Rebased on top of the latest master.
 - Removed these 2 patches from the set, as they will be a separate patch
   sets:
     "trace-cmd library: Refactor APIs for creating output handler"
     "trace-cmd library: Refactor the logic for writing trace data in the file"
 - Addressed Steven's comments.
v3 changes:
 - Fixed issues of split and convert commands with some corner cases.
v2 changes:
 - More cleanups, forgotten in the first version.

Tzvetomir Stoyanov (VMware) (6):
  trace-cmd library: Do not use local variables when reading CPU stat
    option
  trace-cmd library: Track maximum CPUs count in input handler
  trace-cmd library: Fix possible memory leak in read_event_files()
  trace-cmd library: Fix possible memory leak in read_ftrace_files()
  trace-cmd library: Set the correct file state when reading file with
    no kallsyms
  trace-cmd library: Set the correct file state when reading file with
    no ftrace printk data

 lib/trace-cmd/trace-input.c | 92 ++++++++++++++++++++-----------------
 1 file changed, 51 insertions(+), 41 deletions(-)

-- 
2.31.1

