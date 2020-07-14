Return-Path: <SRS0=mFmS=AZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97F96C433E7
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 14:22:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CFCD22365
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 14:22:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgGNOWd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jul 2020 10:22:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728102AbgGNOWd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jul 2020 10:22:33 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76D5322365;
        Tue, 14 Jul 2020 14:22:32 +0000 (UTC)
Date:   Tue, 14 Jul 2020 10:22:30 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Namhyung Kim <namhyung@kernel.org>
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 0/8] Few libtraceeevnt fixes, suggested Namhyung Kim
Message-ID: <20200714102230.1b260442@oasis.local.home>
In-Reply-To: <CAM9d7cg-5sJ-iqCU25MqmdTOdoWPqcyFJFqdc67PdRwjwqqPsA@mail.gmail.com>
References: <20200714103027.2477584-1-tz.stoyanov@gmail.com>
        <CAM9d7cg-5sJ-iqCU25MqmdTOdoWPqcyFJFqdc67PdRwjwqqPsA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 14 Jul 2020 21:07:12 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> Hello,
> 
> On Tue, Jul 14, 2020 at 7:30 PM Tzvetomir Stoyanov (VMware)
> <tz.stoyanov@gmail.com> wrote:
> >
> > Fixes in libtraceeevnt, suggested by Namhyung Kim <namhyung@kernel.org>
> >
> > Tzvetomir Stoyanov (VMware) (8):
> >   trace-cmd: Document tep_load_plugins_hook()
> >   trace-cmd: Handle strdup() error in parse_option_name()
> >   trace-cmd: Fix typo in tep_plugin_add_option() description
> >   trace-cmd: Improve error handling of tep_plugin_add_option() API
> >   trace-cmd: Fixed broken indentation in parse_ip4_print_args()
> >   trace-cmd: Fixed type in PRINT_FMT_STING
> >   trace-cmd: Fixed description of tep_add_plugin_path() API
> >   trace-cmd: Handle possible strdup() error in tep_add_plugin_path() API  
> 
> Shouldn't the prefix be libtraceevent ?  Other than that,

Yes they should, because they are not trace-cmd specific.

> 
> Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks Namhyung!

-- Steve

> 
> Thanks
> Namhyung
> 
> >
> >  lib/traceevent/event-parse-local.h |  2 +-
> >  lib/traceevent/event-parse.c       | 10 +++---
> >  lib/traceevent/event-plugin.c      | 50 ++++++++++++++++++++++--------
> >  3 files changed, 43 insertions(+), 19 deletions(-)
> >
> > --
> > 2.26.2
> >  

