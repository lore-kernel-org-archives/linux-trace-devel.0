Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CCDEC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Jan 2022 03:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236945AbiAQDcc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 16 Jan 2022 22:32:32 -0500
Received: from mga05.intel.com ([192.55.52.43]:29222 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236934AbiAQDcc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 16 Jan 2022 22:32:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642390352; x=1673926352;
  h=from:to:subject:date:message-id;
  bh=F5UgwftZsFbap88Wm6Q/rmQHV7qs67uj5cj9zV/3YgQ=;
  b=mh9fy87gLQlZjDd1414Vt7+2uFqXJFRKyS9lhZe+W8SM12DZI0C7y2f6
   zMK2ZCPpo/mrhpDghm2jlW2jSXHLmOiMQLXf+khtbY1HxMCEhb1i2GtUb
   9e9riHnLWxgQEuhyIYPcKE+uEOAuVM0zh6ZTCO/BQrhh8iHwUjtRepOhU
   vkxjeKrVIRegv0StJ3TT87Wwn+362SFsOGL0933eK2SyTeOLTJ/ATC91K
   WIxrxM6aSQqBDVb4Cp9OTrUxT8EYMRanTJyWHoRdM1IXy1C0dG6qbip9f
   wkgIVZ38X8Fpn848lkA5q5NQqRvexJf0iNxM4d9o7TL2EbhcCCU6npmUO
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10229"; a="330894978"
X-IronPort-AV: E=Sophos;i="5.88,294,1635231600"; 
   d="scan'208";a="330894978"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2022 19:32:23 -0800
X-IronPort-AV: E=Sophos;i="5.88,294,1635231600"; 
   d="scan'208";a="531165629"
Received: from intel-z97x-ud5h.sh.intel.com ([10.67.103.201])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2022 19:32:22 -0800
From:   Hongzhan Chen <hongzhan.chen@intel.com>
To:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com
Subject: [PATCH 0/1] kernel-shark: Move common APIs and definitions out to avoid duplication
Date:   Sun, 16 Jan 2022 22:13:41 -0500
Message-Id: <20220117031342.31474-1-hongzhan.chen@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Yordan,

We decided to maintain new xenomai plugin in our xenomai tree at first because of
concerns as we discussed so I do not send modified xenomai plugin patch to
review anymore. But this patch is still meaningful to avoid code duplication.

Thanks for your patience and time to reveiw my patch. I have learned
lots from your comments.

Regards

Hongzhan Chen 

Hongzhan Chen (1):
  kernel-shark: Move common APIs and definitions out to avoid
    duplication

 src/KsPlugins.cpp           | 22 ++++++++++++
 src/KsPlugins.hpp           | 49 +++++++++++++++++++++++++
 src/plugins/SchedEvents.cpp | 71 ++++++-------------------------------
 src/plugins/common_sched.h  | 64 +++++++++++++++++++++++++++++++++
 src/plugins/sched_events.c  | 32 +----------------
 src/plugins/sched_events.h  |  5 +--
 6 files changed, 147 insertions(+), 96 deletions(-)
 create mode 100644 src/plugins/common_sched.h

-- 
2.17.1

