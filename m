Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A9F2C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Dec 2021 02:35:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbhLPCfc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 15 Dec 2021 21:35:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:38024 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230037AbhLPCfc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 15 Dec 2021 21:35:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639622132; x=1671158132;
  h=from:to:cc:subject:date:message-id;
  bh=LQmsaIwOyJVnI4dmO5IaitGjS9I+eBnBL1hqcnTzW5A=;
  b=RzB2oHB8KleqU1got+WRijmH+6ybPqizLa7+1+wpto4bwbxD5unv5SGn
   NCfDsgprRfU5wPEMFwZQYAMPgHCv/+9jVraBDaylurwiGoQ7vLeQqikBO
   8TmHgznWWBVih8iH+iYqfjS2MF7pwLUwlWSayxBj9/bTjuzsSyPzpkwdn
   nEhjO76IQl6u5iwXiTiXeiRSsqaWI0o9eRgnQkBk/vZ+3JhqjHc+Nw59L
   noPPQ++d37beZLKBurdrdLapeKksE1X6aG/zFf1tE3AjC6G968FCyq3Fq
   9ItVEGCdN5e8shzuLAwj4BvAr1DOvaVZ60S2wTB2dX9F5uRBI27w4Qzo7
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="226668739"
X-IronPort-AV: E=Sophos;i="5.88,210,1635231600"; 
   d="scan'208";a="226668739"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 18:35:31 -0800
X-IronPort-AV: E=Sophos;i="5.88,210,1635231600"; 
   d="scan'208";a="662188845"
Received: from intel-z97x-ud5h.sh.intel.com ([10.67.103.201])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 18:35:30 -0800
From:   Hongzhan Chen <hongzhan.chen@intel.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     jan.kiszka@siemens.com
Subject: [RFC PATCH 0/1] kernel-shark: Add plugin for handling Xenomai cobalt_context_switch.
Date:   Wed, 15 Dec 2021 21:16:48 -0500
Message-Id: <20211216021649.7273-1-hongzhan.chen@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

For Xenomai-cobalt enabled system, cobalt_switch_context means
that there is context switch in companion core(realtime core),
which we may need to do special treatment and take correct action
as main kernel sched_switch to visualize out-of-band state of
realtime tasks running in cobalt core. To achive our target,
we implement following:

  1. store corresponding cobalt_switch_context events into
     container data.
  2. modify pid stored in entry to be equal to next_pid to
     show correct color in cpu bar when cobalt_switch_context
     event happen.
  3. show blue hollow box to mark out-of-band state underneath
     the baseline of task plots according to cobalt_switch_context
     events.
  4. clickable cobalt_switch_context plugin shapes.

I do not know if this patch can be accepted in upstream from function's
view because it is xenomai related which still be different from
pure kernel-shark for pure linux. But it is still independent plugin
which would not influence other kernel-shark's functions and the plugin
would not take effect if there is no cobalt_switch_context event found
in trace data.


Hongzhan Chen (1):
  kernel-shark: Add plugin for handling Xenomai cobalt_context_switch

 src/libkshark-tepdata.c                    |   1 +
 src/plugins/CMakeLists.txt                 |   4 +
 src/plugins/CobaltSwitchEvents.cpp         | 204 +++++++++++++++++++++
 src/plugins/xenomai_cobalt_switch_events.c | 198 ++++++++++++++++++++
 src/plugins/xenomai_cobalt_switch_events.h |  64 +++++++
 5 files changed, 471 insertions(+)
 create mode 100644 src/plugins/CobaltSwitchEvents.cpp
 create mode 100644 src/plugins/xenomai_cobalt_switch_events.c
 create mode 100644 src/plugins/xenomai_cobalt_switch_events.h

-- 
2.17.1

