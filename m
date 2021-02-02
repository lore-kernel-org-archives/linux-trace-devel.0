Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71086C433E6
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Feb 2021 20:01:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3763464E4F
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Feb 2021 20:01:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240228AbhBBUBS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Feb 2021 15:01:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:58542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240306AbhBBUAx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Feb 2021 15:00:53 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18EDA64E41
        for <linux-trace-devel@vger.kernel.org>; Tue,  2 Feb 2021 20:00:12 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1l71qM-0095Yh-Rk
        for linux-trace-devel@vger.kernel.org; Tue, 02 Feb 2021 15:00:10 -0500
Message-ID: <20210202195458.176697224@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 02 Feb 2021 14:54:58 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] libtracefs: Minor formating updates to options code
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is based on top of the options patches:

  https://patchwork.kernel.org/project/linux-trace-devel/list/?series=418299

This adds a BUILD_BUG_ON() and ARRAY_SIZE helper macros and
structures the options_map slightly different.

No functional changes.

Steven Rostedt (VMware) (2):
      tracefs: Use new BUILD_BUG_ON() and ARRAY_SIZE() macros for options_map intergity
      libtracefs: Have the options_map elements be each on their own line

----
 include/tracefs-local.h |  6 ++++++
 src/tracefs-tools.c     | 56 ++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 52 insertions(+), 10 deletions(-)
