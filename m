Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726181AbfAIUgx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Jan 2019 15:36:53 -0500
Date: Wed, 9 Jan 2019 15:36:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Berg <johannes@sipsolutions.net>,
        "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Cc: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Subject: Re: trace-cmd python
Message-ID: <20190109153650.0261951b@gandalf.local.home>
In-Reply-To: <20190103224300.418e002b@vmware.local.home>
References: <1524143246.3024.21.camel@sipsolutions.net>
        <20190103224300.418e002b@vmware.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 3 Jan 2019 22:43:00 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:


> I just checked, and this is still an issue today. I'll make sure that
> this gets fixed soon.
> 
> Thanks for reporting! (even though it got lost in my INBOX :-( )
> 

OK, I finally got around to looking at this. It was a bit of a pain to
figure out. It was caused by the shuffling of the files around, as that
was needed to do because trace-cmd was getting bigger. This caused the
python ctracecmd.so to lose linking with the proper libraries and
caused the undefined symbols.

I just fixed it and pushed it to the repo. Want to give it a try and
see if it works for you?

Thanks!


-- Steve
