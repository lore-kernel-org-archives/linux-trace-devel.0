Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wm0-f68.google.com ([74.125.82.68]:43957 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751157AbeAVJDB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Jan 2018 04:03:01 -0500
Message-ID: <1516611780.6836.0.camel@gmail.com>
Subject: Re: [PATCH v4 1/3] trace-cmd: Make read_proc() to return int status
 via OUT arg
From: "Vladislav K. Valtchev" <vladislav.valtchev@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        y.karadz@gmail.com
Date: Mon, 22 Jan 2018 11:03:00 +0200
In-Reply-To: <20180119170232.4da3f768@gandalf.local.home>
References: <20180116195343.12800-1-vladislav.valtchev@gmail.com>
         <20180116195343.12800-2-vladislav.valtchev@gmail.com>
         <20180119165802.19daee80@gandalf.local.home>
         <20180119170232.4da3f768@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 2018-01-19 at 17:02 -0500, Steven Rostedt wrote:
> On Fri, 19 Jan 2018 16:58:02 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Just to let you know. I accepted all three of your patches. I have one
> > comment, (and changed this myself).
> 
> Anyway,
> 
> Great job so far! I think I'm all set to start getting trace-cmd 2.7
> out now. Unfortunately, I don't think I'll be able to get to that
> before I leave on my next trip.
> 
> -- Steve


Thanks Steven, I'm happy that you accepted my patches!
Sure, the next time I'll use 76 (or maybe even 74) as col limit
for the description.

-- 
Vladislav Valtchev
VMware Open Source Technology Center
