Return-Path: <SRS0=/1KP=AS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C12FBC433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jul 2020 15:31:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A71272085B
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jul 2020 15:31:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730226AbgGGPbn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Jul 2020 11:31:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728661AbgGGPbm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Jul 2020 11:31:42 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8FEB204EC;
        Tue,  7 Jul 2020 15:31:40 +0000 (UTC)
Date:   Tue, 7 Jul 2020 11:31:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Namhyung Kim <namhyung@kernel.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: Re: [PATCH v2 07/15] tools lib traceevent: Optimize pretty_print()
 function
Message-ID: <20200707113138.5a7a27f5@oasis.local.home>
In-Reply-To: <CAM9d7cj1LJ=QO8QxhBo_oDM9APpAswX4BbTwge0JhZ3Y4-Bv9w@mail.gmail.com>
References: <20200702185344.913492689@goodmis.org>
        <20200702185704.559785000@goodmis.org>
        <CAM9d7cj1LJ=QO8QxhBo_oDM9APpAswX4BbTwge0JhZ3Y4-Bv9w@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 8 Jul 2020 00:11:10 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> > --- a/tools/lib/traceevent/event-parse-local.h
> > +++ b/tools/lib/traceevent/event-parse-local.h
> > @@ -85,6 +85,23 @@ struct tep_handle {
> >         struct tep_plugins_dir *plugins_dir;
> >  };
> >
> > +enum tep_print_parse_type {
> > +       PRINT_FMT_STING,  
> 
> STRING ?

Nice catch! ;-)

-- Steve

> 
> > +       PRINT_FMT_ARG_DIGIT,
> > +       PRINT_FMT_ARG_POINTER,
> > +       PRINT_FMT_ARG_STRING,
