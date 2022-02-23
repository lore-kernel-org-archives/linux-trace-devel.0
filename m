Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C19CC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Feb 2022 17:25:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234387AbiBWRZ5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Feb 2022 12:25:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239033AbiBWRZ4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Feb 2022 12:25:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BE053E01
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 09:25:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0858B8211B
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 17:25:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A62FC340E7;
        Wed, 23 Feb 2022 17:25:24 +0000 (UTC)
Date:   Wed, 23 Feb 2022 12:25:23 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: Use tracefs_warning() for
 tracefs_user_event_record() errors
Message-ID: <20220223122523.75d2130a@gandalf.local.home>
In-Reply-To: <20220223172106.GA1727@kbox>
References: <20220222231639.3ccfe44e@rorschach.local.home>
        <20220223172106.GA1727@kbox>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 23 Feb 2022 09:21:19 -0800
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> On Tue, Feb 22, 2022 at 11:16:39PM -0500, Steven Rostedt wrote:
> > From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> > 
> > Instead of hard coding fprintf() into the library, allow the application
> > to control the output, and use tracefs_warning() instead.
> > Also switch the setting of the errno, as tracefs_warning() will
> > add a perror() to the message.
> > 
> > Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> > ---
> >  src/tracefs-userevents.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/src/tracefs-userevents.c b/src/tracefs-userevents.c
> > index ccd511b3045d..7da6aa35bf12 100644
> > --- a/src/tracefs-userevents.c
> > +++ b/src/tracefs-userevents.c
> > @@ -504,13 +504,13 @@ int tracefs_user_event_record(struct tracefs_user_event *event,
> >  	return writev(e->group->fd, head, used);
> >  
> >  bad_length:
> > -	fprintf(stderr, "Bad user_event item length at index %d\n",
> > -		used - 1);
> >  	errno = EINVAL;
> > +	tracefs_warning("Bad user_event item length at index %d\n",
> > +		used - 1);
> >  	return -1;
> >  
> >  bad_count:
> > -	fprintf(stderr, "Too many user_event items passed\n");
> >  	errno = E2BIG;
> > +	tracefs_warning("Too many user_event items passed\n");
> >  	return -1;
> >  }
> > -- 
> > 2.34.1  
> 
> I think you may want to fix tracefs-sqlhist.c as well then? I modelled
> this type of error/warning off what was being done there :)

You mean like this? ;-)

  https://lore.kernel.org/all/20220222232045.129e3b6c@rorschach.local.home/

-- Steve

> 
> Seems like it would do the same thing when tracefs_sql is called and has
> a buffer error, etc. in sql_parse_error() and build_filter().


