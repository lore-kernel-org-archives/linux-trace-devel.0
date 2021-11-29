Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E60B4C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 29 Nov 2021 20:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhK2Ucq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 29 Nov 2021 15:32:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53078 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbhK2Ua1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 29 Nov 2021 15:30:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 965A5B8163F
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 Nov 2021 20:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5619C53FAD;
        Mon, 29 Nov 2021 20:27:05 +0000 (UTC)
Date:   Mon, 29 Nov 2021 15:27:04 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH v2] libtraceevent: Add __rel_loc relative location
 attribute support
Message-ID: <20211129152704.7489dd16@gandalf.local.home>
In-Reply-To: <20211129201507.GA30603@kbox>
References: <20211122223909.15f6fb50@rorschach.local.home>
        <163767457857.543504.6091850281066240970.stgit@devnote2>
        <20211129201507.GA30603@kbox>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 29 Nov 2021 12:15:07 -0800
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> > @@ -3308,19 +3318,23 @@ process_function(struct tep_event *event, struct tep_print_arg *arg,
> >  		free_token(token);
> >  		return process_int_array(event, arg, tok);
> >  	}
> > -	if (strcmp(token, "__get_str") == 0) {
> > +	if (strcmp(token, "__get_str") == 0 ||
> > +	    strcmp(token, "__get_rel_str") == 0) {  
> 
> Should user_events use __get_rel_str vs __get_str for the print_fmt?
> Both __dyn_loc and __rel_loc use __get_str currently.

I'm guessing that it should use the get_rel_str(), as get_str() will use
the absolute offset and not the relative one.

-- Steve
