Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C93DC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Dec 2021 06:59:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235893AbhLVG7V (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 22 Dec 2021 01:59:21 -0500
Received: from mga03.intel.com ([134.134.136.65]:44048 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233629AbhLVG7V (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Dec 2021 01:59:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640156361; x=1671692361;
  h=from:to:subject:date:message-id;
  bh=NCwQOoInBsY2+lYw4TiEC+Uj+PDHzDyLUKgfRq1MmHk=;
  b=XCiGiFUg/r2Xkl1Ux8uWsllb8tcdM8nN4Mf8iN3pZMKVa8N+wSBDL9DA
   ujcbXTYsK2qYL544QeQ8oJ0NSX4FsWapYQI8ag67IkxC+Z3ETInZ8qSJD
   9+2Cpv9EoTsMaiM0Kd5lgby6NAYU3t3QfpWqFoyIfuRHMkOsqHOKRLtPM
   B0Phdy41IChzHaYsF9EO/sVBDJNxozVRbeZbsln0Llkpy2rsgoad0Wz5w
   3HlOqnQMIYhm9Md8p+7bT+sToRUeSx/eiYkOcBgwZa5pTBhr1joT3Hzr1
   ehzIsrh7jJ7CPD5SKOa5byojIgKDOdh8lydiWa+hUFNYyteXr5y+vR6JQ
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="240513538"
X-IronPort-AV: E=Sophos;i="5.88,225,1635231600"; 
   d="scan'208";a="240513538"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 22:59:21 -0800
X-IronPort-AV: E=Sophos;i="5.88,225,1635231600"; 
   d="scan'208";a="607310451"
Received: from intel-z97x-ud5h.sh.intel.com ([10.67.103.201])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 22:59:19 -0800
From:   Hongzhan Chen <hongzhan.chen@intel.com>
To:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com
Subject: [PATCH v2 0/2]kernel-shark:add new plugin for xenomai cobalt_switch_context events
Date:   Wed, 22 Dec 2021 01:40:12 -0500
Message-Id: <20211222064014.4471-1-hongzhan.chen@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

1. To avoid code duplication, move some common APIs and definitions
   out to create new files and share with other plugins.
2. add new plugin for handling xenomai cobalt_switch_context events
   to visualize OOB state of RT tasks.

I tried to move common APIs and definitions to KsPlugins.cpp/hpp but
found these definitions finally depend on KsMainWindow object used
by _doubleClick of LatencyBox assigned by plugin_set_gui_ptr via
KSHARK_MENU_PLUGIN_INITIALIZER. 
I do not know how to remove this dependency so I create new files to
avoid code duplication. Please suggest if there is better way. 

Hongzhan Chen (2):
  kernel-shark: Move common APIs and definitions out to avoid
    duplication
  kernel-shark: Add plugin for handling Xenomai cobalt_context_switch

 src/libkshark-tepdata.c                    |   1 +
 src/plugins/CMakeLists.txt                 |   6 +-
 src/plugins/CobaltSwitchEvents.cpp         | 125 +++++++++++++++
 src/plugins/CommonSched.hpp                |  99 ++++++++++++
 src/plugins/SchedEvents.cpp                |  87 +----------
 src/plugins/common_sched.c                 |  37 +++++
 src/plugins/common_sched.h                 |  50 ++++++
 src/plugins/sched_events.c                 |  37 +----
 src/plugins/sched_events.h                 |  12 +-
 src/plugins/xenomai_cobalt_switch_events.c | 169 +++++++++++++++++++++
 src/plugins/xenomai_cobalt_switch_events.h |  54 +++++++
 11 files changed, 545 insertions(+), 132 deletions(-)
 create mode 100644 src/plugins/CobaltSwitchEvents.cpp
 create mode 100644 src/plugins/CommonSched.hpp
 create mode 100644 src/plugins/common_sched.c
 create mode 100644 src/plugins/common_sched.h
 create mode 100644 src/plugins/xenomai_cobalt_switch_events.c
 create mode 100644 src/plugins/xenomai_cobalt_switch_events.h

-- 
2.17.1

