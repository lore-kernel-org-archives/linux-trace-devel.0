Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9B03C07E9B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 03:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B00C761CC0
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 03:11:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbhGGDNw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Jul 2021 23:13:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229989AbhGGDNw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Jul 2021 23:13:52 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C13EF61CBA;
        Wed,  7 Jul 2021 03:11:12 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1m0xxv-00130V-JQ; Tue, 06 Jul 2021 23:11:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 0/4] libtracefs: Work to add histogram APIs
Date:   Tue,  6 Jul 2021 23:11:06 -0400
Message-Id: <20210707031110.249759-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The first three patches are helper functions to help with
the final patch, although the second patch can probably stand on
its own, as it simplifies access to the files in the system/event/
directory, instead of having to build it first and then call
tracefs_instance_file_*().

Steven Rostedt (VMware) (4):
  libtracefs: Implement tracefs_list_size()
  libtracefs: Implement functions to work on event directory files
  libtracefs: Have instances have internal ref counting
  libtracefs: Implement API to create / modify and display histograms

 Documentation/libtracefs-hist-cont.txt | 192 +++++++++
 Documentation/libtracefs-hist.txt      | 290 ++++++++++++++
 include/tracefs-local.h                |   4 +
 include/tracefs.h                      |  66 +++
 src/Makefile                           |   1 +
 src/tracefs-events.c                   | 182 +++++++++
 src/tracefs-hist.c                     | 529 +++++++++++++++++++++++++
 src/tracefs-instance.c                 |  56 ++-
 src/tracefs-utils.c                    |  16 +
 9 files changed, 1327 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/libtracefs-hist-cont.txt
 create mode 100644 Documentation/libtracefs-hist.txt
 create mode 100644 src/tracefs-hist.c

-- 
2.30.2

