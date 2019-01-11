Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:53461 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbfAKJY0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Jan 2019 04:24:26 -0500
Date: Fri, 11 Jan 2019 10:24:20 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
        <u.kleine-koenig@pengutronix.de>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH] Fix formatting of fixed-point numbers to not skip zeros
Message-ID: <20190111092420.e24fxhyke2o5vnp3@pengutronix.de>
References: <20190110214346.8054-1-u.kleine-koenig@pengutronix.de>
 <20190110164851.6eb411c8@gandalf.local.home>
 <900152eb-ce31-0918-7675-17729f0cfbe9@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <900152eb-ce31-0918-7675-17729f0cfbe9@vmware.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Hello Yordan,

On Fri, Jan 11, 2019 at 09:09:19AM +0000, Yordan Karadzhov wrote:
> On 10.01.19 г. 23:48 ч., Steven Rostedt wrote:
> > On Thu, 10 Jan 2019 22:43:46 +0100
> > Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:
> > 
> >> When a timestamp that represents 1.00001 is converted to (for example)
> >> seconds and microseconds this results in seconds=1 and useconds=10. To
> >> format that into a string requires the format %lu.%06lu to yield
> >> "1.000010". Some code parts used %lu.%lu however which results in "1.10"
> >> which is wrong.
> > 
> > Thanks Uwe!
> > 
> > Yordan, can you review this patch and give an Acked-by or Reviewed-by
> > tag?
> 
> Very well spotted.
> 
> Reviewed-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> 
> Just one minor thing, please sign the patch.

It was a conscious decision to not sign-off the patch as it isn't
formalized for trace-cmd what a Signed-off-by-line would mean.

So if you insist on this formalism, I suggest you formalize it first :-)

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
