Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEC33C63682
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:57:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239445AbiAZJ5l (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:57:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239442AbiAZJ5j (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:57:39 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E051C061744
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:57:39 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id p15so37734125ejc.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:57:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7LWWlSjDFbeVIPnkDglgC/jora1JiasEdimgKJcS2fc=;
        b=EEVRWBOSylRtXWuFTnzj4IycSFrWuEubFMJf2y6MlQRGIj/WT5KORXYBRTfnTEzh1G
         kx7/3AznjDOtY+0/ZPIG5A2bmpoXfV4r/DlCdkPZ1CMnPgYKdQaXl3wVQ2gjzzDc6woR
         AXYGCwOePKeDcUmbuJQZ2CfJ/HDbm9egGzHSoDDHfBl5B4o4zqpEi2tHLeP2T/49QWW1
         hT4mDMHpjqXhYCaygA+AQ66N2bMnc4PCVGg+S+77wA/jrd4u6v0q5z61VnwjRTMV4lKU
         mymVSxTQ+NDFafohpUpeoxIWGdL19vZw1JI3+7V1AtOfXXI0KNiWlFq/WZti0I04aRoF
         p2Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7LWWlSjDFbeVIPnkDglgC/jora1JiasEdimgKJcS2fc=;
        b=IHB0o5VdInsnWzniNputIKW4ol6G0Z8HbiFm7A8SUbkOcceRIdLGEEnqw9XsCy/mJP
         gP77K4OEZTLoPKjzNcLNf0EuVZi43opwX4e2XuYnhCvAjbh022G4gZssTDP9M3oHNLny
         9YnSDgPZYgYw7zIPcM+JjXWmUiQrg3AY2m5LtnrzJNwzdf0o/PNFI84fEev4MzrlPLZR
         V8V9nb14uSRvsp5OzMYP86HzCRszaD5ytn0r7XH3eKGc7enIAs03sN8uIugBrxfLXUUB
         KJMKHMnTrRQe65tPDw6WwoANyiW7NVaWSLXTOBzEH6xUC27U1jyLW8xePoeNZV/JiMyq
         abRQ==
X-Gm-Message-State: AOAM530HXcbGC0uhcEebJkR5GaEIffzTdskMcXmRXP0xl1x4Y6b/lahe
        ckb5bEzDnMC25j99KW+L0WuY7JGQFFs=
X-Google-Smtp-Source: ABdhPJz/ztIXq97xWt3/emmCJORCnjeEC3nMbB/CBIKd2muN3iAxYH3sawSsUdUrwaqLfORpYEOjhQ==
X-Received: by 2002:a17:907:7289:: with SMTP id dt9mr26492ejc.56.1643191057850;
        Wed, 26 Jan 2022 01:57:37 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id j20sm7145299eje.81.2022.01.26.01.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:57:37 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 0/2] Get trace buffer page size from kernel
Date:   Wed, 26 Jan 2022 11:57:33 +0200
Message-Id: <20220126095735.571222-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The trace buffer page size is equal to the system memory page size in
the current ftrace implementation, but this may change in the future.
The newly introduced traceevent library API should be used to get the
real trace buffer page size, bases on the information from the
"events/header_page" ftrace file.

This patch set depends on:
 "[PATCH v8 0/4] trace-cmd documentation update for v7 files"
 https://lore.kernel.org/linux-trace-devel/20220126095530.571035-1-tz.stoyanov@gmail.com/

v6 changes:
 - Code cleanups.
 - Rebase.
v5 changes:
 - Bug fixes.
 - Code cleanups.
 - Rebase.
v4 changes
 - Rebased on top of the latest master.
v3 changes
 - Rebased on top of the latest master.
v2 changes:
 - libtraceevent API is renamed, use the new version.
 - Rewrote get_trace_page_size() to use libtracefs APIs.
 - Cleanups in "trace-cmd dump" output, related to buffer page size print.

Tzvetomir Stoyanov (VMware) (2):
  trace-cmd library: Use the real trace buffer page size
  trace-cmd library: Introduce buffer page size per instance

 .../trace-cmd/trace-cmd.dat.v7.5.txt          |  1 +
 lib/trace-cmd/include/trace-cmd-local.h       |  4 +-
 lib/trace-cmd/trace-input.c                   | 12 ++-
 lib/trace-cmd/trace-output.c                  | 74 +++++++++++++++----
 tracecmd/trace-dump.c                         |  9 ++-
 5 files changed, 80 insertions(+), 20 deletions(-)

-- 
2.34.1

