Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33153C07E97
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 20:35:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F0936141C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 20:35:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhGBUhg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Jul 2021 16:37:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:44552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230144AbhGBUhf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Jul 2021 16:37:35 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C090E6140E;
        Fri,  2 Jul 2021 20:35:02 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1lzPsL-000i7U-K6; Fri, 02 Jul 2021 16:35:01 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 0/2] libtracefs: Have string lists contain their size
Date:   Fri,  2 Jul 2021 16:34:57 -0400
Message-Id: <20210702203459.169473-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Have the string lists contain the size inside them.

The way this is done is by allocating one pointer than the user needs:

/* just pseudo code of the idea, no error checking */
 if (!list) {
	list = malloc(sizeof(*list) * 3);
	list[0] = (char *)1;
	list[1] = strdup(users_string);
	list[2] = NULL;
	return &list[1];
 }
 list--;
 size = *(unsigned long *)list;
 tmp = realloc(list, sizeof(*list) * (size + 3));
 list = tmp;
 list[0] = (char *)(size + 1);
 list++;
 list[size++] = strdup(users_string);
 list[size] = NULL;
 return list;

Implementing this has fixed a few bugs and memory leaks.

Steven Rostedt (VMware) (2):
  libtracefs: Move tracefs_list_free() to tracefs-utils.c
  libtracefs: Restructure how string lists work

 include/tracefs-local.h |  1 +
 include/tracefs.h       |  4 +-
 src/tracefs-events.c    | 61 ++++++++++--------------------
 src/tracefs-instance.c  |  9 +----
 src/tracefs-kprobes.c   | 17 ++-------
 src/tracefs-tools.c     |  6 +--
 src/tracefs-utils.c     | 83 +++++++++++++++++++++++++++++++++++++++++
 7 files changed, 112 insertions(+), 69 deletions(-)

-- 
2.30.2

