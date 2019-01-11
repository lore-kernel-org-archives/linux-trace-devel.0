Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388824AbfAKO35 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Jan 2019 09:29:57 -0500
Date: Fri, 11 Jan 2019 09:29:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?=
        <u.kleine-koenig@pengutronix.de>
Cc: Yordan Karadzhov <ykaradzhov@vmware.com>,
        "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH] Fix formatting of fixed-point numbers to not skip zeros
Message-ID: <20190111092954.05966ae8@gandalf.local.home>
In-Reply-To: <20190111092420.e24fxhyke2o5vnp3@pengutronix.de>
References: <20190110214346.8054-1-u.kleine-koenig@pengutronix.de>
        <20190110164851.6eb411c8@gandalf.local.home>
        <900152eb-ce31-0918-7675-17729f0cfbe9@vmware.com>
        <20190111092420.e24fxhyke2o5vnp3@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 11 Jan 2019 10:24:20 +0100
Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:

> Hello Yordan,
> 
> On Fri, Jan 11, 2019 at 09:09:19AM +0000, Yordan Karadzhov wrote:
> > On 10.01.19 г. 23:48 ч., Steven Rostedt wrote:  
> > > On Thu, 10 Jan 2019 22:43:46 +0100
> > > Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:
> > >   
> > >> When a timestamp that represents 1.00001 is converted to (for example)
> > >> seconds and microseconds this results in seconds=1 and useconds=10. To
> > >> format that into a string requires the format %lu.%06lu to yield
> > >> "1.000010". Some code parts used %lu.%lu however which results in "1.10"
> > >> which is wrong.  
> > > 
> > > Thanks Uwe!
> > > 
> > > Yordan, can you review this patch and give an Acked-by or Reviewed-by
> > > tag?  
> > 
> > Very well spotted.
> > 
> > Reviewed-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> > 
> > Just one minor thing, please sign the patch.  

Nice catch.

> 
> It was a conscious decision to not sign-off the patch as it isn't
> formalized for trace-cmd what a Signed-off-by-line would mean.
> 
> So if you insist on this formalism, I suggest you formalize it first :-)

You're the first one to mention this, and I never even thought about
it. It means the same thing as a Signed-off-by means for the Linux
kernel.

I can copy the text of the DCO and place it into a file called
DCO if that makes you feel better. Could you resend with a
Signed-off-by and I'll add your patch along with the file with the text
below. Take this email as an official declaration of the sign off
meaning.

-- Steve

(Copied from the Linux Kernel's Documentation/process/submitting-patches.rst)

Sign your work - the Developer's Certificate of Origin
------------------------------------------------------

To improve tracking of who did what, especially with patches that can
percolate to their final resting place in the kernel through several
layers of maintainers, we've introduced a "sign-off" procedure on
patches that are being emailed around.

The sign-off is a simple line at the end of the explanation for the
patch, which certifies that you wrote it or otherwise have the right to
pass it on as an open-source patch.  The rules are pretty simple: if you
can certify the below:

Developer's Certificate of Origin 1.1
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

By making a contribution to this project, I certify that:

        (a) The contribution was created in whole or in part by me and I
            have the right to submit it under the open source license
            indicated in the file; or

        (b) The contribution is based upon previous work that, to the best
            of my knowledge, is covered under an appropriate open source
            license and I have the right under that license to submit that
            work with modifications, whether created in whole or in part
            by me, under the same open source license (unless I am
            permitted to submit under a different license), as indicated
            in the file; or

        (c) The contribution was provided directly to me by some other
            person who certified (a), (b) or (c) and I have not modified
            it.

        (d) I understand and agree that this project and the contribution
            are public and that a record of the contribution (including all
            personal information I submit with it, including my sign-off) is
            maintained indefinitely and may be redistributed consistent with
            this project or the open source license(s) involved.

then you just add a line saying::

        Signed-off-by: Random J Developer <random@developer.example.org>

using your real name (sorry, no pseudonyms or anonymous contributions.)

Some people also put extra tags at the end.  They'll just be ignored for
now, but you can do this to mark internal company procedures or just
point out some special detail about the sign-off.
