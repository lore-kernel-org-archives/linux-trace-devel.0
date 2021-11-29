Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C9C6C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 29 Nov 2021 21:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbhK2Vb7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 29 Nov 2021 16:31:59 -0500
Received: from linux.microsoft.com ([13.77.154.182]:52650 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232354AbhK2V37 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 29 Nov 2021 16:29:59 -0500
Received: from kbox (c-73-140-2-214.hsd1.wa.comcast.net [73.140.2.214])
        by linux.microsoft.com (Postfix) with ESMTPSA id 908EC20DEE73;
        Mon, 29 Nov 2021 13:26:40 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 908EC20DEE73
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1638221200;
        bh=ePvkhaw4lFUb5eD3GDgz5JQlAgRVbKiLXAlSc2GgH6s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nnW1Oz6pWWQgc5cGvQFz7q6jaoqUrhQ+Q4uOyIQ5s6dVUhxEpIXpp2TZrgOJiQjCm
         FC5ZnFFe7ywPh5fAxOyWHl5RT+CFLT7bM5qIo9Iu1WbRJkku2SHkSTNmkNnlOeoYHJ
         wG9edz7w0Q+n74W6I9xavJP4P0tACZcIOyKWsP1g=
Date:   Mon, 29 Nov 2021 13:26:35 -0800
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH v2] libtraceevent: Add __rel_loc relative location
 attribute support
Message-ID: <20211129212635.GA7735@kbox>
References: <20211122223909.15f6fb50@rorschach.local.home>
 <163767457857.543504.6091850281066240970.stgit@devnote2>
 <20211129201507.GA30603@kbox>
 <20211129152704.7489dd16@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129152704.7489dd16@gandalf.local.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Nov 29, 2021 at 03:27:04PM -0500, Steven Rostedt wrote:
> On Mon, 29 Nov 2021 12:15:07 -0800
> Beau Belgrave <beaub@linux.microsoft.com> wrote:
> 
> > > @@ -3308,19 +3318,23 @@ process_function(struct tep_event *event, struct tep_print_arg *arg,
> > >  		free_token(token);
> > >  		return process_int_array(event, arg, tok);
> > >  	}
> > > -	if (strcmp(token, "__get_str") == 0) {
> > > +	if (strcmp(token, "__get_str") == 0 ||
> > > +	    strcmp(token, "__get_rel_str") == 0) {  
> > 
> > Should user_events use __get_rel_str vs __get_str for the print_fmt?
> > Both __dyn_loc and __rel_loc use __get_str currently.
> 
> I'm guessing that it should use the get_rel_str(), as get_str() will use
> the absolute offset and not the relative one.
> 
> -- Steve

It appears both cases call into process_str() and set the
TEP_PRINT_STRING field type.

The TEP_FIELD_IS_RELATIVE bit to advance the offset to a relative position
is within dynamic_offset which is used for TEP_PRINT_STRING field types.

I'm not sure if this was intentional or if __get_rel_str is an artifact
left behind considering __get_str appears to be doing the same thing?

Thanks,
-Beau
