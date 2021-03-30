Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C04D5C433E4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 00:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2CAB61997
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 00:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbhC3AxO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 29 Mar 2021 20:53:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229479AbhC3Aws (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 29 Mar 2021 20:52:48 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A63C61988;
        Tue, 30 Mar 2021 00:52:48 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lR2ch-003Tcu-Bw; Mon, 29 Mar 2021 20:52:47 -0400
Message-ID: <20210330005123.151740983@goodmis.org>
User-Agent: quilt/0.66
Date:   Mon, 29 Mar 2021 20:51:23 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: [PATCH 00/13 v2] libtracefs: Add tracefs_function_filter()
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Changes since v1:

 - tracefs_function_filter() man page was added
 - Now thread safe with pthread_mutex_lock()
 - Use of flags instead of reset parameter
 - Added TRACEFS_FL_CONTINUE flag
 - Fixed glob or regex test


Sameeruddin shaik (2):
      libtracefs: An API to set the filtering of functions
      libtracefs: Document function_filter API

Steven Rostedt (VMware) (11):
      libtracefs: Fix notations of tracefs_function_filter() and module parameter
      libtracefs: Move opening of file out of controlled_write()
      libtracefs: Add add_errors() helper function for control_write()
      libtracefs: Add checking of available_filter_functions to tracefs_function_filter()
      libtracefs: Add write_filter() helper function
      libtracefs: Allow for setting filters with regex expressions
      libtracefs: Add indexing to set functions in tracefs_function_filter()
      libtracefs: Pass in reset via flags to tracefs_function_filter()
      libtracefs: Add pthread_mutex_lock() around tracefs_function_filter()
      libtracefs: Move struct tracefs_instance to tracefs-local.h
      libtracefs: Add CONTINUE to tracefs_function_filter()

----
 Documentation/libtracefs-function-filter.txt | 161 ++++++++
 include/tracefs-local.h                      |   7 +
 include/tracefs.h                            |  11 +
 src/tracefs-instance.c                       |   7 +-
 src/tracefs-tools.c                          | 555 ++++++++++++++++++++++++++-
 5 files changed, 735 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/libtracefs-function-filter.txt
