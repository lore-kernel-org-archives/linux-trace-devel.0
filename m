Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C12DC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Apr 2022 02:23:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233115AbiDKC0B (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 10 Apr 2022 22:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiDKC0A (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 10 Apr 2022 22:26:00 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7092D381AD
        for <linux-trace-devel@vger.kernel.org>; Sun, 10 Apr 2022 19:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649643828; x=1681179828;
  h=from:to:cc:subject:date:message-id;
  bh=jgqrrRHafccuxO6arphXJ6PBkIH4CquSrWIVwxejF1I=;
  b=T8czaCPCXqkcZjqeHim79FXyqvYFB92Cs/3rK2aV6zm3FqnqXlEVEWBs
   J8a/a2gcUS1UW7yNMVH+U+6NSJVJyJGbxthQA0g2h8+rZS2MVo35jo07i
   l6uIO3S51oJA826BHGQI8kg9VcugkJ4cFLFuEyzLR9GO7csVKd8t2GTLC
   4bFcSooERwL6qyFNUpfNVtB31n5Vu7Q1g4rdyweDbAlu5KHIv9ZO7x4bo
   Y8iDpVBoKo/XCXM0Erv9zGMhZYxlvf/qwHTOYQumk7VRXSJXRq3DcsYPw
   M5F82i2A+4pjtMM1U7G4oF/z/8t0wvUFNDqSR90w/DCHHNxeTYgjd234W
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10313"; a="287022260"
X-IronPort-AV: E=Sophos;i="5.90,250,1643702400"; 
   d="scan'208";a="287022260"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2022 19:23:47 -0700
X-IronPort-AV: E=Sophos;i="5.90,250,1643702400"; 
   d="scan'208";a="571912223"
Received: from intel-z97x-ud5h.sh.intel.com ([10.67.103.201])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2022 19:23:46 -0700
From:   Hongzhan Chen <hongzhan.chen@intel.com>
To:     y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] kernel-shark: Add instroduction of external Xenomai plugin
Date:   Sun, 10 Apr 2022 22:03:39 -0400
Message-Id: <20220411020339.363-1-hongzhan.chen@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

introduce external Xenomai plugin in README as a reference to
implement and build stand-alone plugin.

Signed-off-by: Hongzhan Chen <hongzhan.chen@intel.com>

diff --git a/README b/README
index 37ccd95..d3bceaa 100644
--- a/README
+++ b/README
@@ -114,6 +114,14 @@ CMake examples:
 
     cmake -DCMAKE_BUILD_TYPE=Package -DCMAKE_C_FLAGS_PACKAGE="-O3 -pedantic"  ../
 
+External plugin example:
+------------------------------------------------------------
+    KernelShark also supports stand-alone plugin except for build-in. There is
+    a real example under https://source.denx.de/Xenomai/xenomai/-/tree/next/tracing/kernelshark/,
+    which is to visualize out-of-band state of realtime task with hollow cobalt
+    blue box mainly when there is cobalt context switches in Xenomai. As its
+    implemention mainly refers to build-in plugin-sched_events, it shares common
+    plugin features such as clickable shapes.
 
 Contributions:
 ------------------------------------------------------------
-- 
2.17.1

