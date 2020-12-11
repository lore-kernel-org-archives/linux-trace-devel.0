Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FB68C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 18:56:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18B3F23F29
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 18:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390043AbgLKRLL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 12:11:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:44494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392029AbgLKRLA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 12:11:00 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E37F23D97
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 17:10:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1knlvo-000HcN-UK
        for linux-trace-devel@vger.kernel.org; Fri, 11 Dec 2020 12:10:12 -0500
Message-ID: <20201211170842.611554918@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 11 Dec 2020 12:08:42 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 00/13] trace-cmd: Clean ups to the Makefile for using external libraries
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Now that libtraceevent and libtracefs are in their separate repositories,
clean up the Makefiles for trace-cmd a bit, and even let the builder know
that libtraceevent and libtracefs are separate and where to find them.

Steven Rostedt (VMware) (13):
      trace-cmd: Add missing SPDX headers
      trace-cmd: Allow overriding of pkg-config
      trace-cmd: Use $(LIBTRACECMD_STATIC) instead of open coding in Makefile
      trace-cmd: Add versioning to libtracecmd.so
      trace-cmd: Add pkg-config configuration for libtracecmd.so
      trace-cmd: Clean up the Makefiles a little
      trace-cmd: Remove making of ld.so.conf.d/trace.conf
      trace-cmd: Install libtracecmd in the proper lib directory
      trace-cmd: Move the installing of libtracecmd to the lib/trace-cmd Makefile
      trace-cmd: Install the soft links for libtracecmd.so
      trace-cmd: Do not install libtracefs nor libtraceevent libraries
      trace-cmd: Do not build shared libraries for libtracefs and libtraceevent
      trace-cmd: Add warning if libtracefs or libtraceevent are not found

----
 Makefile                                      | 119 +++++++++++++++-----------
 features.mk                                   |   1 +
 include/linux/time64.h                        |   2 +
 lib/trace-cmd/Makefile                        |  27 ++++--
 lib/trace-cmd/include/private/trace-msg.h     |   1 +
 lib/traceevent/Makefile                       |  19 +++-
 lib/traceevent/plugins/Makefile               |   2 +
 lib/traceevent/plugins/plugin_python_loader.c |   1 +
 lib/tracefs/Makefile                          |  20 +++--
 libtracecmd.pc.template                       |  10 +++
 python/Makefile                               |   2 +
 scripts/utils.mk                              |  13 ++-
 tracecmd/Makefile                             |   1 +
 tracecmd/include/bug.h                        |   1 +
 tracecmd/trace-usage.c                        |   1 +
 utest/Makefile                                |   1 +
 16 files changed, 148 insertions(+), 73 deletions(-)
 create mode 100644 libtracecmd.pc.template
