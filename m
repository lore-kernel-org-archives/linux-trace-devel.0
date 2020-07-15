Return-Path: <SRS0=0q7s=A2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88BE0C433E2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jul 2020 02:37:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 666F82072D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jul 2020 02:37:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbgGOCg6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jul 2020 22:36:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726829AbgGOCg6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jul 2020 22:36:58 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDFEE20663;
        Wed, 15 Jul 2020 02:36:57 +0000 (UTC)
Date:   Tue, 14 Jul 2020 22:36:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, namhyung@kernel.org
Subject: Re: [PATCH v2 0/8]  Few libtraceeevnt fixes, suggested Namhyung Kim
Message-ID: <20200714223656.615f09d9@oasis.local.home>
In-Reply-To: <20200715023009.2503879-1-tz.stoyanov@gmail.com>
References: <20200715023009.2503879-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 15 Jul 2020 05:30:01 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Fixes in libtraceeevnt, suggested by Namhyung Kim <namhyung@kernel.org>
> 

Good Morning Tzvetomir! ;-)

But I think you missed my email about having theses updated.

I can use this, or the one I updated. No big deal. Whatever you prefer.

-- Steve

> v2 changes:
>  - Added "Link:" pointing to the message with Namhyung's suggestions.
>  - Added "traceevent" in the subjects	
> 
> Tzvetomir Stoyanov (VMware) (8):
>   trace-cmd libtraceevent: Document tep_load_plugins_hook()
>   trace-cmd libtraceevent: Handle strdup() error in parse_option_name()
>   trace-cmd libtraceevent: Fix typo in tep_plugin_add_option()
>     description
>   trace-cmd libtraceevent: Improve error handling of
>     tep_plugin_add_option() API
>   trace-cmd libtraceevent: Fix broken indentation in
>     parse_ip4_print_args()
>   trace-cmd libtraceevent: Fix type in PRINT_FMT_STING
>   trace-cmd libtraceevent: Fix description of tep_add_plugin_path() API
>   trace-cmd libtraceevent: Handle possible strdup() error in
>     tep_add_plugin_path() API
> 
>  lib/traceevent/event-parse-local.h |  2 +-
>  lib/traceevent/event-parse.c       | 10 +++---
>  lib/traceevent/event-plugin.c      | 50 ++++++++++++++++++++++--------
>  3 files changed, 43 insertions(+), 19 deletions(-)
> 

