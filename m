Return-Path: <SRS0=DKMX=5E=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A788C4332D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Mar 2020 14:13:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3F7520CC7
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Mar 2020 14:13:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OIzLFvtP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbgCSOKs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Mar 2020 10:10:48 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36514 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727148AbgCSOKr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Mar 2020 10:10:47 -0400
Received: by mail-lj1-f196.google.com with SMTP id g12so2660743ljj.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Mar 2020 07:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TuRQEVpZPg7sMVN0Mgr+b6khOdtcMBfQRZzpb5zAj8o=;
        b=OIzLFvtPKYaG3Fhvds9hikY0nGVd8eyLGqauy5tBgr6IO0OQPratlL124RV7k660yQ
         c5pq7evQGDOub8wpefoWQg4yob8vyb5SStx5chN7d6I217//RhbMkd4ulpGYzQ1lhErt
         djUsfy19xasLtUZ0kga9dvBmd/F2d5uGPqZGBl+YLWiKRtmFeQcOfbiTDGGce6ClnptH
         lxGu9vPwP4MUGPqEIkHHOED8Om8vaGtzx4dbXtvB8iUFT8X4lkel4UClExRxxNrKEpse
         3NVCcElMOW17ULKLCVxS0Lx6N0akqCupO/REwzF0Cgvm543ER33iDW3AQYUDPxJRMxKY
         3VHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TuRQEVpZPg7sMVN0Mgr+b6khOdtcMBfQRZzpb5zAj8o=;
        b=crtPpx4AieE1Fp5Ign3XvAYYDASjIa3pEa7aSq7ysViSl3maTqUFa491jhSApSO36w
         tu7KP7GGO8shRctMJMn4TIiuDEkYFPhLp98j2klPzfXlq/fNumI1vNK6uaefoi7FLzT8
         BxjE7FS7JAJDBtIioJHsc7OOQxVloC9rVY28kD3gNk05jmYnntbHmahWZmOBhDXi5fyt
         F2sDqyH0ylHmNEOtFlREYlsCc8uBlgQtRJ1jdCEZx2hBItku7kijhj9m02hGiyICJK7l
         yEfCEvhOr2kHjHlVNOxm8TisToPsNyxf0zpiM0blIBHTmMLvnqDmMOxf3D2L5u081RHJ
         jWrA==
X-Gm-Message-State: ANhLgQ2h57Mh7tgq0hn/yhAafU1nVjKRcyXFPOeNF7KeQD72KxFJ2Lqm
        yJMQDgTs0kIG13WtPOVkYdM=
X-Google-Smtp-Source: ADFU+vvgQI3aOvZrN1dSsM5XXMzUyaPR4UTUBQjhNL5KdCHaaAUNmyPTul3UeaN1euyR0+Hpf/+XRQ==
X-Received: by 2002:a2e:924a:: with SMTP id v10mr2218247ljg.21.1584627045482;
        Thu, 19 Mar 2020 07:10:45 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.223])
        by smtp.gmail.com with ESMTPSA id u14sm1817605ljj.54.2020.03.19.07.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 07:10:44 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/5] kernel-shark: Optimize the logic of the filtering menus
Date:   Thu, 19 Mar 2020 16:10:26 +0200
Message-Id: <20200319141031.3774-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The original motivation for this change was to fix the problem that all
negative ID filters which are set using the Quick Context menu of
KernelSharlk are not visible when you open the main Filtering menus.
The logic of the main menus is optimized to use both type of filtering
and to automatically decide whether is more efficient to set positive
(show only) or negative (do not show) filter. The patch-set also includes
one very simple bug fix (patch 2/5) that was found during the development
of the new filtering logic.


Yordan Karadzhov (VMware) (5):
  kernel-shark: Add method for checking if a given ID filter is set
  kernel-shark: Fix bug in bool kshark_export_all_cpu_filters()
  kernel-shark: Add two helper methods to KsUtils
  kernel-shark: Remove unused methods from KsMainWindow class
  kernel-shark: Optimize the logic of the filtering menus

 kernel-shark/src/KsCaptureDialog.cpp  |   6 +-
 kernel-shark/src/KsMainWindow.cpp     | 229 +++++++++++++++-----------
 kernel-shark/src/KsMainWindow.hpp     |  16 +-
 kernel-shark/src/KsUtils.cpp          |  38 +++++
 kernel-shark/src/KsUtils.hpp          |   4 +
 kernel-shark/src/libkshark-configio.c |  17 +-
 kernel-shark/src/libkshark.c          |  21 ++-
 kernel-shark/src/libkshark.h          |   2 +
 8 files changed, 211 insertions(+), 122 deletions(-)

-- 
2.20.1

