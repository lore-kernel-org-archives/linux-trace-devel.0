Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBB18C433DB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 18:44:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70C4F61968
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 18:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbhC3Sns (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Mar 2021 14:43:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232894AbhC3Sno (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Mar 2021 14:43:44 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 394BF619D1;
        Tue, 30 Mar 2021 18:35:47 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lRJDN-003YVI-S9; Tue, 30 Mar 2021 14:35:45 -0400
Message-ID: <20210330183324.709017776@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 30 Mar 2021 14:33:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: [PATCH 0/4] libtracefs: More updates to tracefs_function_filter()
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Allow filter to be NULL when RESET flag is set, or to commit
an already opened filter.

Also add a "FUTURE" flag to match modules that have yet to be loaded.
Starting in Linux v4.13, module functions can be added to the filter
file before the module is loaded (and does not have any matching
function). If the FUTURE flag is set, it will write the filter
directly, and this only works for globs or direct function names.

This patch set is based on top of:

 https://patchwork.kernel.org/project/linux-trace-devel/list/?series=457711
 https://lore.kernel.org/linux-trace-devel/20210330005247.397966909@goodmis.org/


Steven Rostedt (VMware) (4):
      libtracefs: Only allow RESET flag if file is not already opened
      libtracefs: Allow filter be NULL if RESET flag is set
      libtracefs: Allow filter to be NULL if module is set in tracefs_function_filter()
      libtracefs: Add TRACEFS_FL_FUTURE flag for future module filtering

----
 Documentation/libtracefs-function-filter.txt | 52 +++++++++++++----
 include/tracefs.h                            |  3 +
 src/tracefs-tools.c                          | 83 ++++++++++++++++++++++++----
 3 files changed, 114 insertions(+), 24 deletions(-)
