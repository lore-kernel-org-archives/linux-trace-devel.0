Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A91BC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 Jan 2022 04:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiAJEoK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 9 Jan 2022 23:44:10 -0500
Received: from mga05.intel.com ([192.55.52.43]:46024 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229638AbiAJEoJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 9 Jan 2022 23:44:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641789849; x=1673325849;
  h=from:to:subject:date:message-id;
  bh=pZlDFkMt+Yik4hOtlaaiOdqTvTtD/eC5l5C32abYxHg=;
  b=avQaBF0MD9s3b0LM6E8bl0sX7/NMStWdUDkNr47/PEP0B3c6u0rNxczn
   7kXhgmpAwUVc7vL8rJa6d+iO6/fjVoYQl/stYn0UR0dWQxKY27jtLstWm
   t0gEM5Nsm11gGRKiPhdRx13Eeel2TRwr/yFlGlUovj3At0kPJZiea/1fy
   Go5F2deFlE7v6VqgCjXmry4/MD/VSHtSKNHBXie4RPR389l2nOBkVKJHa
   rdX3exD2LJgClu4BBivtLLhbkYpD4IICQNvUZLDifOoQTwzLDrETfbDaD
   RAtzviW1YQUqr5Jg+7wEDtpz4zwgAhp/kAXDIMivVao9A7WvghwL9FHHA
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10222"; a="329492931"
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="329492931"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 20:44:09 -0800
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="514542351"
Received: from intel-z97x-ud5h.sh.intel.com ([10.67.103.201])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 20:44:07 -0800
From:   Hongzhan Chen <hongzhan.chen@intel.com>
To:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com
Subject: [PATCH V4 1/3] kernel-shark: fix typo in sched_events.h
Date:   Sun,  9 Jan 2022 23:25:16 -0500
Message-Id: <20220110042518.9376-1-hongzhan.chen@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

fix typo in sched plugin and make it easier to read.

Signed-off-by: Hongzhan Chen <hongzhan.chen@intel.com>

diff --git a/src/plugins/sched_events.h b/src/plugins/sched_events.h
index 2c540fd..a2ba4b4 100644
--- a/src/plugins/sched_events.h
+++ b/src/plugins/sched_events.h
@@ -9,8 +9,8 @@
  *  @brief   Plugin for Sched events.
  */
 
-#ifndef _KS_PLUGIN_SHED_H
-#define _KS_PLUGIN_SHED_H
+#ifndef _KS_PLUGIN_SCHED_H
+#define _KS_PLUGIN_SCHED_H
 
 // KernelShark
 #include "libkshark.h"
-- 
2.17.1

