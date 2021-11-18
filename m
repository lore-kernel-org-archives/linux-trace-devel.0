Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D135BC433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Nov 2021 19:45:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BED8D61A52
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Nov 2021 19:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232816AbhKRTsg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Nov 2021 14:48:36 -0500
Received: from linux.microsoft.com ([13.77.154.182]:48574 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232969AbhKRTsg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Nov 2021 14:48:36 -0500
Received: from kbox (c-73-140-2-214.hsd1.wa.comcast.net [73.140.2.214])
        by linux.microsoft.com (Postfix) with ESMTPSA id 5869320C7078;
        Thu, 18 Nov 2021 11:45:35 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5869320C7078
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1637264735;
        bh=A5p+9VafbOYligF8cdr2BF7SzLa5YXG1ybXA/Uh0I3s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F+m9m2db9AZT9P9drTtUvhVoeqrj4Gmx6iVVwPRL3p0and34iFNdiCcp0BVfw5zA/
         94kUyj0iFjlpKflDyM5Vnd6E30Ow4tTVtoQC2eqPdEnuZ7ZHDlWm5khMYsOcSz7PSP
         Q1Y9LQmBQyOvQvZm9AkVFX7rCOudWMVSORpmftwQ=
Date:   Thu, 18 Nov 2021 11:45:26 -0800
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     mhiramat@kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 12/12] user_events: Validate user payloads for size
 and null termination
Message-ID: <20211118194514.GA1895@kbox>
References: <20211116005047.1808-1-beaub@linux.microsoft.com>
 <20211116005047.1808-13-beaub@linux.microsoft.com>
 <20211116211150.GA2337@kbox>
 <20211117205220.6d49f5b9@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117205220.6d49f5b9@gandalf.local.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Nov 17, 2021 at 08:52:20PM -0500, Steven Rostedt wrote:
> On Tue, 16 Nov 2021 13:11:50 -0800
> Beau Belgrave <beaub@linux.microsoft.com> wrote:
> 
> > On Mon, Nov 15, 2021 at 04:50:47PM -0800, Beau Belgrave wrote:
> > > +static int user_event_validate(struct user_event *user, void *data, int len)
> > > +{
> > > +	struct list_head *head = &user->validators;
> > > +	struct user_event_validator *validator;
> > > +	void *pos, *end = data + len;
> > > +	u16 *val, offset, size;
> > > +
> > > +	list_for_each_entry(validator, head, link) {
> > > +		pos = data + validator->offset;
> > > +		val = pos;
> > > +
> > > +		/* Already done min_size check, no bounds check here */
> > > +		offset = *val++;
> > > +		size = *val++;  
> > 
> > I believe I have these backwards, size should come first for both dyn
> > and rel data. Is this correct?
> 
> it's size << 16 | offset;
> 
> 
> > 
> > > diff --git a/tools/testing/selftests/user_events/ftrace_test.c b/tools/testing/selftests/user_events/ftrace_test.c
> > > index 9d53717139e6..bea694e9df8c 100644
> > > --- a/tools/testing/selftests/user_events/ftrace_test.c
> > > +++ b/tools/testing/selftests/user_events/ftrace_test.c
> > > @@ -21,6 +21,11 @@ const char *status_file = "/sys/kernel/debug/tracing/user_events_status";
> > >  const char *enable_file = "/sys/kernel/debug/tracing/events/user_events/__test_event/enable";
> > >  const char *trace_file = "/sys/kernel/debug/tracing/trace";
> > >  
> > > +struct rel_loc {
> > > +	__u16 offset;
> > > +	__u16 size;
> > > +} __packed;
> > > +  
> > 
> > Same here.
> 
> I would not use pointer arithmetic or the above structure, as I'm not sure
> they work the same for both big and little endian. It's best to just use
> u32 and '|' (or) the two unsigned shorts into one integer.
> 
> -- Steve

Got it, totally makes sense now, thank you!

-Beau
