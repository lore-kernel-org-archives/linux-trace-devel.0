Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C3A1C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 22:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B364619A6
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 22:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236518AbhKHXCk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 18:02:40 -0500
Received: from linux.microsoft.com ([13.77.154.182]:43748 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235081AbhKHXCk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 18:02:40 -0500
Received: from kbox (unknown [24.17.193.74])
        by linux.microsoft.com (Postfix) with ESMTPSA id 0A0C020B417F;
        Mon,  8 Nov 2021 14:59:55 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0A0C020B417F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1636412395;
        bh=494STVyeEYKT0S/qOYZldNfAd26r3f1GKySptb4suqA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lvvon6SEEKBa3jjTw3XiyXLo75IDxUAbGlSSvRjXSVXENEb6x0oculrOtRLSzZgxV
         /3SXq/vuoDgB/4i3mKPOyzb3t4MO5+atFd+mjO8KPodHCV9B/62sySp25/BQV79Ezu
         /WG2glflakDjIM5XYqigTbczJMvTbTZfQdkuVA+A=
Date:   Mon, 8 Nov 2021 14:59:50 -0800
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/10] user_events: Add minimal support for
 trace_event into ftrace
Message-ID: <20211108225950.GA1452@kbox>
References: <20211104170433.2206-1-beaub@linux.microsoft.com>
 <20211104170433.2206-3-beaub@linux.microsoft.com>
 <20211107233115.1f77e93c4bdf3ff649be99c1@kernel.org>
 <20211108171336.GA1690@kbox>
 <20211108131639.33a4f186@gandalf.local.home>
 <20211108202527.GA1862@kbox>
 <20211108160027.3b16c23d@gandalf.local.home>
 <20211108220945.GA2148@kbox>
 <20211108173053.4b37a1b8@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211108173053.4b37a1b8@gandalf.local.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Nov 08, 2021 at 05:30:53PM -0500, Steven Rostedt wrote:
> On Mon, 8 Nov 2021 14:09:45 -0800
> Beau Belgrave <beaub@linux.microsoft.com> wrote:
> > 
> > It seems like both histograms and filter both reference field flags to
> > determine how to get the data.
> > 
> > How would you feel about another FILTER_* flag on fields, like:
> > FILTER_DYN_STRING_SAFE
> > FILTER_PTR_STRING_SAFE
> 
> You mean "UNSAFE" ?
> 

Yes :) Unsafe data, safe filter method.

> > 
> > user_events when parsing would instead of leaving FILTER_OTHER for
> > __data_loc / __rel_loc switch to the above.
> > 
> > The predicate filter method would then switch based on those types to
> > safer versions.
> > 
> > That way other parts could take advantage of this if needed beyond
> > user_events.
> > 
> > If this is addressed at the filter/histogram level, would then the write
> > callsites still check bounds per-write? Or maybe only care about the
> > undersized data cases?
> 
> I'd have to look at the implementation of this. There's too many variables
> running around in my head right now.
> 
> -- Steve

Understood, thanks for thinking about this.

-Beau
