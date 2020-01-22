Return-Path: <SRS0=9Wso=3L=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C6B0C2D0DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 17:24:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10B0A2465B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 17:24:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbgAVRYL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 22 Jan 2020 12:24:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:54844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbgAVRYL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Jan 2020 12:24:11 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36AAA2465A
        for <linux-trace-devel@vger.kernel.org>; Wed, 22 Jan 2020 17:24:11 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1iuJje-000hwa-4v
        for linux-trace-devel@vger.kernel.org; Wed, 22 Jan 2020 12:24:10 -0500
Message-Id: <20200122172247.539894616@goodmis.org>
User-Agent: quilt/0.65
Date:   Wed, 22 Jan 2020 12:22:47 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/5] trace-cmd: A few udpates
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Take two. Changes in this version:

 - moved the print of the installation of the ld.conf.d file only if it installs
 - fixed the update to the ld.conf.d install script as it was added to the wrong commit.

Steven Rostedt (VMware) (5):
      trace-cmd: Create TRACECMD_MAGIC macro for magic number of trace-cmd data file
      trace-cmd: Place "trace.dat" into the macro DEFAULT_INPUT_FILE
      trace-cmd: Add installation of ld.conf.d file for library paths
      trace-cmd: Have libtracecmd.so include libtraceevent
      trace-cmd: Remove unused trace_util function declarations

----
 Makefile                       |  6 +++++-
 include/trace-cmd/trace-cmd.h  | 13 ++-----------
 lib/trace-cmd/Makefile         |  2 ++
 lib/trace-cmd/trace-input.c    |  2 +-
 scripts/utils.mk               | 12 +++++++++++-
 tracecmd/include/trace-local.h |  1 +
 tracecmd/trace-dump.c          |  6 ++----
 tracecmd/trace-hist.c          |  2 +-
 tracecmd/trace-mem.c           |  2 +-
 tracecmd/trace-read.c          |  2 +-
 tracecmd/trace-record.c        |  2 +-
 tracecmd/trace-restore.c       |  2 +-
 tracecmd/trace-split.c         |  2 +-
 13 files changed, 30 insertions(+), 24 deletions(-)
