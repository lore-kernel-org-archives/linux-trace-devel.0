Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42418C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Nov 2021 00:16:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbhK3ATu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 29 Nov 2021 19:19:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhK3ATu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 29 Nov 2021 19:19:50 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDDCC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 Nov 2021 16:16:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 64E8CCE1689
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 Nov 2021 00:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC0FC53FC7;
        Tue, 30 Nov 2021 00:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638231388;
        bh=q2VzTTwnR0FJhttu5GLO+x6wmAIy+5T6y3hWiWrkd1w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=myjjW6ptm1ZyBWNE/nuGhQbml1QomPunPbgnAqDpKdzOCCDA/NJ8TPU0EAZCfgsjS
         IVTd5/pNZZUaIKg3O5WvTb7NfGoZxEn7tgUze1/2y99N2ILzAGQgGhsJ5odGbgsy6J
         EqI8MvFPfPraawqJnjmALLi/absdO0U8m8QCOEPaLVU8zIYPSStFMBJT4q4rZIjlCe
         h8vMJVNNxZhtZLvxVZG0YBn0dLrIQxnduJ0oP9g4idbI8ivfYy/2TRf4mZ6LD3EBkZ
         WN5z2MNJ7NgOU/qObxsgS+eVTiGB+KpGW7xOa7740m073Kjg1PFp6KFKPh1Mnq7RSI
         RzTr2lzdJ8Ylw==
Date:   Tue, 30 Nov 2021 09:16:25 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH v2] libtraceevent: Add __rel_loc relative location
 attribute support
Message-Id: <20211130091625.ff9f101d87b603b251793f6c@kernel.org>
In-Reply-To: <20211129212635.GA7735@kbox>
References: <20211122223909.15f6fb50@rorschach.local.home>
        <163767457857.543504.6091850281066240970.stgit@devnote2>
        <20211129201507.GA30603@kbox>
        <20211129152704.7489dd16@gandalf.local.home>
        <20211129212635.GA7735@kbox>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 29 Nov 2021 13:26:35 -0800
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> On Mon, Nov 29, 2021 at 03:27:04PM -0500, Steven Rostedt wrote:
> > On Mon, 29 Nov 2021 12:15:07 -0800
> > Beau Belgrave <beaub@linux.microsoft.com> wrote:
> > 
> > > > @@ -3308,19 +3318,23 @@ process_function(struct tep_event *event, struct tep_print_arg *arg,
> > > >  		free_token(token);
> > > >  		return process_int_array(event, arg, tok);
> > > >  	}
> > > > -	if (strcmp(token, "__get_str") == 0) {
> > > > +	if (strcmp(token, "__get_str") == 0 ||
> > > > +	    strcmp(token, "__get_rel_str") == 0) {  
> > > 
> > > Should user_events use __get_rel_str vs __get_str for the print_fmt?
> > > Both __dyn_loc and __rel_loc use __get_str currently.
> > 
> > I'm guessing that it should use the get_rel_str(), as get_str() will use
> > the absolute offset and not the relative one.

Yes, you can see an example in this patch;

https://lore.kernel.org/all/163757343050.510314.2876529802471645178.stgit@devnote2/T/#u

Thus, the user-event must tell the kernel which is used
correctly.

> > 
> > -- Steve
> 
> It appears both cases call into process_str() and set the
> TEP_PRINT_STRING field type.
> 
> The TEP_FIELD_IS_RELATIVE bit to advance the offset to a relative position
> is within dynamic_offset which is used for TEP_PRINT_STRING field types.

Correct. The field type attribute is set in event_read_fields() before
this process.

> 
> I'm not sure if this was intentional or if __get_rel_str is an artifact
> left behind considering __get_str appears to be doing the same thing?

Note that this patch is for libtraceevent, not in-kernel code.

In the kernel, for example, your user-event, you must make a flag for
each field to identify that is __rel_loc, __data_loc, or just a value.
The event filter (and histogram) will parse the "events/*/*/format"
file and identify the field is __rel_loc or __data_loc.

https://lore.kernel.org/all/163757343050.510314.2876529802471645178.stgit@devnote2/T/#m98591a73fb48e4ac79ed6d2e8eb14a13c69703c8

And __get_str()/__get_rel_str() are used in the event which statically
defined (Note that trace_event field itself has no information about
the __rel_loc/__data_loc, so print_fmt function for each field must
handle that correctly.)

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
