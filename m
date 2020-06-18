Return-Path: <SRS0=0fRq=77=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33C90C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Jun 2020 13:24:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05DD12082F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Jun 2020 13:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592486698;
	bh=BOKyY/2jbcNGQCBQvQABfthHJetuXuHqe++i/vRthdg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=TH9Fr5i74dxL4C5icmZ+wzXnTIjDZ3HTv+sxwlHV6U5KBABJ/05AmyAQHa/R0N/So
	 lzDI2W4cEJ4W1TYPdNZQdlreh5Zegv6lOSz/KawpJgYSzoTNWrUvidAa+EqKNUOpoQ
	 OPQ2yH0asIVpFRzdSJ2erdAD6XYqIa+m9ogYfvKY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbgFRNY5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Jun 2020 09:24:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728049AbgFRNY5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Jun 2020 09:24:57 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5554207D8;
        Thu, 18 Jun 2020 13:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592486697;
        bh=BOKyY/2jbcNGQCBQvQABfthHJetuXuHqe++i/vRthdg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2mhTfcR07GYDoBxWR2tp1cTs0+gPxz0FV1Dmp91dE3F5M+y0X+cHbq5PNEoahLmyL
         L4foUHmIKHweq/+T82ovDGWjvjeizwI2mlMuKhJfF8SwWTQTh0LFHSNI3AjFkxqUPR
         Mjfd1eVShvrIcL1ZAwQ2isbm8MvtqH1W8J9wNyqo=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id D68A7405FF; Thu, 18 Jun 2020 10:24:54 -0300 (-03)
Date:   Thu, 18 Jun 2020 10:24:54 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Jaewon Kim <jaewon31.kim@samsung.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 0/3] tool lib traceevent: Fix some parsing errors
Message-ID: <20200618132454.GA26403@kernel.org>
References: <20200324200845.763565368@goodmis.org>
 <20200617172804.7eccb845@oasis.local.home>
 <656DB3D9-6D76-4103-B05B-8E4FE142C3B9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <656DB3D9-6D76-4103-B05B-8E4FE142C3B9@gmail.com>
X-Url:  http://acmel.wordpress.com
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Em Wed, Jun 17, 2020 at 07:55:29PM -0300, Arnaldo Carvalho de Melo escreveu:
> 
> 
> On June 17, 2020 6:28:04 PM GMT-03:00, Steven Rostedt <rostedt@goodmis.org> wrote:
> >Hi Arnaldo,
> >
> >I guess these patches were missed.
> 
> I'll pick those tomorrow,
> 
> Thanks for the reminder,

Thanks, applied to perf/urgent, for v5.8.

- Arnaldo
 
> 
> - Arnaldo
> 
> >
> >-- Steve
> >
> >
> >On Tue, 24 Mar 2020 16:08:45 -0400
> >Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> >> Arnaldo,
> >> 
> >> Here's a few patches for lib traceevent.
> >> 
> >> The first one adds an "append()" helper function for appending to
> >strings,
> >> which will also simplify the next patch.
> >> 
> >> The second patch handles "__attribute__((user))" in the field of a
> >> trace event. This is needed after the stack leak code added this
> >> to parameters of system call events.
> >> 
> >> The last patch adds handling of __builtin_expect(), as someone wanted
> >> to move IS_ERR_VALUE() from the fast path into the print fmt section,
> >> which breaks the parsing. This should also be useful for other macros
> >> that may evaluate down to a __builtin_expect().
> >> 
> >> Steven Rostedt (VMware) (3):
> >>       tools lib traceevent: Add append() function helper for
> >appending strings
> >>       tools lib traceevent: Handle __attribute__((user)) in field
> >names
> >>       tools lib traceevent: Add handler for __builtin_expect()
> >> 
> >> ----
> >>  tools/lib/traceevent/event-parse.c | 168
> >++++++++++++++++++++++++-------------
> >>  1 file changed, 111 insertions(+), 57 deletions(-)
> 
> -- 
> Sent from my Android device with K-9 Mail. Please excuse my brevity.
> 

-- 

- Arnaldo
