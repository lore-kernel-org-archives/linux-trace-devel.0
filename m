Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B6E8C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Feb 2022 17:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240658AbiBWR2R (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Feb 2022 12:28:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239033AbiBWR2Q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Feb 2022 12:28:16 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BFD8947388
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 09:27:48 -0800 (PST)
Received: from kbox (c-73-140-2-214.hsd1.wa.comcast.net [73.140.2.214])
        by linux.microsoft.com (Postfix) with ESMTPSA id 697D220C31CE;
        Wed, 23 Feb 2022 09:27:48 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 697D220C31CE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1645637268;
        bh=RphWzZU4r0EpXBfJGyLeYIJu1FTQV+bxyRGUVCA4k80=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wr5cVyZMJTDkN/1/Gr4dpy44eMNk/6aQiJPYAM0+Z18oa1QFOy1DCI/qy31enbiR1
         ntqBRx9/YexpvKOnqUKhO/s4xBscq3yfak9hco7HSTytZloSEOXJHuoANdiUsfl8RI
         w9smwcCqKinWZEcDgrH643WX5T+jP/eGQ5Rgz1Cg=
Date:   Wed, 23 Feb 2022 09:27:45 -0800
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: Use tracefs_warning() for
 tracefs_user_event_record() errors
Message-ID: <20220223172745.GB1792@kbox>
References: <20220222231639.3ccfe44e@rorschach.local.home>
 <20220223172106.GA1727@kbox>
 <20220223122523.75d2130a@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223122523.75d2130a@gandalf.local.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Feb 23, 2022 at 12:25:23PM -0500, Steven Rostedt wrote:
> On Wed, 23 Feb 2022 09:21:19 -0800
> Beau Belgrave <beaub@linux.microsoft.com> wrote:
> 
> > On Tue, Feb 22, 2022 at 11:16:39PM -0500, Steven Rostedt wrote:
> > > From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> > > 
> > > Instead of hard coding fprintf() into the library, allow the application
> > > to control the output, and use tracefs_warning() instead.
> > > Also switch the setting of the errno, as tracefs_warning() will
> > > add a perror() to the message.
> > > 
> > > Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> > > ---
> > >  src/tracefs-userevents.c | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/src/tracefs-userevents.c b/src/tracefs-userevents.c
> > > index ccd511b3045d..7da6aa35bf12 100644
> > > --- a/src/tracefs-userevents.c
> > > +++ b/src/tracefs-userevents.c
> > > @@ -504,13 +504,13 @@ int tracefs_user_event_record(struct tracefs_user_event *event,
> > >  	return writev(e->group->fd, head, used);
> > >  
> > >  bad_length:
> > > -	fprintf(stderr, "Bad user_event item length at index %d\n",
> > > -		used - 1);
> > >  	errno = EINVAL;
> > > +	tracefs_warning("Bad user_event item length at index %d\n",
> > > +		used - 1);
> > >  	return -1;
> > >  
> > >  bad_count:
> > > -	fprintf(stderr, "Too many user_event items passed\n");
> > >  	errno = E2BIG;
> > > +	tracefs_warning("Too many user_event items passed\n");
> > >  	return -1;
> > >  }
> > > -- 
> > > 2.34.1  
> > 
> > I think you may want to fix tracefs-sqlhist.c as well then? I modelled
> > this type of error/warning off what was being done there :)
> 
> You mean like this? ;-)
> 
>   https://lore.kernel.org/all/20220222232045.129e3b6c@rorschach.local.home/
> 
> -- Steve

Lol, yep, exactly like that.

-Beau
