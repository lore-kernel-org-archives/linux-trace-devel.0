Return-Path: <SRS0=mFmS=AZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D820EC433E2
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 21:23:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCFD92074A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 21:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgGNVXV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jul 2020 17:23:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726960AbgGNVXV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jul 2020 17:23:21 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2E0B20658
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 21:23:20 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jvSOV-004vWu-SL
        for linux-trace-devel@vger.kernel.org; Tue, 14 Jul 2020 17:23:19 -0400
Message-ID: <20200714211929.828530560@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 14 Jul 2020 17:19:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/8] trace-cmd libtraceevent: Tzvetomir's updates from Namhyung's comments
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is an updated series of Tzvetomir's patch set:

  https://lore.kernel.org/r/20200714103027.2477584-1-tz.stoyanov@gmail.com

The only changes to that are:

  - Changed the prefix of the subjects from trace-cmd: to libtraceevent:

  - Adds the links to Namhyung's comments.

  - Adds Namhyung's Acked-by.

The code is unmodified. This only changes the commit logs.

-- Steve



Tzvetomir Stoyanov (VMware) (8):
      libtraceevent: Document tep_load_plugins_hook()
      libtraceevent: Handle strdup() error in parse_option_name()
      libtraceevent: Fix typo in tep_plugin_add_option() description
      libtraceevent: Improve error handling of tep_plugin_add_option() API
      libtraceevent: Fixed broken indentation in parse_ip4_print_args()
      libtraceevent: Fixed type in PRINT_FMT_STING
      libtraceevent: Fixed description of tep_add_plugin_path() API
      libtraceevent: Handle possible strdup() error in tep_add_plugin_path() API

----
 lib/traceevent/event-parse-local.h |  2 +-
 lib/traceevent/event-parse.c       | 10 ++++----
 lib/traceevent/event-plugin.c      | 50 ++++++++++++++++++++++++++++----------
 3 files changed, 43 insertions(+), 19 deletions(-)
