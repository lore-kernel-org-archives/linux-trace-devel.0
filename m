Return-Path: <SRS0=9Wso=3L=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F9FCC2D0DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 17:13:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2ADE024656
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 17:13:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgAVRNb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 22 Jan 2020 12:13:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:49340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbgAVRNa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Jan 2020 12:13:30 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40A9D24656
        for <linux-trace-devel@vger.kernel.org>; Wed, 22 Jan 2020 17:13:30 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1iuJZJ-000hos-0u
        for linux-trace-devel@vger.kernel.org; Wed, 22 Jan 2020 12:13:29 -0500
Message-Id: <20200122171250.252248737@goodmis.org>
User-Agent: quilt/0.65
Date:   Wed, 22 Jan 2020 12:12:50 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/5] trace-cmd: A few updates
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some clean ups, and a fix to get the python module working again.

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
