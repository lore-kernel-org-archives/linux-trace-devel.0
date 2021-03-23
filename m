Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5021EC433E2
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Mar 2021 01:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24C51619A8
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Mar 2021 01:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhCWBdD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 21:33:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231548AbhCWBc1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 21:32:27 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF00561993;
        Tue, 23 Mar 2021 01:32:25 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lOVuC-001cM4-Mi; Mon, 22 Mar 2021 21:32:24 -0400
Message-ID: <20210323012755.155237800@goodmis.org>
User-Agent: quilt/0.66
Date:   Mon, 22 Mar 2021 21:27:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: [PATCH 0/7] libtracfes: Add tracefs_function_filter()
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This adds a new API tracefs_function_filter() as described in:

 https://bugzilla.kernel.org/show_bug.cgi?id=210643

It will use regular expressions against available_filter_functions (or even
the kernel glob expression) to enable the function by the index method if it
is supported. If it is not supported, it will go back to the writing of the
filter strings directly into the set_ftrace_filter file.


Sameeruddin shaik (1):
      libtracefs: An API to set the filtering of functions

Steven Rostedt (VMware) (6):
      libtracefs: Move opening of file out of controlled_write()
      libtracefs: Add add_errors() helper function for control_write()
      libtracefs: Add checking of available_filter_functions to tracefs_function_filter()
      libtracefs: Add write_filter() helper function
      libtracefs: Allow for setting filters with regex expressions
      libtracefs: Add indexing to set functions in tracefs_function_filter()

----
 include/tracefs.h   |   3 +-
 src/tracefs-tools.c | 521 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 522 insertions(+), 2 deletions(-)
