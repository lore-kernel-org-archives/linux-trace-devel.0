Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95E4EC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Nov 2021 12:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234057AbhKZMZq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Nov 2021 07:25:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:60072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234003AbhKZMXo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Nov 2021 07:23:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 659E461108;
        Fri, 26 Nov 2021 12:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637929230;
        bh=Qk/OKPKrhFGM2jtk+r3CcJ1Qnv/AtCRtIgdxEfJuE5g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s/02nuOt3SbpqXmEkZXcIB8qmySFfEV2vtWFVKz9uYc3/LtMt2TyYcMLeBgjO7ooI
         dJlXyrS+5naGdbQo+UdidthwlFB5cxF86RG0LwvKFqWc72hLdyhblxAzruiyAczDeQ
         0sHwHe0RUjnWk1Hud1awdI+whGNlWQHtv4Lql/XQZ0PKKqnAe4P3VyUhNZr2pXlzLl
         ga1NiAQnuKz3QoO9s+82kjOHnSyqy/8XEQQ3OVvC118gHPo7oMzP3R1+GyIf97werQ
         45MqdBUsxMJfrMGkbeRnq4GAt1rWgy+rlmQ4o+f+IMKjUaOPXOHhIsqO/okqqfdFc3
         kXprAMeGWzTgA==
Date:   Fri, 26 Nov 2021 21:20:26 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Beau Belgrave <beaub@linux.microsoft.com>,
        linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH v2] libtraceevent: Add __rel_loc relative location
 attribute support
Message-Id: <20211126212026.e6b035ac8ec318b06030221f@kernel.org>
In-Reply-To: <20211124180708.599aa110@gandalf.local.home>
References: <20211122223909.15f6fb50@rorschach.local.home>
        <163767457857.543504.6091850281066240970.stgit@devnote2>
        <20211124180708.599aa110@gandalf.local.home>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 24 Nov 2021 18:07:08 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 23 Nov 2021 22:36:18 +0900
> Masami Hiramatsu <mhiramat@kernel.org> wrote:
> 
> > +++ b/src/event-parse.h
> > @@ -125,6 +125,7 @@ enum tep_format_flags {
> >  	TEP_FIELD_IS_LONG	= 32,
> >  	TEP_FIELD_IS_FLAG	= 64,
> >  	TEP_FIELD_IS_SYMBOLIC	= 128,
> > +	TEP_FIELD_IS_RELATIVE	= 256,
> >  };
> >  
> >  struct tep_format_field {
> > @@ -153,12 +154,12 @@ struct tep_print_arg_atom {
> >  
> >  struct tep_print_arg_string {
> >  	char			*string;
> > -	int			offset;
> > +	struct tep_format_field	*field;
> >  };
> >  
> >  struct tep_print_arg_bitmask {
> >  	char			*bitmask;
> > -	int			offset;
> > +	struct tep_format_field	*field;
> >  };
> >  
> 
> We need to be careful about modifying content in event-parse.h. Because
> this is exposed outside he library.

Oh, I thought this is an internal header, because it is under src/ directory.
However, indeed "TEP_FIELD_IS_*" referred from perf-tools, so this might be
need to be exposed.

> 
> Although, I don't think this should be an issue.
> 
> We probably need to move some content out of that file if it isn't used in
> any of the exposed APIs :-/
> 
> And since both libtracefs and trace-cmd do not reference any of the
> tep_print_arg* fields, we probably should remove them before somebody does.

Yes, tep_print_arg seems to be used only in the event-parse.c.

Thank you,

> 
> -- Steve


-- 
Masami Hiramatsu <mhiramat@kernel.org>
