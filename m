Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 300FDC432BE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Jul 2021 03:03:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B54460EE6
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Jul 2021 03:03:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234520AbhG3DDY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 23:03:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234496AbhG3DDP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 23:03:15 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 772F561074;
        Fri, 30 Jul 2021 03:03:11 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1m9Inm-002PQr-0t; Thu, 29 Jul 2021 23:03:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 0/6] libtracefs: Updates to event filtering
Date:   Thu, 29 Jul 2021 23:03:01 -0400
Message-Id: <20210730030307.574270-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

First, move the version to 1.3-dev, as I found that installing this with a
newer stable (1.2.4), where this forked form stable at 1.2.1, kept code from
using this version.

Change "GR" and "NQ" to "GT" and "NE" to represent "greater than" and "not
equal" respectively.

Changed the way filters are built, to something that can easily be used, and
is less error prone.

Updated kerneldoc.

Added filtering APIs for normal events, and also a way to verify a filter.

Steven Rostedt (VMware) (6):
  libtracefs: Update to version 1.3-dev
  libtracefs: Rename GR and NQ to GT and NE respectively
  libtracefs: Append the synth filter with parens and conjunctions
  libtracefs: Add kerneldoc comments to the remaining synth functions
  libtracefs: Add filter creating and verify API
  libtracefs: Add man pages for tracefs_event_append_filter()

 Documentation/libtracefs-filter.txt | 329 ++++++++++++
 Documentation/libtracefs-synth.txt  |  78 +--
 Makefile                            |   4 +-
 include/tracefs-local.h             |  14 +
 include/tracefs.h                   |  42 +-
 src/Makefile                        |   1 +
 src/tracefs-filter.c                | 747 ++++++++++++++++++++++++++++
 src/tracefs-hist.c                  | 345 ++++++-------
 8 files changed, 1308 insertions(+), 252 deletions(-)
 create mode 100644 Documentation/libtracefs-filter.txt
 create mode 100644 src/tracefs-filter.c

-- 
2.30.2

